`timescale 1ns/1ps

module tb_scheduler;

    // ── Test infrastructure ───────────────────────────────────────────────────
    int tests_run    = 0;
    int tests_passed = 0;
    int tests_failed = 0;
    string current_suite = "";

    task automatic suite(input string name);
        current_suite = name;
        $display("\n%s", {72{"="}});
        $display("  SUITE: %s", name);
        $display("%s", {72{"="}});
    endtask

    task automatic check(input logic cond, input string desc);
        tests_run++;
        if (cond) begin
            tests_passed++;
            $display("  [PASS] %s", desc);
        end else begin
            tests_failed++;
            $display("  [FAIL] %s  (suite: %s)", desc, current_suite);
        end
    endtask

    task automatic summary();
        $display("\n%s", {72{"="}});
        $display("  RESULTS: %0d / %0d passed", tests_passed, tests_run);
        if (tests_failed == 0)
            $display("  ALL TESTS PASSED");
        else
            $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%s\n", {72{"="}});
    endtask

    // ── Clock ─────────────────────────────────────────────────────────────────
    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;

    task automatic tick(input int n = 1);
        repeat(n) @(posedge clk);
        #1;
    endtask

    // ── State constants (must match enum order in scheduler.sv) ──────────────
    localparam [3:0] ST_IDLE=0, ST_STARTUP=1, ST_SEARCH=2, ST_PUSH_BORDER=3,
                     ST_WAIT_COMP=4, ST_FILL=5, ST_SPLIT=6, ST_QUEUE_FLUSH=7,
                     ST_QUEUE_ALL=8, ST_ADVANCE=9, ST_ADVANCE2=10, ST_FINISHED=11;

    // ── Parameters ────────────────────────────────────────────────────────────
    localparam int DONE_DELAY = 3;   // cycles after last border pixel before complete fires
    localparam int TIMEOUT    = 20000;
    localparam int MAX_FILLS  = 512;

    // ── DUT signals ───────────────────────────────────────────────────────────
    logic        rst, start;
    logic        engine_done;

    // Config (unused by algorithm)
    logic [4:0]  equation_id = '0;
    logic [31:0] centre_x = '0, centre_y = '0, zoom_level = '0;
    logic [11:0] max_iter = '0;
    logic [9:0]  x_offset = '0, y_offset = '0;

    // Job queue
    logic [17:0] sched_coord;
    logic        sched_push;
    logic        sched_stall;
    logic        flush;

    // Comparator config (output from DUT)
    logic        sched_reset;
    logic [8:0]  top_left_x, top_left_y, quad_size;
    logic [10:0] expected_count;

    // Comparator results (input to DUT - driven by fake comparator)
    logic        differ;
    logic        complete;
    logic [5:0]  ref_colour_o;

    // Tile table
    logic        tt_wr_quad_en;
    logic [7:0]  tt_wr_quad_tlx, tt_wr_quad_tly, tt_wr_quad_size;
    logic [5:0]  tt_wr_quad_colour;

    // Tile done
    logic [255:0] sched_tile_done_set;

    // ── DUT instantiation ─────────────────────────────────────────────────────
    scheduler dut (
        .clk                (clk),
        .rst                (rst),
        .start              (start),
        .engine_done        (engine_done),
        .equation_id        (equation_id),
        .centre_x           (centre_x),
        .centre_y           (centre_y),
        .zoom_level         (zoom_level),
        .max_iter           (max_iter),
        .x_offset           (x_offset),
        .y_offset           (y_offset),
        .sched_coord        (sched_coord),
        .sched_push         (sched_push),
        .sched_stall        (sched_stall),
        .flush              (flush),
        .sched_reset        (sched_reset),
        .top_left_x         (top_left_x),
        .top_left_y         (top_left_y),
        .quad_size          (quad_size),
        .expected_count     (expected_count),
        .differ             (differ),
        .complete           (complete),
        .ref_colour_o       (ref_colour_o),
        .tt_wr_quad_en      (tt_wr_quad_en),
        .tt_wr_quad_tlx     (tt_wr_quad_tlx),
        .tt_wr_quad_tly     (tt_wr_quad_tly),
        .tt_wr_quad_size    (tt_wr_quad_size),
        .tt_wr_quad_colour  (tt_wr_quad_colour),
        .sched_tile_done_set(sched_tile_done_set)
    );

    // ── Synthetic image ───────────────────────────────────────────────────────
    logic [5:0] image [0:255][0:255];   // image[y][x]

    // ── Coverage and duplicate tracking ──────────────────────────────────────
    bit covered [0:255][0:255];
    bit queued  [0:255][0:255];
    int dup_count;

    // ── Fill log ─────────────────────────────────────────────────────────────
    int                fill_x   [0:MAX_FILLS-1];
    int                fill_y   [0:MAX_FILLS-1];
    int                fill_sz  [0:MAX_FILLS-1];
    logic [5:0]        fill_col [0:MAX_FILLS-1];
    logic [255:0]      fill_tile_done [0:MAX_FILLS-1];
    int                fill_count;
    int                bad_fill_count;  // fills with wrong colour in image

    // ── Flush log ─────────────────────────────────────────────────────────────
    int flush_count;
    int flush_times [0:63];

    // ── Stall test tracking ───────────────────────────────────────────────────
    int stall_push_gap;     // cycles between pushes during stall
    int pushes_during_stall;

    // ── Fake comparator state ─────────────────────────────────────────────────
    logic        comp_armed;
    logic [5:0]  comp_ref;
    int          comp_seen;
    logic        comp_differ_latched;
    int          comp_countdown;
    logic        prev_sched_reset;

    initial begin
        differ       = 1'b0;
        complete     = 1'b0;
        ref_colour_o = '0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            differ              <= 1'b0;
            complete            <= 1'b0;
            ref_colour_o        <= '0;
            comp_armed          <= 1'b0;
            comp_ref            <= '0;
            comp_seen           <= 0;
            comp_differ_latched <= 1'b0;
            comp_countdown      <= 0;
            prev_sched_reset    <= 1'b0;
        end else begin
            prev_sched_reset <= sched_reset;

            // De-assert complete after one cycle
            if (complete)
                complete <= 1'b0;

            // Rising edge of sched_reset = new box scan
            if (sched_reset && !prev_sched_reset) begin
                differ              <= 1'b0;
                complete            <= 1'b0;
                comp_armed          <= 1'b1;
                comp_ref            <= '0;
                comp_seen           <= 0;
                comp_differ_latched <= 1'b0;
                comp_countdown      <= 0;
            end

            // Process pushed border pixels
            if (sched_push && comp_armed && !comp_differ_latched) begin : comp_check
                logic [5:0] pix;
                int px, py;
                px  = int'(sched_coord[8:0]);
                py  = int'(sched_coord[17:9]);
                pix = image[py][px];
                if (comp_seen == 0) begin
                    comp_ref     <= pix;
                    ref_colour_o <= pix;
                    comp_seen    <= 1;
                end else if (pix !== comp_ref) begin
                    comp_differ_latched <= 1'b1;
                    differ              <= 1'b1;
                end else begin
                    comp_seen <= comp_seen + 1;
                end
            end

            // When all expected pixels are seen and uniform, start countdown to complete
            if (comp_armed && !comp_differ_latched
                    && comp_seen == int'(expected_count)
                    && comp_countdown == 0
                    && comp_seen > 0) begin
                comp_countdown <= DONE_DELAY;
            end

            if (comp_countdown > 0) begin
                comp_countdown <= comp_countdown - 1;
                if (comp_countdown == 1) begin
                    complete   <= 1'b1;
                    comp_armed <= 1'b0;
                end
            end
        end
    end

    // ── Job-queue push monitor ─────────────────────────────────────────────
    always @(posedge clk) begin
        if (flush) begin
            for (int cy = 0; cy < 256; cy++)
                for (int cx = 0; cx < 256; cx++)
                    queued[cy][cx] = 0;
        end
        if (sched_push) begin
            int px, py;
            px = int'(sched_coord[8:0]);
            py = int'(sched_coord[17:9]);
            if (px >= 0 && px < 256 && py >= 0 && py < 256) begin
                if (queued[py][px]) begin
                    dup_count = dup_count + 1;
                    $display("  [DUP] t=%0t pixel (%0d,%0d) pushed again  depth=%0d sz=%0d",
                        $time, px, py, dut.cur_depth, dut.cur_sz);
                end
                queued[py][px]  = 1;
                covered[py][px] = 1;
            end
        end
    end

    // ── Fill monitor ───────────────────────────────────────────────────────
    always @(posedge clk) begin
        if (tt_wr_quad_en) begin : fill_mon
            int tx, ty, tsz;
            tx  = int'(tt_wr_quad_tlx);
            ty  = int'(tt_wr_quad_tly);
            tsz = int'(tt_wr_quad_size);  // inclusive offset = sz-1
            $display("  [FILL] t=%0t  tlx=%3d tly=%3d size=%3d (%0dx%0d) col=%0d  tile_done=%h",
                $time, tx, ty, tsz, tsz+1, tsz+1, tt_wr_quad_colour, sched_tile_done_set);
            if (fill_count < MAX_FILLS) begin
                fill_x        [fill_count] = tx;
                fill_y        [fill_count] = ty;
                fill_sz       [fill_count] = tsz;
                fill_col      [fill_count] = tt_wr_quad_colour;
                fill_tile_done[fill_count] = sched_tile_done_set;
                fill_count = fill_count + 1;
            end
            // Verify fill colour matches image
            for (int fy = ty; fy <= ty + tsz && fy < 256; fy++)
                for (int fx = tx; fx <= tx + tsz && fx < 256; fx++) begin
                    if (image[fy][fx] !== tt_wr_quad_colour)
                        bad_fill_count = bad_fill_count + 1;
                    covered[fy][fx] = 1;
                end
        end
    end

    // ── Flush monitor ─────────────────────────────────────────────────────
    always @(posedge clk) begin
        if (flush && flush_count < 64) begin
            $display("  [FLUSH] t=%0t  state=%s  depth=%0d  cur_box=(%0d,%0d) sz=%0d",
                $time, dut.state.name(), dut.cur_depth, dut.cur_tlx, dut.cur_tly, dut.cur_sz);
            flush_times[flush_count] = $time;
            flush_count = flush_count + 1;
        end
    end

    // ── Continuous state monitor ──────────────────────────────────────────
    logic prev_sched_push;
    logic prev_tt_wr_quad_en;
    logic prev_engine_done;
    
    always @(posedge clk) begin
        #1;
        if (int'(dut.state) != ST_IDLE && !rst) begin
            $display("  t=%5t  %-12s  depth=%0d sz=%3d  box=(%3d,%3d)  b_phase=%0d b_cnt=%3d  push=%b stall=%b differ=%b complete=%b  split_cnt=%0d",
                $time,
                dut.state.name(),
                dut.cur_depth,
                dut.cur_sz,
                dut.cur_tlx,
                dut.cur_tly,
                dut.b_phase,
                dut.b_cnt,
                sched_push,
                sched_stall,
                differ,
                complete,
                dut.split_cnt);
        end
        prev_sched_push     = sched_push;
        prev_tt_wr_quad_en  = tt_wr_quad_en;
        prev_engine_done    = engine_done;
    end

    // ── Helpers ───────────────────────────────────────────────────────────
    task automatic fill_rect(input int x0, y0, w, h, input logic [5:0] col);
        for (int iy = y0; iy < y0+h; iy++)
            for (int ix = x0; ix < x0+w; ix++)
                image[iy][ix] = col;
    endtask

    task automatic set_pixel(input int x, y, input logic [5:0] col);
        image[y][x] = col;
    endtask

    task automatic clear_tracking();
        for (int iy = 0; iy < 256; iy++)
            for (int ix = 0; ix < 256; ix++) begin
                covered[iy][ix] = 0;
                queued [iy][ix] = 0;
            end
        dup_count      = 0;
        fill_count     = 0;
        bad_fill_count = 0;
        flush_count    = 0;
    endtask

    function automatic int count_covered(input int x0, y0, w, h);
        int n = 0;
        for (int iy = y0; iy < y0+h; iy++)
            for (int ix = x0; ix < x0+w; ix++)
                if (covered[iy][ix]) n++;
        return n;
    endfunction

    function automatic int count_queued(input int x0, y0, w, h);
        int n = 0;
        for (int iy = y0; iy < y0+h; iy++)
            for (int ix = x0; ix < x0+w; ix++)
                if (queued[iy][ix]) n++;
        return n;
    endfunction

    function automatic int find_fill(input int tx, ty, tsz);
        for (int i = 0; i < fill_count; i++)
            if (fill_x[i] == tx && fill_y[i] == ty && fill_sz[i] == tsz)
                return i;
        return -1;
    endfunction

    task automatic do_reset_start();
        rst=1; start=0;
        sched_stall = 0;
        tick(2); rst=0; tick(1);
        start=1; tick(1); start=0;
    endtask

    task automatic wait_done(output logic timed_out);
        timed_out = 0;
        begin : wait_loop
            int i;
            for (i = 0; i < TIMEOUT; i++) begin
                if (engine_done) disable wait_loop;
                tick(1);
            end
            timed_out = 1;
        end
    endtask

    // ── Module-level vars ─────────────────────────────────────────────────
    logic timed_out;
    int   fi;

    // ══════════════════════════════════════════════════════════════════════
    initial begin
        $dumpfile("sim/waves/tb_scheduler.vcd");
        $dumpvars(0, tb_scheduler);

        rst=1; start=0; sched_stall=0;
        differ=0; complete=0; ref_colour_o=0;
        tick(4); rst=0; tick(1);

        // ══════════════════════════════════════════════════════════════════
        // TC1 — Uniform 256x256 image colour=5
        //        Expected: single FILL at (0,0) sz=255
        //                  sched_tile_done_set = 256'hFFFF...FFFF
        //                  engine_done after 1 fill
        // ══════════════════════════════════════════════════════════════════
        suite("TC1 - uniform 256x256 colour=5");
        fill_rect(0, 0, 256, 256, 6'd5);
        clear_tracking();
        do_reset_start();
        wait_done(timed_out);

        check(!timed_out,            "engine_done received before timeout");
        check(fill_count == 1,       $sformatf("exactly 1 fill (got %0d)", fill_count));
        check(bad_fill_count == 0,   "no fill wrote wrong colour");
        check(dup_count == 0,        "no pixel queued twice");

        fi = find_fill(0, 0, 255);
        check(fi >= 0, "fill at (0,0) sz=255 exists");
        if (fi >= 0) begin
            check(fill_col[fi] === 6'd5, $sformatf("fill colour=5 (got %0d)", fill_col[fi]));
            check(fill_tile_done[fi] === 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
                "sched_tile_done_set all bits set for 256x256 fill");
        end

        check(count_covered(0, 0, 256, 256) == 65536,
            $sformatf("all 65536 pixels covered (got %0d)", count_covered(0, 0, 256, 256)));
        $display("  [INFO] fills=%0d  flushes=%0d  covered=%0d/65536",
            fill_count, flush_count, count_covered(0, 0, 256, 256));

        // ══════════════════════════════════════════════════════════════════
        // TC2 — Single impurity at (96,0), descent to depth=4
        //
        // Impurity is on the top row of multiple boxes.
        // Expected descent path:
        //   depth=0 (0,0)sz=256  → differ  → SPLIT
        //   depth=1 TL(0,0)sz=128 → differ → SPLIT
        //   depth=2 TL(0,0)sz=64  → FILL (0,0)sz=63
        //   depth=2 TR(64,0)sz=64 → differ → SPLIT
        //   depth=3 TL(64,0)sz=32 → FILL (64,0)sz=31
        //   depth=3 TR(96,0)sz=32 → differ → SPLIT
        //   depth=4 TL(96,0)sz=16 → differ → QUEUE_ALL (256 pixels)
        //   depth=4 TR(112,0)sz=16 → FILL (112,0)sz=15
        //   depth=4 BL(96,16)sz=16 → FILL (96,16)sz=15
        //   depth=4 BR(112,16)sz=16 → FILL (112,16)sz=15
        //   depth=3 BL(64,32)sz=32 → FILL (64,32)sz=31
        //   depth=3 BR(96,32)sz=32 → FILL (96,32)sz=31
        //   depth=2 BL(0,64)sz=64  → FILL (0,64)sz=63
        //   depth=2 BR(64,64)sz=64 → FILL (64,64)sz=63
        //   depth=1 TR(128,0)sz=128 → FILL (128,0)sz=127
        //   depth=1 BL(0,128)sz=128 → FILL (0,128)sz=127
        //   depth=1 BR(128,128)sz=128 → FILL (128,128)sz=127
        //   Total: 12 fills, 1 QUEUE_ALL at (96,0) covering 256 pixels
        // ══════════════════════════════════════════════════════════════════
        suite("TC2 - impurity at (96,0), descent to depth=4");
        fill_rect(0, 0, 256, 256, 6'd5);
        set_pixel(96, 0, 6'd10);
        clear_tracking();
        do_reset_start();
        wait_done(timed_out);

        check(!timed_out,            "engine_done received before timeout");
        check(bad_fill_count == 0,   "no fill wrote wrong colour");
        check(dup_count == 0,        "no pixel queued twice");
        check(fill_count == 12,      $sformatf("12 fills (got %0d)", fill_count));
        // covered[] persists across flushes; queued[] is reset per-flush window
        check(count_covered(96, 0, 16, 16) == 256,
            $sformatf("QUEUE_ALL covered all 256 pixels at tile (96,0) (got %0d)",
                count_covered(96, 0, 16, 16)));

        // Check all expected fills exist
        fi = find_fill(0, 0, 63);    check(fi >= 0, "fill (0,0) sz=63");
        fi = find_fill(64, 0, 31);   check(fi >= 0, "fill (64,0) sz=31");
        fi = find_fill(112, 0, 15);  check(fi >= 0, "fill (112,0) sz=15");
        fi = find_fill(96, 16, 15);  check(fi >= 0, "fill (96,16) sz=15");
        fi = find_fill(112, 16, 15); check(fi >= 0, "fill (112,16) sz=15");
        fi = find_fill(64, 32, 31);  check(fi >= 0, "fill (64,32) sz=31");
        fi = find_fill(96, 32, 31);  check(fi >= 0, "fill (96,32) sz=31");
        fi = find_fill(0, 64, 63);   check(fi >= 0, "fill (0,64) sz=63");
        fi = find_fill(64, 64, 63);  check(fi >= 0, "fill (64,64) sz=63");
        fi = find_fill(128, 0, 127); check(fi >= 0, "fill (128,0) sz=127");
        fi = find_fill(0, 128, 127); check(fi >= 0, "fill (0,128) sz=127");
        fi = find_fill(128, 128, 127); check(fi >= 0, "fill (128,128) sz=127");

        check(count_covered(0, 0, 256, 256) == 65536,
            $sformatf("all 65536 pixels covered (got %0d)", count_covered(0, 0, 256, 256)));

        $display("  [INFO] fills=%0d  flushes=%0d  covered_tile_96_0=%0d  covered=%0d/65536",
            fill_count, flush_count, count_covered(96, 0, 16, 16),
            count_covered(0, 0, 256, 256));

        // ══════════════════════════════════════════════════════════════════
        // TC3 — sched_tile_done_set bit verification
        //        Uniform image: fill at (0,0) sz=255 → all 256 bits set
        //        Partial fill at depth=2 (sz=64): verify only 16 bits set
        // ══════════════════════════════════════════════════════════════════
        suite("TC3 - sched_tile_done_set correctness");
        // Verify TC2 fill at (0,0) sz=63 (depth=2) has 4x4=16 tile bits set
        fi = find_fill(0, 0, 63);
        if (fi >= 0) begin : check_td_d2
            logic [255:0] expected_td;
            // tiles (0..3, 0..3) in 16x16 grid
            expected_td = '0;
            for (int ty2 = 0; ty2 < 4; ty2++)
                for (int tx2 = 0; tx2 < 4; tx2++)
                    expected_td[ty2*16 + tx2] = 1'b1;
            check(fill_tile_done[fi] === expected_td,
                $sformatf("fill (0,0)sz=63 tile_done has 4x4=16 bits set (got %h)",
                    fill_tile_done[fi]));
        end

        // Verify fill at (64,0) sz=31 (depth=3) has 2x2=4 tile bits set
        fi = find_fill(64, 0, 31);
        if (fi >= 0) begin : check_td_d3
            logic [255:0] expected_td;
            // tiles (4..5, 0..1) 
            expected_td = '0;
            for (int ty2 = 0; ty2 < 2; ty2++)
                for (int tx2 = 0; tx2 < 2; tx2++)
                    expected_td[ty2*16 + (4 + tx2)] = 1'b1;
            check(fill_tile_done[fi] === expected_td,
                $sformatf("fill (64,0)sz=31 tile_done has 2x2=4 bits set (got %h)",
                    fill_tile_done[fi]));
        end

        // Verify fill at (112,0) sz=15 (depth=4) has exactly 1 tile bit set
        fi = find_fill(112, 0, 15);
        if (fi >= 0) begin : check_td_d4
            // tile (112/16=7, 0/16=0) = index 0*16+7 = 7
            logic [255:0] expected_td;
            expected_td = '0;
            expected_td[7] = 1'b1;
            check(fill_tile_done[fi] === expected_td,
                $sformatf("fill (112,0)sz=15 tile_done bit 7 only (got %h)",
                    fill_tile_done[fi]));
        end

        // Verify TC1 fill: all 256 tile bits set
        // Re-run TC1 briefly to capture fresh fill_tile_done
        fill_rect(0, 0, 256, 256, 6'd7);
        clear_tracking();
        do_reset_start();
        wait_done(timed_out);
        fi = find_fill(0, 0, 255);
        if (fi >= 0) begin
            check(fill_tile_done[fi] === {256{1'b1}},
                "fill (0,0)sz=255 tile_done all 256 bits set");
        end

        // ══════════════════════════════════════════════════════════════════
        // TC4 — QUEUE_ALL pushes exactly 256 pixels at leaf level
        //        Impurity in TL tile forces QUEUE_ALL
        // ══════════════════════════════════════════════════════════════════
        suite("TC4 - QUEUE_ALL pushes exactly 256 unique pixels");
        fill_rect(0, 0, 256, 256, 6'd3);
        set_pixel(0, 0, 6'd1);   // impurity in TL tile (0,0..15 x 0,0..15)
        clear_tracking();
        do_reset_start();
        wait_done(timed_out);

        check(!timed_out, "engine_done before timeout");
        // covered[] accumulates all pushes regardless of flush
        check(count_covered(0, 0, 16, 16) == 256,
            $sformatf("QUEUE_ALL covered all 256 pixels in tile (0,0) (got %0d)",
                count_covered(0, 0, 16, 16)));
        check(dup_count == 0, "no pixel queued twice within a flush window");

        $display("  [INFO] covered_tile_0_0=%0d  fills=%0d",
            count_covered(0, 0, 16, 16), fill_count);

        // ══════════════════════════════════════════════════════════════════
        // TC5 — sched_stall pauses border push
        //        Stall for 5 cycles mid-push, verify no pixels pushed during stall
        // ══════════════════════════════════════════════════════════════════
        suite("TC5 - sched_stall halts border pixel push");
        fill_rect(0, 0, 256, 256, 6'd9);
        clear_tracking();
        pushes_during_stall = 0;
        do_reset_start();

        // Wait until scheduler is in PUSH_BORDER and has started pushing
        begin : stall_wait
            int i;
            for (i = 0; i < 200; i++) begin
                if (int'(dut.state) == ST_PUSH_BORDER && sched_push) disable stall_wait;
                tick(1);
            end
        end

        // Assert stall for 5 cycles, count any pushes that slip through
        sched_stall = 1;
        begin : stall_count
            int i;
            int prev_coord;
            prev_coord = sched_coord;
            for (i = 0; i < 5; i++) begin
                tick(1);
                if (sched_push) pushes_during_stall++;
            end
        end
        sched_stall = 0;

        wait_done(timed_out);

        check(!timed_out,                "engine_done after stall");
        check(pushes_during_stall == 0,  "no pixels pushed while sched_stall=1");
        check(bad_fill_count == 0,       "no fill with wrong colour after stall");
        $display("  [INFO] pushes_during_stall=%0d  fills=%0d",
            pushes_during_stall, fill_count);

        // ══════════════════════════════════════════════════════════════════
        // TC6 — Flush fired in correct states
        //        flush must fire in SEARCH and in SPLIT states
        //        flush must NOT fire in PUSH_BORDER or WAIT_COMP
        // ══════════════════════════════════════════════════════════════════
        suite("TC6 - flush fires in SEARCH and SPLIT, not elsewhere");
        fill_rect(0, 0, 256, 256, 6'd5);
        set_pixel(96, 0, 6'd10);   // same as TC2 - causes splits
        clear_tracking();

        // Track which states flush fires in
        begin : flush_state_check
            int flush_in_search = 0;
            int flush_in_split  = 0;
            int flush_in_push   = 0;
            int flush_in_wait   = 0;
            int flush_in_queue_flush = 0;

            // Fork a background monitor
            fork
                begin : flush_mon_fork
                    forever @(posedge clk) begin
                        #1;
                        if (flush) begin
                            case (int'(dut.state))
                                ST_SEARCH:      flush_in_search++;
                                ST_SPLIT:       flush_in_split++;
                                ST_PUSH_BORDER: flush_in_push++;
                                ST_WAIT_COMP:   flush_in_wait++;
                                ST_QUEUE_FLUSH: flush_in_queue_flush++;
                            endcase
                        end
                    end
                end
                begin
                    do_reset_start();
                    wait_done(timed_out);
                    disable flush_mon_fork;
                end
            join

            check(!timed_out,          "engine_done before timeout (TC6)");
            check(flush_in_search > 0, $sformatf("flush fired in SEARCH (%0d times)", flush_in_search));
            check(flush_in_split > 0,  $sformatf("flush fired in SPLIT (%0d times)", flush_in_split));
            check(flush_in_push == 0,  $sformatf("flush never fired in PUSH_BORDER (got %0d)", flush_in_push));
            check(flush_in_wait == 0,  $sformatf("flush never fired in WAIT_COMP (got %0d)", flush_in_wait));
            $display("  [INFO] flush counts: SEARCH=%0d SPLIT=%0d PUSH_BORDER=%0d WAIT_COMP=%0d QUEUE_FLUSH=%0d",
                flush_in_search, flush_in_split, flush_in_push, flush_in_wait, flush_in_queue_flush);
        end

        // ══════════════════════════════════════════════════════════════════
        // TC7 — Full coverage: all pixels covered by fills + QUEUE_ALL
        //        Two impurities in different quadrants
        // ══════════════════════════════════════════════════════════════════
        suite("TC7 - two impurities, full 65536-pixel coverage");
        fill_rect(0, 0, 256, 256, 6'd5);
        set_pixel(96, 0, 6'd10);     // impurity in top-left region
        set_pixel(160, 128, 6'd11);  // impurity in BR region (on border of depth=1 BR box)
        clear_tracking();
        do_reset_start();
        wait_done(timed_out);

        check(!timed_out, "engine_done before timeout");
        check(bad_fill_count == 0, "no fill with wrong colour");
        check(dup_count == 0,      "no pixel queued twice");
        check(count_covered(0, 0, 256, 256) == 65536,
            $sformatf("all 65536 pixels covered (got %0d)",
                count_covered(0, 0, 256, 256)));
        $display("  [INFO] fills=%0d  flushes=%0d  covered=%0d/65536",
            fill_count, flush_count, count_covered(0, 0, 256, 256));

        // ══════════════════════════════════════════════════════════════════
        summary();
        $finish;
    end

    // ── Watchdog ──────────────────────────────────────────────────────────
    initial begin
        #100_000_000;
        $display("\n[TIMEOUT] simulation exceeded hard limit");
        $finish;
    end

endmodule
