// Dual-engine top level: one dual_sixteenth_controller drives two per_sixteenth_engine
// instances in parallel.  Each engine's bram_to_dram drives its own
// axi_hp_master_wrap, routed to a separate HP port (HP0 for engine A,
// HP1 for engine B) — independent DRAM write streams, no arbitration.

module dual_top_level #(
    parameter int TILE_W = 16
)(
    input  logic clk,
    input  logic rst,

    input  logic        ps_start,
    input  logic [4:0]  cfg_fractal_type,
    input  logic [34:0] cfg_julia_real,
    input  logic [34:0] cfg_julia_imag,
    input  logic [34:0] cfg_pan_x,
    input  logic [34:0] cfg_pan_y,
    input  logic [15:0] cfg_zoom_level,
    input  logic [11:0] cfg_max_iter,
    input  logic [31:0] cfg_image_base_addr,

    output logic irq_all_done,
    output logic irq_started,

    // AXI HP0 master (engine A)
    output logic [5:0]  hp0_awid,
    output logic [31:0] hp0_awaddr,
    output logic [7:0]  hp0_awlen,
    output logic [2:0]  hp0_awsize,
    output logic [1:0]  hp0_awburst,
    output logic [3:0]  hp0_awcache,
    output logic [2:0]  hp0_awprot,
    output logic [3:0]  hp0_awqos,
    output logic        hp0_awvalid,
    input  logic        hp0_awready,
    output logic [63:0] hp0_wdata,
    output logic [7:0]  hp0_wstrb,
    output logic        hp0_wlast,
    output logic        hp0_wvalid,
    input  logic        hp0_wready,
    input  logic [5:0]  hp0_bid,
    input  logic [1:0]  hp0_bresp,
    input  logic        hp0_bvalid,
    output logic        hp0_bready,

    // AXI HP1 master (engine B)
    output logic [5:0]  hp1_awid,
    output logic [31:0] hp1_awaddr,
    output logic [7:0]  hp1_awlen,
    output logic [2:0]  hp1_awsize,
    output logic [1:0]  hp1_awburst,
    output logic [3:0]  hp1_awcache,
    output logic [2:0]  hp1_awprot,
    output logic [3:0]  hp1_awqos,
    output logic        hp1_awvalid,
    input  logic        hp1_awready,
    output logic [63:0] hp1_wdata,
    output logic [7:0]  hp1_wstrb,
    output logic        hp1_wlast,
    output logic        hp1_wvalid,
    input  logic        hp1_wready,
    input  logic [5:0]  hp1_bid,
    input  logic [1:0]  hp1_bresp,
    input  logic        hp1_bvalid,
    output logic        hp1_bready,

    // Status (per port)
    output logic        hp0_err_flag,
    output logic        hp0_burst_done,
    output logic        hp1_err_flag,
    output logic        hp1_burst_done
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

    // bram_to_dram → axi_hp_master_wrap (per engine)
    logic [31:0] axi_wr_addr_a, axi_wr_addr_b;
    logic [63:0] axi_wr_data_a, axi_wr_data_b;
    logic        axi_wr_en_a,   axi_wr_en_b;
    logic        axi_wr_ready_a, axi_wr_ready_b;

    // Dual controller 
    dual_sixteenth_controller #(.TILE_W(TILE_W)) u_dual_controller (
        .clk                  (clk),
        .rst                  (rst),
        .ps_start             (ps_start),
        .cfg_fractal_type     (cfg_fractal_type),
        .cfg_pan_x            (cfg_pan_x),
        .cfg_pan_y            (cfg_pan_y),
        .cfg_zoom_level       (cfg_zoom_level),
        .cfg_max_iter         (cfg_max_iter),
        .cfg_image_base_addr  (cfg_image_base_addr),
        .engine_rst_a         (ctrl_engine_rst_a),
        .start_a              (ctrl_start_a),
        .engine_rst_b         (ctrl_engine_rst_b),
        .start_b              (ctrl_start_b),
        .fractal_type         (ctrl_fractal_type),
        .pan_x                (ctrl_pan_x),
        .pan_y                (ctrl_pan_y),
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

    // Engine A 
    per_sixteenth_engine #(.TILE_W(TILE_W), .CLUSTER_COUNT(2)) u_engine_a (
        .clk                (clk),
        .rst                (engine_combined_rst_a),
        .start              (ctrl_start_a),
        .engine_done        (),
        .sixteenth_complete (ctrl_sixteenth_complete_a),
        .fractal_type       (ctrl_fractal_type),
        .julia_real         (cfg_julia_real),
        .julia_imag         (cfg_julia_imag),
        .centre_x           (ctrl_pan_x),
        .centre_y           (ctrl_pan_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .sixteenth_id       (ctrl_sixteenth_id_a),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr_a),
        .axi_wr_addr        (axi_wr_addr_a),
        .axi_wr_data        (axi_wr_data_a),
        .axi_wr_en          (axi_wr_en_a),
        .axi_wr_ready       (axi_wr_ready_a)
    );

    // Engine B 
    per_sixteenth_engine #(.TILE_W(TILE_W), .CLUSTER_COUNT(2)) u_engine_b (
        .clk                (clk),
        .rst                (engine_combined_rst_b),
        .start              (ctrl_start_b),
        .engine_done        (),
        .sixteenth_complete (ctrl_sixteenth_complete_b),
        .fractal_type       (ctrl_fractal_type),
        .julia_real         (cfg_julia_real),
        .julia_imag         (cfg_julia_imag),
        .centre_x           (ctrl_pan_x),
        .centre_y           (ctrl_pan_y),
        .zoom_level         (ctrl_zoom_level),
        .max_iter           (ctrl_max_iter),
        .sixteenth_id       (ctrl_sixteenth_id_b),
        .sixteenth_base_addr(ctrl_sixteenth_base_addr_b),
        .axi_wr_addr        (axi_wr_addr_b),
        .axi_wr_data        (axi_wr_data_b),
        .axi_wr_en          (axi_wr_en_b),
        .axi_wr_ready       (axi_wr_ready_b)
    );

    // AXI HP0 master wrap (engine A → S_AXI_HP0) 
    axi_hp_master_wrap #(.TILE_W(TILE_W)) u_hp_a (
        .clk      (clk),
        .rst      (rst),
        .wr_addr  (axi_wr_addr_a),
        .wr_data  (axi_wr_data_a),
        .wr_en    (axi_wr_en_a),
        .wr_ready (axi_wr_ready_a),
        .m_awid   (hp0_awid),
        .m_awaddr (hp0_awaddr),
        .m_awlen  (hp0_awlen),
        .m_awsize (hp0_awsize),
        .m_awburst(hp0_awburst),
        .m_awcache(hp0_awcache),
        .m_awprot (hp0_awprot),
        .m_awqos  (hp0_awqos),
        .m_awvalid(hp0_awvalid),
        .m_awready(hp0_awready),
        .m_wdata  (hp0_wdata),
        .m_wstrb  (hp0_wstrb),
        .m_wlast  (hp0_wlast),
        .m_wvalid (hp0_wvalid),
        .m_wready (hp0_wready),
        .m_bid    (hp0_bid),
        .m_bresp  (hp0_bresp),
        .m_bvalid (hp0_bvalid),
        .m_bready (hp0_bready),
        .err_flag  (hp0_err_flag),
        .burst_done(hp0_burst_done)
    );

    // AXI HP1 master wrap (engine B → S_AXI_HP1) 
    axi_hp_master_wrap #(.TILE_W(TILE_W)) u_hp_b (
        .clk      (clk),
        .rst      (rst),
        .wr_addr  (axi_wr_addr_b),
        .wr_data  (axi_wr_data_b),
        .wr_en    (axi_wr_en_b),
        .wr_ready (axi_wr_ready_b),
        .m_awid   (hp1_awid),
        .m_awaddr (hp1_awaddr),
        .m_awlen  (hp1_awlen),
        .m_awsize (hp1_awsize),
        .m_awburst(hp1_awburst),
        .m_awcache(hp1_awcache),
        .m_awprot (hp1_awprot),
        .m_awqos  (hp1_awqos),
        .m_awvalid(hp1_awvalid),
        .m_awready(hp1_awready),
        .m_wdata  (hp1_wdata),
        .m_wstrb  (hp1_wstrb),
        .m_wlast  (hp1_wlast),
        .m_wvalid (hp1_wvalid),
        .m_wready (hp1_wready),
        .m_bid    (hp1_bid),
        .m_bresp  (hp1_bresp),
        .m_bvalid (hp1_bvalid),
        .m_bready (hp1_bready),
        .err_flag  (hp1_err_flag),
        .burst_done(hp1_burst_done)
    );

    assign irq_all_done = ctrl_all_done;
    assign irq_started  = ctrl_started;

endmodule
