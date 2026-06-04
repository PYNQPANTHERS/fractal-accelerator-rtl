// tb_scheduler.sv
// Testbench for scheduler.sv
//
// Simulates a 256x256 Mandelbrot section using a pre-calculated synthetic
// image array. A fake comparator monitors job_queue_push, reads pixel colours
// from the image, and drives comparator_flag_so_far / comparator_flag_done as
// the real hardware would: flag_so_far drops immediately on a differing pixel;
// flag_done pulses for one cycle exactly DONE_DELAY cycles after the last
// border pixel when the border was uniform throughout.
//
// Test cases
// ----------
//   TC1  Entire 256x256 image uniform colour 3.
//        -> single FILL_BOX (0,0) size=256 colour=3.  No pixel pushes.
//
//   TC2  Mostly colour 5; (128,0) forces zoom-0 differ/descend.
//        (64,0) forces zoom-1 box-00 to differ again.
//        All remaining box borders are uniform colour 5.
//        -> several flood-fills covering all 65536 pixels.
//
//   TC3  Impurity chain (128,0)(64,0)(32,0)(16,0) forces descent to zoom=4.
//        zoom-4 box-00 (0,0)-(15,15): uniform colour 2  -> flood-fill.
//        zoom-4 box-01 (16,0)-(32,15): mixed interior   -> pixels queued.
//        All other boxes uniform colour 2.
//
// Compile (add hdl/scheduler to HDL_DIRS in Makefile first):
//   make TB=tb/scheduler/tb_scheduler.sv

`timescale 1ns/1ps

module tb_scheduler;

    // ── test infrastructure ───────────────────────────────────────────────
    int tests_run    = 0;
    int tests_passed = 0;
    int tests_failed = 0;
    string current_suite = "";

    task automatic suite(input string name);
        current_suite = name;
        $display("\n%0s", {72{"="}});
        $display("  SUITE: %s", name);
        $display("%0s", {72{"="}});
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
        $display("\n%0s", {72{"="}});
        $display("  RESULTS: %0d / %0d passed", tests_passed, tests_run);
        if (tests_failed == 0)
            $display("  ALL TESTS PASSED");
        else
            $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%0s\n", {72{"="}});
    endtask

    // ── clock ─────────────────────────────────────────────────────────────
    localparam int CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;

    task automatic tick(input int n = 1);
        repeat(n) @(posedge clk);
        #1;
    endtask

    // ── parameters ────────────────────────────────────────────────────────
    localparam int N            = 10;
    localparam int Z            = 3;
    localparam int COLOUR_WIDTH = 4;
    localparam int DONE_DELAY   = 5;   // cycles after last border pixel
    localparam int TIMEOUT      = 200000;
    localparam int MAX_FILLS    = 256;

    // ── DUT signals ───────────────────────────────────────────────────────
    logic                    rst, start;
    logic                    comparator_flag_so_far;
    logic                    comparator_flag_done;
    logic [COLOUR_WIDTH-1:0] comparator_colour;
    logic                    engine_done;
    logic [8:0]              jq_x_coord_to_queue;
    logic [8:0]              jq_y_coord_to_queue;
    logic                    job_queue_push;
    logic                    job_queue_flush;
    logic                    tt_wr_quad_en;
    logic [7:0]              tt_wr_quad_tlx;
    logic [7:0]              tt_wr_quad_tly;
    logic [7:0]              tt_wr_quad_size;
    logic [COLOUR_WIDTH-1:0] tt_wr_quad_colour;

    scheduler #(.N(N), .Z(Z), .COLOUR_WIDTH(COLOUR_WIDTH)) dut (
        .clk                    (clk),
        .rst                    (rst),
        .start                  (start),
        .comparator_flag_so_far (comparator_flag_so_far),
        .comparator_flag_done   (comparator_flag_done),
        .comparator_colour      (comparator_colour),
        .engine_done            (engine_done),
        .jq_x_coord_to_queue    (jq_x_coord_to_queue),
        .jq_y_coord_to_queue    (jq_y_coord_to_queue),
        .job_queue_push         (job_queue_push),
        .job_queue_flush        (job_queue_flush),
        .tt_wr_quad_en          (tt_wr_quad_en),
        .tt_wr_quad_tlx         (tt_wr_quad_tlx),
        .tt_wr_quad_tly         (tt_wr_quad_tly),
        .tt_wr_quad_size        (tt_wr_quad_size),
        .tt_wr_quad_colour      (tt_wr_quad_colour)
    );

    // ── synthetic image ───────────────────────────────────────────────────
    logic [COLOUR_WIDTH-1:0] image [0:255][0:255];   // image[y][x]

    // ── coverage and duplicate tracking ──────────────────────────────────
    bit covered [0:255][0:255];   // pixel reached by push or flood-fill
    bit queued  [0:255][0:255];   // set on first individual push
    int dup_count;                // incremented when queued[][] already set

    // ── flood-fill log (parallel static arrays) ───────────────────────────
    int                      fill_x   [0:MAX_FILLS-1];
    int                      fill_y   [0:MAX_FILLS-1];
    int                      fill_sz  [0:MAX_FILLS-1];
    logic [COLOUR_WIDTH-1:0] fill_col [0:MAX_FILLS-1];
    int fill_count;
    int bad_fill_count;   // pixels inside a fill whose image colour mismatches

    // ── fake comparator state (driven by always block) ────────────────────
    logic                    comp_armed;        // 1 while a scan is in progress
    logic                    comp_uniform;      // 1 while no differ seen
    logic                    comp_first;        // 1 until first pixel of scan
    logic [COLOUR_WIDTH-1:0] comp_ref;          // reference colour for scan
    int                      comp_countdown;    // done-delay counter
    logic                    comp_counting;     // 1 while countdown active
    logic                    prev_gen_rst;      // edge-detect for generator reset

    // Fake comparator: reacts each clock to push events and scan boundaries.
    // Mirrors real comparator behaviour: flag_so_far drops immediately on a
    // differing pixel; flag_done pulses DONE_DELAY cycles after the last pixel
    // when the scan was uniform throughout.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            comparator_flag_so_far <= 1'b1;
            comparator_flag_done   <= 1'b0;
            comparator_colour      <= '0;
            comp_ref               <= '0;
            comp_armed             <= 1'b0;
            comp_uniform           <= 1'b1;
            comp_first             <= 1'b1;
            comp_countdown         <= 0;
            comp_counting          <= 1'b0;
            prev_gen_rst           <= 1'b0;
        end else begin
            prev_gen_rst <= dut.pixel_generator_reset;

            // Auto-clear flag_done after one cycle
            if (comparator_flag_done)
                comparator_flag_done <= 1'b0;

            // Rising edge of pixel_generator_reset = new scan starting
            if (dut.pixel_generator_reset && !prev_gen_rst) begin
                comparator_flag_so_far <= 1'b1;
                comparator_flag_done   <= 1'b0;
                comp_armed             <= 1'b1;
                comp_uniform           <= 1'b1;
                comp_first             <= 1'b1;
                comp_countdown         <= 0;
                comp_counting          <= 1'b0;
            end

            // Flush clears comparator state
            if (job_queue_flush) begin
                comparator_flag_so_far <= 1'b1;
                comparator_flag_done   <= 1'b0;
                comp_armed             <= 1'b0;
                comp_uniform           <= 1'b1;
                comp_first             <= 1'b1;
                comp_countdown         <= 0;
                comp_counting          <= 1'b0;
            end

            // Incoming border pixel
            if (job_queue_push && comp_armed && !job_queue_flush) begin : comp_pix
                logic [COLOUR_WIDTH-1:0] pix;
                int px, py;
                px  = int'(jq_x_coord_to_queue);
                py  = int'(jq_y_coord_to_queue);
                pix = image[py][px];
                if (comp_first) begin
                    comp_ref               <= pix;
                    comparator_colour      <= pix;
                    comp_first             <= 1'b0;
                end else if (comp_uniform && pix !== comp_ref) begin
                    comp_uniform           <= 1'b0;
                    comparator_flag_so_far <= 1'b0;
                end
            end

            // border_pixel_chooser done: start delay countdown (uniform only)
            if (dut.border_pixel_chooser_done && comp_armed
                    && comp_uniform && !comp_counting) begin
                comp_counting  <= 1'b1;
                comp_countdown <= DONE_DELAY;
            end

            // Tick down the done delay
            if (comp_counting && comp_countdown > 0) begin
                comp_countdown <= comp_countdown - 1;
                if (comp_countdown == 1) begin
                    comparator_flag_done <= 1'b1;
                    comp_counting        <= 1'b0;
                    comp_armed           <= 1'b0;
                end
            end
        end
    end

    // ── job-queue push monitor ────────────────────────────────────────────
    always @(posedge clk) begin
        if (job_queue_flush) begin : flush_mon
            int cy, cx;
            for (cy = 0; cy < 256; cy++)
                for (cx = 0; cx < 256; cx++)
                    queued[cy][cx] = 0;
            dup_count = 0;
        end else if (job_queue_push) begin : push_mon
            int px, py;
            px = int'(jq_x_coord_to_queue);
            py = int'(jq_y_coord_to_queue);
            if (px >= 0 && px < 256 && py >= 0 && py < 256) begin
                if (queued[py][px]) dup_count = dup_count + 1;
                queued [py][px] = 1;
                covered[py][px] = 1;
            end
        end
    end

    // ── flood-fill monitor ────────────────────────────────────────────────
    always @(posedge clk) begin
        if (tt_wr_quad_en) begin : fill_mon
            int tx, ty, tsz, fy, fx;
            tx  = int'(tt_wr_quad_tlx);
            ty  = int'(tt_wr_quad_tly);
            tsz = int'(tt_wr_quad_size);
            if (fill_count < MAX_FILLS) begin
                fill_x  [fill_count] = tx;
                fill_y  [fill_count] = ty;
                fill_sz [fill_count] = tsz;
                fill_col[fill_count] = tt_wr_quad_colour;
                fill_count = fill_count + 1;
            end
            for (fy = ty; fy < ty + tsz && fy < 256; fy++)
                for (fx = tx; fx < tx + tsz && fx < 256; fx++) begin
                    if (image[fy][fx] !== tt_wr_quad_colour)
                        bad_fill_count = bad_fill_count + 1;
                    covered[fy][fx] = 1;
                end
        end
    end

    // ── image / tracking helpers ──────────────────────────────────────────
    task automatic fill_rect(input int x0, y0, w, h,
                              input logic [COLOUR_WIDTH-1:0] col);
        for (int iy = y0; iy < y0+h; iy++)
            for (int ix = x0; ix < x0+w; ix++)
                image[iy][ix] = col;
    endtask

    task automatic set_pixel(input int x, y,
                              input logic [COLOUR_WIDTH-1:0] col);
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
    endtask

    // Count covered pixels inside a rectangle
    function automatic int count_covered(input int x0, y0, w, h);
        int n;
        n = 0;
        for (int iy = y0; iy < y0+h; iy++)
            for (int ix = x0; ix < x0+w; ix++)
                if (covered[iy][ix]) n++;
        return n;
    endfunction

    // Count individually-queued pixels inside a rectangle
    function automatic int count_queued(input int x0, y0, w, h);
        int n;
        n = 0;
        for (int iy = y0; iy < y0+h; iy++)
            for (int ix = x0; ix < x0+w; ix++)
                if (queued[iy][ix]) n++;
        return n;
    endfunction

    // Find a fill-log entry by position and size; returns index or -1
    function automatic int find_fill(input int tx, ty, tsz);
        for (int i = 0; i < fill_count; i++)
            if (fill_x[i] == tx && fill_y[i] == ty && fill_sz[i] == tsz)
                return i;
        return -1;
    endfunction

    // Reset DUT: rst high on tick 1, rst low + start high on tick 2
    task automatic sched_reset_start();
        rst=1; start=0; tick(1);
        rst=0; start=1; tick(1);
        start=0;
    endtask

    // Spin until engine_done or TIMEOUT cycles; sets timed_out flag
    task automatic wait_done(output logic timed_out);
        timed_out = 0;
        begin : wait_loop
            int i;
            for (i = 0; i < TIMEOUT; i = i + 1) begin
                if (engine_done) disable wait_loop;
                tick(1);
            end
            timed_out = 1;
        end
    endtask

    // ── module-level vars used across suites ──────────────────────────────
    logic timed_out;
    int   fi;

    // ═════════════════════════════════════════════════════════════════════
    initial begin
        $dumpfile("sim/waves/tb_scheduler.vcd");
        $dumpvars(0, tb_scheduler);

        // Initialise DUT inputs and give reset time to settle
        rst=1; start=0;
        comparator_flag_so_far=1; comparator_flag_done=0;
        comparator_colour='0;
        tick(4); rst=0; tick(1);

        // ═════════════════════════════════════════════════════════════════
        // TC1 – Entire 256x256 image uniform colour 3
        // Expected: exactly one FILL_BOX (0,0) size=256 colour=3
        // ═════════════════════════════════════════════════════════════════

        suite("TC1 - uniform 256x256 image");
        fill_rect(0, 0, 256, 256, 4'h3);
        clear_tracking();
        sched_reset_start();
        wait_done(timed_out);

        check(!timed_out,
            "engine_done received before timeout");
        check(bad_fill_count == 0,
            "no fill wrote pixels with wrong colour");
        check(dup_count == 0,
            "no pixel pushed more than once");
        check(count_queued(0, 0, 256, 256) == 0,
            "no pixels individually queued for uniform image");
        check(fill_count == 1,
            $sformatf("exactly one flood-fill (got %0d)", fill_count));

        fi = find_fill(0, 0, 256);
        check(fi >= 0,
            "flood-fill entry at (0,0) size=256 exists");
        if (fi >= 0)
            check(fill_col[fi] === 4'h3,
                $sformatf("fill colour is 3 (got %0h)", fill_col[fi]));

        check(count_covered(0, 0, 256, 256) == 65536,
            $sformatf("all 65536 pixels covered (got %0d)",
                count_covered(0, 0, 256, 256)));

        // ═════════════════════════════════════════════════════════════════
        // TC2 – Two-level descent then flood-fills for all remaining boxes
        //
        // Image: mostly colour 5.
        //   (128,0): on zoom-0 border     -> differ, descend to zoom=1
        //   ( 64,0): on zoom-1 box-00 border -> differ, descend to zoom=2
        // All zoom-1 non-00 borders and all zoom-2 borders are uniform 5.
        // ═════════════════════════════════════════════════════════════════

        suite("TC2 - zoom-0 differ, zoom-1 box-00 differ, rest flood-fill");
        fill_rect(0, 0, 256, 256, 4'h5);
        set_pixel(128, 0, 4'hA);   // zoom-0 border impurity
        set_pixel( 64, 0, 4'hB);   // zoom-1 box-00 border impurity
        clear_tracking();
        sched_reset_start();
        wait_done(timed_out);

        check(!timed_out,
            "engine_done received before timeout");
        check(bad_fill_count == 0,
            "no fill wrote pixels with wrong colour");
        check(dup_count == 0,
            "no pixel pushed more than once");
        check(fill_count > 0,
            $sformatf("at least one flood-fill performed (got %0d)", fill_count));
        check(count_covered(0, 0, 256, 256) == 65536,
            $sformatf("all 65536 pixels covered (got %0d)",
                count_covered(0, 0, 256, 256)));

        $display("  [INFO] fills=%0d  pixels_individually_queued=%0d",
            fill_count, count_queued(0, 0, 256, 256));

        // ═════════════════════════════════════════════════════════════════
        // TC3 – Full descent to zoom=4 (16x16 tiles)
        //
        // Impurity chain forces the scheduler all the way down to zoom=4:
        //   (128,0) zoom-0 border      (64,0) zoom-1 box-00 border
        //   ( 32,0) zoom-2 box-00 border  (16,0) zoom-3 box-00 border
        //
        // At zoom=4 (normal_width=16):
        //   box-00 (0,0)-(15,15):  entirely colour 2  -> flood-fill
        //   box-01 (16,0)-(32,15): mixed interior     -> pixels queued
        // All other boxes at every level are uniform colour 2.
        //
        // Box-00 path is all-left/all-top, so:
        //   box-00 width  = 16 (all_left=1 -> no +1)
        //   box-01 width  = 17 (all_left=0 -> +1), height = 16 (all_top=1)
        // ═════════════════════════════════════════════════════════════════

        suite("TC3 - full descent to zoom=4, one fill + one pixel-queue");
        fill_rect(0, 0, 256, 256, 4'h2);
        set_pixel(128,  0, 4'hF);   // zoom-0 border impurity
        set_pixel( 64,  0, 4'hF);   // zoom-1 box-00 border impurity
        set_pixel( 32,  0, 4'hF);   // zoom-2 box-00 border impurity
        set_pixel( 16,  0, 4'hF);   // zoom-3 box-00 border impurity
        // Interior impurities in zoom-4 box-01 so its border check fails
        set_pixel(20,  5, 4'h7);
        set_pixel(25,  8, 4'h9);
        set_pixel(18, 12, 4'hC);
        clear_tracking();
        sched_reset_start();
        wait_done(timed_out);

        check(!timed_out,
            "engine_done received before timeout");
        check(bad_fill_count == 0,
            "no fill wrote pixels with wrong colour");
        check(dup_count == 0,
            "no pixel pushed more than once");
        check(fill_count > 0,
            $sformatf("at least one flood-fill performed (got %0d)", fill_count));

        // zoom-4 box-00: all_left=1, all_top=1 -> size = normal_width = 256>>4 = 16
        fi = find_fill(0, 0, 16);
        check(fi >= 0,
            "zoom-4 box-00 flood-fill at (0,0) size=16 exists");
        if (fi >= 0)
            check(fill_col[fi] === 4'h2,
                $sformatf("zoom-4 box-00 fill colour is 2 (got %0h)", fill_col[fi]));

        // zoom-4 box-01 pixels must have been individually queued
        // (16,0) to (32,15): width 17 since all_left=0, height 16 since all_top=1
        check(count_queued(16, 0, 17, 16) > 0,
            $sformatf("pixels queued in zoom-4 box-01 region (got %0d)",
                count_queued(16, 0, 17, 16)));

        $display("  [INFO] fills=%0d  queued_in_box01=%0d  total_covered=%0d/65536",
            fill_count, count_queued(16, 0, 17, 16),
            count_covered(0, 0, 256, 256));

        // Print fill log for inspection (up to 12 entries)
        begin
            int lim;
            lim = fill_count < 12 ? fill_count : 12;
            for (int i = 0; i < lim; i++)
                $display("  [INFO] fill[%0d]: (%0d,%0d) sz=%0d col=%0h",
                    i, fill_x[i], fill_y[i], fill_sz[i], fill_col[i]);
        end

        // ═════════════════════════════════════════════════════════════════
        summary();
        $finish;
    end

    // ── watchdog ──────────────────────────────────────────────────────────
    initial begin
        #200_000_000;
        $display("\n[TIMEOUT] simulation exceeded hard limit - possible hang");
        $finish;
    end

endmodule