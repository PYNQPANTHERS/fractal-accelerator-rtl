// Dual-engine top level: one dual_sixteenth_controller drives two per_sixteenth_engine
// instances in parallel.  Engine A renders even sixteenths (0,2,…,14); engine B
// renders odd sixteenths (1,3,…,15).  DRAM/AXI is stubbed (axi_wr_ready tied high)
// and will be wired up in a future revision.

module top_level #(
    parameter int TILE_W        = 16,
    parameter int CLUSTER_COUNT = 4,   // iterator compute clusters per engine (power of 2)
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

    output logic irq_all_done,
    output logic irq_started
);

    // ── Controller → engine wires ───────────────────────────────────────────
    logic        ctrl_engine_rst_a, ctrl_engine_rst_b;
    logic        ctrl_start_a,      ctrl_start_b;
    logic [4:0]  ctrl_fractal_type;
    logic [34:0] ctrl_pan_x;
    logic [34:0] ctrl_pan_y;
    logic [15:0] ctrl_zoom_level;
    logic [11:0] ctrl_max_iter;

    logic [3:0]  ctrl_sixteenth_id_a;
    logic [31:0] ctrl_sixteenth_base_addr_a;
    logic        ctrl_sixteenth_complete_a;

    logic [3:0]  ctrl_sixteenth_id_b;
    logic [31:0] ctrl_sixteenth_base_addr_b;
    logic        ctrl_sixteenth_complete_b;

    logic ctrl_all_done;
    logic ctrl_started;

    // Each engine has its own combined reset
    wire engine_combined_rst_a = rst | ctrl_engine_rst_a;
    wire engine_combined_rst_b = rst | ctrl_engine_rst_b;

    // ── AXI stubs (DRAM not connected yet — tied ready high) ───────────────
    logic [31:0] axi_wr_addr_a, axi_wr_addr_b;
    logic [63:0] axi_wr_data_a, axi_wr_data_b;
    logic        axi_wr_en_a,   axi_wr_en_b;

    // ── Dual controller ────────────────────────────────────────────────────
    sixteenth_controller #(.TILE_W(TILE_W)) u_dual_controller (
        .clk                  (clk),
        .rst                  (rst),
        .ps_start             (ps_start),
        .cfg_fractal_type     (cfg_fractal_type),
        .cfg_centre_x            (cfg_centre_x),
        .cfg_centre_y            (cfg_centre_y),
        .cfg_zoom_level       (cfg_zoom_level),
        .cfg_max_iter         (cfg_max_iter),
        .cfg_image_base_addr  (cfg_image_base_addr),
        .engine_rst_a         (ctrl_engine_rst_a),
        .start_a              (ctrl_start_a),
        .engine_rst_b         (ctrl_engine_rst_b),
        .start_b              (ctrl_start_b),
        .fractal_type         (ctrl_fractal_type),
        .centre_x                (ctrl_pan_x),
        .centre_y                (ctrl_pan_y),
        .zoom_level           (ctrl_zoom_level),
        .max_iter             (ctrl_max_iter),
        .sixteenth_id_a       (ctrl_sixteenth_id_a),
        .sixteenth_base_addr_a(ctrl_sixteenth_base_addr_a),
        .sixteenth_complete_a (ctrl_sixteenth_complete_a),
        .sixteenth_id_b       (ctrl_sixteenth_id_b),
        .sixteenth_base_addr_b(ctrl_sixteenth_base_addr_b),
        .sixteenth_complete_b (ctrl_sixteenth_complete_b),
        .all_done             (ctrl_all_done),
        .started              (ctrl_started)
    );

    // ── Engine A (even sixteenths: 0, 2, 4, …, 14) ────────────────────────
    per_sixteenth_engine #(
        .TILE_W       (TILE_W),
        .CLUSTER_COUNT(CLUSTER_COUNT),
        .CLUSTER_SIZE (CLUSTER_SIZE)
    ) u_engine_a (
        .clk                (clk),
        .rst                (engine_combined_rst_a),
        .start              (ctrl_start_a),
        .engine_done        (),
        .sixteenth_complete (ctrl_sixteenth_complete_a),
        .fractal_type       (ctrl_fractal_type),
        .julia_real         (cfg_julia_real),
        .julia_imag         (cfg_julia_imag),
        .centre_x              (ctrl_pan_x),
        .centre_y              (ctrl_pan_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .sixteenth_id       (ctrl_sixteenth_id_a),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr_a),
        .axi_wr_addr        (axi_wr_addr_a),
        .axi_wr_data        (axi_wr_data_a),
        .axi_wr_en          (axi_wr_en_a),
        .axi_wr_ready       (1'b1)
    );

    // ── Engine B (odd sixteenths: 1, 3, 5, …, 15) ─────────────────────────
    per_sixteenth_engine #(
        .TILE_W       (TILE_W),
        .CLUSTER_COUNT(CLUSTER_COUNT),
        .CLUSTER_SIZE (CLUSTER_SIZE)
    ) u_engine_b (
        .clk                (clk),
        .rst                (engine_combined_rst_b),
        .start              (ctrl_start_b),
        .engine_done        (),
        .sixteenth_complete (ctrl_sixteenth_complete_b),
        .fractal_type       (ctrl_fractal_type),
        .julia_real         (cfg_julia_real),
        .julia_imag         (cfg_julia_imag),
        .centre_x              (ctrl_pan_x),
        .centre_y              (ctrl_pan_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .sixteenth_id       (ctrl_sixteenth_id_b),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr_b),
        .axi_wr_addr        (axi_wr_addr_b),
        .axi_wr_data        (axi_wr_data_b),
        .axi_wr_en          (axi_wr_en_b),
        .axi_wr_ready       (1'b1)
    );

    assign irq_all_done = ctrl_all_done;
    assign irq_started  = ctrl_started;

endmodule
