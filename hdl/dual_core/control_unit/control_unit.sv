module control_unit #(
    parameter int DATA_WIDTH          = 18,
    parameter int CLUSTER_COUNT       = 4,
    parameter int CLUSTER_SIZE        = 8,
    parameter int PIXEL_ADDR_W        = 16,
    parameter int JOB_DATA_W          = 18,
    parameter int PIXEL_W             = 8,
    parameter int OPCODE_W            = 5,
    parameter  int LOWEST_MAX_ITER_POW = 6,
    parameter  int TILE_W              = 16,  // tile width/height in pixels (must be power of 2)
    localparam int BRAM_ADDR_W         = 13
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    opcode_reset,

    // frame control
    input  logic [4:0]              fractal_type,
    input  logic [34:0]   centre_x,
    input  logic [34:0]   centre_y,
    input  logic [15:0]              zoom_level,
    input  logic [4:0]              max_iter,
    input  logic                    start_flag,
    input  logic                    width_flag,
    input  logic [3:0]              sixteenth,

    // julia c in full precision
    input  logic [34:0]   c_x,
    input  logic [34:0]   c_y,

    // scheduler handshake (pixel coords in)
    output logic                    wants_job,
    input  logic                    grant,
    input  logic                    coord_skip,  // 1 = bottom-level quadtree tile, bypass BRAM check
    input  logic [PIXEL_ADDR_W-1:0] coord_out,

    // dispatch queue flush reset
    input logic                     flush,

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
    output logic [BRAM_ADDR_W-1:0]  cu_wr_waddr,
    output logic [63:0]             cu_wr_word,
    // color bram RMW pre-read
    output logic [BRAM_ADDR_W-1:0]  cu_rmw_rd_addr,
    output logic                    cu_rmw_rd_en,
    input  logic [63:0]             cu_rmw_rd_data,

    // state_bram
    output logic [PIXEL_W-1:0]      sb_x,
    output logic [PIXEL_W-1:0]      sb_y,
    output logic                    sb_rd,
    output logic                    sb_we,
    output logic [1:0]              sb_wstate,
    input  logic [1:0]              sb_rstate

);

    localparam int Z_WIDE       = 35;
    localparam int WORDS_NARROW = 2;
    localparam int WORDS_WIDE   = 4;
    localparam int RES_FIFO_DW  = PIXEL_ADDR_W + PIXEL_W + 1; // +1 for reinject flag (MSB)
    localparam int RES_FIFO_D   = CLUSTER_COUNT * 2;
    // Dispatch FIFO: {z_real, z_imag, pixel_addr} — CLUSTER_COUNT must be a power of 2
    localparam int DISPATCH_DW  = PIXEL_ADDR_W + Z_WIDE * 2;
    localparam int DISPATCH_D   = CLUSTER_COUNT * 2;

    logic julia, wide;
    assign julia = fractal_type[4];
    assign wide  = width_flag;

    logic rst_i;
    assign rst_i = rst | opcode_reset;

    logic opcode_broadcast_en, load_c_en;
    logic start_load_pulse;

    logic [Z_WIDE-1:0] z_real, z_imag;

    logic [PIXEL_W-1:0]      pf_coord_a, pf_coord_b;
    logic                    pf_check_bram;
    logic                    pf_inject_pending;
    logic [PIXEL_ADDR_W-1:0] pf_inject_addr;
    logic [PIXEL_W-1:0]      pf_inject_colour;
    // TB-visible alias so both old and new CU share the same probe path
    logic                    inject_pending;
    assign inject_pending = pf_inject_pending;

    logic                    dispatch_wr_en;
    logic [DISPATCH_DW-1:0]  dispatch_wr_data;
    logic                    dispatch_full;
    logic                    dispatch_rd_en;
    logic [DISPATCH_DW-1:0]  dispatch_rd_data;
    logic                    dispatch_empty;

    logic                    dispatch_queue_clear;
    assign dispatch_queue_clear = rst | flush;

    assign cu_rd_x = pf_coord_a;
    assign cu_rd_y = pf_coord_b;

    translate #(
        .DATA_WIDTH (35),
        .RESOLUTION (PIXEL_W)
    ) cheezy_translator (
        .clk       (clk),
        .centre_x     (centre_x),
        .centre_y     (centre_y),
        .a         (pf_coord_a),
        .b         (pf_coord_b),
        .zoom      (zoom_level),
        .sixteenth (sixteenth),
        .z_real    (z_real),
        .z_imag    (z_imag)
    );

    logic bram_miss, bram_started, bram_done;
    logic [7:0] bram_colour;
    logic bram_read_done_pulse;

    logic                    res_fifo_wr_en;
    logic [RES_FIFO_DW-1:0]  res_fifo_wr_data;
    logic                    res_fifo_full;
    logic                    res_fifo_rd_en;
    logic [RES_FIFO_DW-1:0]  res_fifo_rd_data;
    logic                    res_fifo_empty;

    bram_read_write #(
        .PIXEL_W (PIXEL_W),
        .TILE_W  (TILE_W)
    ) u_bram_rw (
        .clk             (clk),
        .rst             (rst_i),
        .check_bram      (pf_check_bram),
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
        .res_reinject    (res_fifo_rd_data[RES_FIFO_DW-1]),
        .res_a           (res_fifo_rd_data[RES_FIFO_DW-2 -: PIXEL_W]),
        .res_b           (res_fifo_rd_data[RES_FIFO_DW-2-PIXEL_W -: PIXEL_W]),
        .res_colour      (res_fifo_rd_data[7:0]),
        .res_rd_en       (res_fifo_rd_en),
        .miss            (bram_miss),
        .started         (bram_started),
        .done            (bram_done),
        .colour          (bram_colour),
        .read_done_pulse (bram_read_done_pulse)
    );

    job_prefetch #(
        .PIXEL_ADDR_W (PIXEL_ADDR_W),
        .PIXEL_W      (PIXEL_W),
        .Z_WIDE       (Z_WIDE)
    ) u_prefetch (
        .clk                 (clk),
        .rst                 (rst_i),
        .wants_job           (wants_job),
        .grant               (grant),
        .skip                (coord_skip),
        .coord_out           (coord_out),
        .coord_a             (pf_coord_a),
        .coord_b             (pf_coord_b),
        .z_real              (z_real),
        .z_imag              (z_imag),
        .check_bram          (pf_check_bram),
        .bram_miss           (bram_miss),
        .bram_done           (bram_done),
        .bram_colour         (bram_colour),
        .bram_read_done_pulse(bram_read_done_pulse),
        .dispatch_wr_en      (dispatch_wr_en),
        .dispatch_wr_data    (dispatch_wr_data),
        .dispatch_full       (dispatch_full),
        .inject_pending      (pf_inject_pending),
        .inject_addr         (pf_inject_addr),
        .inject_colour       (pf_inject_colour),
        .res_fifo_full       (res_fifo_full)
    );


    // this needs to reset on flush from scheduler 
    // Dispatch FIFO — {z_real, z_imag, pixel_addr} entries ready for cluster dispatch
    sync_fifo #(
        .DW    (DISPATCH_DW),
        .DEPTH (DISPATCH_D)
    ) u_dispatch_fifo (
        .clk    (clk),
        .rst    (rst_i),
        .wr_en  (dispatch_wr_en),
        .wr_data(dispatch_wr_data),
        .full   (dispatch_full),
        .rd_en  (dispatch_rd_en),
        .rd_data(dispatch_rd_data),
        .empty  (dispatch_empty)
    );


    localparam int CLUST_ADDR_W = (CLUSTER_COUNT > 1) ? $clog2(CLUSTER_COUNT) : 1;

    logic [CLUSTER_COUNT-1:0] cluster_wants_job;
    logic [CLUSTER_COUNT-1:0] cluster_done;
    logic [CLUSTER_COUNT-1:0] cluster_result_ready;
    logic [PIXEL_ADDR_W-1:0]  cluster_result_pixel_addr [CLUSTER_COUNT];
    logic [PIXEL_W-1:0]       cluster_iter_colour       [CLUSTER_COUNT];

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

        if (pf_inject_pending) begin
            res_fifo_wr_en   = !res_fifo_full;
            res_fifo_wr_data = { 1'b1, pf_inject_addr, pf_inject_colour };
        end else if (res_arb_any && !res_fifo_full) begin
            res_fifo_wr_en   = 1'b1;
            res_fifo_wr_data = { 1'b0, cluster_result_pixel_addr[res_arb_idx],
                                 cluster_iter_colour[res_arb_idx] };
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

    assign done       = res_fifo_wr_en;
    assign iter_x     = res_fifo_wr_data[RES_FIFO_DW-2          -: PIXEL_W];
    assign iter_y     = res_fifo_wr_data[RES_FIFO_DW-2-PIXEL_W  -: PIXEL_W];
    assign iter_colour= res_fifo_wr_data[7:0];

    localparam int SEQ_CNT_W = $clog2(WORDS_WIDE + 1 + 1);
    logic [SEQ_CNT_W-1:0] word_idx;
    logic                 load_active, load_last;
    logic [SEQ_CNT_W-1:0] n_words;
    assign n_words = wide ? WORDS_WIDE[SEQ_CNT_W-1:0] : WORDS_NARROW[SEQ_CNT_W-1:0];

    frame_fsm u_fsm (
        .clk                 (clk),
        .rst                 (rst_i),
        .start_flag          (start_flag),
        .julia               (julia),
        .wide                (wide),
        .load_last           (load_last),
        .opcode_broadcast_en (opcode_broadcast_en),
        .load_c_en           (load_c_en),
        .start_load_pulse    (start_load_pulse)
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

    logic opcode_reset_i;
    assign opcode_reset_i = opcode_broadcast_en | opcode_reset;

    always_comb begin
        cluster_result_ready = '0;
        if (res_arb_any && !res_fifo_full && !pf_inject_pending)
            cluster_result_ready = res_arb_onehot;
    end

    logic [CLUSTER_COUNT-1:0]  dispatch_req_per;
    logic [CLUSTER_COUNT-1:0]  dispatch_grant_per;
    logic                      dispatch_any_req;
    logic [CLUSTER_COUNT-1:0]  disp_valid_per;
    logic [PIXEL_ADDR_W-1:0]   disp_pixel_addr_per [CLUSTER_COUNT];
    logic [JOB_DATA_W-1:0]     disp_job_data_per   [CLUSTER_COUNT];

    // Priority-encoded FIFO arbiter lowest index wins ties
    // cant think of better way tbh there is a writing bottle neck
    priority_encoder #(.BUS_WIDTH(CLUSTER_COUNT)) u_dispatch_arb (
        .core_bus    (dispatch_req_per),
        .core_select (dispatch_grant_per),
        .core_address(),
        .any_valid   (dispatch_any_req)
    );
    assign dispatch_rd_en = dispatch_any_req;

    generate
        for (genvar g = 0; g < CLUSTER_COUNT; g++) begin : gen_dispatch_paths
            cluster_dispatch_path #(
                .DATA_WIDTH   (DATA_WIDTH),
                .JOB_DATA_W   (JOB_DATA_W),
                .OPCODE_W     (OPCODE_W),
                .PIXEL_ADDR_W (PIXEL_ADDR_W),
                .Z_WIDE       (Z_WIDE),
                .MAX_WORDS    (WORDS_WIDE + 1)
            ) u_disp (
                .clk               (clk),
                .rst               (rst_i),
                .wide              (wide),
                .opcode_broadcast_en(opcode_broadcast_en),
                .load_c_en         (load_c_en),
                .shared_word_idx   (word_idx[1:0]),
                .c_real            (c_x),
                .c_imag            (c_y),
                .fractal_type      (fractal_type),
                .max_iter          (max_iter),
                .dispatch_empty    (dispatch_empty),
                .dispatch_rd_data  (dispatch_rd_data),
                .dispatch_req      (dispatch_req_per[g]),
                .dispatch_grant    (dispatch_grant_per[g]),
                .cluster_wants_job (cluster_wants_job[g]),
                .disp_valid        (disp_valid_per[g]),
                .disp_pixel_addr   (disp_pixel_addr_per[g]),
                .disp_job_data     (disp_job_data_per[g])
            );
        end
    endgenerate

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
                .disp_valid        (disp_valid_per[g]),
                .disp_pixel_addr   (disp_pixel_addr_per[g]),
                .disp_job_data     (disp_job_data_per[g]),
                .cluster_wants_job (cluster_wants_job[g]),
                .result_valid      (cluster_done[g]),
                .result_pixel_addr (cluster_result_pixel_addr[g]),
                .result_data       (cluster_iter_colour[g]),
                .result_ready      (cluster_result_ready[g])
            );
        end
    endgenerate
endmodule
