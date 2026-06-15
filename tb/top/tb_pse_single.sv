`timescale 1ns/1ps

// Single-run per_sixteenth_engine testbench.
// Compile with -DRUN_ORIG to use orig_single_* output files (pse-single-orig target).
// Logs pixel events (ACCEPT/BRAM-HIT/MISS/STARTED/INJECT/CLUSTER/BRAMWR/DRAMWR)
// to *_events.csv for post-sim pixel-trace analysis.

module tb_pse_single;

    localparam int TILE_W       = 8;
    localparam int TILES_P_AXIS = 256 / TILE_W;
    localparam int TOTAL_TILES  = TILES_P_AXIS * TILES_P_AXIS;
    localparam int WORDS_P_TILE = TILE_W * TILE_W / 8;

    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // ── DUT signals ──────────────────────────────────────────────────────────
    logic        rst, start;
    wire         engine_done, sixteenth_complete;
    logic [4:0]  fractal_type;
    logic [34:0] centre_x, centre_y;
    logic [15:0] zoom_level;
    logic [34:0] julia_real, julia_imag;
    logic [11:0] max_iter;
    
    logic [3:0]  sixteenth_id;
    logic [31:0] sixteenth_base_addr;
    wire  [31:0] axi_wr_addr;
    wire  [63:0] axi_wr_data;
    wire         axi_wr_en;
    logic        axi_wr_ready;

    localparam logic [31:0] CENTRE_X = 32'hFFFF_0000;
    localparam logic [31:0] CENTRE_Y = 32'h0001_0000;
    localparam logic [15:0] ZOOM  = 16'd1;
    localparam logic [34:0] JULIA = 35'b0;
    localparam logic [11:0] MAX_I = 12'd1;   // match benchmark; raise to isolate compute vs drain
    localparam logic [31:0] BASE  = 32'h0000_0000;

    per_sixteenth_engine #(.TILE_W(TILE_W)) dut (
        .clk                (clk),
        .rst                (rst),
        .start              (start),
        .engine_done        (engine_done),
        .sixteenth_complete (sixteenth_complete),
        .fractal_type       (fractal_type),
        .centre_x              (centre_x),
        .centre_y              (centre_y),
        .zoom_level         (zoom_level),
        .julia_real         (julia_real),
        .julia_imag         (julia_imag),
        .max_iter           (max_iter),
        
        
        .sixteenth_id       (sixteenth_id),
        .sixteenth_base_addr(sixteenth_base_addr),
        .axi_wr_addr        (axi_wr_addr),
        .axi_wr_data        (axi_wr_data),
        .axi_wr_en          (axi_wr_en),
        .axi_wr_ready       (axi_wr_ready)
    );

    // ── Capture arrays (BRAM writes, DRAM writes) ─────────────────────────────
    localparam int MAX_BRAM = 65536;
    localparam int MAX_DRAM = 8192;

    logic [7:0]  bram_x   [0:MAX_BRAM-1];
    logic [7:0]  bram_y   [0:MAX_BRAM-1];
    logic [7:0]  bram_col [0:MAX_BRAM-1];
    int          bram_cnt = 0;

    logic [31:0] dram_addr [0:MAX_DRAM-1];
    logic [63:0] dram_data [0:MAX_DRAM-1];
    int          dram_cnt  = 0;

    always @(posedge clk) begin
        if (dut.u_control_unit.u_bram_rw.bram_wr_en && bram_cnt < MAX_BRAM) begin
            bram_x  [bram_cnt] = dut.u_control_unit.u_bram_rw.res_a;
            bram_y  [bram_cnt] = dut.u_control_unit.u_bram_rw.res_b;
            bram_col[bram_cnt] = dut.u_control_unit.u_bram_rw.res_colour;
            bram_cnt++;
        end
        if (axi_wr_en && axi_wr_ready && dram_cnt < MAX_DRAM) begin
            dram_addr[dram_cnt] = axi_wr_addr;
            dram_data[dram_cnt] = axi_wr_data;
            dram_cnt++;
        end
    end

    // ── Pixel event log ──────────────────────────────────────────────────────
    // kind codes (stored as integer in CSV, decoded by compare_pixels.py):
    //   65='A' ACCEPT    - coord accepted from scheduler
    //   72='H' BRAM_HIT  - BRAM check: pixel already done  (inject will fire)
    //   83='S' BRAM_STA  - BRAM check: pixel started (in-flight)
    //   77='M' BRAM_MIS  - BRAM check: pixel fresh miss
    //   73='I' INJECT    - inject fires into res_fifo (reused done colour)
    //   67='C' CLUSTER   - cluster result fires into res_fifo
    //   66='B' BRAMWR    - colour BRAM RMW write completes
    //   68='D' DRAMWR    - AXI pixel write to DRAM
    localparam int MAX_EV = 500_000;

    longint      ev_cyc  [0:MAX_EV-1];
    logic [7:0]  ev_px   [0:MAX_EV-1];
    logic [7:0]  ev_py   [0:MAX_EV-1];
    logic [7:0]  ev_col  [0:MAX_EV-1];
    logic [7:0]  ev_kind [0:MAX_EV-1]; // ASCII kind code
    int          ev_cnt = 0;

    task automatic log_ev(input longint c, input logic [7:0] x, y, col, k);
        if (ev_cnt < MAX_EV) begin
            ev_cyc [ev_cnt] = c;
            ev_px  [ev_cnt] = x;
            ev_py  [ev_cnt] = y;
            ev_col [ev_cnt] = col;
            ev_kind[ev_cnt] = k;
            ev_cnt++;
        end
    endtask

    longint cyc = 0;
    always @(posedge clk) cyc++;

    // Intermediate wires to avoid local-var-in-always-block issues in Icarus
    logic [7:0] bram_check_x, bram_check_y;
    assign bram_check_x = dut.u_control_unit.u_bram_rw.a_latch;
    assign bram_check_y = dut.u_control_unit.u_bram_rw.b_latch;

    // ── Event monitors (common to both CU versions) ───────────────────────────

    // ACCEPT: coord granted to CU
    always @(posedge clk)
        if (dut.u_control_unit.wants_job && dut.u_control_unit.grant)
            log_ev(cyc,
                   dut.u_control_unit.coord_out[7:0],
                   dut.u_control_unit.coord_out[15:8],
                   8'h00, 8'd65); // 'A'

    // BRAM check result (read_done_pulse fires one cycle after READ state exits)
    always @(posedge clk)
        if (dut.u_control_unit.u_bram_rw.read_done_pulse) begin
            if (dut.u_control_unit.u_bram_rw.done)
                log_ev(cyc, bram_check_x, bram_check_y,
                       dut.u_control_unit.u_bram_rw.colour, 8'd72); // 'H'
            else if (dut.u_control_unit.u_bram_rw.started)
                log_ev(cyc, bram_check_x, bram_check_y, 8'h00, 8'd83); // 'S'
            else
                log_ev(cyc, bram_check_x, bram_check_y, 8'h00, 8'd77); // 'M'
        end

    // INJECT: pixel reused from BRAM (reinject flag set in res_fifo_wr_data MSB)
    always @(posedge clk)
        if (dut.u_control_unit.res_fifo_wr_en &&
                dut.u_control_unit.res_fifo_wr_data[dut.u_control_unit.RES_FIFO_DW-1])
            log_ev(cyc,
                   dut.u_control_unit.iter_x,
                   dut.u_control_unit.iter_y,
                   dut.u_control_unit.iter_colour, 8'd73); // 'I'

    // CLUSTER: fresh cluster result
    always @(posedge clk)
        if (dut.u_control_unit.res_fifo_wr_en &&
                !dut.u_control_unit.res_fifo_wr_data[dut.u_control_unit.RES_FIFO_DW-1])
            log_ev(cyc,
                   dut.u_control_unit.iter_x,
                   dut.u_control_unit.iter_y,
                   dut.u_control_unit.iter_colour, 8'd67); // 'C'

    // BRAMWR: colour BRAM write completes
    always @(posedge clk)
        if (dut.u_control_unit.u_bram_rw.bram_wr_en)
            log_ev(cyc,
                   dut.u_control_unit.u_bram_rw.res_a,
                   dut.u_control_unit.u_bram_rw.res_b,
                   dut.u_control_unit.u_bram_rw.wr_data_q, 8'd66); // 'B'

    // DRAMWR: decode AXI 64-bit word into 8 pixel events
    logic [31:0] dram_ev_off;
    int          dram_ev_tile, dram_ev_wt, dram_ev_tc, dram_ev_tr;
    int          dram_ev_rit, dram_ev_cs, dram_ev_px, dram_ev_py;
    localparam int LOG2_BPT_EV = $clog2(TILE_W * TILE_W);
    localparam int WPR_EV      = TILE_W / 8;

    always @(posedge clk)
        if (axi_wr_en && axi_wr_ready) begin
            dram_ev_off  = axi_wr_addr - BASE;
            dram_ev_tile = dram_ev_off >> LOG2_BPT_EV;
            dram_ev_wt   = dram_ev_off[LOG2_BPT_EV-1:3];
            dram_ev_tc   = dram_ev_tile % TILES_P_AXIS;
            dram_ev_tr   = dram_ev_tile / TILES_P_AXIS;
            dram_ev_rit  = dram_ev_wt / WPR_EV;
            dram_ev_cs   = (dram_ev_wt % WPR_EV) * 8;
            for (int b = 0; b < 8; b++) begin
                dram_ev_px = dram_ev_tc * TILE_W + dram_ev_cs + b;
                dram_ev_py = dram_ev_tr * TILE_W + dram_ev_rit;
                if (dram_ev_px < 256 && dram_ev_py < 256)
                    log_ev(cyc, dram_ev_px[7:0], dram_ev_py[7:0],
                           axi_wr_data[b*8 +: 8], 8'd68); // 'D'
            end
        end

    // ── Heartbeat ─────────────────────────────────────────────────────────────
    always @(posedge clk)
        if ((cyc % 100_000) == 0)
            $display("  [hb] cyc=%0d  eng_done=%0b  sxt_complete=%0b  transferred=%0d  bram=%0d  dram=%0d  events=%0d",
                     cyc, engine_done, sixteenth_complete,
                     $countones(dut.u_bram_to_dram.transferred),
                     bram_cnt, dram_cnt, dut.u_scheduler.current_state);

    // ── Drain-tail + b2d-occupancy metrics (engine_done → sixteenth_complete) ──
    longint edone_cyc = 0;      // cycle engine_done first rose
    longint scomplete_cyc = 0;  // cycle sixteenth_complete rose
    logic   edone_prev = 0, scomp_prev = 0;
    longint b2d_active_cyc = 0; // cycles bram_to_dram actively draining (not SCAN)
    longint b2d_scan_busy  = 0; // SCAN cycles WHILE tiles pending (true per-tile overhead)
    longint b2d_scan_idle  = 0; // SCAN cycles with NO tiles pending (starved/waiting)
    // drain-tail-specific (between engine_done and sixteenth_complete):
    longint tail_active = 0;    // b2d actively draining during the tail
    longint tail_scan_busy = 0; // b2d in SCAN with work pending during the tail
    longint tail_scan_idle = 0; // b2d in SCAN starved during the tail
    logic   in_tail = 0;
    logic   b2d_is_scan, b2d_pend;   // per-cycle temps
    // bram_to_dram state enum: SCAN=0, CHECK_TABLE=1, GENERATE_FILL=2, BURST_PIPE=3
    always @(posedge clk) begin
        edone_prev <= engine_done;
        scomp_prev <= sixteenth_complete;
        if (engine_done && !edone_prev) begin edone_cyc <= cyc; in_tail <= 1'b1; end
        if (sixteenth_complete && !scomp_prev) begin scomplete_cyc <= cyc; in_tail <= 1'b0; end
        if (!sixteenth_complete) begin
            b2d_is_scan = (int'(dut.u_bram_to_dram.state) == 0);
            b2d_pend    = dut.u_bram_to_dram.any_pending;
            if (!b2d_is_scan)        b2d_active_cyc <= b2d_active_cyc + 1;
            else if (b2d_pend)       b2d_scan_busy  <= b2d_scan_busy + 1;
            else                     b2d_scan_idle  <= b2d_scan_idle + 1;
            if (in_tail) begin
                if (!b2d_is_scan)    tail_active    <= tail_active + 1;
                else if (b2d_pend)   tail_scan_busy <= tail_scan_busy + 1;
                else                 tail_scan_idle <= tail_scan_idle + 1;
            end
        end
    end

    // ── Box-decision and QUEUE_BOX-complete monitors ─────────────────────────
    // Track previous scheduler state to detect transitions
    typedef enum {IDLE, STARTUP, INCREASE_LEVEL, INCREASE_LEVEL_SECOND, BEGIN_SEARCH_BOX, WAIT, QUEUE_BOX_INIT, QUEUE_BOX, QUEUE_BOX_DRAIN, FILL_BOX, NEXT_BOX, DESCEND_LEVEL, FINISHED} tb_sched_state_t;
    tb_sched_state_t prev_sched_state;
    int qbox_push_count;
    always @(posedge clk) begin
        prev_sched_state <= tb_sched_state_t'(dut.u_scheduler.current_state);

        // WAIT→something: print the decision
        if (prev_sched_state == WAIT && tb_sched_state_t'(dut.u_scheduler.current_state) != WAIT) begin
            case (tb_sched_state_t'(dut.u_scheduler.current_state))
                FILL_BOX:      $display("  [decision] cyc=%0d  FILL      box_id=%0b  zoom=%0d  tile=(%0d,%0d)  pw_x=%0d  pw_y=%0d",
                                        cyc, dut.u_scheduler.box_id, dut.u_scheduler.zoom_level,
                                        dut.u_scheduler.tlx, dut.u_scheduler.tly,
                                        dut.u_scheduler.pixel_width_x, dut.u_scheduler.pixel_width_y);
                DESCEND_LEVEL: $display("  [decision] cyc=%0d  DESCEND   box_id=%0b  zoom=%0d  tile=(%0d,%0d)  pw_x=%0d  pw_y=%0d",
                                        cyc, dut.u_scheduler.box_id, dut.u_scheduler.zoom_level,
                                        dut.u_scheduler.tlx, dut.u_scheduler.tly,
                                        dut.u_scheduler.pixel_width_x, dut.u_scheduler.pixel_width_y);
                QUEUE_BOX_INIT:$display("  [decision] cyc=%0d  QUEUE_ALL box_id=%0b  zoom=%0d  tile=(%0d,%0d)  pw_x=%0d  pw_y=%0d",
                                        cyc, dut.u_scheduler.box_id, dut.u_scheduler.zoom_level,
                                        dut.u_scheduler.tlx, dut.u_scheduler.tly,
                                        dut.u_scheduler.pixel_width_x, dut.u_scheduler.pixel_width_y);
                default: ;
            endcase
        end

        // Count pushes for the whole QUEUE_BOX sequence (QUEUE_BOX_INIT + QUEUE_BOX); reset on QUEUE_BOX_INIT entry
        if (prev_sched_state != QUEUE_BOX_INIT && tb_sched_state_t'(dut.u_scheduler.current_state) == QUEUE_BOX_INIT)
            qbox_push_count <= 0;
        else if ((tb_sched_state_t'(dut.u_scheduler.current_state) == QUEUE_BOX_INIT ||
                  tb_sched_state_t'(dut.u_scheduler.current_state) == QUEUE_BOX) && dut.jqh_sched_push)
            qbox_push_count <= qbox_push_count + 1;

        // QUEUE_BOX→something: print summary
        if (prev_sched_state == QUEUE_BOX && tb_sched_state_t'(dut.u_scheduler.current_state) != QUEUE_BOX) begin
            $display("  [qbox_end] cyc=%0d  box_id=%0b  zoom=%0d  tile=(%0d,%0d)  pw_x=%0d  pw_y=%0d  pushed=%0d  expected=%0d",
                     cyc, dut.u_scheduler.box_id, dut.u_scheduler.zoom_level,
                     dut.u_scheduler.tlx, dut.u_scheduler.tly,
                     dut.u_scheduler.pixel_width_x, dut.u_scheduler.pixel_width_y,
                     qbox_push_count,
                     dut.u_scheduler.pixel_width_x * dut.u_scheduler.pixel_width_y);
        end
    end

    // ── Job queue push monitor ────────────────────────────────────────────────
    always @(posedge clk) begin
        if (dut.jqh_flush) begin
            $display("  [flush]   cyc=%0d  state=%s  box_id=%0b  zoom=%0d  tlx=%0d  tly=%0d  pw_x=%0d  pw_y=%0d",
                     cyc,
                     dut.u_scheduler.current_state.name(),
                     dut.u_scheduler.box_id,
                     dut.u_scheduler.zoom_level,
                     dut.u_scheduler.tlx, dut.u_scheduler.tly,
                     dut.u_scheduler.pixel_width_x,
                     dut.u_scheduler.pixel_width_y);
        end
    end

    // ── Log when tile_done fires for any tile ─────────────────────────────────
    // Read tile_table one cycle after the rising edge so the registered write
    // from tt_wr_quad_en has had time to land (avoids tt_filled=0 for fills).
    logic [TOTAL_TILES-1:0] tile_done_prev;
    logic [TOTAL_TILES-1:0] tile_done_rose;
    always @(posedge clk) begin
        tile_done_prev <= dut.tile_done;
        tile_done_rose <= dut.tile_done & ~tile_done_prev;
    end
    always @(posedge clk) begin
        for (int _i = 0; _i < TOTAL_TILES; _i++) begin
            if (tile_done_rose[_i])
                $display("  [tile_done] cyc=%0d  tile=%0d  pixel_cnt=%0d  tt_filled=%0b  bram_writes_so_far=%0d",
                         cyc, _i,
                         dut.u_colour_bram.active ? dut.u_colour_bram.tile_wr_cnt_b[_i] : dut.u_colour_bram.tile_wr_cnt_a[_i],
                         dut.u_tile_table.tile_table[_i][6],
                         bram_cnt);
        end
    end

    // ── CSV tasks ─────────────────────────────────────────────────────────────
    task automatic dump_bram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        $fwrite(fd, "write_index,x,y,colour\n");
        for (int i = 0; i < bram_cnt; i++)
            $fwrite(fd, "%0d,%0d,%0d,%0d\n", i, bram_x[i], bram_y[i], bram_col[i] & 8'h3F);
        $fclose(fd);
        $display("  wrote %s  (%0d rows)", path, bram_cnt);
    endtask

    task automatic dump_dram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        $fwrite(fd, "write_index,addr_hex,b0,b1,b2,b3,b4,b5,b6,b7\n");
        for (int i = 0; i < dram_cnt; i++)
            $fwrite(fd, "%0d,0x%08X,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                i, dram_addr[i],
                dram_data[i][ 7: 0], dram_data[i][15: 8],
                dram_data[i][23:16], dram_data[i][31:24],
                dram_data[i][39:32], dram_data[i][47:40],
                dram_data[i][55:48], dram_data[i][63:56]);
        $fclose(fd);
        $display("  wrote %s  (%0d rows)", path, dram_cnt);
    endtask

    task automatic dump_image_csv(input string path);
        localparam int LOG2_BPT  = $clog2(TILE_W * TILE_W);
        localparam int WPR       = TILE_W / 8;
        logic [7:0] image [0:255][0:255];
        integer fd;
        int tile_idx, wt, tc, tr, rit, cs, px, py;
        logic [31:0] off;
        for (int r = 0; r < 256; r++)
            for (int c = 0; c < 256; c++) image[r][c] = 8'hFF;
        for (int i = 0; i < dram_cnt; i++) begin
            off      = dram_addr[i] - BASE;
            tile_idx = off >> LOG2_BPT;
            wt       = off[LOG2_BPT-1:3];
            tc       = tile_idx % TILES_P_AXIS;
            tr       = tile_idx / TILES_P_AXIS;
            rit      = wt / WPR;
            cs       = (wt % WPR) * 8;
            for (int b = 0; b < 8; b++) begin
                px = tc * TILE_W + cs + b;
                py = tr * TILE_W + rit;
                if (px < 256 && py < 256) image[py][px] = dram_data[i][b*8 +: 8];
            end
        end
        fd = $fopen(path, "w");
        $fwrite(fd, "row,col,colour\n");
        for (int r = 0; r < 256; r++)
            for (int c = 0; c < 256; c++)
                $fwrite(fd, "%0d,%0d,%0d\n", r, c, image[r][c] & 8'h3F);
        $fclose(fd);
        $display("  wrote %s  (256x256)", path);
    endtask

    task automatic dump_bram_direct_csv(input string path);
        localparam int WPR = (TILE_W / 8 > 0) ? TILE_W / 8 : 1;
        integer fd;
        logic [63:0] word;
        int px, py, tc, tr, rit, cs;
        fd = $fopen(path, "w");
        $fwrite(fd, "row,col,colour\n");
        for (int tile = 0; tile < TOTAL_TILES; tile++) begin
            tc = tile % TILES_P_AXIS;
            tr = tile / TILES_P_AXIS;
            for (int w = 0; w < WORDS_P_TILE; w++) begin
                word = dut.u_colour_bram.mem[tile * WORDS_P_TILE + w];
                rit  = w / WPR;
                cs   = (w % WPR) * 8;
                for (int b = 0; b < 8; b++) begin
                    px = tc * TILE_W + cs + b;
                    py = tr * TILE_W + rit;
                    $fwrite(fd, "%0d,%0d,%0d\n", py, px, word[b*8 +: 8] & 8'h3F);
                end
            end
        end
        $fclose(fd);
        $display("  wrote %s  (256x256 direct)", path);
    endtask

    task automatic dump_events_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        $fwrite(fd, "cyc,kind,px,py,colour\n");
        for (int i = 0; i < ev_cnt; i++)
            // kind written as integer (ASCII): A=65 H=72 S=83 M=77 I=73 C=67 B=66 D=68
            $fwrite(fd, "%0d,%0d,%0d,%0d,%0d\n",
                    ev_cyc[i], ev_kind[i],
                    ev_px[i], ev_py[i], ev_col[i] & 8'h3F);
        $fclose(fd);
        $display("  wrote %s  (%0d events)", path, ev_cnt);
    endtask

    // ── Engine-done diagnostics ───────────────────────────────────────────────
    logic engine_done_prev;
    always @(posedge clk) begin
        engine_done_prev <= engine_done;
        if (engine_done && !engine_done_prev)
            $display("  [eng_done] cyc=%0d  tile_done=%0d  sched_tile_done=%0d  cbram_tile_done=%0d  transferred=%0d",
                     cyc,
                     $countones(dut.tile_done),
                     $countones(dut.sched_tile_done),
                     $countones(dut.cbram_tile_done),
                     $countones(dut.u_bram_to_dram.transferred));
    end

    // ── Main ─────────────────────────────────────────────────────────────────
    int _t;
    initial begin
        fractal_type        = 5'b0_0000;
        centre_x               = CENTRE_X;
        centre_y               = CENTRE_Y;
        zoom_level          = ZOOM;
        max_iter            = MAX_I;
        julia_real          = JULIA;
        julia_imag          = JULIA;
        sixteenth_id        = 4'd0;
        sixteenth_base_addr = BASE;
        axi_wr_ready        = 1'b1;
        start               = 1'b0;

        rst = 1; tick(4); rst = 0; tick(2);
        start = 1; tick(1); start = 0;

        _t = 0;
        while (!sixteenth_complete && _t < 20_000_000) begin tick(1); _t++; end

        if (sixteenth_complete)
            $display("\n  sixteenth_complete at cyc=%0d  bram=%0d  dram=%0d  events=%0d",
                     cyc, bram_cnt, dram_cnt, ev_cnt);
        else
            $display("\n  [TIMEOUT] not complete after %0d cycles", _t);

        $display("\n  ===== B2D DRAIN METRICS (max_iter=%0d, TILE_W=%0d) =====", MAX_I, TILE_W);
        $display("  total cycles to complete     : %0d", cyc);
        $display("  engine_done at cycle         : %0d", edone_cyc);
        $display("  drain tail (edone->complete) : %0d cycles", cyc - edone_cyc);
        $display("  DRAM words written           : %0d", dram_cnt);
        $display("  --- whole-run b2d occupancy ---");
        $display("  active (draining)            : %0d cyc", b2d_active_cyc);
        $display("  SCAN while tiles pending     : %0d cyc  (true per-tile overhead)", b2d_scan_busy);
        $display("  SCAN while starved (no work) : %0d cyc  (waiting on compute pipeline)", b2d_scan_idle);
        $display("  cyc per DRAM word (active)   : %0.3f",
                 (dram_cnt>0) ? real'(b2d_active_cyc)/real'(dram_cnt) : 0.0);
        $display("  --- DRAIN TAIL breakdown (edone -> complete) ---");
        $display("  tail active (draining)       : %0d cyc", tail_active);
        $display("  tail SCAN pending (overhead) : %0d cyc", tail_scan_busy);
        $display("  tail SCAN starved (waiting)  : %0d cyc", tail_scan_idle);
        $display("  >>> tail is %s",
                 (tail_active > (tail_scan_busy+tail_scan_idle)) ?
                 "B2D-BOUND (b2d slow to drain)" : "STARVED (waiting for tiles/clear)");
        $display("  ============================================\n");

        $display("\n  Writing CSVs...");
`ifdef RUN_ORIG
        dump_bram_csv("sim/render/orig_single_bram.csv");
        dump_bram_direct_csv("sim/render/orig_single_bram_direct.csv");
        dump_dram_csv("sim/render/orig_single_dram.csv");
        dump_image_csv("sim/render/orig_single_image.csv");
        dump_events_csv("sim/render/orig_single_events.csv");
`else
        dump_bram_csv("sim/render/single_bram.csv");
        dump_bram_direct_csv("sim/render/single_bram_direct.csv");
        dump_dram_csv("sim/render/single_dram.csv");
        dump_image_csv("sim/render/single_image.csv");
        dump_events_csv("sim/render/single_events.csv");
`endif

        $finish;
    end

endmodule
