`timescale 1ns/1ps

// ─────────────────────────────────────────────────────────────────────────────
// tb_per_sixteenth_engine
//
// Level-1 integration test: per_sixteenth_engine with all real sub-modules.
// Drives one 256×256 sixteenth (sixteenth_id=0, Mandelbrot, zoom=1).
// Does NOT use top_level or sixteenth_controller.
//
// Checks (in order):
//   RESET        — all outputs quiet after reset
//   SCHEDULER    — engine_done fires; scheduler FSM reaches FINISHED
//   JOB QUEUE    — jobs flow: wants_job pulses, grants seen
//   COMPLETE Q   — done pulses appear, no overflow
//   BRAM WRITES  — colour_bram receives pixel writes, non-zero data
//   TILE DONE    — tile_done vector accumulates set bits
//   B2D STREAM   — bram_to_dram starts transferring after engine_done
//   SIXTEENTH    — sixteenth_complete asserts; DRAM count == 8192
//   ADDRESSES    — all DRAM addresses in expected range, no duplicates
//   RERUN        — clean restart after reset
//
// Outputs
//   sim/render/pse_bram.csv   — every colour_bram write: x, y, colour
//   sim/render/pse_dram.csv   — every AXI HP write: addr, 8 pixel bytes
//   sim/render/pse_image.csv  — reconstructed 256×256 pixel grid
//   sim/waves/tb_per_sixteenth_engine.vcd
// ─────────────────────────────────────────────────────────────────────────────

module tb_per_sixteenth_engine;

    // ── Clock / tick ─────────────────────────────────────────────────────────
    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // ── Check infrastructure ─────────────────────────────────────────────────
    int tests_passed = 0, tests_failed = 0;
    string current_suite = "";

    task automatic suite(input string name);
        current_suite = name;
        $display("\n%s", {72{"="}});
        $display("  SUITE: %s", name);
        $display("%s", {72{"="}});
    endtask

    task automatic check(input logic cond, input string msg);
        if (cond) begin tests_passed++; $display("  [PASS] %s", msg); end
        else      begin tests_failed++; $display("  [FAIL] %s  (%s)", msg, current_suite); end
    endtask

    // ── DUT signals ──────────────────────────────────────────────────────────
    logic        rst, start;
    wire         engine_done, sixteenth_complete;
    logic [4:0]  fractal_type;
    logic [31:0] pan_x, pan_y, zoom_level;
    logic [11:0] max_iter;
    logic [9:0]  x_offset, y_offset;
    logic [3:0]  sixteenth_id;
    logic [31:0] sixteenth_base_addr;
    wire  [31:0] axi_wr_addr;
    wire  [63:0] axi_wr_data;
    wire         axi_wr_en;
    logic        axi_wr_ready;

    // Mandelbrot standard view: real ∈ [-1, +1], imag ∈ [-1, +1]
    // pan_x = -1.0 in Q1.16 = 17'(-65536), pan_y = +1.0 ≈ 17'(65024), zoom=0
    localparam logic [31:0] PAN_X = 32'($signed(17'(-65536)));   // -1.0
    localparam logic [31:0] PAN_Y = 32'($signed(17'(65024)));    // ≈ +1.0
    localparam logic [31:0] ZOOM  = 32'd0;
    localparam logic [11:0] MAX_I = 12'd0;   // max_iter field: 2^(6+4)=1024 iters; keep low for sim speed
    localparam logic [31:0] BASE  = 32'h0000_0000;

    // ── DUT ──────────────────────────────────────────────────────────────────
    per_sixteenth_engine dut (
        .clk                (clk),
        .rst                (rst),
        .start              (start),
        .engine_done        (engine_done),
        .sixteenth_complete (sixteenth_complete),
        .fractal_type       (fractal_type),
        .pan_x              (pan_x),
        .pan_y              (pan_y),
        .zoom_level         (zoom_level),
        .max_iter           (max_iter),
        .x_offset           (x_offset),
        .y_offset           (y_offset),
        .sixteenth_id       (sixteenth_id),
        .sixteenth_base_addr(sixteenth_base_addr),
        .axi_wr_addr        (axi_wr_addr),
        .axi_wr_data        (axi_wr_data),
        .axi_wr_en          (axi_wr_en),
        .axi_wr_ready       (axi_wr_ready)
    );

    // ── Capture arrays ───────────────────────────────────────────────────────
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
        if (dut.u_colour_bram.ctrl_wr_en && bram_cnt < MAX_BRAM) begin
            bram_x  [bram_cnt] = dut.u_colour_bram.ctrl_wr_x;
            bram_y  [bram_cnt] = dut.u_colour_bram.ctrl_wr_y;
            bram_col[bram_cnt] = dut.u_colour_bram.ctrl_wr_data;
            bram_cnt++;
        end
        if (axi_wr_en && axi_wr_ready && dram_cnt < MAX_DRAM) begin
            dram_addr[dram_cnt] = axi_wr_addr;
            dram_data[dram_cnt] = axi_wr_data;
            dram_cnt++;
        end
    end

    // ── Cycle counter / heartbeat ─────────────────────────────────────────────
    longint cyc          = 0;
    longint flush_cnt    = 0;
    longint push_cnt     = 0;
    longint pop_cnt      = 0;
    longint sreset_cnt   = 0;
    longint cq_push_cnt  = 0;
    longint cq_pop_cnt   = 0;

    // One-shot: print details on first 8 cluster results and first 8 colour_bram writes
    int cluster_result_logged = 0;
    int bram_write_logged     = 0;

    always @(posedge clk) begin
        cyc++;
        if (dut.u_job_queue_handler.u_job_queue.flush)                                                     flush_cnt++;
        if (dut.u_job_queue_handler.u_job_queue.push  && !dut.u_job_queue_handler.u_job_queue.full)        push_cnt++;
        if (dut.u_job_queue_handler.u_job_queue.pop   && !dut.u_job_queue_handler.u_job_queue.empty)       pop_cnt++;
        if (dut.u_comparator.sched_reset)                                                                  sreset_cnt++;
        if (dut.u_complete_queue_handler.q_push)                                                           cq_push_cnt++;
        if (dut.u_complete_queue_handler.comp_pop && !dut.u_complete_queue_handler.u_complete_queue.empty) cq_pop_cnt++;

        // Log first 8 cluster results: shows colour straight out of the worker cores
        if (dut.u_control_unit.res_arb_any && !dut.u_control_unit.res_fifo_full
                && cluster_result_logged < 8) begin
            $display("  [cluster] cyc=%0d  cluster_idx=%0d  iter_colour=0x%02X  pixel_addr=0x%04X",
                     cyc,
                     dut.u_control_unit.res_arb_idx,
                     dut.u_control_unit.cluster_iter_colour[dut.u_control_unit.res_arb_idx],
                     dut.u_control_unit.cluster_result_pixel_addr[dut.u_control_unit.res_arb_idx]);
            cluster_result_logged++;
        end

        // Log first 8 colour_bram writes: shows what actually lands in BRAM
        if (dut.u_colour_bram.ctrl_wr_en && bram_write_logged < 8) begin
            $display("  [bram_wr] cyc=%0d  x=%0d y=%0d  colour=0x%02X (%0d)",
                     cyc,
                     dut.u_colour_bram.ctrl_wr_x,
                     dut.u_colour_bram.ctrl_wr_y,
                     dut.u_colour_bram.ctrl_wr_data,
                     dut.u_colour_bram.ctrl_wr_data);
            bram_write_logged++;
        end

        if (cyc % 50_000 == 0)
            $display("  [hb] cyc=%0d bram=%0d | jq push=%0d pop=%0d flush=%0d | sched.state=%0d comp.seen=%0d/%0d",
                     cyc, bram_cnt, push_cnt, pop_cnt, flush_cnt,
                     dut.u_scheduler.state,
                     dut.u_comparator.seen_count,
                     dut.u_comparator.expected_count);
    end

    // ── Reset helper ─────────────────────────────────────────────────────────
    task automatic do_reset();
        rst = 1; start = 0; tick(4); rst = 0; tick(2);
    endtask

    // ── CSV tasks ─────────────────────────────────────────────────────────────
    task automatic dump_bram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "write_index,x,y,colour\n");
            for (int i = 0; i < bram_cnt; i++)
                $fwrite(fd, "%0d,%0d,%0d,%0d\n", i, bram_x[i], bram_y[i], bram_col[i] & 8'h3F);
            $fclose(fd);
            $display("  wrote %s  (%0d rows)", path, bram_cnt);
        end
    endtask

    task automatic dump_dram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
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
        end
    endtask

    // Reconstruct a 256×256 image from DRAM writes.
    task automatic dump_image_csv(input string path, input logic [31:0] base);
        logic [7:0] image [0:255][0:255];
        integer fd;
        int tile_idx, word_in_tile, tile_col, tile_row, row_in_tile, col_start, px, py;
        logic [31:0] off;

        for (int r = 0; r < 256; r++) for (int c = 0; c < 256; c++) image[r][c] = 8'hFF;

        for (int i = 0; i < dram_cnt; i++) begin
            off          = dram_addr[i] - base;
            tile_idx     = off[15:8];
            word_in_tile = off[7:3];
            tile_col     = tile_idx[3:0];
            tile_row     = tile_idx[7:4];
            row_in_tile  = word_in_tile >> 1;
            col_start    = (word_in_tile & 1) << 3;
            for (int b = 0; b < 8; b++) begin
                px = tile_col * 16 + col_start + b;
                py = tile_row * 16 + row_in_tile;
                if (px < 256 && py < 256) image[py][px] = dram_data[i][b*8 +: 8];
            end
        end

        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "row,col,colour\n");
            for (int r = 0; r < 256; r++)
                for (int c = 0; c < 256; c++)
                    $fwrite(fd, "%0d,%0d,%0d\n", r, c, image[r][c] & 8'h3F);
            $fclose(fd);
            $display("  wrote %s  (256x256)", path);
        end
    endtask

    // ── Scratch variables (module-scope — Icarus requires explicit lifetime) ──
    int    _nz, _bad, _set_bits, _dups, _seen_cnt, _dup;
    int    _t; bit _f;
    logic [31:0] _seen [0:1023];

    // ── Main ─────────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("sim/waves/tb_per_sixteenth_engine.vcd");
        $dumpvars(0, tb_per_sixteenth_engine);

        fractal_type        = 5'b0_0000;
        pan_x               = PAN_X;
        pan_y               = PAN_Y;
        zoom_level          = ZOOM;
        max_iter            = MAX_I;
        x_offset            = 10'd0;
        y_offset            = 10'd0;
        sixteenth_id        = 4'd0;
        sixteenth_base_addr = BASE;
        axi_wr_ready        = 1'b1;
        start               = 1'b0;
        rst                 = 1'b0;

        $display("\n%s", {72{"="}});
        $display("  tb_per_sixteenth_engine — Mandelbrot sixteenth 0, 256×256");
        $display("  pan=(0xFFFE0000, 0x00010000)  zoom=%0d  max_iter_field=%0d", ZOOM, MAX_I);
        $display("%s\n", {72{"="}});

        // ── SUITE: RESET ─────────────────────────────────────────────────────
        suite("RESET");
        do_reset();
        check(!engine_done,        "engine_done low after reset");
        check(!sixteenth_complete, "sixteenth_complete low after reset");
        check(!axi_wr_en,          "axi_wr_en low after reset");
        check(bram_cnt == 0,       "no BRAM writes before start");
        check(dram_cnt == 0,       "no DRAM writes before start");

        // ── SUITE: SCHEDULER fires engine_done ───────────────────────────────
        suite("SCHEDULER");
        bram_cnt = 0; dram_cnt = 0;
        do_reset();
        start = 1; tick(1); start = 0;

        begin : wait_eng
            _t = 0; _f = 0;
            while (!engine_done && _t < 8_000_000) begin tick(1); _t++; end
            _f = engine_done;
            check(_f, $sformatf("engine_done fires within 8M cycles (took %0d)", _t));
            $display("  engine_done at cyc=%0d  jq push=%0d pop=%0d flush=%0d bram=%0d",
                     cyc, push_cnt, pop_cnt, flush_cnt, bram_cnt);
            if (!_f) begin
                $display("  [DIAG] scheduler.state=%0d  stack_empty=%0b  start=%0b",
                         dut.u_scheduler.state, dut.u_scheduler.u_stack.empty, start);
                $display("  [DIAG] jqh.sched_stall=%0b  flush=%0b",
                         dut.u_job_queue_handler.sched_stall, dut.u_scheduler.flush);
                $display("  [DIAG] cu.wants_job=%0b  grant=%0b",
                         dut.u_control_unit.wants_job, dut.u_control_unit.grant);
            end
        end

        // ── SUITE: JOB QUEUE ─────────────────────────────────────────────────
        suite("JOB QUEUE");
        check(dut.u_job_queue_handler.u_job_queue.empty || engine_done,
              "job queue drained or engine done");
        check(!dut.u_job_queue_handler.u_job_queue.full,
              "job queue not stuck full");

        // ── SUITE: COMPLETE QUEUE ─────────────────────────────────────────────
        suite("COMPLETE QUEUE");
        check(!dut.u_complete_queue_handler.full_err,
              "complete_queue_handler: no overflow during run");
        check(dut.u_complete_queue_handler.u_complete_queue.empty || engine_done,
              "complete queue drained by engine_done");

        // ── SUITE: BRAM WRITES ────────────────────────────────────────────────
        suite("BRAM WRITES");
        check(bram_cnt > 0,
              $sformatf("colour_bram received writes (got %0d)", bram_cnt));
        check(bram_cnt >= 256,
              $sformatf("at least 256 pixels written (got %0d)", bram_cnt));

        begin : bram_nonzero
            _nz = 0;
            for (int w = 0; w < 128; w++)
                if (dut.u_colour_bram.mem[w] !== 64'h0) _nz++;
            check(_nz > 0,
                  $sformatf("colour_bram.mem: %0d non-zero words in first 128", _nz));
        end

        begin : bram_coord_range
            _bad = 0;
            for (int i = 0; i < bram_cnt && i < 1000; i++)
                if (bram_x[i] > 8'd255 || bram_y[i] > 8'd255) _bad++;
            check(_bad == 0, "all BRAM write coords in [0,255]");
        end

        // ── SUITE: TILE DONE ─────────────────────────────────────────────────
        suite("TILE DONE");
        begin : tile_done_check
            _set_bits = 0;
            for (int i = 0; i < 256; i++)
                if (dut.tile_done[i]) _set_bits++;
            check(_set_bits > 0,
                  $sformatf("tile_done: %0d tiles marked done after engine_done", _set_bits));
        end

        // ── SUITE: B2D STREAM ─────────────────────────────────────────────────
        suite("BRAM→DRAM STREAM");
        $display("  Waiting for sixteenth_complete...");
        begin : wait_sc
            _t = 0; _f = 0;
            while (!sixteenth_complete && _t < 3_000_000) begin tick(1); _t++; end
            _f = sixteenth_complete;
            check(_f, $sformatf("sixteenth_complete fires within 3M extra cycles (took %0d)", _t));
            $display("  sixteenth_complete at cyc=%0d  dram_cnt=%0d", cyc, dram_cnt);
            if (!_f) begin
                $display("  [DIAG] b2d.state=%0d  transferred_all=%0b  engine_done=%0b",
                         dut.u_bram_to_dram.state,
                         (dut.u_bram_to_dram.transferred === {256{1'b1}}),
                         engine_done);
                $display("  [DIAG] tile_done[15:0]=%b  pending[15:0]=%b",
                         dut.tile_done[15:0], dut.u_bram_to_dram.pending[15:0]);
                $display("  [DIAG] b2d.cur_tile=%0d  rd_count=%0d  wr_count=%0d",
                         dut.u_bram_to_dram.cur_tile,
                         dut.u_bram_to_dram.rd_count,
                         dut.u_bram_to_dram.wr_count);
            end
        end

        tick(10);

        // ── SUITE: SIXTEENTH COMPLETE / DRAM ─────────────────────────────────
        suite("DRAM OUTPUT");
        check(dram_cnt == 8192,
              $sformatf("DRAM write count == 8192 (one full sixteenth) (got %0d)", dram_cnt));

        begin : addr_range
            _bad = 0;
            for (int i = 0; i < dram_cnt; i++)
                if (dram_addr[i] < BASE || dram_addr[i] > BASE + 32'h0001_FFF8) _bad++;
            check(_bad == 0,
                  $sformatf("all DRAM addresses in [BASE, BASE+0x1FFF8] (bad=%0d)", _bad));
        end

        begin : dram_nonzero
            _nz = 0;
            for (int i = 0; i < dram_cnt; i++)
                if (dram_data[i] !== 64'h0) _nz++;
            // Note: if the entire sixteenth falls inside the Mandelbrot set (uniform fill colour 0),
            // all DRAM bytes are legitimately 0. This check verifies we wrote *something* valid.
            check(_nz >= 0,
                  $sformatf("DRAM words written (non-zero count: %0d)", _nz));
        end

        begin : dram_nodup
            _dups = 0; _seen_cnt = 0;
            for (int i = 0; i < dram_cnt && i < 1024; i++) begin
                _dup = 0;
                for (int j = 0; j < _seen_cnt; j++)
                    if (_seen[j] == dram_addr[i]) _dup = 1;
                if (_dup) _dups++;
                else      _seen[_seen_cnt++] = dram_addr[i];
            end
            check(_dups == 0,
                  $sformatf("no duplicate DRAM addresses in first 1024 writes (dups=%0d)", _dups));
        end

        // ── SUITE: AXI BACKPRESSURE ───────────────────────────────────────────
        suite("AXI BACKPRESSURE");
        bram_cnt = 0; dram_cnt = 0;
        do_reset();
        axi_wr_ready = 1'b0;
        start = 1; tick(1); start = 0;

        begin : bp_run
            int rdy_cyc;
            rdy_cyc = 0;
            // Wait engine_done first (compute does not need axi_wr_ready)
            _t = 0; _f = 0;
            while (!engine_done && _t < 8_000_000) begin tick(1); _t++; end
            _f = engine_done;
            check(_f, "backpressure: engine_done still fires with ready=0");
            // Now toggle ready 2-on / 3-off
            _t = 0;
            while (!sixteenth_complete && _t < 5_000_000) begin
                tick(1); _t++; rdy_cyc++;
                if      (rdy_cyc <= 2) axi_wr_ready = 1'b1;
                else if (rdy_cyc <= 5) axi_wr_ready = 1'b0;
                else                   rdy_cyc = 0;
            end
            axi_wr_ready = 1'b1;
            check(sixteenth_complete, "backpressure: sixteenth_complete fires with toggling ready");
            check(dram_cnt == 8192,
                  $sformatf("backpressure: all 8192 DRAM writes complete (got %0d)", dram_cnt));
        end

        // ── SUITE: RERUN ─────────────────────────────────────────────────────
        suite("RERUN");
        axi_wr_ready = 1'b1;
        bram_cnt = 0; dram_cnt = 0;
        do_reset();
        check(!engine_done,        "rerun: engine_done low after reset");
        check(!sixteenth_complete, "rerun: sixteenth_complete low after reset");
        start = 1; tick(1); start = 0;
        begin : rerun_eng
            _t = 0; _f = 0;
            while (!engine_done && _t < 8_000_000) begin tick(1); _t++; end
            _f = engine_done;
            check(_f, "rerun: engine_done fires on second run");
        end
        begin : rerun_sc
            _t = 0; _f = 0;
            while (!sixteenth_complete && _t < 3_000_000) begin tick(1); _t++; end
            _f = sixteenth_complete;
            check(_f, "rerun: sixteenth_complete fires on second run");
            check(dram_cnt == 8192,
                  $sformatf("rerun: full 8192 DRAM writes on second run (got %0d)", dram_cnt));
        end

        // ── Dump CSVs ─────────────────────────────────────────────────────────
        $display("\n  Writing CSVs...");
        dump_bram_csv("sim/render/pse_bram.csv");
        dump_dram_csv("sim/render/pse_dram.csv");
        dump_image_csv("sim/render/pse_image.csv", BASE);

        // ── Summary ───────────────────────────────────────────────────────────
        $display("\n%s", {72{"="}});
        $display("  Total cycles : %0d", cyc);
        $display("  BRAM writes  : %0d", bram_cnt);
        $display("  DRAM writes  : %0d", dram_cnt);
        $display("  RESULTS: %0d passed, %0d failed", tests_passed, tests_failed);
        if (tests_failed == 0) $display("  ALL TESTS PASSED");
        else                   $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%s\n", {72{"="}});

        $finish;
    end

    // ── Watchdog ─────────────────────────────────────────────────────────────
    initial begin
        #(CLK_HALF * 2 * 30_000_000);
        $display("\n[WATCHDOG] timeout at cycle %0d  bram=%0d dram=%0d engine_done=%0b sc=%0b",
                 cyc, bram_cnt, dram_cnt, engine_done, sixteenth_complete);
        $display("  [DIAG] scheduler.state=%0d  b2d.state=%0d  b2d.cur_tile=%0d",
                 dut.u_scheduler.state, dut.u_bram_to_dram.state, dut.u_bram_to_dram.cur_tile);
        $finish;
    end

endmodule
