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
//  ── Existing control / config / status ──────────────────────────────────────
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
//  0x20  IRQ_ENABLE           RW   [0]=enable all_done interrupt to PS
//  0x24  TRANS_COUNT          RO   Number of AXI HP bursts completed
//  0x28  CLR_STATUS           WO   [0]=clear all_done
//                                  [1]=clear axi_err
//                                  [2]=clear trans_count
//                                  [3]=clear all debug counters
//
//  ── Debug registers (read-only, cleared by CLR_STATUS[3]) ───────────────────
//  0x2C  DBG_SCHED_STATE      RO   [3:0]  scheduler_state (live snapshot)
//  0x30  DBG_SCHED_PUSH       RO   [31:0] sched_push_count   (saturating)
//  0x34  DBG_WANTS_JOB        RO   [31:0] wants_job_count    (saturating)
//  0x38  DBG_GRANT            RO   [31:0] grant_count        (saturating)
//  0x3C  DBG_CQH_DONE         RO   [31:0] cqh_done_count     (saturating)
//  0x40  DBG_COMP_VALID       RO   [31:0] comp_valid_count   (saturating)
//  0x44  DBG_FLAGS            RO   [0]=comp_complete (live)
//                                  [1]=comp_differ   (live)
//                                  [2]=engine_done   (live)
// -----------------------------------------------------------------------------
// AXI-Lite handling notes:
//   - AW and W channels latched independently; write commits only when both
//     have been seen (no assumption about arrival order).
//   - 1-cycle read latency: ARVALID → RVALID next cycle.
//   - SLVERR returned for unknown addresses (read and write).
//   - Debug counters are saturating (stop at 0xFFFF_FFFF, not wrap-around)
//     so a max-value read means "at least that many events occurred".
//   - ADDR_WIDTH extended to 9 bits to cover 0x00-0x44.
// =============================================================================

module axi_lite_slave #(
    parameter ADDR_WIDTH = 9    // covers 0x00-0xFF (extended from 8 for debug regs)
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
    output logic        ps_start,
    output logic [4:0]  cfg_fractal_type,
    output logic [31:0] cfg_pan_x,
    output logic [31:0] cfg_pan_y,
    output logic [31:0] cfg_zoom_level,
    output logic [11:0] cfg_max_iter,
    output logic [31:0] cfg_image_base_addr,
    output logic        reg_soft_reset,

    // -------------------------------------------------------------------------
    // Status inputs ← top_level / axi_hp_master_wrap
    // -------------------------------------------------------------------------
    input  logic        in_started,
    input  logic        in_all_done,
    input  logic        in_axi_err,
    input  logic        in_burst_done,

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
        case (aw_addr_lat[ADDR_WIDTH-1:2])
            // existing regs 0x00-0x28
            7'h00, 7'h01, 7'h02, 7'h03, 7'h04,
            7'h05, 7'h06, 7'h07, 7'h08, 7'h09,
            7'h0A,
            // debug regs 0x2C-0x44 (read-only but we ACK writes gracefully)
            7'h0B, 7'h0C, 7'h0D, 7'h0E, 7'h0F,
            7'h10, 7'h11: addr_valid = 1'b1;
            default:       addr_valid = 1'b0;
        endcase
    end

    // AW channel
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            s_awready   <= 1'b0;
            aw_active   <= 1'b0;
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
    // Write commit — only config/control registers are writable
    // Debug registers are read-only; writes are ACK'd but have no effect.
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
        end else begin
            reg_ctrl[0] <= 1'b0;   // start bit self-clears every cycle

            if (write_commit) begin
                case (aw_addr_lat[ADDR_WIDTH-1:2])
                    7'h00: begin
                        reg_ctrl       <= apply_strobe(reg_ctrl, w_data_lat, w_strb_lat);
                        reg_ctrl[31:2] <= '0;
                    end
                    // 7'h01 STATUS — RO, writes ignored
                    7'h02: begin
                        reg_fractal_type       <= apply_strobe(reg_fractal_type, w_data_lat, w_strb_lat);
                        reg_fractal_type[31:5] <= '0;
                    end
                    7'h03: reg_pan_x      <= apply_strobe(reg_pan_x,      w_data_lat, w_strb_lat);
                    7'h04: reg_pan_y      <= apply_strobe(reg_pan_y,      w_data_lat, w_strb_lat);
                    7'h05: reg_zoom_level <= apply_strobe(reg_zoom_level, w_data_lat, w_strb_lat);
                    7'h06: begin
                        reg_max_iter        <= apply_strobe(reg_max_iter, w_data_lat, w_strb_lat);
                        reg_max_iter[31:12] <= '0;
                    end
                    7'h07: begin
                        reg_image_base_addr      <= apply_strobe(reg_image_base_addr, w_data_lat, w_strb_lat);
                        reg_image_base_addr[7:0] <= 8'h00;
                    end
                    7'h08: begin
                        reg_irq_enable       <= apply_strobe(reg_irq_enable, w_data_lat, w_strb_lat);
                        reg_irq_enable[31:1] <= '0;
                    end
                    // 7'h09 TRANS_COUNT — RO
                    // 7'h0A CLR_STATUS  — handled in sticky-flag/counter blocks
                    // 7'h0B-7'h11 debug regs — RO, writes silently ignored
                    default: ;
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
    // CLR_STATUS decode
    // bit[0] = clear done_flag
    // bit[1] = clear err_flag
    // bit[2] = clear trans_count
    // bit[3] = clear all debug counters
    // =========================================================================
    logic clr_done, clr_err, clr_count, clr_debug;
    assign clr_done  = write_commit && (aw_addr_lat[ADDR_WIDTH-1:2] == 7'h0A) && w_data_lat[0];
    assign clr_err   = write_commit && (aw_addr_lat[ADDR_WIDTH-1:2] == 7'h0A) && w_data_lat[1];
    assign clr_count = write_commit && (aw_addr_lat[ADDR_WIDTH-1:2] == 7'h0A) && w_data_lat[2];
    assign clr_debug = write_commit && (aw_addr_lat[ADDR_WIDTH-1:2] == 7'h0A) && w_data_lat[3];

    // =========================================================================
    // Sticky flags
    // =========================================================================
    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            done_flag <= 1'b0;
            err_flag  <= 1'b0;
        end else begin
            if (clr_done)         done_flag <= 1'b0;
            else if (in_all_done) done_flag <= 1'b1;

            if (clr_err)          err_flag <= 1'b0;
            else if (in_axi_err)  err_flag <= 1'b1;
        end
    end

    // =========================================================================
    // Burst / transaction counter
    // =========================================================================
    always_ff @(posedge aclk) begin
        if (!aresetn || clr_count) begin
            reg_trans_count <= '0;
        end else if (in_burst_done && reg_trans_count != 32'hFFFF_FFFF) begin
            reg_trans_count <= reg_trans_count + 1;
        end
    end

    // =========================================================================
    // Debug counters — saturating, cleared by CLR_STATUS[3]
    // Each increments on the corresponding pulse input for one cycle.
    // Saturate at 0xFFFF_FFFF rather than wrapping so the PS can distinguish
    // "exactly N events" from "at least N events".
    // =========================================================================
    // Saturating next-value (pure function — assigned via NBA at the call site,
    // which is portable; NBA to a `ref` task arg is rejected by Icarus/Vivado).
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
    // DBG_FLAGS register — live snapshot, no latching needed
    // =========================================================================
    logic [31:0] reg_dbg_flags;
    always_comb begin
        reg_dbg_flags    = '0;
        reg_dbg_flags[0] = dbg_comp_complete;
        reg_dbg_flags[1] = dbg_comp_differ;
        reg_dbg_flags[2] = dbg_engine_done;
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
                case (ar_addr_lat[ADDR_WIDTH-1:2])
                    // ── existing registers ──────────────────────────────────
                    7'h00: begin s_rdata <= reg_ctrl;            s_rresp <= 2'b00; end
                    7'h01: begin s_rdata <= reg_status;          s_rresp <= 2'b00; end
                    7'h02: begin s_rdata <= reg_fractal_type;    s_rresp <= 2'b00; end
                    7'h03: begin s_rdata <= reg_pan_x;           s_rresp <= 2'b00; end
                    7'h04: begin s_rdata <= reg_pan_y;           s_rresp <= 2'b00; end
                    7'h05: begin s_rdata <= reg_zoom_level;      s_rresp <= 2'b00; end
                    7'h06: begin s_rdata <= reg_max_iter;        s_rresp <= 2'b00; end
                    7'h07: begin s_rdata <= reg_image_base_addr; s_rresp <= 2'b00; end
                    7'h08: begin s_rdata <= reg_irq_enable;      s_rresp <= 2'b00; end
                    7'h09: begin s_rdata <= reg_trans_count;     s_rresp <= 2'b00; end
                    7'h0A: begin s_rdata <= 32'h0000_0000;       s_rresp <= 2'b00; end // CLR_STATUS WO
                    // ── debug registers ─────────────────────────────────────
                    7'h0B: begin s_rdata <= {28'b0, dbg_scheduler_state}; s_rresp <= 2'b00; end // 0x2C
                    7'h0C: begin s_rdata <= dbg_sched_push_count;         s_rresp <= 2'b00; end // 0x30
                    7'h0D: begin s_rdata <= dbg_wants_job_count;          s_rresp <= 2'b00; end // 0x34
                    7'h0E: begin s_rdata <= dbg_grant_count;              s_rresp <= 2'b00; end // 0x38
                    7'h0F: begin s_rdata <= dbg_cqh_done_count;           s_rresp <= 2'b00; end // 0x3C
                    7'h10: begin s_rdata <= dbg_comp_valid_count;         s_rresp <= 2'b00; end // 0x40
                    7'h11: begin s_rdata <= reg_dbg_flags;                s_rresp <= 2'b00; end // 0x44
                    default: begin s_rdata <= 32'hDEAD_BEEF;              s_rresp <= 2'b10; end
                endcase
            end

            if (s_rvalid && s_rready)
                s_rvalid <= 1'b0;
        end
    end

    // =========================================================================
    // Output assignments
    // =========================================================================
    assign ps_start            = reg_ctrl[0];
    assign reg_soft_reset      = reg_ctrl[1];
    assign cfg_fractal_type    = reg_fractal_type[4:0];
    assign cfg_pan_x           = reg_pan_x;
    assign cfg_pan_y           = reg_pan_y;
    assign cfg_zoom_level      = reg_zoom_level;
    assign cfg_max_iter        = reg_max_iter[11:0];
    assign cfg_image_base_addr = reg_image_base_addr;

    // =========================================================================
    // Interrupt
    // =========================================================================
    assign irq_out = done_flag & reg_irq_enable[0];

endmodule


// =============================================================================
// COMPLETE REGISTER MAP SUMMARY
// =============================================================================
//
//  0x00  CTRL                 RW
//  0x04  STATUS               RO
//  0x08  FRACTAL_TYPE         RW
//  0x0C  PAN_X                RW
//  0x10  PAN_Y                RW
//  0x14  ZOOM_LEVEL           RW
//  0x18  MAX_ITER             RW
//  0x1C  IMAGE_BASE_ADDR      RW
//  0x20  IRQ_ENABLE           RW
//  0x24  TRANS_COUNT          RO
//  0x28  CLR_STATUS           WO  [3]=clr debug counters (new)
//  0x2C  DBG_SCHED_STATE      RO  [3:0] live scheduler FSM state
//  0x30  DBG_SCHED_PUSH       RO  saturating count of scheduler push pulses
//  0x34  DBG_WANTS_JOB        RO  saturating count of core job requests
//  0x38  DBG_GRANT            RO  saturating count of scheduler grants
//  0x3C  DBG_CQH_DONE         RO  saturating count of CQ head completions
//  0x40  DBG_COMP_VALID       RO  saturating count of valid comparator results
//  0x44  DBG_FLAGS            RO  [0]=comp_complete [1]=comp_differ [2]=engine_done
//
// =============================================================================