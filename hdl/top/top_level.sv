// Top-level integration: sixteenth_controller + per_sixteenth_engine
// AXI Lite slave and AXI HP master are stubbed pending IP wrapper integration

module top_level (
    input  logic clk,
    input  logic rst,

    // AXI HP write master - routed straight from bram_to_dram
    // TODO: connect to AXI HP master wrapper
    output logic [31:0] hp_axi_wr_addr,
    output logic [63:0] hp_axi_wr_data,
    output logic        hp_axi_wr_en,
    input  logic        hp_axi_wr_ready,

    // Interrupt to PS
    output logic irq_all_done
);

    // AXI Lite config registers (written by PS)
    // TODO: connect to AXI Lite slave wrapper
    logic        ps_start           = 1'b0;
    logic [4:0]  cfg_equation_id    = 5'd0;
    logic [31:0] cfg_centre_x       = 32'd0;
    logic [31:0] cfg_centre_y       = 32'd0;
    logic [31:0] cfg_zoom_level     = 32'd0;
    logic [11:0] cfg_max_iter       = 12'd0;
    logic [31:0] cfg_image_base_addr = 32'd0;

    // Controller <-> engine wires
    logic        ctrl_engine_rst;
    logic        ctrl_start;
    logic [4:0]  ctrl_equation_id;
    logic [31:0] ctrl_centre_x;
    logic [31:0] ctrl_centre_y;
    logic [31:0] ctrl_zoom_level;
    logic [11:0] ctrl_max_iter;
    logic [9:0]  ctrl_x_offset;
    logic [9:0]  ctrl_y_offset;
    logic [31:0] ctrl_sixteenth_base_addr;
    logic        ctrl_quarter_complete;
    logic        ctrl_all_done;

    // engine_rst combines global reset with between-sixteenth reset from controller
    wire engine_combined_rst = rst | ctrl_engine_rst;

    // sixteenth_controller
    sixteenth_controller u_sixteenth_controller (
        .clk                (clk),
        .rst                (rst),
        .ps_start           (ps_start),
        .cfg_equation_id    (cfg_equation_id),
        .cfg_centre_x       (cfg_centre_x),
        .cfg_centre_y       (cfg_centre_y),
        .cfg_zoom_level     (cfg_zoom_level),
        .cfg_max_iter       (cfg_max_iter),
        .cfg_image_base_addr(cfg_image_base_addr),
        .engine_rst         (ctrl_engine_rst),
        .start              (ctrl_start),
        .equation_id        (ctrl_equation_id),
        .centre_x           (ctrl_centre_x),
        .centre_y           (ctrl_centre_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .x_offset           (ctrl_x_offset),
        .y_offset           (ctrl_y_offset),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr),
        .quarter_complete   (ctrl_quarter_complete),
        .all_done           (ctrl_all_done)
    );

    // per_sixteenth_engine
    per_sixteenth_engine u_engine (
        .clk                (clk),
        .rst                (engine_combined_rst),
        .start              (ctrl_start),
        .engine_done        (),
        .quarter_complete   (ctrl_quarter_complete),
        .equation_id        (ctrl_equation_id),
        .centre_x           (ctrl_centre_x),
        .centre_y           (ctrl_centre_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .x_offset           (ctrl_x_offset),
        .y_offset           (ctrl_y_offset),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr),
        .axi_wr_addr        (hp_axi_wr_addr),
        .axi_wr_data        (hp_axi_wr_data),
        .axi_wr_en          (hp_axi_wr_en),
        .axi_wr_ready       (hp_axi_wr_ready)
    );

    assign irq_all_done = ctrl_all_done;

endmodule
