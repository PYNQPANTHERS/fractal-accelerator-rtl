// ─────────────────────────────────────────────────────────────────────────────
// control_unit (thin top)
//
//   Wires together:
//     - translate        : pixel coord -> complex plane (combinational)
//     - frame_fsm        : sequencer + scheduler handshake + bram check gate
//     - bram_read        : status-BRAM lookup (started/done/miss per pixel)
//     - load_sequencer   : multi-cycle transfer counter
//     - cluster_arbiter  : cluster priority encoder + winner lock
//     - job_datapath     : coord latch + word mux -> disp_job_data
//     - CLUSTER_COUNT x cluster
//     - result arbiter   : priority-picks the first cluster with a valid result
//     - result FIFO      : output buffer, handshake independent of dispatch side
//
//   TODO:
//     - pan_x / pan_y / zoom tied off
//     - finish bram write logic
// ─────────────────────────────────────────────────────────────────────────────
module control_unit #(
    parameter int DATA_WIDTH    = 17,
    parameter int PIXEL_WIDTH   = 9,
    parameter int CLUSTER_COUNT = 4,
    parameter int CLUSTER_SIZE  = 8,
    parameter int PIXEL_ADDR_W  = 16,
    parameter int JOB_DATA_W    = 18,
    parameter int PIXEL_W       = 8,
    parameter int OPCODE_W      = 5
) (
    input  logic            clk,
    input  logic            rst,

    // frame control
    input  logic            start_flag,
    input  logic            width_flag,
    input  logic [4:0]      fractal_type,
    input  logic [4:0]      iteration_count,

    // scheduler handshake (pixel coords in)
    input  logic                    job_valid,
    input  logic [PIXEL_WIDTH-1:0]  job_a,
    input  logic [PIXEL_WIDTH-1:0]  job_b,
    output logic                    job_ready,

    // result output handshake (independent of dispatch-side FSM)
    output logic                    result_valid,
    output logic [PIXEL_ADDR_W-1:0] result_pixel_addr,
    output logic [PIXEL_W-1:0]      result_data,
    input  logic                    result_ready,

    // external BRAM interface — 1-cycle read latency
    // rd_en asserted cycle N → rd_data valid cycle N+1
    output logic                    bram_rd_en,
    output logic [PIXEL_W-1:0]      bram_pixel_a,   // row coordinate
    output logic [PIXEL_W-1:0]      bram_pixel_b,   // col coordinate
    input  logic [15:0]             bram_rd_data,   // [7:0]=status  [15:8]=colour
    output logic                    bram_wr_en,
    output logic [PIXEL_W-1:0]      bram_wr_pixel_a,
    output logic [PIXEL_W-1:0]      bram_wr_pixel_b,
    output logic [7:0]              bram_wr_data
);

    // ──────────────────────────────────────────────────────────────
    // local params
    // ──────────────────────────────────────────────────────────────
    localparam int Z_WIDTH      = DATA_WIDTH + 1;
    localparam int Z_WIDE       = Z_WIDTH * 2 - 1;
    localparam int CLUST_ADDR_W = $clog2(CLUSTER_COUNT);
    localparam int WORDS_NARROW = 2;
    localparam int WORDS_WIDE   = 4;
    localparam int RES_FIFO_DW  = PIXEL_ADDR_W + PIXEL_W;
    localparam int RES_FIFO_D   = (CLUSTER_COUNT < 4) ? 4 : CLUSTER_COUNT * 2;

    logic julia, wide;
    assign julia = fractal_type[4];
    assign wide  = width_flag;

    // ──────────────────────────────────────────────────────────────
    // latched pixel coords (captured on job accept)
    // ──────────────────────────────────────────────────────────────
    logic [PIXEL_WIDTH-1:0] coord_a_q, coord_b_q;

    always_ff @(posedge clk) begin
        if (rst) begin
            coord_a_q <= '0;
            coord_b_q <= '0;
        end else if (accept_pulse) begin
            coord_a_q <= job_a;
            coord_b_q <= job_b;
        end
    end

    // ──────────────────────────────────────────────────────────────
    // translate — runs on latched coords
    // ──────────────────────────────────────────────────────────────
    logic [DATA_WIDTH-1:0] pan_x, pan_y;
    logic [3:0]            zoom;
    logic [Z_WIDE-1:0]     z_real, z_imag;

    assign pan_x = '0;  // TODO
    assign pan_y = '0;  // TODO
    assign zoom  = '0;  // TODO

    translate #(
        .DATA_WIDTH (Z_WIDE),
        .RESOLUTION (PIXEL_WIDTH)
    ) cheezy_translator (
        .pan_x  (pan_x),
        .pan_y  (pan_y),
        .a      (coord_a_q),
        .b      (coord_b_q),
        .zoom   (zoom),
        .z_real (z_real),
        .z_imag (z_imag)
    );

    // ──────────────────────────────────────────────────────────────
    // FSM control strobes
    // ──────────────────────────────────────────────────────────────
    logic opcode_broadcast_en, load_c_en, load_z_en;
    logic start_load_pulse, accept_pulse, capture_winner;
    logic check_bram;

    // ──────────────────────────────────────────────────────────────
    // bram_read status BRAM lookup for completed pixel
    // a/b are 8-bit pixel coordinates 
    // ──────────────────────────────────────────────────────────────
    logic bram_miss, bram_started, bram_done;
    logic [4:0] bram_colour;

    // bram_done fast-path: pixel already computed, push directly to result FIFO
    logic                    bram_res_pending;
    logic [PIXEL_ADDR_W-1:0] bram_res_pixel_addr;
    logic [PIXEL_W-1:0]      bram_res_data;

    assign bram_res_pending    = bram_done;
    assign bram_res_pixel_addr = {coord_a_q[PIXEL_W-1:0], coord_b_q[PIXEL_W-1:0]};
    assign bram_res_data       = {{(PIXEL_W-5){1'b0}}, bram_colour};

    bram_read #(
        .PIXEL_ADDR_W (PIXEL_ADDR_W),
        .PIXEL_W      (PIXEL_W),
        .COLOURWIDTH  (5)
    ) u_bram_read (
        .clk          (clk),
        .rst          (rst),
        .check_bram   (check_bram),
        .a            (coord_a_q[PIXEL_W-1:0]),
        .b            (coord_b_q[PIXEL_W-1:0]),
        .bram_rd_en   (bram_rd_en),
        .bram_rd_data (bram_rd_data),
        .miss         (bram_miss),
        .started      (bram_started),
        .done         (bram_done),
        .colour       (bram_colour)
    );

    // pixel coords wired directly to BRAM address ports
    assign bram_pixel_a = coord_a_q[PIXEL_W-1:0];
    assign bram_pixel_b = coord_b_q[PIXEL_W-1:0];

    // write path not yet implemented — tied off
    assign bram_wr_en      = 1'b0;  // TODO: wire to result write path
    assign bram_wr_pixel_a = '0;
    assign bram_wr_pixel_b = '0;
    assign bram_wr_data    = '0;

    // ──────────────────────────────────────────────────────────────
    // dispatch arbiter (cluster-level)
    // ──────────────────────────────────────────────────────────────
    logic [CLUSTER_COUNT-1:0] chosen_onehot;
    logic [CLUST_ADDR_W-1:0]  chosen_idx;
    logic                     chosen_valid;
    logic                     any_cluster_free;

    // ──────────────────────────────────────────────────────────────
    // sequencer
    // ──────────────────────────────────────────────────────────────
    localparam int SEQ_CNT_W = $clog2(WORDS_WIDE + 1 + 1);
    logic [SEQ_CNT_W-1:0] word_idx;
    logic                 load_active, load_last;
    logic [SEQ_CNT_W-1:0] n_words;
    assign n_words = wide ? WORDS_WIDE[SEQ_CNT_W-1:0] : WORDS_NARROW[SEQ_CNT_W-1:0];

    // ──────────────────────────────────────────────────────────────
    // datapath
    // ──────────────────────────────────────────────────────────────
    logic [JOB_DATA_W-1:0] disp_job_data;

    // ──────────────────────────────────────────────────────────────
    // cluster signals
    // ──────────────────────────────────────────────────────────────
    logic [CLUSTER_COUNT-1:0]  cluster_wants_job;
    logic [CLUSTER_COUNT-1:0]  cluster_disp_valid;
    logic [PIXEL_ADDR_W-1:0]   disp_pixel_addr;
    logic [CLUSTER_COUNT-1:0]  cluster_result_valid;
    logic [CLUSTER_COUNT-1:0]  cluster_result_ready;
    logic [PIXEL_ADDR_W-1:0]   cluster_result_pixel_addr [CLUSTER_COUNT];
    logic [PIXEL_W-1:0]        cluster_result_data       [CLUSTER_COUNT];

    assign disp_pixel_addr = {coord_a_q[PIXEL_W-1:0], coord_b_q[PIXEL_W-1:0]};
    assign cluster_disp_valid = load_z_en ? chosen_onehot : '0;

    // ──────────────────────────────────────────────────────────────
    // result arbiter :
    // priority-pick from clusters with valid results
    // mirrors the cluster-internal done arbiter pattern.
    // adds the BRAM result to this wuth maximum priority so is always
    // taken ensuring no stall
    // ──────────────────────────────────────────────────────────────
    logic [CLUSTER_COUNT-1:0] res_arb_onehot;
    logic [CLUST_ADDR_W-1:0]  res_arb_idx;
    logic                     res_arb_any;

    priority_encoder #(.BUS_WIDTH(CLUSTER_COUNT)) u_res_arb (
        .core_bus    (cluster_result_valid),
        .core_select (res_arb_onehot),
        .core_address(res_arb_idx),
        .any_valid   (res_arb_any)
    );

    // ──────────────────────────────────────────────────────────────
    // result output FIFO
    // filled by the result arbiter drained by comp unit
    // via an independent valid/ready handshake.
    // ──────────────────────────────────────────────────────────────
    logic                    res_fifo_wr_en;
    logic [RES_FIFO_DW-1:0]  res_fifo_wr_data;
    logic                    res_fifo_full;

    logic                    res_fifo_rd_en;
    logic [RES_FIFO_DW-1:0]  res_fifo_rd_data;
    logic                    res_fifo_empty;

    // Result FIFO write mux — BRAM result always wins.
    // and written out stalling fifo from draining

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
                                     cluster_result_data[res_arb_idx] };
            cluster_result_ready = res_arb_onehot;
        end
    end

    sync_fifo #(
        .DW    (RES_FIFO_DW),
        .DEPTH (RES_FIFO_D)
    ) u_res_fifo (
        .clk    (clk),
        .rst_n  (~rst),
        .wr_en  (res_fifo_wr_en),
        .wr_data(res_fifo_wr_data),
        .full   (res_fifo_full),
        .rd_en  (res_fifo_rd_en),
        .rd_data(res_fifo_rd_data),
        .empty  (res_fifo_empty)
    );

    // output handshake — fully independent of the dispatch FSM
    assign result_valid                        = !res_fifo_empty;
    assign {result_pixel_addr, result_data}    = res_fifo_rd_data;
    assign res_fifo_rd_en                      = result_valid && result_ready;

    // ──────────────────────────────────────────────────────────────
    // sub-modules
    // ──────────────────────────────────────────────────────────────
    frame_fsm u_fsm (
        .clk                 (clk),
        .rst                 (rst),
        .start_flag          (start_flag),
        .julia               (julia),
        .wide                (wide),
        .job_valid           (job_valid),
        .job_ready           (job_ready),
        .load_last           (load_last),
        .any_cluster_free    (any_cluster_free),
        .bram_miss           (bram_miss),
        .bram_started        (bram_started),
        .bram_done           (bram_done),
        .check_bram          (check_bram),
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
        .rst         (rst),
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
        .rst               (rst),
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
        .fractal_type    (fractal_type),
        .iteration_count (iteration_count),
        .disp_job_data   (disp_job_data)
    );

    generate
        for (genvar g = 0; g < CLUSTER_COUNT; g++) begin : gen_clusters
            cluster #(
                .CLUSTER_SIZE (CLUSTER_SIZE),
                .PIXEL_ADDR_W (PIXEL_ADDR_W),
                .PIXEL_W      (PIXEL_W),
                .JOB_DATA_W   (JOB_DATA_W)
            ) u_cluster (
                .clk               (clk),
                .rst_n             (~rst),
                .disp_valid        (cluster_disp_valid[g]),
                .disp_pixel_addr   (disp_pixel_addr),
                .disp_job_data     (disp_job_data),
                .cluster_wants_job (cluster_wants_job[g]),
                .result_valid      (cluster_result_valid[g]),
                .result_pixel_addr (cluster_result_pixel_addr[g]),
                .result_data       (cluster_result_data[g]),
                .result_ready      (cluster_result_ready[g])
            );
        end
    endgenerate

endmodule
