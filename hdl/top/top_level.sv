// Top-level integration: sixteenth_controller + per_sixteenth_engine
//
// AXI Lite config registers and AXI HP write interface are now exposed as
// plain ports — they are driven/consumed by axi_lite_slave and
// axi_hp_master_wrap respectively in bram_to_dram_top.sv.

module top_level #(
    parameter int TILE_W = 16   // tile width/height in pixels (must be power of 2)
)(
    input  logic clk,
    input  logic rst,

    // AXI HP write master - routed straight from bram_to_dram (inside engine)
    // connect to axi_hp_master_wrap in bram_to_dram_top
    output logic [31:0] hp_axi_wr_addr,
    output logic [63:0] hp_axi_wr_data,
    output logic        hp_axi_wr_en,
    input  logic        hp_axi_wr_ready,

    // Interrupt to PS
    output logic irq_all_done,

    // PS handshake: high while PL is rendering (PS should not re-assert ps_start)
    output logic irq_started,

    // -------------------------------------------------------------------------
    // AXI Lite config registers — driven by axi_lite_slave in bram_to_dram_top
    // -------------------------------------------------------------------------
    input  logic        ps_start,
    input  logic [4:0]  cfg_fractal_type,
    input  logic [34:0] cfg_julia_real,
    input  logic [34:0] cfg_julia_imag,
    input  logic [34:0] cfg_pan_x,
    input  logic [34:0] cfg_pan_y,
    input  logic [15:0] cfg_zoom_level,
    input  logic [11:0] cfg_max_iter,
    input  logic [31:0] cfg_image_base_addr,

    // -------------------------------------------------------------------------
    // Debug taps → axi_lite_slave (driven by per_sixteenth_engine)
    // -------------------------------------------------------------------------
    output logic [3:0]  dbg_scheduler_state,
    output logic        dbg_sched_push,
    output logic        dbg_wants_job,
    output logic        dbg_grant,
    output logic        dbg_cqh_done,
    output logic        dbg_comp_valid,
    output logic        dbg_comp_complete,
    output logic        dbg_comp_differ,
    output logic        dbg_engine_done,

    // writeback-stage debug taps (per_sixteenth_engine → bram_to_dram) → axi_lite_slave (BD)
    output logic [8:0]  dbg_tile_done_pop,
    output logic [8:0]  dbg_transferred_pop,
    output logic [2:0]  dbg_b2d_state,
    output logic        dbg_b2d_any_pending,
    output logic        dbg_b2d_wr_en,
    output logic        dbg_b2d_accept,
    output logic        dbg_tile_done_rise
);

    // Controller <-> engine wires
    logic        ctrl_engine_rst;
    logic        ctrl_start;
    logic [4:0]  ctrl_fractal_type;
    logic [34:0] ctrl_pan_x;
    logic [34:0] ctrl_pan_y;
    logic [15:0] ctrl_zoom_level;
    logic [11:0] ctrl_max_iter;
    logic [3:0]  ctrl_sixteenth_id;
    logic [31:0] ctrl_sixteenth_base_addr;
    logic        ctrl_sixteenth_complete;
    logic        ctrl_all_done;
    logic        ctrl_started;

    // engine_rst combines global reset with between-sixteenth reset from controller
    wire engine_combined_rst = rst | ctrl_engine_rst;

    // sixteenth_controller
    sixteenth_controller #(.TILE_W(TILE_W)) u_sixteenth_controller (
        .clk                (clk),
        .rst                (rst),
        .ps_start           (ps_start),
        .cfg_fractal_type   (cfg_fractal_type),
        .cfg_pan_x          (cfg_pan_x),
        .cfg_pan_y          (cfg_pan_y),
        .cfg_zoom_level     (cfg_zoom_level),
        .cfg_max_iter       (cfg_max_iter),
        .cfg_image_base_addr(cfg_image_base_addr),
        .engine_rst         (ctrl_engine_rst),
        .start              (ctrl_start),
        .fractal_type       (ctrl_fractal_type),
        .pan_x              (ctrl_pan_x),
        .pan_y              (ctrl_pan_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .sixteenth_id       (ctrl_sixteenth_id),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr),
        .sixteenth_complete (ctrl_sixteenth_complete),
        .all_done           (ctrl_all_done),
        .started            (ctrl_started)
    );

    // per_sixteenth_engine
    per_sixteenth_engine #(.TILE_W(TILE_W)) u_engine (
        .clk                (clk),
        .rst                (engine_combined_rst),
        .start              (ctrl_start),
        .engine_done        (),
        .sixteenth_complete (ctrl_sixteenth_complete),
        .fractal_type       (ctrl_fractal_type),
        .julia_real         (cfg_julia_real),
        .julia_imag         (cfg_julia_imag),
        .pan_x              (ctrl_pan_x),
        .pan_y              (ctrl_pan_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .sixteenth_id       (ctrl_sixteenth_id),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr),
        .axi_wr_addr        (hp_axi_wr_addr),
        .axi_wr_data        (hp_axi_wr_data),
        .axi_wr_en          (hp_axi_wr_en),
        .axi_wr_ready       (hp_axi_wr_ready),

        // debug taps → top_level ports → axi_lite_slave
        .dbg_scheduler_state(dbg_scheduler_state),
        .dbg_sched_push     (dbg_sched_push),
        .dbg_wants_job      (dbg_wants_job),
        .dbg_grant          (dbg_grant),
        .dbg_cqh_done       (dbg_cqh_done),
        .dbg_comp_valid     (dbg_comp_valid),
        .dbg_comp_complete  (dbg_comp_complete),
        .dbg_comp_differ    (dbg_comp_differ),
        .dbg_engine_done    (dbg_engine_done),

        // writeback-stage debug taps → top_level ports → axi_lite_slave (BD)
        .dbg_tile_done_pop  (dbg_tile_done_pop),
        .dbg_transferred_pop(dbg_transferred_pop),
        .dbg_b2d_state      (dbg_b2d_state),
        .dbg_b2d_any_pending(dbg_b2d_any_pending),
        .dbg_b2d_wr_en      (dbg_b2d_wr_en),
        .dbg_b2d_accept     (dbg_b2d_accept),
        .dbg_tile_done_rise (dbg_tile_done_rise)
    );

    assign irq_all_done = ctrl_all_done;
    assign irq_started  = ctrl_started;

endmodule
