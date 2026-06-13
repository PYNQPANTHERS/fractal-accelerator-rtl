// =============================================================================
// bram_to_dram_top.sv
//
// Top-level wrapper for Vivado Block Design integration on PYNQ Z1.
//
// Instantiates:
//   - axi_lite_slave     (PS → PL config/status, connect to M_AXI_GP0)
//   - top_level           (sixteenth_controller + per_sixteenth_engine,
//                           which internally contains bram_to_dram)
//   - axi_hp_master_wrap  (PL → DRAM data, connect to S_AXI_HP0)
//
// Port naming follows Xilinx AXI convention (s_axi_lite_*, m_axi_hp_*) so
// that when this module is added to a Block Design as an RTL module,
// "Create Interface" / Connection Automation can group and connect them
// to the Zynq PS block.
//
// TILE_W is forwarded to both top_level and axi_hp_master_wrap — they
// MUST match for AWLEN/WLAST timing to be correct.
// =============================================================================

module bram_to_dram_top #(
    parameter int TILE_W = 16   // tile width/height in pixels (power of 2)
)(
    // -------------------------------------------------------------------------
    // Clock and Reset — connect to Zynq PS FCLK_CLK0 / FCLK_RESET0_N
    // -------------------------------------------------------------------------
    input  logic         s_axi_aclk,
    input  logic         s_axi_aresetn,   // active-low, from FCLK_RESET0_N

    // -------------------------------------------------------------------------
    // AXI4-Lite Slave port — connect to M_AXI_GP0
    // -------------------------------------------------------------------------
    input  logic [7:0]   s_axi_lite_awaddr,
    input  logic         s_axi_lite_awvalid,
    output logic         s_axi_lite_awready,

    input  logic [31:0]  s_axi_lite_wdata,
    input  logic [3:0]   s_axi_lite_wstrb,
    input  logic         s_axi_lite_wvalid,
    output logic         s_axi_lite_wready,

    output logic [1:0]   s_axi_lite_bresp,
    output logic         s_axi_lite_bvalid,
    input  logic         s_axi_lite_bready,

    input  logic [7:0]   s_axi_lite_araddr,
    input  logic         s_axi_lite_arvalid,
    output logic         s_axi_lite_arready,

    output logic [31:0]  s_axi_lite_rdata,
    output logic [1:0]   s_axi_lite_rresp,
    output logic         s_axi_lite_rvalid,
    input  logic         s_axi_lite_rready,

    // -------------------------------------------------------------------------
    // AXI4 HP Master port — connect to S_AXI_HP0
    // -------------------------------------------------------------------------
    output logic [5:0]   m_axi_hp_awid,
    output logic [31:0]  m_axi_hp_awaddr,
    output logic [7:0]   m_axi_hp_awlen,
    output logic [2:0]   m_axi_hp_awsize,
    output logic [1:0]   m_axi_hp_awburst,
    output logic [3:0]   m_axi_hp_awcache,
    output logic [2:0]   m_axi_hp_awprot,
    output logic [3:0]   m_axi_hp_awqos,
    output logic         m_axi_hp_awvalid,
    input  logic         m_axi_hp_awready,

    output logic [63:0]  m_axi_hp_wdata,
    output logic [7:0]   m_axi_hp_wstrb,
    output logic         m_axi_hp_wlast,
    output logic         m_axi_hp_wvalid,
    input  logic         m_axi_hp_wready,

    input  logic [5:0]   m_axi_hp_bid,
    input  logic [1:0]   m_axi_hp_bresp,
    input  logic         m_axi_hp_bvalid,
    output logic         m_axi_hp_bready,

    // -------------------------------------------------------------------------
    // Interrupt to PS — connect to IRQ_F2P
    // -------------------------------------------------------------------------
    output logic         irq_out
);

    // =========================================================================
    // Reset — combine PS reset with PL soft-reset from CTRL register
    // =========================================================================
    logic pl_rst;          // active-high, for top_level and axi_hp_master_wrap
    logic reg_soft_reset;  // from axi_lite_slave CTRL[1]

    assign pl_rst = (~s_axi_aresetn) | reg_soft_reset;

    // =========================================================================
    // axi_lite_slave  ↔  top_level config wires
    // =========================================================================
    logic        ps_start;
    logic [4:0]  cfg_fractal_type;
    logic [31:0] cfg_pan_x;
    logic [31:0] cfg_pan_y;
    logic [31:0] cfg_zoom_level;
    logic [11:0] cfg_max_iter;
    logic [31:0] cfg_image_base_addr;

    // =========================================================================
    // top_level status → axi_lite_slave
    // =========================================================================
    logic irq_all_done_w;
    logic irq_started_w;

    // =========================================================================
    // Debug taps: top_level → axi_lite_slave (same clock domain, no CDC)
    // =========================================================================
    logic [3:0] dbg_scheduler_state;
    logic       dbg_sched_push;
    logic       dbg_wants_job;
    logic       dbg_grant;
    logic       dbg_cqh_done;
    logic       dbg_comp_valid;
    logic       dbg_comp_complete;
    logic       dbg_comp_differ;
    logic       dbg_engine_done;

    // =========================================================================
    // top_level ↔ axi_hp_master_wrap simple write interface
    // =========================================================================
    logic [31:0] hp_wr_addr;
    logic [63:0] hp_wr_data;
    logic        hp_wr_en;
    logic        hp_wr_ready;

    // =========================================================================
    // axi_hp_master_wrap status → axi_lite_slave
    // =========================================================================
    logic hp_err_flag;
    logic hp_burst_done;

    // =========================================================================
    // AXI-Lite Slave instance
    // =========================================================================
    axi_lite_slave #(
        .ADDR_WIDTH(8)
    ) u_axi_lite_slave (
        .aclk    (s_axi_aclk),
        .aresetn (s_axi_aresetn),

        .s_awaddr  (s_axi_lite_awaddr),
        .s_awvalid (s_axi_lite_awvalid),
        .s_awready (s_axi_lite_awready),

        .s_wdata   (s_axi_lite_wdata),
        .s_wstrb   (s_axi_lite_wstrb),
        .s_wvalid  (s_axi_lite_wvalid),
        .s_wready  (s_axi_lite_wready),

        .s_bresp   (s_axi_lite_bresp),
        .s_bvalid  (s_axi_lite_bvalid),
        .s_bready  (s_axi_lite_bready),

        .s_araddr  (s_axi_lite_araddr),
        .s_arvalid (s_axi_lite_arvalid),
        .s_arready (s_axi_lite_arready),

        .s_rdata   (s_axi_lite_rdata),
        .s_rresp   (s_axi_lite_rresp),
        .s_rvalid  (s_axi_lite_rvalid),
        .s_rready  (s_axi_lite_rready),

        // Config outputs → top_level
        .ps_start            (ps_start),
        .cfg_fractal_type    (cfg_fractal_type),
        .cfg_pan_x           (cfg_pan_x),
        .cfg_pan_y           (cfg_pan_y),
        .cfg_zoom_level      (cfg_zoom_level),
        .cfg_max_iter        (cfg_max_iter),
        .cfg_image_base_addr (cfg_image_base_addr),

        .reg_soft_reset (reg_soft_reset),

        // Status inputs
        .in_started    (irq_started_w),
        .in_all_done   (irq_all_done_w),
        .in_axi_err    (hp_err_flag),
        .in_burst_done (hp_burst_done),

        // Debug inputs ← top_level
        .dbg_scheduler_state(dbg_scheduler_state),
        .dbg_sched_push     (dbg_sched_push),
        .dbg_wants_job      (dbg_wants_job),
        .dbg_grant          (dbg_grant),
        .dbg_cqh_done       (dbg_cqh_done),
        .dbg_comp_valid     (dbg_comp_valid),
        .dbg_comp_complete  (dbg_comp_complete),
        .dbg_comp_differ    (dbg_comp_differ),
        .dbg_engine_done    (dbg_engine_done),

        .irq_out (irq_out)
    );

    // =========================================================================
    // top_level instance — sixteenth_controller + per_sixteenth_engine
    // (bram_to_dram is instantiated inside per_sixteenth_engine)
    // =========================================================================
    top_level #(
        .TILE_W (TILE_W)
    ) u_top_level (
        .clk (s_axi_aclk),
        .rst (pl_rst),

        // AXI HP simple write interface → axi_hp_master_wrap
        .hp_axi_wr_addr  (hp_wr_addr),
        .hp_axi_wr_data  (hp_wr_data),
        .hp_axi_wr_en    (hp_wr_en),
        .hp_axi_wr_ready (hp_wr_ready),

        .irq_all_done (irq_all_done_w),
        .irq_started  (irq_started_w),

        // Config inputs ← axi_lite_slave
        .ps_start            (ps_start),
        .cfg_fractal_type    (cfg_fractal_type),
        .cfg_pan_x           (cfg_pan_x),
        .cfg_pan_y           (cfg_pan_y),
        .cfg_zoom_level      (cfg_zoom_level),
        .cfg_max_iter        (cfg_max_iter),
        .cfg_image_base_addr (cfg_image_base_addr),

        // Debug taps → axi_lite_slave
        .dbg_scheduler_state(dbg_scheduler_state),
        .dbg_sched_push     (dbg_sched_push),
        .dbg_wants_job      (dbg_wants_job),
        .dbg_grant          (dbg_grant),
        .dbg_cqh_done       (dbg_cqh_done),
        .dbg_comp_valid     (dbg_comp_valid),
        .dbg_comp_complete  (dbg_comp_complete),
        .dbg_comp_differ    (dbg_comp_differ),
        .dbg_engine_done    (dbg_engine_done)
    );

    // =========================================================================
    // AXI HP Master Wrapper instance
    // =========================================================================
    axi_hp_master_wrap #(
        .TILE_W (TILE_W)
    ) u_axi_hp_master_wrap (
        .clk (s_axi_aclk),
        .rst (pl_rst),

        // Simple write interface from top_level (bram_to_dram)
        .wr_addr  (hp_wr_addr),
        .wr_data  (hp_wr_data),
        .wr_en    (hp_wr_en),
        .wr_ready (hp_wr_ready),

        // AXI4 HP Master — passthrough to top-level ports
        .m_awid    (m_axi_hp_awid),
        .m_awaddr  (m_axi_hp_awaddr),
        .m_awlen   (m_axi_hp_awlen),
        .m_awsize  (m_axi_hp_awsize),
        .m_awburst (m_axi_hp_awburst),
        .m_awcache (m_axi_hp_awcache),
        .m_awprot  (m_axi_hp_awprot),
        .m_awqos   (m_axi_hp_awqos),
        .m_awvalid (m_axi_hp_awvalid),
        .m_awready (m_axi_hp_awready),

        .m_wdata  (m_axi_hp_wdata),
        .m_wstrb  (m_axi_hp_wstrb),
        .m_wlast  (m_axi_hp_wlast),
        .m_wvalid (m_axi_hp_wvalid),
        .m_wready (m_axi_hp_wready),

        .m_bid    (m_axi_hp_bid),
        .m_bresp  (m_axi_hp_bresp),
        .m_bvalid (m_axi_hp_bvalid),
        .m_bready (m_axi_hp_bready),

        .err_flag   (hp_err_flag),
        .burst_done (hp_burst_done)
    );

endmodule


// =============================================================================
// INTEGRATION NOTES
// =============================================================================
//
// 1. wr_ready / axi_wr_ready
//    top_level.hp_axi_wr_ready is driven directly by
//    axi_hp_master_wrap.wr_ready (= skid buffer not full). bram_to_dram
//    inside per_sixteenth_engine already checks axi_wr_ready before
//    advancing wr_count/fill_count — no changes needed there.
//
// 2. CLOCK DOMAIN
//    Single clock domain (s_axi_aclk = FCLK_CLK0, typically 100MHz).
//    Both M_AXI_GP0 and S_AXI_HP0 must be configured to the same clock
//    in the Zynq PS block for this design to be valid without CDC logic.
//
// 3. RESET
//    s_axi_aresetn is active-low (matches FCLK_RESET0_N / Processor
//    System Reset block "peripheral_aresetn" output).
//    reg_soft_reset (CTRL[1] in axi_lite_slave) is active-high and is
//    OR'd in so the PS can issue a soft reset of top_level + the HP
//    wrapper without resetting the AXI-Lite slave itself (so the PS
//    can still read STATUS / clear the reset afterwards).
//
// 4. TILE_W CONSISTENCY
//    TILE_W is a single parameter on this top module, forwarded to both
//    top_level (→ per_sixteenth_engine → bram_to_dram) and
//    axi_hp_master_wrap. Changing TILE_W here changes AWLEN/WLAST timing
//    and burst size consistently across both — do not override TILE_W
//    independently on the two sub-instances.
//
// 5. VIVADO BLOCK DESIGN STEPS
//    a) Add as design sources: bram_to_dram_top.sv, top_level.sv,
//       axi_lite_slave.sv, axi_hp_master_wrap.sv, plus
//       sixteenth_controller.sv, per_sixteenth_engine.sv, bram_to_dram.sv,
//       lowest_set_tree.sv and any other existing dependencies.
//    b) Block Design → Add Module → bram_to_dram_top
//    c) Add ZYNQ7 Processing System, Run Block Automation
//    d) Zynq PS configuration:
//         - PS-PL Configuration → AXI Non Secure Enablement
//             → GP Master AXI → enable M_AXI_GP0
//             → HP Slave AXI  → enable S_AXI_HP0, data width = 64-bit
//         - Clock Configuration → FCLK_CLK0 enabled (drives both AXI clocks)
//         - Interrupts → Fabric Interrupts → PL-PS IRQ_F2P enable
//    e) Select all s_axi_lite_* ports → right-click → Create Interface
//       → AXI4LITE. Repeat for m_axi_hp_* → AXI4.
//    f) Connect:
//         s_axi_aclk    ← FCLK_CLK0
//         s_axi_aresetn ← Processor System Reset (peripheral_aresetn)
//         S_AXI_LITE    ← M_AXI_GP0  (via AXI Interconnect/SmartConnect)
//         M_AXI_HP      → S_AXI_HP0  (via AXI Interconnect/SmartConnect)
//         irq_out       → IRQ_F2P[0:0]
//    g) Run Connection Automation to insert SmartConnect/Interconnect and
//       Processor System Reset blocks automatically.
//    h) Address Editor → assign axi_lite_slave a base address
//       (e.g. 0x4300_0000, range 4K). Note this for PYNQ MMIO.
//    i) Validate Design (F6) → Create HDL Wrapper → Generate Bitstream.
//
// 6. JUPYTER ACCESS
//    from pynq import Overlay, MMIO, allocate
//    import numpy as np
//
//    ol = Overlay('design.bit')
//    mmio = MMIO(0x43000000, 0x1000)
//
//    buf = allocate(shape=(256*256,), dtype=np.uint8)
//
//    mmio.write(0x1C, buf.physical_address)  # IMAGE_BASE_ADDR
//    mmio.write(0x08, 0)                     # FRACTAL_TYPE
//    mmio.write(0x0C, 0)                     # PAN_X
//    mmio.write(0x10, 0)                     # PAN_Y
//    mmio.write(0x14, 1 << 16)               # ZOOM_LEVEL (fixed-point)
//    mmio.write(0x18, 256)                   # MAX_ITER
//    mmio.write(0x20, 0x1)                   # enable all_done IRQ
//    mmio.write(0x00, 0x1)                   # CTRL.start
//
//    while not (mmio.read(0x04) & 0x2):
//        pass                                # poll STATUS.all_done
//
//    mmio.write(0x28, 0x1)                   # clear all_done
//    image = np.array(buf).reshape(256, 256)
//
// =============================================================================
