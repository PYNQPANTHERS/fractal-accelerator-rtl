`timescale 1ns/1ps

// ─────────────────────────────────────────────────────────────────────────────
// tb_tile_benchmark
//   Renders the SAME full 1024×1024 image (all 16 sixteenths) twice:
//   once with TILE_W=16 leaves, once with TILE_W=8 leaves, keeping pan/zoom/
//   max_iter identical. Collects core-utilisation and scheduler-occupancy
//   metrics for a report comparing the two leaf granularities.
//
//   Outputs:
//     sim/render/bench_tile16_dram.csv,  bench_tile16_image.csv (+ .png via visualise.py)
//     sim/render/bench_tile8_dram.csv,   bench_tile8_image.csv
//     A METRICS summary table to stdout.
//
//   Run:  make tile-bench   (add target) or compile both top_level params + this TB.
// ─────────────────────────────────────────────────────────────────────────────
module tb_tile_benchmark;

    // ── Shared render config (identical for both runs) ───────────────────────
    localparam logic [31:0] CFG_PAN_X  = 32'hFFFF_0000;  // -1.0 Q1.16
    localparam logic [31:0] CFG_PAN_Y  = 32'h0001_0000;  // +1.0 Q1.16
    localparam logic [31:0] CFG_ZOOM   = 32'd1;
    localparam logic [11:0] CFG_MAX_I  = 12'd5;          // higher iteration count for the report
    localparam logic [31:0] CFG_BASE   = 32'h0000_0000;
    localparam logic [31:0] SXT_STRIDE = 32'd65536;

    localparam int CORES = 32;   // 4 clusters × 8 cores

    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // ── Two DUTs: TILE_W=16 and TILE_W=8 ─────────────────────────────────────
    logic rst16, rst8;

    wire  [31:0] axi16_addr, axi8_addr;
    wire  [63:0] axi16_data, axi8_data;
    wire         axi16_en,   axi8_en;
    logic        axi16_ready, axi8_ready;
    wire         done16, done8, started16, started8;

    top_level #(.TILE_W(16)) dut16 (
        .clk(clk), .rst(rst16),
        .hp_axi_wr_addr(axi16_addr), .hp_axi_wr_data(axi16_data),
        .hp_axi_wr_en(axi16_en), .hp_axi_wr_ready(axi16_ready),
        .irq_all_done(done16), .irq_started(started16)
    );

    top_level #(.TILE_W(8)) dut8 (
        .clk(clk), .rst(rst8),
        .hp_axi_wr_addr(axi8_addr), .hp_axi_wr_data(axi8_data),
        .hp_axi_wr_en(axi8_en), .hp_axi_wr_ready(axi8_ready),
        .irq_all_done(done8), .irq_started(started8)
    );

    // ── Free-running cycle counter + heartbeat (single block to avoid
    //    double-prints from a separate heartbeat process on the same edge) ─────
    longint cyc = 0;
    always @(posedge clk) begin
        cyc++;
        if ((cyc % 200_000) == 0) begin
            if (m16_run)
                $display("  [hb TILE16] cyc=%0d  sxt=%0d  dram=%0d  sched_state=%0d  busycores~%0d/32",
                         cyc, dut16.u_sixteenth_controller.sixteenth_index, d16_cnt,
                         dut16.u_engine.u_scheduler.current_state,
                         cluster_busy_cores(dut16.u_engine.u_control_unit.cluster_wants_job));
            if (m8_run)
                $display("  [hb TILE8 ] cyc=%0d  sxt=%0d  dram=%0d  sched_state=%0d  busycores~%0d/32",
                         cyc, dut8.u_sixteenth_controller.sixteenth_index, d8_cnt,
                         dut8.u_engine.u_scheduler.current_state,
                         cluster_busy_cores(dut8.u_engine.u_control_unit.cluster_wants_job));
        end
    end

    // ── DRAM capture (per DUT) ───────────────────────────────────────────────
    localparam int MAX_DRAM = 131072;  // 16 × 8192
    logic [31:0] d16_addr [0:MAX_DRAM-1];
    logic [63:0] d16_data [0:MAX_DRAM-1];
    logic [31:0] d8_addr  [0:MAX_DRAM-1];
    logic [63:0] d8_data  [0:MAX_DRAM-1];
    int d16_cnt = 0, d8_cnt = 0;

    always @(posedge clk) begin
        if (axi16_en && axi16_ready && d16_cnt < MAX_DRAM) begin
            d16_addr[d16_cnt] = axi16_addr; d16_data[d16_cnt] = axi16_data; d16_cnt++;
        end
        if (axi8_en && axi8_ready && d8_cnt < MAX_DRAM) begin
            d8_addr[d8_cnt] = axi8_addr; d8_data[d8_cnt] = axi8_data; d8_cnt++;
        end
    end

    // ── Metrics accumulators (per DUT) ───────────────────────────────────────
    // active_cycles      : cycles the DUT was running (between start and all_done)
    // busy_core_cycles   : sum over time of (cores not requesting a job) = core-cycles of work
    // sched_wait_cycles  : cycles scheduler in WAIT (border testing)
    // sched_busy_cycles  : cycles scheduler not IDLE/FINISHED
    // pixel_writes       : BRAM writes (pixels actually iterated)
    // any_core_busy_cyc  : cycles where at least one core was busy
    // all_core_idle_cyc  : cycles where every core was idle (stall/scheduler-bound)
    reg [7:0]  dump_image [0:1023][0:1023];
    reg [63:0] di_dd;
    integer    di_fd, di_log2_bpt, di_words_p_row, di_tiles_p_axis, di_n;
    integer    di_sxt_id, di_tile_idx, di_word_in_tile, di_tile_col, di_tile_row;
    integer    di_row_in_tile, di_col_start, di_px, di_py, di_sxt_col, di_sxt_row;
    integer    di_a, di_addr_off, di_within;
    integer    di_r, di_c, di_i, di_b;

    longint m16_active=0, m16_busycore=0, m16_wait=0, m16_schedbusy=0;
    longint m16_pix=0, m16_anybusy=0, m16_allidle=0;
    longint m8_active=0,  m8_busycore=0,  m8_wait=0,  m8_schedbusy=0;
    longint m8_pix=0,  m8_anybusy=0,  m8_allidle=0;
    int bc16, bc8;

    // ── BRAM→DRAM drain-tail metric (engine_done → sixteenth_complete) ────────
    // For each sixteenth, measure cycles from engine_done rising (compute finished)
    // to sixteenth_complete rising (all tiles flushed to DRAM). Sum across all 16.
    longint m16_drain_total=0, m8_drain_total=0;  // summed tail cycles across sixteenths
    longint m16_drain_max=0,   m8_drain_max=0;    // worst single-sixteenth tail
    int     m16_drain_n=0,     m8_drain_n=0;      // sixteenths counted
    longint m16_edone_cyc=0,   m8_edone_cyc=0;    // cycle engine_done rose (current sxt)
    logic   m16_edone_seen=0,  m8_edone_seen=0;   // engine_done rising latched this sxt
    logic   m16_edone_prev=0,  m8_edone_prev=0;
    logic   m16_sc_prev=0,     m8_sc_prev=0;

    // ── MS-effectiveness metrics (1: descent/fill, 2: border overhead) ───────
    // fill_events  : # FILL_BOX flood-fills (a box decided uniform → filled whole)
    // descend_evts : # DESCEND_LEVEL (a box differed and was subdivided)
    // queue_evts   : # QUEUE_BOX_INIT (a leaf box that had to iterate all its pixels)
    // border_px    : # border pixels generated (border-test work)
    longint m16_fill=0, m16_descend=0, m16_queue=0, m16_border=0;
    longint m8_fill=0,  m8_descend=0,  m8_queue=0,  m8_border=0;
    // prev-state for rising-edge detection of the decision states
    int m16_st_prev=0, m8_st_prev=0;

    // ── (4) peak job-queue occupancy ─────────────────────────────────────────
    longint m16_qpeak=0, m8_qpeak=0;     // max fifo count seen
    longint m16_qsum=0,  m8_qsum=0;      // sum of fifo count (for average occupancy)

    // scheduler enum ordinals (from the typedef in scheduler.sv)
    localparam int SC_IDLE=0, SC_WAIT=5, SC_QBOXINIT=6, SC_FILL=9,
                   SC_DESCEND=11, SC_FINISHED=12;

    // helper: busy cores for a DUT = CORES - (# cores requesting a job)
    // cluster_wants_job is per-CLUSTER (4 bits); a cluster requesting = whole cluster idle.
    // We approximate per-core utilisation at cluster granularity × CLUSTER_SIZE.
    function automatic int cluster_busy_cores(input logic [3:0] wants);
        int free_clusters;
        free_clusters = $countones(wants);
        return (4 - free_clusters) * 8;   // CLUSTER_COUNT=4, CLUSTER_SIZE=8
    endfunction

    // ── TILE_W=16 metric sampling (only while dut16 active) ───────────────────
    logic m16_run = 0;
    always @(posedge clk) if (m16_run) begin
        int bc16;
        bc16 = cluster_busy_cores(dut16.u_engine.u_control_unit.cluster_wants_job);
        m16_active    <= m16_active + 1;
        m16_busycore  <= m16_busycore + bc16;
        if (bc16 > 0) m16_anybusy <= m16_anybusy + 1;
        else          m16_allidle <= m16_allidle + 1;
        if (int'(dut16.u_engine.u_scheduler.current_state) == SC_WAIT)
            m16_wait <= m16_wait + 1;
        if (int'(dut16.u_engine.u_scheduler.current_state) != SC_IDLE &&
            int'(dut16.u_engine.u_scheduler.current_state) != SC_FINISHED)
            m16_schedbusy <= m16_schedbusy + 1;
        if (dut16.u_engine.u_control_unit.u_bram_rw.bram_wr_en)
            m16_pix <= m16_pix + 1;

        // MS decisions: count rising edges into FILL/DESCEND/QUEUE_BOX_INIT states
        m16_st_prev <= int'(dut16.u_engine.u_scheduler.current_state);
        if (int'(dut16.u_engine.u_scheduler.current_state)==SC_FILL    && m16_st_prev!=SC_FILL)    m16_fill    <= m16_fill + 1;
        if (int'(dut16.u_engine.u_scheduler.current_state)==SC_DESCEND  && m16_st_prev!=SC_DESCEND) m16_descend <= m16_descend + 1;
        if (int'(dut16.u_engine.u_scheduler.current_state)==SC_QBOXINIT && m16_st_prev!=SC_QBOXINIT)m16_queue   <= m16_queue + 1;
        // border-test work: count border pixels generated
        if (dut16.u_engine.u_scheduler.border_pixel_valid) m16_border <= m16_border + 1;
        // job-queue occupancy
        if (longint'(dut16.u_engine.u_job_queue_handler.u_job_queue.u_fifo.count) > m16_qpeak)
            m16_qpeak <= longint'(dut16.u_engine.u_job_queue_handler.u_job_queue.u_fifo.count);
        m16_qsum <= m16_qsum + longint'(dut16.u_engine.u_job_queue_handler.u_job_queue.u_fifo.count);

        // drain tail: latch cycle when engine_done rises; on sixteenth_complete
        // rising, accumulate the gap and arm for the next sixteenth.
        m16_edone_prev <= dut16.u_engine.engine_done;
        m16_sc_prev    <= dut16.u_engine.sixteenth_complete;
        if (dut16.u_engine.engine_done && !m16_edone_prev && !m16_edone_seen) begin
            m16_edone_cyc  <= cyc;
            m16_edone_seen <= 1'b1;
        end
        if (dut16.u_engine.sixteenth_complete && !m16_sc_prev && m16_edone_seen) begin
            longint tail; tail = cyc - m16_edone_cyc;
            m16_drain_total <= m16_drain_total + tail;
            if (tail > m16_drain_max) m16_drain_max <= tail;
            m16_drain_n    <= m16_drain_n + 1;
            m16_edone_seen <= 1'b0;   // re-arm for next sixteenth
        end
    end

    // ── TILE_W=8 metric sampling (only while dut8 active) ─────────────────────
    logic m8_run = 0;
    always @(posedge clk) if (m8_run) begin
        int bc8;
        bc8 = cluster_busy_cores(dut8.u_engine.u_control_unit.cluster_wants_job);
        m8_active    <= m8_active + 1;
        m8_busycore  <= m8_busycore + bc8;
        if (bc8 > 0) m8_anybusy <= m8_anybusy + 1;
        else         m8_allidle <= m8_allidle + 1;
        if (int'(dut8.u_engine.u_scheduler.current_state) == SC_WAIT)
            m8_wait <= m8_wait + 1;
        if (int'(dut8.u_engine.u_scheduler.current_state) != SC_IDLE &&
            int'(dut8.u_engine.u_scheduler.current_state) != SC_FINISHED)
            m8_schedbusy <= m8_schedbusy + 1;
        if (dut8.u_engine.u_control_unit.u_bram_rw.bram_wr_en)
            m8_pix <= m8_pix + 1;

        m8_st_prev <= int'(dut8.u_engine.u_scheduler.current_state);
        if (int'(dut8.u_engine.u_scheduler.current_state)==SC_FILL    && m8_st_prev!=SC_FILL)    m8_fill    <= m8_fill + 1;
        if (int'(dut8.u_engine.u_scheduler.current_state)==SC_DESCEND  && m8_st_prev!=SC_DESCEND) m8_descend <= m8_descend + 1;
        if (int'(dut8.u_engine.u_scheduler.current_state)==SC_QBOXINIT && m8_st_prev!=SC_QBOXINIT)m8_queue   <= m8_queue + 1;
        if (dut8.u_engine.u_scheduler.border_pixel_valid) m8_border <= m8_border + 1;
        if (longint'(dut8.u_engine.u_job_queue_handler.u_job_queue.u_fifo.count) > m8_qpeak)
            m8_qpeak <= longint'(dut8.u_engine.u_job_queue_handler.u_job_queue.u_fifo.count);
        m8_qsum <= m8_qsum + longint'(dut8.u_engine.u_job_queue_handler.u_job_queue.u_fifo.count);

        m8_edone_prev <= dut8.u_engine.engine_done;
        m8_sc_prev    <= dut8.u_engine.sixteenth_complete;
        if (dut8.u_engine.engine_done && !m8_edone_prev && !m8_edone_seen) begin
            m8_edone_cyc  <= cyc;
            m8_edone_seen <= 1'b1;
        end
        if (dut8.u_engine.sixteenth_complete && !m8_sc_prev && m8_edone_seen) begin
            longint tail; tail = cyc - m8_edone_cyc;
            m8_drain_total <= m8_drain_total + tail;
            if (tail > m8_drain_max) m8_drain_max <= tail;
            m8_drain_n    <= m8_drain_n + 1;
            m8_edone_seen <= 1'b0;
        end
    end


    // ── DRAM → image CSV dump (tile-linear, parameterised by tw) ──────────────
    task automatic dump_dram_csv(input string path, input int which);
        integer fd;
        int n;
        logic [31:0] a;
        logic [63:0] dd;
        fd = $fopen(path, "w");
        $fwrite(fd, "write_index,addr_hex,b0,b1,b2,b3,b4,b5,b6,b7\n");
        n = (which == 16) ? d16_cnt : d8_cnt;
        for (int i = 0; i < n; i++) begin
            a  = (which == 16) ? d16_addr[i] : d8_addr[i];
            dd = (which == 16) ? d16_data[i] : d8_data[i];
            $fwrite(fd, "%0d,0x%08X,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                i, a, dd[7:0], dd[15:8], dd[23:16], dd[31:24],
                dd[39:32], dd[47:40], dd[55:48], dd[63:56]);
        end
        $fclose(fd);
        $display("  wrote %s  (%0d rows)", path, n);
    endtask

    task automatic dump_image_csv(input string path, input int tw);
        // tile-linear DRAM → raster 1024×1024
        logic [7:0] image [0:1023][0:1023];
        integer fd;
        int log2_bpt, words_p_row, tiles_p_axis, n;
        int sxt_id, tile_idx, word_in_tile, tile_col, tile_row;
        int row_in_tile, col_start, px, py, sxt_col, sxt_row;
        logic [31:0] a, addr_off, within_sxt;
        logic [63:0] dd;
        // tw is 8 or 16 only; avoid $clog2 on a runtime arg (iverilog needs a constant)
        log2_bpt     = (tw == 16) ? 8 : 6;   // log2(TILE_W*TILE_W): 16→256→8, 8→64→6
        words_p_row  = tw / 8;               // 2 for 16, 1 for 8
        tiles_p_axis = 256 / tw;
        for (int r=0;r<1024;r++) for (int c=0;c<1024;c++) image[r][c]=8'hFF;
        n = (tw == 16) ? d16_cnt : d8_cnt;
        for (int i=0;i<n;i++) begin
            a  = (tw == 16) ? d16_addr[i] : d8_addr[i];
            dd = (tw == 16) ? d16_data[i] : d8_data[i];
            addr_off = a - CFG_BASE;
            sxt_id = int'(addr_off / SXT_STRIDE);
            if (sxt_id >= 0 && sxt_id <= 15) begin
                within_sxt = a - (CFG_BASE + SXT_STRIDE * sxt_id);
                tile_idx     = within_sxt >> log2_bpt;
                word_in_tile = (within_sxt & ((1<<log2_bpt)-1)) >> 3;
                tile_col     = tile_idx % tiles_p_axis;
                tile_row     = tile_idx / tiles_p_axis;
                row_in_tile  = word_in_tile / words_p_row;
                col_start    = (word_in_tile % words_p_row) * 8;
                sxt_col = sxt_id & 3; sxt_row = sxt_id >> 2;
                for (int b=0;b<8;b++) begin
                    px = sxt_col*256 + tile_col*tw + col_start + b;
                    py = sxt_row*256 + tile_row*tw + row_in_tile;
                    if (px<1024 && py<1024)
                        image[py][px] = dd[b*8 +: 8];
                end
            end
        end
        di_fd = $fopen(path, "w");
        $fwrite(di_fd, "row,col,colour\n");
        for (di_r=0; di_r<1024; di_r++) for (di_c=0; di_c<1024; di_c++)
            $fwrite(di_fd, "%0d,%0d,%0d\n", di_r, di_c, dump_image[di_r][di_c] & 8'h3F);
        $fclose(di_fd);
        $display("  wrote %s  (1024x1024)", path);
    endtask

    // ── Metrics report ───────────────────────────────────────────────────────
    task automatic report_metrics;
        real u16, u8, idle16, idle8, w16, w8;
        u16 = (m16_active>0) ? 100.0*real'(m16_busycore)/(real'(m16_active)*CORES) : 0.0;
        u8  = (m8_active >0) ? 100.0*real'(m8_busycore) /(real'(m8_active )*CORES) : 0.0;
        idle16 = (m16_active>0) ? 100.0*real'(m16_allidle)/real'(m16_active) : 0.0;
        idle8  = (m8_active >0) ? 100.0*real'(m8_allidle) /real'(m8_active ) : 0.0;
        w16 = (m16_active>0) ? 100.0*real'(m16_wait)/real'(m16_active) : 0.0;
        w8  = (m8_active >0) ? 100.0*real'(m8_wait) /real'(m8_active ) : 0.0;

        $display("\n");
        $display("================================================================");
        $display("  TILE-SIZE BENCHMARK  (pan/zoom identical, max_iter=%0d)", CFG_MAX_I);
        $display("================================================================");
        $display("  metric                          TILE_W=16        TILE_W=8");
        $display("  ----------------------------------------------------------------");
        $display("  total active cycles           %12d   %12d", m16_active, m8_active);
        $display("  speed ratio (8/16)                                   %0.3fx",
                 (m16_active>0)?real'(m8_active)/real'(m16_active):0.0);
        $display("  pixels iterated (BRAM writes) %12d   %12d", m16_pix, m8_pix);
        $display("  of 1048576 total px              %8.1f%%       %8.1f%%",
                 100.0*real'(m16_pix)/1048576.0, 100.0*real'(m8_pix)/1048576.0);
        $display("  DRAM writes                   %12d   %12d", d16_cnt, d8_cnt);
        $display("  ----------------------------------------------------------------");
        $display("  CORE UTILISATION");
        $display("  avg core utilisation             %8.2f%%       %8.2f%%", u16, u8);
        $display("  busy-core-cycles              %12d   %12d", m16_busycore, m8_busycore);
        $display("  all-cores-idle cycles         %12d   %12d", m16_allidle, m8_allidle);
        $display("  all-cores-idle fraction          %8.2f%%       %8.2f%%", idle16, idle8);
        $display("  >>> busy:idle cycle ratio        %8.3f        %8.3f",
                 (m16_allidle>0)?real'(m16_anybusy)/real'(m16_allidle):0.0,
                 (m8_allidle >0)?real'(m8_anybusy) /real'(m8_allidle ):0.0);
        $display("  ----------------------------------------------------------------");
        $display("  SCHEDULER OCCUPANCY");
        $display("  cycles in WAIT (border test)  %12d   %12d", m16_wait, m8_wait);
        $display("  WAIT fraction of active          %8.2f%%       %8.2f%%", w16, w8);
        $display("  scheduler-busy cycles         %12d   %12d", m16_schedbusy, m8_schedbusy);
        $display("  ----------------------------------------------------------------");
        $display("  BRAM->DRAM DRAIN TAIL (engine_done -> sixteenth_complete)");
        $display("  sixteenths measured           %12d   %12d", m16_drain_n, m8_drain_n);
        $display("  total drain cycles (all 16)   %12d   %12d", m16_drain_total, m8_drain_total);
        $display("  avg drain per sixteenth          %12.1f   %12.1f",
                 (m16_drain_n>0)?real'(m16_drain_total)/real'(m16_drain_n):0.0,
                 (m8_drain_n >0)?real'(m8_drain_total) /real'(m8_drain_n ):0.0);
        $display("  worst single-sixteenth drain  %12d   %12d", m16_drain_max, m8_drain_max);
        $display("  drain as %% of total cycles       %8.2f%%       %8.2f%%",
                 (m16_active>0)?100.0*real'(m16_drain_total)/real'(m16_active):0.0,
                 (m8_active >0)?100.0*real'(m8_drain_total) /real'(m8_active ):0.0);
        $display("  ----------------------------------------------------------------");
        $display("  MARIANI-SILVER EFFECTIVENESS");
        $display("  flood-fill events (FILL_BOX)  %12d   %12d", m16_fill, m8_fill);
        $display("  descend events (DESCEND)      %12d   %12d", m16_descend, m8_descend);
        $display("  leaf queue-all (QUEUE_BOX)    %12d   %12d", m16_queue, m8_queue);
        $display("  border pixels generated       %12d   %12d", m16_border, m8_border);
        $display("  border-px : iterated-px ratio    %8.3f        %8.3f",
                 (m16_pix>0)?real'(m16_border)/real'(m16_pix):0.0,
                 (m8_pix >0)?real'(m8_border) /real'(m8_pix ):0.0);
        $display("  fill : descend ratio             %8.3f        %8.3f",
                 (m16_descend>0)?real'(m16_fill)/real'(m16_descend):0.0,
                 (m8_descend >0)?real'(m8_fill) /real'(m8_descend ):0.0);
        $display("  ----------------------------------------------------------------");
        $display("  JOB-QUEUE OCCUPANCY (depth=256)");
        $display("  peak occupancy                %12d   %12d", m16_qpeak, m8_qpeak);
        $display("  avg occupancy                    %12.2f   %12.2f",
                 (m16_active>0)?real'(m16_qsum)/real'(m16_active):0.0,
                 (m8_active >0)?real'(m8_qsum) /real'(m8_active ):0.0);
        $display("  peak as %% of depth               %8.2f%%       %8.2f%%",
                 100.0*real'(m16_qpeak)/256.0, 100.0*real'(m8_qpeak)/256.0);
        $display("  ----------------------------------------------------------------");
        $display("  DERIVED");
        $display("  cycles per iterated pixel        %8.3f        %8.3f",
                 (m16_pix>0)?real'(m16_active)/real'(m16_pix):0.0,
                 (m8_pix >0)?real'(m8_active )/real'(m8_pix ):0.0);
        $display("  cycles per DRAM word             %8.3f        %8.3f",
                 (d16_cnt>0)?real'(m16_active)/real'(d16_cnt):0.0,
                 (d8_cnt >0)?real'(m8_active )/real'(d8_cnt ):0.0);
        $display("================================================================\n");

        write_metrics_csv("sim/render/bench_metrics.csv");
    endtask

    // Machine-readable report: one row per tile size, columns = metrics.
    // Lives in sim/render/ which `make clean` is configured to preserve.
    task automatic write_metrics_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        $fwrite(fd, "tile_w,max_iter,active_cycles,pixels_iterated,pct_pixels,");
        $fwrite(fd, "dram_writes,avg_core_util_pct,busy_core_cycles,all_idle_cycles,");
        $fwrite(fd, "all_idle_pct,busy_idle_ratio,wait_cycles,wait_pct,sched_busy_cycles,");
        $fwrite(fd, "drain_total_cycles,drain_avg_per_sxt,drain_max,drain_pct,");
        $fwrite(fd, "cyc_per_pixel,cyc_per_dram_word,");
        $fwrite(fd, "fill_events,descend_events,queue_events,border_px,");
        $fwrite(fd, "border_per_pixel,fill_descend_ratio,qpeak,qavg,qpeak_pct\n");

        // TILE_W=16 row
        $fwrite(fd, "16,%0d,%0d,%0d,%0.3f,%0d,%0.3f,%0d,%0d,%0.3f,%0.4f,%0d,%0.3f,%0d,%0d,%0.1f,%0d,%0.3f,%0.4f,%0.4f,",
            CFG_MAX_I, m16_active, m16_pix, 100.0*real'(m16_pix)/1048576.0, d16_cnt,
            (m16_active>0)?100.0*real'(m16_busycore)/(real'(m16_active)*CORES):0.0,
            m16_busycore, m16_allidle,
            (m16_active>0)?100.0*real'(m16_allidle)/real'(m16_active):0.0,
            (m16_allidle>0)?real'(m16_anybusy)/real'(m16_allidle):0.0,
            m16_wait, (m16_active>0)?100.0*real'(m16_wait)/real'(m16_active):0.0,
            m16_schedbusy, m16_drain_total,
            (m16_drain_n>0)?real'(m16_drain_total)/real'(m16_drain_n):0.0,
            m16_drain_max, (m16_active>0)?100.0*real'(m16_drain_total)/real'(m16_active):0.0,
            (m16_pix>0)?real'(m16_active)/real'(m16_pix):0.0,
            (d16_cnt>0)?real'(m16_active)/real'(d16_cnt):0.0);
        $fwrite(fd, "%0d,%0d,%0d,%0d,%0.4f,%0.4f,%0d,%0.2f,%0.2f\n",
            m16_fill, m16_descend, m16_queue, m16_border,
            (m16_pix>0)?real'(m16_border)/real'(m16_pix):0.0,
            (m16_descend>0)?real'(m16_fill)/real'(m16_descend):0.0,
            m16_qpeak, (m16_active>0)?real'(m16_qsum)/real'(m16_active):0.0,
            100.0*real'(m16_qpeak)/256.0);

        // TILE_W=8 row
        $fwrite(fd, "8,%0d,%0d,%0d,%0.3f,%0d,%0.3f,%0d,%0d,%0.3f,%0.4f,%0d,%0.3f,%0d,%0d,%0.1f,%0d,%0.3f,%0.4f,%0.4f,",
            CFG_MAX_I, m8_active, m8_pix, 100.0*real'(m8_pix)/1048576.0, d8_cnt,
            (m8_active>0)?100.0*real'(m8_busycore)/(real'(m8_active)*CORES):0.0,
            m8_busycore, m8_allidle,
            (m8_active>0)?100.0*real'(m8_allidle)/real'(m8_active):0.0,
            (m8_allidle>0)?real'(m8_anybusy)/real'(m8_allidle):0.0,
            m8_wait, (m8_active>0)?100.0*real'(m8_wait)/real'(m8_active):0.0,
            m8_schedbusy, m8_drain_total,
            (m8_drain_n>0)?real'(m8_drain_total)/real'(m8_drain_n):0.0,
            m8_drain_max, (m8_active>0)?100.0*real'(m8_drain_total)/real'(m8_active):0.0,
            (m8_pix>0)?real'(m8_active)/real'(m8_pix):0.0,
            (d8_cnt>0)?real'(m8_active)/real'(d8_cnt):0.0);
        $fwrite(fd, "%0d,%0d,%0d,%0d,%0.4f,%0.4f,%0d,%0.2f,%0.2f\n",
            m8_fill, m8_descend, m8_queue, m8_border,
            (m8_pix>0)?real'(m8_border)/real'(m8_pix):0.0,
            (m8_descend>0)?real'(m8_fill)/real'(m8_descend):0.0,
            m8_qpeak, (m8_active>0)?real'(m8_qsum)/real'(m8_active):0.0,
            100.0*real'(m8_qpeak)/256.0);

        $fclose(fd);
        $display("  wrote sim/render/bench_metrics.csv  (machine-readable report)");
    endtask

    // ── Drive one DUT to completion ──────────────────────────────────────────
    task automatic run_dut16;
        $display("\n=== RUN 1: TILE_W=16 ===");
        rst16 = 1; tick(4); rst16 = 0; tick(2);
        force dut16.cfg_fractal_type    = 5'b0_0000;
        force dut16.cfg_pan_x           = CFG_PAN_X;
        force dut16.cfg_pan_y           = CFG_PAN_Y;
        force dut16.cfg_zoom_level      = CFG_ZOOM;
        force dut16.cfg_max_iter        = CFG_MAX_I;
        force dut16.cfg_image_base_addr = CFG_BASE;
        force dut16.ps_start            = 1'b1;
        tick(1);
        release dut16.ps_start;
        m16_run = 1;
        begin : w16loop
            longint t; t = 0;
            while (!done16 && t < 400_000_000) begin tick(1); t++; end
            if (done16) $display("  TILE_W=16 done at cyc=%0d  active=%0d  dram=%0d",
                                 cyc, m16_active, d16_cnt);
            else        $display("  [TIMEOUT] TILE_W=16 t=%0d", t);
        end
        m16_run = 0;
        release dut16.cfg_fractal_type; release dut16.cfg_pan_x;
        release dut16.cfg_pan_y; release dut16.cfg_zoom_level;
        release dut16.cfg_max_iter; release dut16.cfg_image_base_addr;
    endtask

    task automatic run_dut8;
        $display("\n=== RUN 2: TILE_W=8 ===");
        rst8 = 1; tick(4); rst8 = 0; tick(2);
        force dut8.cfg_fractal_type    = 5'b0_0000;
        force dut8.cfg_pan_x           = CFG_PAN_X;
        force dut8.cfg_pan_y           = CFG_PAN_Y;
        force dut8.cfg_zoom_level      = CFG_ZOOM;
        force dut8.cfg_max_iter        = CFG_MAX_I;
        force dut8.cfg_image_base_addr = CFG_BASE;
        force dut8.ps_start            = 1'b1;
        tick(1);
        release dut8.ps_start;
        m8_run = 1;
        begin : w8loop
            longint t; t = 0;
            while (!done8 && t < 400_000_000) begin tick(1); t++; end
            if (done8) $display("  TILE_W=8 done at cyc=%0d  active=%0d  dram=%0d",
                                cyc, m8_active, d8_cnt);
            else       $display("  [TIMEOUT] TILE_W=8 t=%0d", t);
        end
        m8_run = 0;
        release dut8.cfg_fractal_type; release dut8.cfg_pan_x;
        release dut8.cfg_pan_y; release dut8.cfg_zoom_level;
        release dut8.cfg_max_iter; release dut8.cfg_image_base_addr;
    endtask

    // ── Main ─────────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("sim/waves/tb_tile_benchmark.vcd");
        // no $dumpvars by default — huge with 64 cores ×2; uncomment if needed
        // $dumpvars(0, tb_tile_benchmark);

        rst16 = 1; rst8 = 1;
        axi16_ready = 1'b1; axi8_ready = 1'b1;

        $display("\ntb_tile_benchmark — comparing TILE_W=16 vs TILE_W=8");
        $display("PAN_X=0x%08X PAN_Y=0x%08X ZOOM=%0d MAX_I=%0d  (32 cores)",
                 CFG_PAN_X, CFG_PAN_Y, CFG_ZOOM, CFG_MAX_I);

        run_dut16();
        run_dut8();

        $display("\n  Writing CSVs and images...");
        dump_dram_csv ("sim/render/bench_tile16_dram.csv", 16);
        dump_image_csv("sim/render/bench_tile16_image.csv", 16);
        dump_dram_csv ("sim/render/bench_tile8_dram.csv", 8);
        dump_image_csv("sim/render/bench_tile8_image.csv", 8);

        report_metrics();
        $finish;
    end

    // global watchdog
    initial begin
        #(CLK_HALF * 2 * 850_000_000);
        $display("\n[WATCHDOG] global timeout at cyc=%0d", cyc);
        report_metrics();
        $finish;
    end

endmodule
