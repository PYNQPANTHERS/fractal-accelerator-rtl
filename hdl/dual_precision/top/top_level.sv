// Single-engine top level: sixteenth_controller + one per_sixteenth_engine.
// The single engine drives the hp_axi_wr_* port DIRECTLY — no arbiter needed
// (dual_core merges its two engines through axi_wr_arbiter; here there is only
// one). External ports are IDENTICAL to dual_core/top_level so a single Vivado
// block design (axi_lite_slave -> cfg_*, hp_axi_wr_* -> axi_hp_master_wrap) works
// for both designs. The testbench reconstructs the image from the colour-BRAM
// write stream via hierarchical refs and just holds hp_axi_wr_ready high.

module top_level #(
    parameter int TILE_W        = 16,  // tile width/height in pixels (power of 2)
    parameter int CLUSTER_COUNT = 4,   // iterator compute clusters per engine
    parameter int CLUSTER_SIZE  = 8    // worker cores per cluster
)(
    input  logic clk,
    input  logic rst,

    input  logic        ps_start,
    input  logic [4:0]  cfg_fractal_type,
    input  logic [34:0] cfg_julia_real,
    input  logic [34:0] cfg_julia_imag,
    input  logic [34:0] cfg_centre_x,
    input  logic [34:0] cfg_centre_y,
    input  logic [15:0] cfg_zoom_level,
    input  logic [11:0] cfg_max_iter,
    input  logic [31:0] cfg_image_base_addr,

    // AXI HP write master — connect to axi_hp_master_wrap in the block design
    output logic [31:0] hp_axi_wr_addr,
    output logic [63:0] hp_axi_wr_data,
    output logic        hp_axi_wr_en,
    input  logic        hp_axi_wr_ready,

    output logic irq_all_done,
    output logic irq_started
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
        .cfg_centre_x          (cfg_centre_x),
        .cfg_centre_y          (cfg_centre_y),
        .cfg_zoom_level     (cfg_zoom_level),
        .cfg_max_iter       (cfg_max_iter),
        .cfg_image_base_addr(cfg_image_base_addr),
        .engine_rst         (ctrl_engine_rst),
        .start              (ctrl_start),
        .fractal_type       (ctrl_fractal_type),
        .centre_x              (ctrl_pan_x),
        .centre_y              (ctrl_pan_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .sixteenth_id       (ctrl_sixteenth_id),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr),
        .sixteenth_complete (ctrl_sixteenth_complete),
        .all_done           (ctrl_all_done),
        .started            (ctrl_started)
    );

    // Single engine drives the HP write port directly — no arbiter needed.
    // (named u_engine_a so one TB matches dual_core too)
    per_sixteenth_engine #(
        .TILE_W       (TILE_W),
        .CLUSTER_COUNT(CLUSTER_COUNT),
        .CLUSTER_SIZE (CLUSTER_SIZE)
    ) u_engine_a (
        .clk                (clk),
        .rst                (engine_combined_rst),
        .start              (ctrl_start),
        .engine_done        (),
        .sixteenth_complete (ctrl_sixteenth_complete),
        .fractal_type       (ctrl_fractal_type),
        .julia_real         (cfg_julia_real),
        .julia_imag         (cfg_julia_imag),
        .centre_x              (ctrl_pan_x),
        .centre_y              (ctrl_pan_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .sixteenth_id       (ctrl_sixteenth_id),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr),
        .axi_wr_addr        (hp_axi_wr_addr),
        .axi_wr_data        (hp_axi_wr_data),
        .axi_wr_en          (hp_axi_wr_en),
        .axi_wr_ready       (hp_axi_wr_ready)
    );

    assign irq_all_done = ctrl_all_done;
    assign irq_started  = ctrl_started;

endmodule
