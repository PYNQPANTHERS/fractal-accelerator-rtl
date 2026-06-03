// Integrates all compute modules for one 256x256 sixteenth

module per_sixteenth_engine (
    input  logic clk,
    input  logic rst,

    // Control
    input  logic start,
    output logic engine_done,
    output logic sixteenth_complete,

    // Config from sixteenth_controller
    input  logic [4:0]  equation_id,
    input  logic [31:0] centre_x,
    input  logic [31:0] centre_y,
    input  logic [31:0] zoom_level,
    input  logic [11:0] max_iter,
    input  logic [9:0]  x_offset,
    input  logic [9:0]  y_offset,
    input  logic [31:0] sixteenth_base_addr,

    // AXI HP write (bram_to_dram → top level)
    output logic [31:0] axi_wr_addr,
    output logic [63:0] axi_wr_data,
    output logic        axi_wr_en,
    input  logic        axi_wr_ready
);
    // Job queue handler wire
    logic [17:0] jqh_sched_coord;
    logic        jqh_sched_push;
    logic        jqh_sched_stall;
    logic        jqh_flush;
    logic        jqh_wants_job;
    logic        jqh_grant;
    logic [17:0] jqh_coord_out;
    // Complete queue handler wire
    logic        cqh_done;
    logic [8:0]  cqh_iter_x;
    logic [8:0]  cqh_iter_y;
    logic [3:0]  cqh_iter_colour;
    logic        cqh_comp_pop;
    logic        cqh_comp_valid;
    logic [21:0] cqh_comp_data;
    // Comparator wires (driven by scheduler, read by comparator
    logic        comp_sched_reset;
    logic [8:0]  comp_top_left_x;
    logic [8:0]  comp_top_left_y;
    logic [8:0]  comp_quad_size;
    logic [10:0] comp_expected_count;
    logic [5:0]  comp_ref_colour_o;
    logic        comp_differ;
    logic        comp_complete;
    // colour_bram wire (ctrl read driven by control_unit; ctrl write also by control_unit)
    logic [8:0]  cbram_ctrl_rd_x;
    logic [8:0]  cbram_ctrl_rd_y;
    logic        cbram_ctrl_rd_en;
    logic [7:0]  cbram_ctrl_rd_data;
    logic [8:0]  cbram_ctrl_wr_x;
    logic [8:0]  cbram_ctrl_wr_y;
    logic        cbram_ctrl_wr_en;
    logic [7:0]  cbram_ctrl_wr_data;
    logic [12:0] cbram_b2d_word_addr;
    logic        cbram_b2d_rd_en;
    logic        cbram_b2d_rd_grant;
    logic [63:0] cbram_b2d_rd_data;
    // state_bram wires (driven by control_unit
    logic [8:0]  sbram_a_x;
    logic [8:0]  sbram_a_y;
    logic        sbram_a_rd;
    logic        sbram_a_we;
    logic [1:0]  sbram_a_wstate;
    logic [1:0]  sbram_a_rstate;
    // tile_table wire
    logic        tt_wr_single_en;
    logic [7:0]  tt_wr_single_index;
    logic        tt_wr_single_filled;
    logic [5:0]  tt_wr_single_colour;
    logic        tt_wr_quad_en;
    logic [7:0]  tt_wr_quad_tlx;
    logic [7:0]  tt_wr_quad_tly;
    logic [7:0]  tt_wr_quad_size;
    logic [5:0]  tt_wr_quad_colour;
    logic [7:0]  tt_rd_index;
    logic        tt_is_filled;
    logic [5:0]  tt_fill_colour;
    // tile_done: sticky OR of flood-fill (scheduler) and tiled (control_unit) path
    logic [255:0] sched_tile_done_set;
    logic [255:0] cu_tile_done_set;
    logic [255:0] tile_done;

    always_ff @(posedge clk) begin
        if (rst)
            tile_done <= '0;
        else
            tile_done <= tile_done | sched_tile_done_set | cu_tile_done_set;
    end
    // scheduler
    // Quad-tree FSM (Mariani-Silver). Pushes border pixels to job queue,
    // receives comparator flags, flood fills or splits
    scheduler u_scheduler (
        .clk                (clk),
        .rst                (rst),
        .start              (start),

        .equation_id        (equation_id),
        .centre_x           (centre_x),
        .centre_y           (centre_y),
        .zoom_level         (zoom_level),
        .max_iter           (max_iter),
        .x_offset           (x_offset),
        .y_offset           (y_offset),

        // Job queue push
        .sched_coord        (jqh_sched_coord),
        .sched_push         (jqh_sched_push),
        .sched_stall        (jqh_sched_stall),
        .flush              (jqh_flush),

        // Comparator configuration
        .sched_reset        (comp_sched_reset),
        .top_left_x         (comp_top_left_x),
        .top_left_y         (comp_top_left_y),
        .quad_size          (comp_quad_size),
        .expected_count     (comp_expected_count),

        // Comparator results
        .differ             (comp_differ),
        .complete           (comp_complete),
        .ref_colour_o       (comp_ref_colour_o),

        // tile_table quad write (flood fill path)
        .tt_wr_quad_en      (tt_wr_quad_en),
        .tt_wr_quad_tlx     (tt_wr_quad_tlx),
        .tt_wr_quad_tly     (tt_wr_quad_tly),
        .tt_wr_quad_size    (tt_wr_quad_size),
        .tt_wr_quad_colour  (tt_wr_quad_colour),

        // Tile done (flood fill path)
        .sched_tile_done_set(sched_tile_done_set),

        .engine_done        (engine_done)
    );

    // control_unit
    // Manages iterator pool. Pops jobs, computes pixels, writes colour/state
    control_unit u_control_unit (
        .clk                (clk),
        .rst                (rst),

        .equation_id        (equation_id),
        .centre_x           (centre_x),
        .centre_y           (centre_y),
        .zoom_level         (zoom_level),
        .max_iter           (max_iter),
        .x_offset           (x_offset),
        .y_offset           (y_offset),

        // Job queue pop
        .wants_job          (jqh_wants_job),
        .grant              (jqh_grant),
        .coord_out          (jqh_coord_out),

        // Complete queue push
        .done               (cqh_done),
        .iter_x             (cqh_iter_x),
        .iter_y             (cqh_iter_y),
        .iter_colour        (cqh_iter_colour),

        // colour_bram read (check cached colour for already-computed pixels)
        .cu_rd_x            (cbram_ctrl_rd_x),
        .cu_rd_y            (cbram_ctrl_rd_y),
        .cu_rd_en           (cbram_ctrl_rd_en),
        .cu_rd_data         (cbram_ctrl_rd_data),

        // colour_bram write
        .cu_wr_x            (cbram_ctrl_wr_x),
        .cu_wr_y            (cbram_ctrl_wr_y),
        .cu_wr_en           (cbram_ctrl_wr_en),
        .cu_wr_data         (cbram_ctrl_wr_data),

        // state_bram
        .sb_x               (sbram_a_x),
        .sb_y               (sbram_a_y),
        .sb_rd              (sbram_a_rd),
        .sb_we              (sbram_a_we),
        .sb_wstate          (sbram_a_wstate),
        .sb_rstate          (sbram_a_rstate),

        // tile_table single write (tiled path)
        .tt_wr_single_en    (tt_wr_single_en),
        .tt_wr_single_index (tt_wr_single_index),
        .tt_wr_single_filled(tt_wr_single_filled),
        .tt_wr_single_colour(tt_wr_single_colour),

        // Tile done (tiled path)
        .cu_tile_done_set   (cu_tile_done_set)
    );

    // comparator
    // Drains complete_queue_handler. Checks border colour uniformity
    comparator u_comparator (
        .clk            (clk),
        .rst            (rst),
        .sched_reset    (comp_sched_reset),
        .top_left_x     (comp_top_left_x),
        .top_left_y     (comp_top_left_y),
        .quad_size      (comp_quad_size),
        .expected_count (comp_expected_count),
        .comp_valid     (cqh_comp_valid),
        .comp_data      (cqh_comp_data),
        .comp_pop       (cqh_comp_pop),
        .ref_colour_o   (comp_ref_colour_o),
        .differ         (comp_differ),
        .complete       (comp_complete)
    );

    // job_queue_handler
    // Buffers pixel coordinates between scheduler (push) and control_unit (pop)
    job_queue_handler u_job_queue_handler (
        .clk        (clk),
        .rst        (rst),
        .sched_coord(jqh_sched_coord),
        .sched_push (jqh_sched_push),
        .sched_stall(jqh_sched_stall),
        .flush      (jqh_flush),
        .wants_job  (jqh_wants_job),
        .grant      (jqh_grant),
        .coord_out  (jqh_coord_out)
    );

    // complete_queue_handler
    // Buffers completed pixel results between control_unit (push) and comparator (pop)
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

    // colour_bram
    // Dual-port: ctrl (Port A, read by bram_to_dram / write by control_unit),
    //            b2d (Port B, read by control_unit)
    colour_bram u_colour_bram (
        .clk          (clk),
        .ctrl_rd_x    (cbram_ctrl_rd_x),
        .ctrl_rd_y    (cbram_ctrl_rd_y),
        .ctrl_rd_en   (cbram_ctrl_rd_en),
        .ctrl_rd_data (cbram_ctrl_rd_data),
        .ctrl_wr_x    (cbram_ctrl_wr_x),
        .ctrl_wr_y    (cbram_ctrl_wr_y),
        .ctrl_wr_en   (cbram_ctrl_wr_en),
        .ctrl_wr_data (cbram_ctrl_wr_data),
        .b2d_word_addr(cbram_b2d_word_addr),
        .b2d_rd_en    (cbram_b2d_rd_en),
        .b2d_rd_grant (cbram_b2d_rd_grant),
        .b2d_rd_data  (cbram_b2d_rd_data)
    );

    // state_bram
    // Per-pixel computation state (uncomputed / in-progress / done)
    state_bram u_state_bram (
        .clk     (clk),
        .rst     (rst),
        .a_x     (sbram_a_x),
        .a_y     (sbram_a_y),
        .a_rd    (sbram_a_rd),
        .a_we    (sbram_a_we),
        .a_wstate(sbram_a_wstate),
        .a_rstate(sbram_a_rstate)
    );

    // tile_table
    // 256-entry register file: one entry per 16x16 tile.
    // quad port driven by scheduler (flood fill); single port by control_unit (tiled).
    // Read combinationally by bram_to_dram
    tile_table u_tile_table (
        .clk             (clk),
        .rst             (rst),
        .wr_single_en    (tt_wr_single_en),
        .wr_single_index (tt_wr_single_index),
        .wr_single_filled(tt_wr_single_filled),
        .wr_single_colour(tt_wr_single_colour),
        .wr_quad_en      (tt_wr_quad_en),
        .wr_quad_tlx     (tt_wr_quad_tlx),
        .wr_quad_tly     (tt_wr_quad_tly),
        .wr_quad_size    (tt_wr_quad_size),
        .wr_quad_colour  (tt_wr_quad_colour),
        .rd_index        (tt_rd_index),
        .rd_is_filled    (tt_is_filled),
        .rd_fill_colour  (tt_fill_colour)
    );

    // bram_to_dram
    // Streams completed tiles to DDR3 via AXI HP
    bram_to_dram u_bram_to_dram (
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
        .sixteenth_complete   (sixteenth_complete)
    );

endmodule
