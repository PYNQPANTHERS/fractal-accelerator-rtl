// Top-level integration for one 256x256 sixteenth

module per_sixteenth_engine #(
    parameter int COORD_W = 8,   // coordinate bit width; matches scheduler and comparator
    parameter int TILE_W  = 16   // tile width/height in pixels (must be power of 2)
) (
    input  logic clk,
    input  logic rst,

    // Control
    input  logic start,
    output logic engine_done,
    output logic sixteenth_complete,

    // Config from sixteenth_controller
    input  logic [4:0]  fractal_type,
    input  logic [31:0] pan_x,
    input  logic [31:0] pan_y,
    input  logic [31:0] zoom_level,
    input  logic [11:0] max_iter,
    input  logic [9:0]  x_offset,
    input  logic [9:0]  y_offset,
    input  logic [3:0]  sixteenth_id,
    input  logic [31:0] sixteenth_base_addr,

    // AXI HP write (bram_to_dram → top level)
    output logic [31:0] axi_wr_addr,
    output logic [63:0] axi_wr_data,
    output logic        axi_wr_en,
    input  logic        axi_wr_ready
);

    localparam int TILES_PER_AXIS = (1 << COORD_W) / TILE_W;
    localparam int TOTAL_TILES    = TILES_PER_AXIS * TILES_PER_AXIS;
    localparam int TILE_IDX_W     = $clog2(TOTAL_TILES);
    localparam int BRAM_WORDS     = TOTAL_TILES * (TILE_W * TILE_W / 8);
    localparam int BRAM_ADDR_W    = $clog2(BRAM_WORDS);

    logic [COORD_W-1:0] sched_x, sched_y;
    logic        jqh_sched_push;
    logic        jqh_sched_stall;
    logic        jqh_flush;
    logic        jqh_wants_job;
    logic        jqh_grant;
    logic [15:0] jqh_coord_out;
    logic        cqh_done;
    logic [COORD_W-1:0] cqh_iter_x;
    logic [COORD_W-1:0] cqh_iter_y;
    logic [7:0]  cu_iter_colour_raw;
    logic [3:0]  cqh_iter_colour;
    assign cqh_iter_colour = cu_iter_colour_raw[3:0];
    logic        cqh_comp_pop;
    logic        cqh_comp_valid;
    logic [19:0] cqh_comp_data;
    logic        comp_sched_reset;
    logic [COORD_W-1:0] comp_top_left_x;
    logic [COORD_W-1:0] comp_top_left_y;
    logic [COORD_W:0]   comp_quad_size_x;
    logic [COORD_W:0]   comp_quad_size_y;
    logic [10:0] comp_expected_count;
    logic [5:0]  comp_ref_colour_o;
    logic        comp_differ;
    logic        comp_complete;
    logic [7:0]  cbram_ctrl_rd_x;
    logic [7:0]  cbram_ctrl_rd_y;
    logic        cbram_ctrl_rd_en;
    logic [7:0]  cbram_ctrl_rd_data;
    logic        cbram_ctrl_wr_en;
    logic [BRAM_ADDR_W-1:0] cbram_ctrl_wr_waddr;
    logic [63:0] cbram_ctrl_wr_word;
    logic [BRAM_ADDR_W-1:0] cbram_ctrl_rmw_rd_addr;
    logic        cbram_ctrl_rmw_rd_en;
    logic [63:0] cbram_ctrl_rmw_rd_data;
    logic [BRAM_ADDR_W-1:0] cbram_b2d_word_addr;
    logic        cbram_b2d_rd_en;
    logic        cbram_b2d_rd_grant;
    logic [63:0] cbram_b2d_rd_data;
    logic [TOTAL_TILES-1:0] cbram_tile_done;
    logic [7:0]  sbram_x;
    logic [7:0]  sbram_y;
    logic        sbram_rd;
    logic        sbram_we;
    logic [1:0]  sbram_wstate;
    logic [1:0]  sbram_rstate;
    logic        sbram_rd_valid;
    logic        sbram_wr_done;
    logic        sbram_clear_done;
    logic        b2d_sixteenth_complete;
    assign sixteenth_complete = b2d_sixteenth_complete && sbram_clear_done;
    logic        tt_wr_quad_en;
    logic [COORD_W-1:0] tt_wr_quad_tlx;
    logic [COORD_W-1:0] tt_wr_quad_tly;
    logic [COORD_W:0]   tt_wr_quad_size;
    logic [5:0]  tt_wr_quad_colour;
    logic [TILE_IDX_W-1:0] tt_rd_index;
    logic        tt_is_filled;
    logic [5:0]  tt_fill_colour;
    logic [TOTAL_TILES-1:0] sched_tile_done_set;
    logic [TOTAL_TILES-1:0] sched_tile_done;
    logic [TOTAL_TILES-1:0] tile_done;
    assign tile_done = cbram_tile_done | sched_tile_done;
    logic jqh_queue_empty;

    always_ff @(posedge clk) begin
        if (rst)
            sched_tile_done <= '0;
        else
            sched_tile_done <= sched_tile_done | sched_tile_done_set;
    end
    logic sched_engine_done;

    scheduler #(.COORD_W(COORD_W), .TILE_W(TILE_W)) u_scheduler (
        .clk              (clk),
        .rst              (rst),
        .start            (start),

        // comparator
        .differ           (comp_differ),
        .complete         (comp_complete),
        .ref_colour_o     (comp_ref_colour_o),
        .sched_reset      (comp_sched_reset),
        .expected_count   (comp_expected_count),
        .quad_size_x      (comp_quad_size_x),
        .quad_size_y      (comp_quad_size_y),
        .top_left_x       (comp_top_left_x),
        .top_left_y       (comp_top_left_y),

        // job queue
        .sched_x          (sched_x),
        .sched_y          (sched_y),
        .sched_push       (jqh_sched_push),
        .sched_stall_out  (),
        .sched_stall      (jqh_sched_stall),
        .flush            (jqh_flush),
        .job_queue_empty  (jqh_queue_empty),

        // tile_table
        .tt_wr_quad_en    (tt_wr_quad_en),
        .tt_wr_quad_tlx   (tt_wr_quad_tlx),
        .tt_wr_quad_tly   (tt_wr_quad_tly),
        .tt_wr_quad_size  (tt_wr_quad_size),
        .tt_wr_quad_colour(tt_wr_quad_colour),

        .sched_tile_done_set(sched_tile_done_set),
        .engine_done        (sched_engine_done)
    );

    // engine_done latched: scheduler fires a one-cycle pulse, bram_to_dram needs level
    always_ff @(posedge clk) begin
        if (rst)
            engine_done <= 1'b0;
        else if (sched_engine_done)
            engine_done <= 1'b1;
    end

    control_unit #(.TILE_W(TILE_W)) u_control_unit (
        .clk                (clk),
        .rst                (rst),
        .opcode_reset       (1'b0),

        .fractal_type       (fractal_type),
        .pan_x              (pan_x[17:0]),
        .pan_y              (pan_y[17:0]),
        .zoom_level         (zoom_level[3:0]),
        .max_iter           (max_iter[4:0]),
        .sixteenth          (sixteenth_id),
        .start_flag         (start),
        .width_flag         (1'b0),
        .c_x                ('0),
        .c_y                ('0),

        .wants_job          (jqh_wants_job),
        .grant              (jqh_grant),
        .coord_out          (jqh_coord_out),
        .done               (cqh_done),
        .iter_x             (cqh_iter_x),
        .iter_y             (cqh_iter_y),
        .iter_colour        (cu_iter_colour_raw),
        .cu_rd_x            (cbram_ctrl_rd_x),
        .cu_rd_y            (cbram_ctrl_rd_y),
        .cu_rd_en           (cbram_ctrl_rd_en),
        .cu_rd_data         (cbram_ctrl_rd_data),
        .cu_wr_en           (cbram_ctrl_wr_en),
        .cu_wr_waddr        (cbram_ctrl_wr_waddr),
        .cu_wr_word         (cbram_ctrl_wr_word),
        .cu_rmw_rd_en       (cbram_ctrl_rmw_rd_en),
        .cu_rmw_rd_addr     (cbram_ctrl_rmw_rd_addr),
        .cu_rmw_rd_data     (cbram_ctrl_rmw_rd_data),
        .sb_x               (sbram_x),
        .sb_y               (sbram_y),
        .sb_rd              (sbram_rd),
        .sb_we              (sbram_we),
        .sb_wstate          (sbram_wstate),
        .sb_rstate          (sbram_rstate)
    );

    comparator #(.COORD_W(COORD_W)) u_comparator (
        .clk            (clk),
        .rst            (rst),
        .sched_reset    (comp_sched_reset),
        .top_left_x     (comp_top_left_x),
        .top_left_y     (comp_top_left_y),
        .quad_size_x    (comp_quad_size_x),
        .quad_size_y    (comp_quad_size_y),
        .expected_count (comp_expected_count),
        .comp_valid     (cqh_comp_valid),
        .comp_data      (cqh_comp_data),
        .comp_pop       (cqh_comp_pop),
        .ref_colour_o   (comp_ref_colour_o),
        .differ         (comp_differ),
        .complete       (comp_complete)
    );

    job_queue_handler u_job_queue_handler (
        .clk         (clk),
        .rst         (rst),
        .sched_coord ({sched_y, sched_x}),
        .sched_push  (jqh_sched_push),
        .sched_stall (jqh_sched_stall),
        .flush       (jqh_flush),
        .wants_job   (jqh_wants_job),
        .grant       (jqh_grant),
        .coord_out   (jqh_coord_out),
        .queue_empty (jqh_queue_empty)
    );

    complete_queue_handler u_complete_queue_handler (
        .clk        (clk),
        .rst        (rst),
        .done       (cqh_done),
        .iter_x     (cqh_iter_x),
        .iter_y     (cqh_iter_y),
        .iter_colour(cqh_iter_colour),
        .comp_pop   (cqh_comp_pop),
        .comp_valid (cqh_comp_valid),
        .comp_data  (cqh_comp_data),
        .full_err   ()
    );

    colour_bram #(.TILE_W(TILE_W)) u_colour_bram (
        .clk          (clk),
        .rst          (rst),
        .ctrl_rd_x    (cbram_ctrl_rd_x),
        .ctrl_rd_y    (cbram_ctrl_rd_y),
        .ctrl_rd_en   (cbram_ctrl_rd_en),
        .ctrl_rd_data (cbram_ctrl_rd_data),
        .ctrl_wr_en       (cbram_ctrl_wr_en),
        .ctrl_wr_waddr    (cbram_ctrl_wr_waddr),
        .ctrl_wr_word     (cbram_ctrl_wr_word),
        .ctrl_rmw_rd_en   (cbram_ctrl_rmw_rd_en),
        .ctrl_rmw_rd_addr (cbram_ctrl_rmw_rd_addr),
        .ctrl_rmw_rd_data (cbram_ctrl_rmw_rd_data),
        .b2d_word_addr(cbram_b2d_word_addr),
        .b2d_rd_en    (cbram_b2d_rd_en),
        .b2d_rd_grant (cbram_b2d_rd_grant),
        .b2d_rd_data  (cbram_b2d_rd_data),
        .tile_done    (cbram_tile_done)
    );

    state_bram u_state_bram (
        .clk     (clk),
        .rst     (rst),
        .x       (sbram_x),
        .y       (sbram_y),
        .rd      (sbram_rd),
        .we      (sbram_we),
        .wstate  (sbram_wstate),
        .rstate    (sbram_rstate),
        .rd_valid  (sbram_rd_valid),
        .wr_done   (sbram_wr_done),
        .clear_done(sbram_clear_done)
    );

    tile_table #(.TILE_W(TILE_W)) u_tile_table (
        .clk             (clk),
        .rst             (rst),
        .wr_quad_en      (tt_wr_quad_en),
        .wr_quad_tlx     (tt_wr_quad_tlx),
        .wr_quad_tly     (tt_wr_quad_tly),
        .wr_quad_size    (tt_wr_quad_size),
        .wr_quad_colour  (tt_wr_quad_colour),
        .rd_index        (tt_rd_index),
        .rd_is_filled    (tt_is_filled),
        .rd_fill_colour  (tt_fill_colour)
    );

    bram_to_dram #(.TILE_W(TILE_W)) u_bram_to_dram (
        .clk                (clk),
        .rst                (rst),
        .tile_done          (tile_done),
        .engine_done        (engine_done),
        .tt_rd_index        (tt_rd_index),
        .tt_is_filled       (tt_is_filled),
        .tt_fill_colour     (tt_fill_colour),
        .b2d_word_addr      (cbram_b2d_word_addr),
        .b2d_rd_en          (cbram_b2d_rd_en),
        .b2d_rd_grant       (cbram_b2d_rd_grant),
        .b2d_rd_data        (cbram_b2d_rd_data),
        .axi_wr_addr        (axi_wr_addr),
        .axi_wr_data        (axi_wr_data),
        .axi_wr_en          (axi_wr_en),
        .axi_wr_ready       (axi_wr_ready),
        .cache_valid_wr_en  (),
        .cache_valid_index  (),
        .cache_valid_value  (),
        .sixteenth_base_addr(sixteenth_base_addr),
        .sixteenth_complete   (b2d_sixteenth_complete)
    );

endmodule
