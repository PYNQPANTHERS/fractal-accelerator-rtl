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
// tt_wr_quad_size semantics: size = normal_width - 1, used as an inclusive
// offset. tt_wr_quad_tlx/y are adjusted by +1 for non-leftmost/topmost boxes
// to skip the shared boundary pixel. Fill covers:
//   (tlx, tly) to (tlx+size, tly+size) inclusive = (size+1)x(size+1) pixels.
//
// Test cases
// ----------
//   TC1  Entire 256x256 image uniform colour 3.
//        -> single FILL_BOX (0,0) size=255 colour=3.
//
//   TC2  Image uniform colour 5, impurity at (75,0)=4'hA.
//        Descent path: zoom-0 -> zoom-1 box-00 -> zoom-2 box-01
//                   -> zoom-3 box-00 -> zoom-4 box-00 (QUEUE_BOX).
//        12 flood-fills, one queued 17x16 region.
//
//   TC3  Same as TC2 plus an interior impurity at (75,200)=4'hA.
//        Interior pixel must never appear in any border scan.
//        Same 12 fills, same queue region, (75,200) covered only
//        by flood-fill of zoom=1 box-10, never individually queued.
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
    localparam int N            = 8;
    localparam int Z            = 3;
    localparam int COLOUR_WIDTH = 4;
    localparam int DONE_DELAY   = 5;
    localparam int TIMEOUT      = 5000;
    localparam int MAX_FILLS    = 256;

    // ── DUT signals ───────────────────────────────────────────────────────
    logic                    rst, start;
    logic                    comparator_flag_so_far;
    logic                    comparator_flag_done;
    logic [COLOUR_WIDTH-1:0] comparator_colour;
    logic                    engine_done;
    logic [N-1:0]            jq_x_coord_to_queue;
    logic [N-1:0]            jq_y_coord_to_queue;
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
    bit covered [0:255][0:255];
    bit queued  [0:255][0:255];
    int dup_count;

    // ── flood-fill log ────────────────────────────────────────────────────
    int                      fill_x   [0:MAX_FILLS-1];
    int                      fill_y   [0:MAX_FILLS-1];
    int                      fill_sz  [0:MAX_FILLS-1];
    logic [COLOUR_WIDTH-1:0] fill_col [0:MAX_FILLS-1];
    int fill_count;
    int bad_fill_count;

    // ── fake comparator state ─────────────────────────────────────────────
    logic                    comp_armed;
    logic                    comp_uniform;
    logic                    comp_first;
    logic [COLOUR_WIDTH-1:0] comp_ref;
    int                      comp_countdown;
    logic                    comp_counting;
    logic                    prev_gen_rst;


    initial begin
    forever @(posedge clk) begin
        #1; // small delay to let signals settle after clock edge
        $display("t=%0t state=%s tlx=%0d tly=%0d zoom=%0d box=%0b quad_size=%0d bpc_state=%s bpc_done=%0b all_left=%0b all_top=%0b qbox_x=%0d qbox_y=%0d",
    $time,
    dut.current_state.name(),
    dut.top_left_x,
    dut.top_left_y,
    dut.zoom_level,
    dut.box_id,
    dut.pixel_width_x,
    dut.pixel_generator.current_state.name(),
    dut.border_pixel_chooser_done,
    dut.all_left_quadrants,
    dut.all_top_quadrants,
    dut.qbox_x,
    dut.qbox_y);
    end
end

    // Fake comparator
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

            if (job_queue_flush) begin
                comparator_flag_so_far <= 1'b1;
                comparator_flag_done   <= 1'b0;
                comp_armed             <= 1'b0;
                comp_uniform           <= 1'b1;
                comp_first             <= 1'b1;
                comp_countdown         <= 0;
                comp_counting          <= 1'b0;
            end

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

            // done_flag stays high while generator is in IDLE so
            // !comp_counting guard ensures countdown only starts once
            if (dut.border_pixel_chooser_done && comp_armed
                    && comp_uniform && !comp_counting) begin
                comp_counting  <= 1'b1;
                comp_countdown <= DONE_DELAY;
            end

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
    if (job_queue_flush) begin
        for (int cy = 0; cy < 256; cy++)
            for (int cx = 0; cx < 256; cx++)
                queued[cy][cx] = 0;
        dup_count = 0;
    end else if (job_queue_push) begin
        int px, py;
        px = int'(jq_x_coord_to_queue);
        py = int'(jq_y_coord_to_queue);
        if (px >= 0 && px < 256 && py >= 0 && py < 256) begin
            if (queued[py][px]) begin
                dup_count = dup_count + 1;
                $display("DUP at (%0d,%0d) zoom=%0d box=%0b",
                    px, py, dut.zoom_level, dut.box_id);
            end
            queued[py][px]  = 1;
            covered[py][px] = 1;
        end
    end
end

    // ── flood-fill monitor ────────────────────────────────────────────────
    // tt_wr_quad_size is an inclusive offset: covers
    // (tlx,tly) to (tlx+size, tly+size) inclusive
    always @(posedge clk) begin
        if (tt_wr_quad_en) begin : fill_mon
            int tx, ty, tsz, fy, fx;
            tx  = int'(tt_wr_quad_tlx);
            ty  = int'(tt_wr_quad_tly);
            tsz = int'(tt_wr_quad_size);
            $display("fill captured: tlx=%0d tly=%0d tsz=%0d col=%0h",
    tx, ty, tsz, tt_wr_quad_colour);
            if (fill_count < MAX_FILLS) begin
                fill_x  [fill_count] = tx;
                fill_y  [fill_count] = ty;
                fill_sz [fill_count] = tsz;
                fill_col[fill_count] = tt_wr_quad_colour;
                fill_count = fill_count + 1;
            end
            for (fy = ty; fy <= ty + tsz && fy < 256; fy++)
                for (fx = tx; fx <= tx + tsz && fx < 256; fx++) begin
                    if (image[fy][fx] !== tt_wr_quad_colour)
                        bad_fill_count = bad_fill_count + 1;
                    covered[fy][fx] = 1;
                end
        end
    end

    // ── helpers ───────────────────────────────────────────────────────────
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

    function automatic int count_covered(input int x0, y0, w, h);
        int n;
        n = 0;
        for (int iy = y0; iy < y0+h; iy++)
            for (int ix = x0; ix < x0+w; ix++)
                if (covered[iy][ix]) n++;
        return n;
    endfunction

    function automatic int count_queued(input int x0, y0, w, h);
        int n;
        n = 0;
        for (int iy = y0; iy < y0+h; iy++)
            for (int ix = x0; ix < x0+w; ix++)
                if (queued[iy][ix]) n++;
        return n;
    endfunction

    // Find fill entry by top-left and size; returns index or -1
    function automatic int find_fill(input int tx, ty, tsz);
        for (int i = 0; i < fill_count; i++)
            if (fill_x[i] == tx && fill_y[i] == ty && fill_sz[i] == tsz)
                return i;
        return -1;
    endfunction

    task automatic sched_reset_start();
        rst=1; start=0; tick(1);
        rst=0; start=1; tick(1);
        start=0;
    endtask

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

    // ── module-level vars ─────────────────────────────────────────────────
    logic timed_out;
    int   fi;

    // ═════════════════════════════════════════════════════════════════════
    initial begin
        $dumpfile("sim/waves/tb_scheduler.vcd");
        $dumpvars(0, tb_scheduler);

        rst=1; start=0;
        comparator_flag_so_far=1; comparator_flag_done=0;
        comparator_colour='0;
        tick(4); rst=0; tick(1);

        // // ═════════════════════════════════════════════════════════════════
        // // TC1 – Entire 256x256 image uniform colour 3
        // //
        // // zoom=0: all_left=1, all_top=1 (special case)
        // //   tt_wr_quad_tlx = 0 + ~1 = 0
        // //   tt_wr_quad_tly = 0 + ~1 = 0
        // //   tt_wr_quad_size = 256-1 = 255
        // //   covers (0,0)→(255,255) inclusive = all 65536 pixels
        // // ═════════════════════════════════════════════════════════════════

        // suite("TC1 - uniform 256x256 image colour=3");
        // fill_rect(0, 0, 256, 256, 4'h3);
        // clear_tracking();
        // sched_reset_start();
        // wait_done(timed_out);

        // check(!timed_out,
        //     "engine_done received before timeout");
        // check(bad_fill_count == 0,
        //     "no fill wrote pixels with wrong colour");
        // check(dup_count == 0,
        //     "no pixel pushed more than once");
        // check(fill_count == 1,
        //     $sformatf("exactly one flood-fill (got %0d)", fill_count));

        // fi = find_fill(0, 0, 255);
        // check(fi >= 0,
        //     "flood-fill at (0,0) size=255 exists");
        // if (fi >= 0)
        //     check(fill_col[fi] === 4'h3,
        //         $sformatf("fill colour=3 (got %0h)", fill_col[fi]));

        // check(count_covered(0, 0, 256, 256) == 65536,
        //     $sformatf("all 65536 pixels covered (got %0d)",
        //         count_covered(0, 0, 256, 256)));

        // $display("  [INFO] fills=%0d  total_covered=%0d/65536",
        //     fill_count, count_covered(0, 0, 256, 256));

        // ═════════════════════════════════════════════════════════════════
        // TC2 – Single impurity at (75,0), descent to zoom=4
        //
        // Image: uniform colour 5, (75,0)=4'hA.
        //
        // Descent path (box containing (75,0) at each level):
        //   zoom=0  box-00 (0,0)     differ -> descend
        //   zoom=1  box-00 (0,0)     differ -> descend
        //   zoom=2  box-01 (63,0)    differ -> descend
        //   zoom=3  box-00 (63,0)    differ -> descend
        //   zoom=4  box-00 (63,0)    max zoom -> QUEUE_BOX (17x16)
        //
        // Fill table (tlx = top_left_x + ~all_left, size = normal_width-1):
        //   zoom=1  box-01  (128, 0)  sz=127
        //   zoom=1  box-10  (0,  128) sz=127
        //   zoom=1  box-11  (128,128) sz=127
        //   zoom=2  box-00  (0,   0)  sz=63
        //   zoom=2  box-10  (0,  64)  sz=63
        //   zoom=2  box-11  (64, 64)  sz=63
        //   zoom=3  box-01  (96,  0)  sz=31
        //   zoom=3  box-10  (64, 33)  sz=31
        //   zoom=3  box-11  (96, 33)  sz=31
        //   zoom=4  box-01  (80,  0)  sz=15
        //   zoom=4  box-10  (64, 17)  sz=15
        //   zoom=4  box-11  (80, 17)  sz=15
        //                             total: 12 fills
        // ═════════════════════════════════════════════════════════════════

        suite("TC2 - impurity at (75,0), descent to zoom=4, 12 fills");
        fill_rect(0, 0, 256, 256, 4'h5);
        set_pixel(75, 0, 4'hA);
        clear_tracking();
        sched_reset_start();
        wait_done(timed_out);

        check(!timed_out,
            "engine_done received before timeout");
        check(bad_fill_count == 0,
            "no fill wrote pixels with wrong colour");
        check(dup_count == 0,
            "no pixel pushed more than once");
        check(fill_count == 12,
            $sformatf("exactly 12 flood-fills (got %0d)", fill_count));

        // zoom=1 fills
        fi = find_fill(128, 0, 127);
        check(fi >= 0, "zoom=1 box-01 fill at (128,0) sz=127");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=1 box-01 colour=5 (got %0h)", fill_col[fi]));

        fi = find_fill(0, 128, 127);
        check(fi >= 0, "zoom=1 box-10 fill at (0,128) sz=127");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=1 box-10 colour=5 (got %0h)", fill_col[fi]));

        fi = find_fill(128, 128, 127);
        check(fi >= 0, "zoom=1 box-11 fill at (128,128) sz=127");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=1 box-11 colour=5 (got %0h)", fill_col[fi]));

        // zoom=2 fills
        fi = find_fill(0, 0, 63);
        check(fi >= 0, "zoom=2 box-00 fill at (0,0) sz=63");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=2 box-00 colour=5 (got %0h)", fill_col[fi]));

        fi = find_fill(0, 64, 63);
        check(fi >= 0, "zoom=2 box-10 fill at (0,64) sz=63");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=2 box-10 colour=5 (got %0h)", fill_col[fi]));

        fi = find_fill(64, 64, 63);
        check(fi >= 0, "zoom=2 box-11 fill at (64,64) sz=63");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=2 box-11 colour=5 (got %0h)", fill_col[fi]));

        // zoom=3 fills
        fi = find_fill(96, 0, 31);
        check(fi >= 0, "zoom=3 box-01 fill at (96,0) sz=31");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=3 box-01 colour=5 (got %0h)", fill_col[fi]));

        fi = find_fill(64, 33, 31);
        check(fi >= 0, "zoom=3 box-10 fill at (64,33) sz=31");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=3 box-10 colour=5 (got %0h)", fill_col[fi]));

        fi = find_fill(96, 33, 31);
        check(fi >= 0, "zoom=3 box-11 fill at (96,33) sz=31");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=3 box-11 colour=5 (got %0h)", fill_col[fi]));

        // zoom=4 fills
        fi = find_fill(80, 0, 15);
        check(fi >= 0, "zoom=4 box-01 fill at (80,0) sz=15");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=4 box-01 colour=5 (got %0h)", fill_col[fi]));

        fi = find_fill(64, 17, 15);
        check(fi >= 0, "zoom=4 box-10 fill at (64,17) sz=15");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=4 box-10 colour=5 (got %0h)", fill_col[fi]));

        fi = find_fill(80, 17, 15);
        check(fi >= 0, "zoom=4 box-11 fill at (80,17) sz=15");
        if (fi >= 0) check(fill_col[fi] === 4'h5,
            $sformatf("zoom=4 box-11 colour=5 (got %0h)", fill_col[fi]));

        // zoom=4 box-00 (63,0): 17x16 pixels individually queued
        // all_left=0 -> pixel_width_x=17, all_top=1 -> pixel_width_y=16
        check(count_queued(63, 0, 17, 16) > 0,
            $sformatf("pixels queued in zoom=4 box-00 (63,0) 17x16 (got %0d)",
                count_queued(63, 0, 17, 16)));

        $display("  [INFO] fills=%0d  queued_z4box00=%0d  total_covered=%0d/65536",
            fill_count, count_queued(63, 0, 17, 16),
            count_covered(0, 0, 256, 256));

        // ═════════════════════════════════════════════════════════════════
        // // TC3 – Same as TC2 plus interior impurity at (75,200)
        // //
        // // (75,200) is strictly interior to zoom=1 box-10 fill region
        // // (0,128)→(127,255). It lies on no box border at any zoom level
        // // so must never appear in any border scan or be individually
        // // queued. It should be covered only by the zoom=1 box-10 fill.
        // //
        // // Expected outcome: identical to TC2 (same 12 fills, same queue
        // // region) since the interior pixel never affects any scan.
        // // ═════════════════════════════════════════════════════════════════

        // suite("TC3 - TC2 + interior impurity at (75,200), same outcome");
        // fill_rect(0, 0, 256, 256, 4'h5);
        // set_pixel(75,   0, 4'hA);   // border impurity, same as TC2
        // set_pixel(75, 200, 4'hA);   // interior impurity, must be ignored
        // clear_tracking();
        // sched_reset_start();
        // wait_done(timed_out);

        // check(!timed_out,
        //     "engine_done received before timeout");
        // check(bad_fill_count == 0,
        //     "no fill wrote pixels with wrong colour");
        // check(dup_count == 0,
        //     "no pixel pushed more than once");

        // // Outcome must be identical to TC2 — interior pixel causes no
        // // extra descent or queuing
        // check(fill_count == 12,
        //     $sformatf("still exactly 12 fills with interior impurity (got %0d)",
        //         fill_count));

        // // zoom=4 box-00 still queued
        // check(count_queued(63, 0, 17, 16) > 0,
        //     $sformatf("zoom=4 box-00 pixels still queued (got %0d)",
        //         count_queued(63, 0, 17, 16)));

        // // Interior pixel covered by zoom=1 box-10 fill (0,128)→(127,255)
        // check(covered[200][75] == 1,
        //     "interior pixel (75,200) covered by flood-fill");

        // // Interior pixel must NOT have been individually queued
        // check(queued[200][75] == 0,
        //     "interior pixel (75,200) was NOT individually queued");

        // $display("  [INFO] fills=%0d  queued_z4box00=%0d  total_covered=%0d/65536",
        //     fill_count, count_queued(63, 0, 17, 16),
        //     count_covered(0, 0, 256, 256));

        // ═════════════════════════════════════════════════════════════════
        summary();
        $finish;
    end

    // ── watchdog ──────────────────────────────────────────────────────────
    initial begin
        #500_000_000;
        $display("\n[TIMEOUT] simulation exceeded hard limit - possible hang");
        $finish;
    end

endmodule