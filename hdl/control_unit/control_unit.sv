module control_unit #(
    parameter int DATA_WIDTH          = 18,
    parameter int CLUSTER_COUNT       = 4,
    parameter int CLUSTER_SIZE        = 8,
    parameter int PIXEL_ADDR_W        = 16,
    parameter int JOB_DATA_W          = 18,
    parameter int PIXEL_W             = 8,
    parameter int OPCODE_W            = 5,
    parameter int LOWEST_MAX_ITER_POW = 6
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    opcode_reset,

    // frame control
    input  logic [4:0]              fractal_type,
    input  logic [DATA_WIDTH-1:0]   pan_x,
    input  logic [DATA_WIDTH-1:0]   pan_y,
    input  logic [3:0]              zoom_level,
    input  logic [4:0]              max_iter,
    input  logic                    start_flag,
    input  logic                    width_flag,
    input  logic [3:0]              sixteenth,

    // julia c in full precision
    input  logic [DATA_WIDTH-1:0]   c_x,
    input  logic [DATA_WIDTH-1:0]   c_y,
    

    // scheduler handshake (pixel coords in)
    output logic                    wants_job,
    input  logic                    grant,
    input  logic [PIXEL_ADDR_W-1:0] coord_out,


    // result output handshake (independent of dispatch-side FSM)
    output logic                    done,
    output logic [PIXEL_W-1:0]      iter_x,
    output logic [PIXEL_W-1:0]      iter_y,
    output logic [7:0]              iter_colour,

    // color bram read
    output logic [PIXEL_W-1:0]      cu_rd_x,
    output logic [PIXEL_W-1:0]      cu_rd_y,
    output logic                    cu_rd_en,
    input  logic [7:0]              cu_rd_data,

    // color bram write (full-word RMW, managed internally by bram_read_write)
    output logic                    cu_wr_en,
    output logic [12:0]             cu_wr_waddr,
    output logic [63:0]             cu_wr_word,
    // color bram RMW pre-read
    output logic [12:0]             cu_rmw_rd_addr,
    output logic                    cu_rmw_rd_en,
    input  logic [63:0]             cu_rmw_rd_data,


    // state_bram
    output logic [PIXEL_W-1:0]      sb_x,
    output logic [PIXEL_W-1:0]      sb_y,
    output logic                    sb_rd,
    output logic                    sb_we,
    output logic [1:0]              sb_wstate,
    input  logic [1:0]              sb_rstate,

    // tile table complete
    output logic [255:0]            cu_tile_done_set

);

    localparam int Z_WIDTH      = DATA_WIDTH + 1;
    localparam int Z_WIDE       = Z_WIDTH * 2 - 1;
    localparam int CLUST_ADDR_W = (CLUSTER_COUNT > 1) ? $clog2(CLUSTER_COUNT) : 1;
    localparam int WORDS_NARROW = 2;
    localparam int WORDS_WIDE   = 4;
    localparam int RES_FIFO_DW  = PIXEL_ADDR_W + PIXEL_W;
    localparam int RES_FIFO_D   = (CLUSTER_COUNT < 4) ? 4 : CLUSTER_COUNT * 2;

    logic julia, wide;
    assign julia = fractal_type[4];
    assign wide  = width_flag;

    logic rst_i;
    assign rst_i = rst | opcode_reset;

    // forward-declare strobes so coord latch block can reference accept_pulse
    logic opcode_broadcast_en, load_c_en, load_z_en;
    logic start_load_pulse, accept_pulse, capture_winner;
    logic check_bram;

    logic [PIXEL_W-1:0] coord_a_q, coord_b_q;

    always_ff @(posedge clk) begin
        if (rst_i) begin
            coord_a_q <= '0;
            coord_b_q <= '0;
        end else if (accept_pulse) begin
            coord_a_q <= coord_out[7:0];
            coord_b_q <= coord_out[15:8];
        end
    end

    logic [Z_WIDE-1:0] z_real, z_imag;

    translate #(
        .DATA_WIDTH (Z_WIDE),
        .RESOLUTION (PIXEL_W)
    ) cheezy_translator (
        .pan_x     ({{(Z_WIDE-DATA_WIDTH){pan_x[DATA_WIDTH-1]}}, pan_x}),
        .pan_y     ({{(Z_WIDE-DATA_WIDTH){pan_y[DATA_WIDTH-1]}}, pan_y}),
        .a         (coord_a_q),
        .b         (coord_b_q),
        .zoom      (zoom_level),
        .sixteenth (sixteenth),
        .z_real    (z_real),
        .z_imag    (z_imag)
    );

    logic bram_miss, bram_started, bram_done;
    logic [7:0] bram_colour;
    logic bram_read_done_pulse;

    logic                    bram_res_pending;
    logic [PIXEL_ADDR_W-1:0] bram_res_pixel_addr;
    logic [PIXEL_W-1:0]      bram_res_data;

    // Retrying injector: latch "done" detection (fires once per READ via read_done_pulse)
    // and retry each cycle until res_fifo has space. The latch also preserves addr/colour
    // across accept_pulse, which updates coord_a_q/b_q before the injection can fire.
    // The !inject_pending guard prevents a second simultaneous "done" from overwriting
    // a pending injection; stall_inject feeds back to frame_fsm so it holds JOB_WAIT
    // until the latch clears before accepting the next pixel.
    logic inject_pending;
    logic [PIXEL_ADDR_W-1:0] inject_addr;
    logic [PIXEL_W-1:0]      inject_colour;

    always_ff @(posedge clk) begin
        if (rst_i) begin
            inject_pending <= 1'b0;
            inject_addr    <= '0;
            inject_colour  <= '0;
        end else if (bram_read_done_pulse && bram_done && check_bram && !inject_pending) begin
            inject_pending <= 1'b1;
            inject_addr    <= {coord_a_q[PIXEL_W-1:0], coord_b_q[PIXEL_W-1:0]};
            inject_colour  <= bram_colour;
        end else if (inject_pending && !res_fifo_full) begin
            inject_pending <= 1'b0;
        end
    end

    assign bram_res_pending    = inject_pending;
    assign bram_res_pixel_addr = inject_addr;
    assign bram_res_data       = inject_colour;

    assign cu_rd_x = coord_a_q[PIXEL_W-1:0];
    assign cu_rd_y = coord_b_q[PIXEL_W-1:0];

    // declared here so bram_rw instantiation can reference them
    logic                    res_fifo_wr_en;
    logic [RES_FIFO_DW-1:0]  res_fifo_wr_data;
    logic                    res_fifo_full;
    logic                    res_fifo_rd_en;
    logic [RES_FIFO_DW-1:0]  res_fifo_rd_data;
    logic                    res_fifo_empty;

    bram_read_write #(
        .PIXEL_W (PIXEL_W)
    ) u_bram_rw (
        .clk             (clk),
        .rst             (rst_i),
        .check_bram      (check_bram),
        .a               (cu_rd_x),
        .b               (cu_rd_y),
        .bram_rd_en      (cu_rd_en),
        .bram_rd_data    (cu_rd_data),
        .bram_wr_en      (cu_wr_en),
        .bram_wr_waddr   (cu_wr_waddr),
        .bram_wr_word    (cu_wr_word),
        .bram_rmw_rd_en  (cu_rmw_rd_en),
        .bram_rmw_rd_addr(cu_rmw_rd_addr),
        .bram_rmw_rd_data(cu_rmw_rd_data),
        .sb_rd           (sb_rd),
        .sb_we           (sb_we),
        .sb_x            (sb_x),
        .sb_y            (sb_y),
        .sb_wstate       (sb_wstate),
        .sb_rstate       (sb_rstate),
        .res_valid       (!res_fifo_empty),
        .res_a           (res_fifo_rd_data[RES_FIFO_DW-1 -: PIXEL_W]),
        .res_b           (res_fifo_rd_data[RES_FIFO_DW-1-PIXEL_W -: PIXEL_W]),
        .res_colour      (res_fifo_rd_data[7:0]),
        .res_rd_en       (res_fifo_rd_en),
        .miss            (bram_miss),
        .started         (bram_started),
        .done            (bram_done),
        .colour          (bram_colour),
        .read_done_pulse (bram_read_done_pulse)
    );

    logic [CLUSTER_COUNT-1:0] chosen_onehot;
    logic [CLUST_ADDR_W-1:0]  chosen_idx;
    logic                     chosen_valid;
    logic                     any_cluster_free;

    localparam int SEQ_CNT_W = $clog2(WORDS_WIDE + 1 + 1);
    logic [SEQ_CNT_W-1:0] word_idx;
    logic                 load_active, load_last;
    logic [SEQ_CNT_W-1:0] n_words;
    assign n_words = wide ? WORDS_WIDE[SEQ_CNT_W-1:0] : WORDS_NARROW[SEQ_CNT_W-1:0];

    logic [JOB_DATA_W-1:0] disp_job_data;

    logic [CLUSTER_COUNT-1:0]  cluster_wants_job;
    logic [CLUSTER_COUNT-1:0]  cluster_disp_valid;
    logic [PIXEL_ADDR_W-1:0]   disp_pixel_addr;
    logic [CLUSTER_COUNT-1:0]  cluster_done;
    logic [CLUSTER_COUNT-1:0]  cluster_result_ready;
    logic [PIXEL_ADDR_W-1:0]   cluster_result_pixel_addr [CLUSTER_COUNT];
    logic [PIXEL_W-1:0]        cluster_iter_colour       [CLUSTER_COUNT];

    assign disp_pixel_addr   = {coord_a_q[PIXEL_W-1:0], coord_b_q[PIXEL_W-1:0]};
    assign cluster_disp_valid = load_z_en ? chosen_onehot : '0;

    
                               
    logic opcode_reset_i;
    assign opcode_reset_i = opcode_broadcast_en | opcode_reset;

    logic [CLUSTER_COUNT-1:0] res_arb_onehot;
    logic [CLUST_ADDR_W-1:0]  res_arb_idx;
    logic                     res_arb_any;

    priority_encoder #(.BUS_WIDTH(CLUSTER_COUNT)) u_res_arb (
        .core_bus    (cluster_done),
        .core_select (res_arb_onehot),
        .core_address(res_arb_idx),
        .any_valid   (res_arb_any)
    );

    always_comb begin
        res_fifo_wr_en       = 1'b0;
        res_fifo_wr_data     = '0;
        cluster_result_ready = '0;

        if (bram_res_pending) begin
            res_fifo_wr_en   = !res_fifo_full;
            res_fifo_wr_data = { bram_res_pixel_addr, bram_res_data };
        end else if (res_arb_any && !res_fifo_full) begin
            res_fifo_wr_en       = 1'b1;
            res_fifo_wr_data     = { cluster_result_pixel_addr[res_arb_idx],
                                     cluster_iter_colour[res_arb_idx] };
            cluster_result_ready = res_arb_onehot;
        end
    end

    sync_fifo #(
        .DW    (RES_FIFO_DW),
        .DEPTH (RES_FIFO_D)
    ) u_res_fifo (
        .clk    (clk),
        .rst    (rst_i),
        .wr_en  (res_fifo_wr_en),
        .wr_data(res_fifo_wr_data),
        .full   (res_fifo_full),
        .rd_en  (res_fifo_rd_en),
        .rd_data(res_fifo_rd_data),
        .empty  (res_fifo_empty)
    );

    assign done                          = res_fifo_wr_en;
    assign {iter_x, iter_y, iter_colour} = res_fifo_wr_data;


    frame_fsm u_fsm (
        .clk                 (clk),
        .rst                 (rst_i),
        .start_flag          (start_flag),
        .julia               (julia),
        .wide                (wide),
        .job_valid           (grant),
        .job_ready           (wants_job),
        .load_last           (load_last),
        .any_cluster_free    (any_cluster_free),
        .bram_result_valid   (bram_read_done_pulse),
        .inject_stall        (inject_pending),
        .bram_miss           (bram_miss),
        .bram_started        (bram_started),
        .bram_done           (bram_done),
        .check_bram          (check_bram),
        .pixel_skip          (),
        .opcode_broadcast_en (opcode_broadcast_en),
        .load_c_en           (load_c_en),
        .load_z_en           (load_z_en),
        .start_load_pulse    (start_load_pulse),
        .accept_pulse        (accept_pulse),
        .capture_winner      (capture_winner)
    );

    load_sequencer #(
        .MAX_WORDS (WORDS_WIDE + 1)
    ) u_seq (
        .clk         (clk),
        .rst         (rst_i),
        .start_load  (start_load_pulse),
        .n_words     (n_words),
        .word_idx    (word_idx),
        .load_active (load_active),
        .load_last   (load_last)
    );

    cluster_arbiter #(
        .CLUSTER_COUNT (CLUSTER_COUNT)
    ) u_arb (
        .clk               (clk),
        .rst               (rst_i),
        .cluster_wants_job (cluster_wants_job),
        .capture           (capture_winner),
        .hold              (load_z_en),
        .chosen_onehot     (chosen_onehot),
        .chosen_idx        (chosen_idx),
        .chosen_valid      (chosen_valid),
        .any_free          (any_cluster_free)
    );

    job_datapath #(
        .DATA_WIDTH      (DATA_WIDTH),
        .JOB_DATA_W      (JOB_DATA_W),
        .OPCODE_W        (OPCODE_W)
    ) u_dp (
        .z_real          (z_real),
        .z_imag          (z_imag),
        .wide            (wide),
        .word_idx        (word_idx[1:0]),
        .opcode_en       (opcode_broadcast_en),
        .load_c_en       (load_c_en),
        .c_real          (c_x),
        .c_imag          (c_y),
        .fractal_type    (fractal_type),
        .max_iter        (max_iter),
        .disp_job_data   (disp_job_data)
    );

    generate
        for (genvar g = 0; g < CLUSTER_COUNT; g++) begin : gen_clusters
            cluster #(
                .CLUSTER_SIZE        (CLUSTER_SIZE),
                .PIXEL_ADDR_W        (PIXEL_ADDR_W),
                .PIXEL_W             (PIXEL_W),
                .JOB_DATA_W          (JOB_DATA_W),
                .LOWEST_MAX_ITER_POW (LOWEST_MAX_ITER_POW)
            ) u_cluster (
                .clk               (clk),
                .rst               (rst_i),
                .wide              (wide),
                .opcode_reset      (opcode_reset_i),
                .disp_valid        (cluster_disp_valid[g]),
                .disp_pixel_addr   (disp_pixel_addr),
                .disp_job_data     (disp_job_data),
                .cluster_wants_job (cluster_wants_job[g]),
                .result_valid      (cluster_done[g]),
                .result_pixel_addr (cluster_result_pixel_addr[g]),
                .result_data       (cluster_iter_colour[g]),
                .result_ready      (cluster_result_ready[g])
            );
        end
    endgenerate


logic [7:0] tile_table_addr;
// 9-bit saturating counter: bit[8] is the "full" latch.
// Counts to 256 (0x100) and holds there — no wrap, no pulse needed.
logic [8:0] tile_pixel_cnt [0:255];

// cu_wr_waddr = {tile_y[3:0], tile_x[3:0], row_in_tile[3:0], col_half[0]}
// waddr[12:5] = {tile_y[3:0], tile_x[3:0]} = tile index
assign tile_table_addr = cu_wr_waddr[12:5];

// cu_tile_done_set[i] is level-high once tile i has received all 256 pixels
genvar i;
generate
    for (i = 0; i < 256; i++) begin : tile_done_gen
        assign cu_tile_done_set[i] = tile_pixel_cnt[i][8];
    end
endgenerate

always_ff @(posedge clk) begin
    if (rst_i) begin
        for (int j = 0; j < 256; j++)
            tile_pixel_cnt[j] <= 9'h000;
    end else if (cu_wr_en && !tile_pixel_cnt[tile_table_addr][8]) begin
        tile_pixel_cnt[tile_table_addr] <= tile_pixel_cnt[tile_table_addr] + 9'h001;
    end
end
endmodule
