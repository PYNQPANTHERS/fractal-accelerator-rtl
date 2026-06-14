// =============================================================================
// axi_lite_slave.sv
//
// AXI4-Lite Slave — Control & Status Register Block for top_level
// (fractal renderer: sixteenth_controller + per_sixteenth_engine)
//
// Connects to the PS via M_AXI_GP0.
// Assign a base address in Vivado address editor, e.g. 0x4300_0000.
//
// -----------------------------------------------------------------------------
// REGISTER MAP  (all registers 32-bit, word-addressed, byte offset)
// -----------------------------------------------------------------------------
//
//  0x00  CTRL                 RW   [0]=start (self-clearing pulse → ps_start)
//                                  [1]=soft reset (level, hold high to reset)
//
//  0x04  STATUS               RO   [0]=started   (live, from irq_started)
//                                  [1]=all_done   (sticky, from irq_all_done)
//                                  [2]=axi_err    (sticky, from HP wrapper)
//
//  0x08  FRACTAL_TYPE         RW   [4:0]  → cfg_fractal_type
//  0x0C  PAN_X                RW   [31:0] → cfg_pan_x
//  0x10  PAN_Y                RW   [31:0] → cfg_pan_y
//  0x14  ZOOM_LEVEL           RW   [31:0] → cfg_zoom_level
//  0x18  MAX_ITER             RW   [11:0] → cfg_max_iter
//  0x1C  IMAGE_BASE_ADDR      RW   [31:0] → cfg_image_base_addr
//                                  bits[7:0] forced to 0 — 256B tile alignment
//
//  0x20  IRQ_ENABLE           RW   [0]=enable all_done interrupt to PS
//
//  0x24  TRANS_COUNT          RO   Number of AXI HP bursts completed
//
//  0x28  CLR_STATUS           WO   [0]=clear all_done
//                                  [1]=clear axi_err
//                                  [2]=clear trans_count
//                                  [3]=clear all debug counters
//
//  0x2C  JULIA_REAL           RW   [31:0] → cfg_julia_real  (Q1.17 fixed-point C real)
//  0x30  JULIA_IMAG           RW   [31:0] → cfg_julia_imag  (Q1.17 fixed-point C imag)
//
//  ── Debug registers (read-only, cleared by CLR_STATUS[3]) ───────────────────
//  0x34  DBG_SCHED_STATE      RO   [3:0]  scheduler_state (live snapshot)
//  0x38  DBG_SCHED_PUSH       RO   [31:0] sched_push_count   (saturating)
//  0x3C  DBG_WANTS_JOB        RO   [31:0] wants_job_count    (saturating)
//  0x40  DBG_GRANT            RO   [31:0] grant_count        (saturating)
//  0x44  DBG_CQH_DONE         RO   [31:0] cqh_done_count     (saturating)
//  0x48  DBG_COMP_VALID       RO   [31:0] comp_valid_count   (saturating)
//  0x4C  DBG_FLAGS            RO   [0]=comp_complete (live)
//                                  [1]=comp_differ   (live)
//                                  [2]=engine_done   (live)
// -----------------------------------------------------------------------------
// AXI-Lite handling notes:
//   - AW and W channels latched independently; write commits only when both
//     have been seen (no assumption about arrival order).
//   - 1-cycle read latency: ARVALID → RVALID next cycle.
//   - SLVERR returned for unknown addresses (read and write).
// =============================================================================

module axi_lite_slave #(
    parameter ADDR_WIDTH = 8    // covers 0x00-0xFF
)(
    input  logic        aclk,
    input  logic        aresetn,        // active-low, from PS

    // AXI4-Lite slave port
    input  logic [ADDR_WIDTH-1:0] s_awaddr,
    input  logic                  s_awvalid,
    output logic                  s_awready,

    input  logic [31:0]           s_wdata,
    input  logic [3:0]            s_wstrb,
    input  logic                  s_wvalid,
    output logic                  s_wready,

    output logic [1:0]            s_bresp,
    output logic                  s_bvalid,
    input  logic                  s_bready,

    input  logic [ADDR_WIDTH-1:0] s_araddr,
    input  logic                  s_arvalid,
    output logic                  s_arready,

    output logic [31:0]           s_rdata,
    output logic [1:0]            s_rresp,
    output logic                  s_rvalid,
    input  logic                  s_rready,

    // -------------------------------------------------------------------------
    // Config outputs → top_level
    // -------------------------------------------------------------------------
    output logic        ps_start,            // 1-cycle pulse
    output logic [4:0]  cfg_fractal_type,
    output logic [34:0] cfg_pan_x,
    output logic [34:0] cfg_pan_y,
    output logic [15:0] cfg_zoom_level,
    output logic [11:0] cfg_max_iter,
    output logic [31:0] cfg_image_base_addr,
    output logic [34:0] cfg_julia_real,
    output logic [34:0] cfg_julia_imag,

    // Soft reset → top_level / axi_hp_master_wrap (level, active-high)
    output logic        reg_soft_reset,

    // -------------------------------------------------------------------------
    // Status inputs ← top_level / axi_hp_master_wrap
    // -------------------------------------------------------------------------
    input  logic        in_started,      // ← top_level.irq_started
    input  logic        in_all_done,     // ← top_level.irq_all_done (pulse or level)
    input  logic        in_axi_err,      // ← axi_hp_master_wrap.err_flag
    input  logic        in_burst_done,   // ← axi_hp_master_wrap.burst_done (pulse)

    // -------------------------------------------------------------------------
    // Debug inputs ← scheduler / engine (all in the same clock domain)
    // -------------------------------------------------------------------------
    input  logic [3:0]  dbg_scheduler_state,   // live scheduler FSM state
    input  logic        dbg_sched_push,         // pulse: scheduler pushed a job
    input  logic        dbg_wants_job,          // pulse: a core requested a job
    input  logic        dbg_grant,              // pulse: scheduler granted a job
    input  logic        dbg_cqh_done,           // pulse: completion queue head done
    input  logic        dbg_comp_valid,         // pulse: comparator result valid
    input  logic        dbg_comp_complete,      // level: comparator complete
    input  logic        dbg_comp_differ,        // level: comparator found difference
    input  logic        dbg_engine_done,        // level: engine_done signal

    // -------------------------------------------------------------------------
    // Interrupt → PS (IRQ_F2P)
    // -------------------------------------------------------------------------
    output logic        irq_out
);

    // =========================================================================
    // Register storage
    // =========================================================================
    logic [31:0] reg_ctrl;
    logic [31:0] reg_fractal_type;
    logic [31:0] reg_pan_x;
    logic [31:0] reg_pan_y;
    logic [31:0] reg_zoom_level;
    logic [31:0] reg_max_iter;
    logic [31:0] reg_image_base_addr;
    logic [31:0] reg_irq_enable;
    logic [31:0] reg_trans_count;
    logic [31:0] reg_julia_real;
    logic [31:0] reg_julia_imag;

    // Debug counters — saturating 32-bit
    logic [31:0] dbg_sched_push_count;
    logic [31:0] dbg_wants_job_count;
    logic [31:0] dbg_grant_count;
    logic [31:0] dbg_cqh_done_count;
    logic [31:0] dbg_comp_valid_count;

    // Sticky flags
    logic done_flag;
    logic err_flag;

    // =========================================================================
    // Write path — AW/W independent latches
    // =========================================================================
    logic                  aw_active, w_active;
    logic [ADDR_WIDTH-1:0] aw_addr_lat;
    logic [31:0]           w_data_lat;
    logic [3:0]            w_strb_lat;
    logic                  write_commit;
    logic                  addr_valid;

    assign write_commit = aw_active && w_active;

    // Word-aligned register index (drop byte bits [1:0])
    always_comb begin
        case (aw_addr_lat[7:2])
            6'h00, 6'h01, 6'h02, 6'h03, 6'h04,
            6'h05, 6'h06, 6'h07, 6'h08, 6'h09,
            6'h0A, 6'h0B, 6'h0C,
            // debug regs 0x34-0x4C (read-only but we ACK writes gracefully)
            6'h0D, 6'h0E, 6'h0F, 6'h10, 6'h11,
            6'h12, 6'h13: addr_valid = 1'b1;
            default: addr_valid = 1'b0;
        endcase
    end

    // AW channel
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            s_awready <= 1'b0;
            aw_active <= 1'b0;
            aw_addr_lat <= '0;
        end else begin
            s_awready <= 1'b0;
            if (s_awvalid && !aw_active && !write_commit) begin
                aw_addr_lat <= s_awaddr;
                aw_active   <= 1'b1;
                s_awready   <= 1'b1;
            end
            if (write_commit)
                aw_active <= 1'b0;
        end
    end

    // W channel
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            s_wready   <= 1'b0;
            w_active   <= 1'b0;
            w_data_lat <= '0;
            w_strb_lat <= '0;
        end else begin
            s_wready <= 1'b0;
            if (s_wvalid && !w_active && !write_commit) begin
                w_data_lat <= s_wdata;
                w_strb_lat <= s_wstrb;
                w_active   <= 1'b1;
                s_wready   <= 1'b1;
            end
            if (write_commit)
                w_active <= 1'b0;
        end
    end

    // Byte-strobe-masked write helper
    function automatic logic [31:0] apply_strobe(
        input logic [31:0] old_val,
        input logic [31:0] new_val,
        input logic [3:0]  strb
    );
        for (int b = 0; b < 4; b++)
            apply_strobe[b*8 +: 8] = strb[b] ? new_val[b*8 +: 8] : old_val[b*8 +: 8];
    endfunction

    // =========================================================================
    // Write commit
    // =========================================================================
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            reg_ctrl            <= '0;
            reg_fractal_type    <= '0;
            reg_pan_x           <= '0;
            reg_pan_y           <= '0;
            reg_zoom_level      <= '0;
            reg_max_iter        <= '0;
            reg_image_base_addr <= 32'h1000_0000;
            reg_irq_enable      <= '0;
            reg_julia_real      <= '0;
            reg_julia_imag      <= '0;
        end else begin
            // start bit is a pulse — self clear every cycle
            reg_ctrl[0] <= 1'b0;

            if (write_commit) begin
                case (aw_addr_lat[7:2])
                    6'h00: begin // CTRL
                        reg_ctrl       <= apply_strobe(reg_ctrl, w_data_lat, w_strb_lat);
                        reg_ctrl[31:2] <= '0;
                    end
                    // 6'h01 STATUS — read-only, writes ignored
                    6'h02: begin // FRACTAL_TYPE
                        reg_fractal_type        <= apply_strobe(reg_fractal_type, w_data_lat, w_strb_lat);
                        reg_fractal_type[31:5]  <= '0;
                    end
                    6'h03: reg_pan_x      <= apply_strobe(reg_pan_x,      w_data_lat, w_strb_lat);
                    6'h04: reg_pan_y      <= apply_strobe(reg_pan_y,      w_data_lat, w_strb_lat);
                    6'h05: reg_zoom_level <= apply_strobe(reg_zoom_level, w_data_lat, w_strb_lat);
                    6'h06: begin // MAX_ITER
                        reg_max_iter        <= apply_strobe(reg_max_iter, w_data_lat, w_strb_lat);
                        reg_max_iter[31:12] <= '0;
                    end
                    6'h07: begin // IMAGE_BASE_ADDR
                        reg_image_base_addr       <= apply_strobe(reg_image_base_addr, w_data_lat, w_strb_lat);
                        reg_image_base_addr[7:0]  <= 8'h00;  // force 256B alignment
                    end
                    6'h08: begin // IRQ_ENABLE
                        reg_irq_enable       <= apply_strobe(reg_irq_enable, w_data_lat, w_strb_lat);
                        reg_irq_enable[31:1] <= '0;
                    end
                    // 6'h09 TRANS_COUNT — read-only, writes ignored
                    6'h0A: begin // CLR_STATUS — handled in sticky-flag block below
                    end
                    6'h0B: reg_julia_real <= apply_strobe(reg_julia_real, w_data_lat, w_strb_lat);
                    6'h0C: reg_julia_imag <= apply_strobe(reg_julia_imag, w_data_lat, w_strb_lat);
                    default: ; // unknown — ACK with SLVERR via addr_valid
                endcase
            end
        end
    end

    // =========================================================================
    // B channel
    // =========================================================================
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            s_bvalid <= 1'b0;
            s_bresp  <= 2'b00;
        end else begin
            if (write_commit) begin
                s_bvalid <= 1'b1;
                s_bresp  <= addr_valid ? 2'b00 : 2'b10;
            end else if (s_bvalid && s_bready) begin
                s_bvalid <= 1'b0;
            end
        end
    end

    // =========================================================================
    // Sticky flags + CLR_STATUS handling
    // =========================================================================
    logic clr_done, clr_err, clr_count, clr_debug;
    assign clr_done  = write_commit && (aw_addr_lat[7:2] == 6'h0A) && w_data_lat[0];
    assign clr_err   = write_commit && (aw_addr_lat[7:2] == 6'h0A) && w_data_lat[1];
    assign clr_count = write_commit && (aw_addr_lat[7:2] == 6'h0A) && w_data_lat[2];
    assign clr_debug = write_commit && (aw_addr_lat[7:2] == 6'h0A) && w_data_lat[3];

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            done_flag <= 1'b0;
            err_flag  <= 1'b0;
        end else begin
            // clear takes priority over set in the same cycle
            if (clr_done)        done_flag <= 1'b0;
            else if (in_all_done) done_flag <= 1'b1;

            if (clr_err)         err_flag <= 1'b0;
            else if (in_axi_err) err_flag <= 1'b1;
        end
    end

    // =========================================================================
    // Burst / transaction counter
    // =========================================================================
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            reg_trans_count <= '0;
        end else if (clr_count) begin
            reg_trans_count <= '0;
        end else if (in_burst_done && reg_trans_count != 32'hFFFF_FFFF) begin
            reg_trans_count <= reg_trans_count + 1;
        end
    end

    // =========================================================================
    // Debug counters — saturating, cleared by CLR_STATUS[3]
    // Saturate at 0xFFFF_FFFF rather than wrapping so the PS can distinguish
    // "exactly N events" from "at least N events".
    // =========================================================================
    function automatic logic [31:0] sat_next(
        input logic [31:0] cnt,
        input logic        pulse,
        input logic        clr
    );
        if (clr)                                sat_next = '0;
        else if (pulse && cnt != 32'hFFFF_FFFF) sat_next = cnt + 1;
        else                                    sat_next = cnt;
    endfunction

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            dbg_sched_push_count <= '0;
            dbg_wants_job_count  <= '0;
            dbg_grant_count      <= '0;
            dbg_cqh_done_count   <= '0;
            dbg_comp_valid_count <= '0;
        end else begin
            dbg_sched_push_count <= sat_next(dbg_sched_push_count, dbg_sched_push, clr_debug);
            dbg_wants_job_count  <= sat_next(dbg_wants_job_count,  dbg_wants_job,  clr_debug);
            dbg_grant_count      <= sat_next(dbg_grant_count,      dbg_grant,      clr_debug);
            dbg_cqh_done_count   <= sat_next(dbg_cqh_done_count,   dbg_cqh_done,   clr_debug);
            dbg_comp_valid_count <= sat_next(dbg_comp_valid_count, dbg_comp_valid, clr_debug);
        end
    end

    // =========================================================================
    // DBG_FLAGS register — live snapshot
    // =========================================================================
    logic [31:0] reg_dbg_flags;
    always_comb begin
        reg_dbg_flags    = '0;
        reg_dbg_flags[0] = dbg_comp_complete;
        reg_dbg_flags[1] = dbg_comp_differ;
        reg_dbg_flags[2] = dbg_engine_done;
    end

    // =========================================================================
    // STATUS register — combinational
    // =========================================================================
    logic [31:0] reg_status;
    always_comb begin
        reg_status    = '0;
        reg_status[0] = in_started;
        reg_status[1] = done_flag;
        reg_status[2] = err_flag;
    end

    // =========================================================================
    // Read path — 1-cycle latency
    // =========================================================================
    logic [ADDR_WIDTH-1:0] ar_addr_lat;
    logic                  ar_active;

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            s_arready   <= 1'b0;
            s_rvalid    <= 1'b0;
            s_rdata     <= '0;
            s_rresp     <= 2'b00;
            ar_addr_lat <= '0;
            ar_active   <= 1'b0;
        end else begin
            s_arready <= 1'b0;

            if (s_arvalid && !ar_active && !s_rvalid) begin
                ar_addr_lat <= s_araddr;
                ar_active   <= 1'b1;
                s_arready   <= 1'b1;
            end

            if (ar_active) begin
                ar_active <= 1'b0;
                s_rvalid  <= 1'b1;
                case (ar_addr_lat[7:2])
                    6'h00: begin s_rdata <= reg_ctrl;            s_rresp <= 2'b00; end
                    6'h01: begin s_rdata <= reg_status;          s_rresp <= 2'b00; end
                    6'h02: begin s_rdata <= reg_fractal_type;    s_rresp <= 2'b00; end
                    6'h03: begin s_rdata <= reg_pan_x;           s_rresp <= 2'b00; end
                    6'h04: begin s_rdata <= reg_pan_y;           s_rresp <= 2'b00; end
                    6'h05: begin s_rdata <= reg_zoom_level;      s_rresp <= 2'b00; end
                    6'h06: begin s_rdata <= reg_max_iter;        s_rresp <= 2'b00; end
                    6'h07: begin s_rdata <= reg_image_base_addr; s_rresp <= 2'b00; end
                    6'h08: begin s_rdata <= reg_irq_enable;      s_rresp <= 2'b00; end
                    6'h09: begin s_rdata <= reg_trans_count;     s_rresp <= 2'b00; end
                    6'h0A: begin s_rdata <= 32'h0000_0000;       s_rresp <= 2'b00; end // CLR_STATUS WO
                    6'h0B: begin s_rdata <= reg_julia_real;      s_rresp <= 2'b00; end
                    6'h0C: begin s_rdata <= reg_julia_imag;      s_rresp <= 2'b00; end
                    // ── debug registers ─────────────────────────────────────
                    6'h0D: begin s_rdata <= {28'b0, dbg_scheduler_state}; s_rresp <= 2'b00; end // 0x34
                    6'h0E: begin s_rdata <= dbg_sched_push_count;         s_rresp <= 2'b00; end // 0x38
                    6'h0F: begin s_rdata <= dbg_wants_job_count;          s_rresp <= 2'b00; end // 0x3C
                    6'h10: begin s_rdata <= dbg_grant_count;              s_rresp <= 2'b00; end // 0x40
                    6'h11: begin s_rdata <= dbg_cqh_done_count;           s_rresp <= 2'b00; end // 0x44
                    6'h12: begin s_rdata <= dbg_comp_valid_count;         s_rresp <= 2'b00; end // 0x48
                    6'h13: begin s_rdata <= reg_dbg_flags;                s_rresp <= 2'b00; end // 0x4C
                    default: begin s_rdata <= 32'hDEAD_BEEF;     s_rresp <= 2'b10; end
                endcase
            end

            if (s_rvalid && s_rready)
                s_rvalid <= 1'b0;
        end
    end

    // =========================================================================
    // Output assignments
    // =========================================================================
    assign ps_start            = reg_ctrl[0];   // 1-cycle pulse
    assign reg_soft_reset       = reg_ctrl[1];  // level
    assign cfg_fractal_type     = reg_fractal_type[4:0];
    assign cfg_pan_x            = {reg_pan_x,      3'b0};
    assign cfg_pan_y            = {reg_pan_y,      3'b0};
    assign cfg_zoom_level       = reg_zoom_level[15:0];
    assign cfg_max_iter         = reg_max_iter[11:0];
    assign cfg_image_base_addr  = reg_image_base_addr;
    assign cfg_julia_real       = {reg_julia_real, 3'b0};
    assign cfg_julia_imag       = {reg_julia_imag, 3'b0};
    assign cfg_julia_real       = {3'b0, reg_julia_real};
    assign cfg_julia_imag       = {3'b0, reg_julia_imag};

    // =========================================================================
    // Interrupt
    // =========================================================================
    assign irq_out = done_flag & reg_irq_enable[0];

endmodule


// =============================================================================
// PYNQ ACCESS EXAMPLE
// =============================================================================
//
//   from pynq import MMIO
//   mmio = MMIO(0x43000000, 0x1000)
//
//   mmio.write(0x08, fractal_type)        # 0..31
//   mmio.write(0x0C, pan_x)
//   mmio.write(0x10, pan_y)
//   mmio.write(0x14, zoom_level)
//   mmio.write(0x18, max_iter)
//   mmio.write(0x1C, image_phys_addr)     # bottom 8 bits ignored/forced 0
//   mmio.write(0x20, 0x1)                 # enable all_done IRQ
//   mmio.write(0x00, 0x1)                 # CTRL.start
//
//   while not (mmio.read(0x04) & 0x2):
//       pass                              # poll STATUS.all_done
//
//   mmio.write(0x28, 0x1)                 # clear all_done
//
// =============================================================================
