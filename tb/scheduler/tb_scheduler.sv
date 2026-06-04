// Testbench for scheduler.sv
//
// Verification strategy:
//   - Pre-calculate a synthetic 256×256 "Mandelbrot" image as a flat colour array.
//   - A fake comparator monitors job_queue_push and the pixel coordinates, reads
//     the image array, and drives comparator_flag_so_far / comparator_flag_done
//     exactly as the real comparator would.
//   - A pixel-coverage bitmap records every pixel accounted for, either via an
//     individually queued push or a flood-fill (tt_wr_quad_en).
//   - After engine_done, checks verify full 256×256 coverage and no duplicates.
//
// Test cases
// ----------
//   TC1  Entire 256×256 image uniform colour 3.
//        Expected: one FILL_BOX (0,0) size=256 colour=3.  No pixel pushes.
//
//   TC2  Mostly colour 5; impurity at (128,0) forces zoom-0 differ and descent.
//        Second impurity at (64,0) forces zoom-1 box-00 to differ again.
//        All remaining zoom-1 and zoom-2 box borders are uniform.
//        Expected: several flood-fills covering the full 256×256; no pixel-level queue.
//
//   TC3  Impurity chain at (128,0),(64,0),(32,0),(16,0) forces descent to zoom=4.
//        At zoom=4, box-00 (0,0)→(15,15) is uniform colour 2  → flood-fill.
//        At zoom=4, box-01 (16,0)→(32,15) has mixed interior  → all pixels queued.
//        All other boxes at every level are uniform.
//        Expected: flood-fill for box-00, individual queuing for box-01 region,
//                  plus fills for all remaining boxes; full 256×256 coverage.
//
// NOTE – the fake comparator asserts comparator_flag_done exactly 5 cycles after
//        border_pixel_chooser_done rises, matching the real pipeline latency.
//        comparator_flag_so_far drops immediately when a differing pixel is seen.
//
// NOTE – scheduler_stack must be compiled alongside this testbench.
//
// Compile example (iverilog):
//   iverilog -g2012 -Wall -o sim/build/tb_scheduler.out \
//       hdl/scheduler/scheduler.sv             \
//       hdl/scheduler/border_coord_generator.sv \
//       hdl/scheduler/scheduler_stack.sv        \
//       tb/scheduler/tb_scheduler.sv &&         \
//   vvp sim/build/tb_scheduler.out

`timescale 1ns/1ps

module tb_scheduler;

    // ── parameters ────────────────────────────────────────────────────────
    localparam int N            = 10;
    localparam int Z            = 3;
    localparam int COLOUR_WIDTH = 4;
    localparam int IMG_W        = 256;
    localparam int IMG_H        = 256;
    localparam int HALF         = 5;       // 100 MHz clock
    localparam int TIMEOUT      = 200_000; // cycles before declaring stuck
    localparam int DONE_DELAY   = 5;       // cycles after last border pixel

    // ── DUT ports ─────────────────────────────────────────────────────────
    logic                    clk, rst, start;
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

    // ── DUT ───────────────────────────────────────────────────────────────
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

    // ── clock ─────────────────────────────────────────────────────────────
    initial clk = 0;
    always #HALF clk = ~clk;

    // ── synthetic image and coverage bitmap ───────────────────────────────
    logic [COLOUR_WIDTH-1:0] image   [0:IMG_H-1][0:IMG_W-1];
    bit                      covered [0:IMG_H-1][0:IMG_W-1];
    bit                      queued  [0:IMG_H-1][0:IMG_W-1]; // pushed individually

    // ── test counters ─────────────────────────────────────────────────────
    integer pass_count, fail_count, test_count;

    // ── fake comparator state ─────────────────────────────────────────────
    logic [COLOUR_WIDTH-1:0] ref_colour;
    logic                    scan_uniform;
    integer                  done_countdown;
    logic                    countdown_active;
    logic                    prev_rst_start;

    // ── helpers ───────────────────────────────────────────────────────────

    task automatic fill_rect(input int x0, y0, w, h,
                              input logic [COLOUR_WIDTH-1:0] col);
        for (int y = y0; y < y0+h; y++)
            for (int x = x0; x < x0+w; x++)
                image[y][x] = col;
    endtask

    task automatic set_pixel(input int x, y,
                              input logic [COLOUR_WIDTH-1:0] col);
        image[y][x] = col;
    endtask

    task automatic clear_coverage();
        for (int y = 0; y < IMG_H; y++)
            for (int x = 0; x < IMG_W; x++) begin
                covered[y][x] = 0;
                queued[y][x]  = 0;
            end
    endtask

    // Mark a flood-fill quad as covered and verify colour consistency
    task automatic apply_fill(input int tx, ty, tsz,
                               input logic [COLOUR_WIDTH-1:0] col,
                               ref integer bad_fill);
        for (int fy = ty; fy < ty+tsz && fy < IMG_H; fy++) begin
            for (int fx = tx; fx < tx+tsz && fx < IMG_W; fx++) begin
                if (image[fy][fx] !== col) bad_fill++;
                covered[fy][fx] = 1;
            end
        end
    endtask

    // Check full rectangle coverage, report first few missing
    task automatic check_coverage(input int x0, y0, w, h,
                                   input string label,
                                   ref integer failures);
        integer missed, shown;
        missed = 0; shown = 0;
        for (int y = y0; y < y0+h; y++) begin
            for (int x = x0; x < x0+w; x++) begin
                if (!covered[y][x]) begin
                    if (shown < 6) begin
                        $display("       missing pixel (%0d,%0d)", x, y);
                        shown++;
                    end
                    missed++;
                end
            end
        end
        if (missed == 0)
            $display("PASS [%s] all %0d pixels covered", label, w*h);
        else begin
            $display("FAIL [%s] %0d/%0d pixels missing",
                     label, missed, w*h);
            if (missed > 6)
                $display("       ... and %0d more", missed-6);
            failures++;
        end
    endtask

    // Check no pixel was queued more than once
    task automatic check_no_duplicates(input string label,
                                        ref integer failures);
        integer dups;
        dups = 0;
        // queued[] is set on first push; a second push to the same coord
        // is caught by the monitor (see always block below)
        // We track duplicates via a separate dup_count updated in the monitor
        // and read here (see dup_count logic in monitor section)
        if (dup_count == 0)
            $display("PASS [%s] no duplicate pushes", label);
        else begin
            $display("FAIL [%s] %0d duplicate push(es) detected", label, dup_count);
            failures++;
        end
    endtask

    // ── duplicate-push counter (updated by monitor always block) ─────────
    integer dup_count;

    // ── fill log (for inspection) ─────────────────────────────────────────
    typedef struct {
        int x, y, sz;
        logic [COLOUR_WIDTH-1:0] col;
    } fill_entry_t;
    fill_entry_t fill_log [0:255];   // static array; fill_log_count tracks depth
    integer fill_log_count;
    integer bad_fill_count;          // pixels inside a fill whose colour mismatches

    // ── monitors ─────────────────────────────────────────────────────────

    // Job-queue push monitor: records pushes, checks duplicates, marks covered
    always @(posedge clk) begin
        if (job_queue_flush) begin
            // flush: clear queued bitmap (pixels before flush are discarded)
            for (int y = 0; y < IMG_H; y++)
                for (int x = 0; x < IMG_W; x++)
                    queued[y][x] = 0;
            dup_count = 0;
        end
        else if (job_queue_push) begin
            automatic int px = int'(jq_x_coord_to_queue);
            automatic int py = int'(jq_y_coord_to_queue);
            if (px >= 0 && px < IMG_W && py >= 0 && py < IMG_H) begin
                if (queued[py][px])
                    dup_count++;
                queued[py][px]  = 1;
                covered[py][px] = 1;
            end
        end
    end

    // Flood-fill monitor: marks all pixels in the quad as covered
    always @(posedge clk) begin
        if (tt_wr_quad_en) begin
            automatic int tx  = int'(tt_wr_quad_tlx);
            automatic int ty  = int'(tt_wr_quad_tly);
            automatic int tsz = int'(tt_wr_quad_size);
            automatic logic [COLOUR_WIDTH-1:0] tcol = tt_wr_quad_colour;
            if (fill_log_count < 256) begin
                fill_log[fill_log_count].x   = tx;
                fill_log[fill_log_count].y   = ty;
                fill_log[fill_log_count].sz  = tsz;
                fill_log[fill_log_count].col = tcol;
                fill_log_count++;
            end
            for (int fy = ty; fy < ty+tsz && fy < IMG_H; fy++) begin
                for (int fx = tx; fx < tx+tsz && fx < IMG_W; fx++) begin
                    if (image[fy][fx] !== tcol)
                        bad_fill_count++;
                    covered[fy][fx] = 1;
                end
            end
        end
    end

    // ── fake comparator ──────────────────────────────────────────────────
    // Watches every pushed pixel. The first pixel of each scan sets
    // ref_colour. Any differing pixel immediately drops flag_so_far.
    // 5 cycles after border_pixel_chooser_done (if still uniform),
    // flag_done is pulsed for one cycle.

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            comparator_flag_so_far <= 1'b1;
            comparator_flag_done   <= 1'b0;
            comparator_colour      <= '0;
            ref_colour             <= '0;
            scan_uniform           <= 1'b1;
            done_countdown         <= 0;
            countdown_active       <= 1'b0;
            prev_rst_start         <= 1'b0;
        end
        else begin
            prev_rst_start <= dut.pixel_generator_reset;

            // Auto-clear done after one cycle
            if (comparator_flag_done)
                comparator_flag_done <= 1'b0;

            // New scan beginning: pixel_generator_reset rising edge
            if (dut.pixel_generator_reset && !prev_rst_start) begin
                comparator_flag_so_far <= 1'b1;
                comparator_flag_done   <= 1'b0;
                scan_uniform           <= 1'b1;
                done_countdown         <= 0;
                countdown_active       <= 1'b0;
                // ref_colour set on first pixel below
            end

            // Flush: reset comparator
            if (job_queue_flush) begin
                comparator_flag_so_far <= 1'b1;
                comparator_flag_done   <= 1'b0;
                scan_uniform           <= 1'b1;
                done_countdown         <= 0;
                countdown_active       <= 1'b0;
            end

            // Incoming pixel
            if (job_queue_push && !job_queue_flush) begin
                automatic int px = int'(jq_x_coord_to_queue);
                automatic int py = int'(jq_y_coord_to_queue);
                automatic logic [COLOUR_WIDTH-1:0] pix;
                pix = (px >= 0 && px < IMG_W && py >= 0 && py < IMG_H)
                      ? image[py][px] : 4'h0;

                if (!countdown_active && comparator_colour === 4'hx) begin
                    // very first pixel of scan
                    ref_colour        <= pix;
                    comparator_colour <= pix;
                end else if (pix !== ref_colour && scan_uniform) begin
                    scan_uniform           <= 1'b0;
                    comparator_flag_so_far <= 1'b0;
                end
            end

            // border_pixel_chooser finished: start done countdown
            // (only if scan was uniform throughout)
            if (dut.border_pixel_chooser_done && scan_uniform
                    && !countdown_active) begin
                countdown_active <= 1'b1;
                done_countdown   <= DONE_DELAY;
            end

            // Countdown
            if (countdown_active && done_countdown > 0) begin
                done_countdown <= done_countdown - 1;
                if (done_countdown == 1) begin
                    comparator_flag_done <= 1'b1;
                    countdown_active     <= 1'b0;
                end
            end
        end
    end

    // ── main test task ────────────────────────────────────────────────────

    task automatic run_test(input string label);
        integer timeout_ctr, local_fail;

        // Reset comparator_colour to undefined so first pixel sets ref
        // (done via rst below)

        // Hard reset – tick 1
        @(negedge clk);
        rst   = 1'b1;
        start = 1'b0;
        @(negedge clk);  // tick 1 rising edge: rst high

        // De-assert rst, raise start – tick 2
        rst   = 1'b0;
        start = 1'b1;
        @(negedge clk);  // tick 2 rising edge: start sampled

        start = 1'b0;    // start is a one-cycle pulse

        // Wait for engine_done or timeout
        timeout_ctr = 0;
        @(posedge clk); #1;
        while (!engine_done && timeout_ctr < TIMEOUT) begin
            @(posedge clk); #1;
            timeout_ctr++;
        end

        test_count++;
        local_fail = 0;

        if (!engine_done) begin
            $display("FAIL [%0d] %-32s TIMEOUT after %0d cycles",
                     test_count, label, TIMEOUT);
            fail_count++;
            return;
        end

        // Check bad fills
        if (bad_fill_count > 0) begin
            $display("FAIL [%0d] %-32s %0d pixel(s) inside a fill with wrong colour",
                     test_count, label, bad_fill_count);
            local_fail++;
        end

        // Check no duplicate pushes
        check_no_duplicates(label, local_fail);

        // Check full image coverage
        check_coverage(0, 0, IMG_W, IMG_H, label, local_fail);

        if (local_fail == 0) begin
            $display("PASS [%0d] %-32s done in %0d cycles  fills=%0d  pushed=%0d",
                     test_count, label, timeout_ctr, fill_log_count,
                     $countones(queued));
            pass_count++;
        end else begin
            $display("     [%0d] %-32s fills=%0d  pushed=%0d  bad_fills=%0d",
                     test_count, label, fill_log_count, $countones(queued),
                     bad_fill_count);
            // Print fill log for debugging
            for (int i = 0; i < fill_log_count && i < 16; i++)
                $display("       fill[%0d]: (%0d,%0d) sz=%0d col=%0h",
                         i, fill_log[i].x, fill_log[i].y,
                         fill_log[i].sz, fill_log[i].col);
            fail_count++;
        end
    endtask

    // ── test cases ────────────────────────────────────────────────────────

    task automatic tc1();
        // Entire 256×256 uniform colour 3
        // → one FILL_BOX (0,0) size=256 colour=3
        fill_rect(0, 0, 256, 256, 4'h3);
        clear_coverage();
        dup_count      = 0;
        fill_log_count = 0;
        bad_fill_count = 0;
        run_test("TC1: uniform 256x256 col=3");

        // Extra: verify the single fill entry
        if (fill_log_count != 1) begin
            $display("FAIL [TC1-fills] expected 1 fill, got %0d", fill_log_count);
            fail_count++;
        end else if (fill_log[0].x != 0 || fill_log[0].y != 0 ||
                     fill_log[0].sz != 256 || fill_log[0].col !== 4'h3) begin
            $display("FAIL [TC1-fills] fill[0]=(%0d,%0d,sz=%0d,col=%0h) expected (0,0,256,3)",
                     fill_log[0].x, fill_log[0].y, fill_log[0].sz, fill_log[0].col);
            fail_count++;
        end else
            $display("PASS [TC1-fills] single fill (0,0) sz=256 col=3 correct");
    endtask

    task automatic tc2();
        // Mostly colour 5; two impurities force descent to zoom=1/zoom=2,
        // then all sub-boxes are flood-filled.
        //   (128, 0) = 4'hA  → zoom-0 border differ, descend to zoom=1
        //   ( 64, 0) = 4'hB  → zoom-1 box-00 border differ, descend to zoom=2
        // All other box borders: uniform colour 5
        fill_rect(0, 0, 256, 256, 4'h5);
        set_pixel(128,  0, 4'hA);
        set_pixel( 64,  0, 4'hB);
        clear_coverage();
        dup_count      = 0;
        fill_log_count = 0;
        bad_fill_count = 0;
        run_test("TC2: 2-level descent then fills");

        // Verify no individual pixels were queued after the final descent
        // (all remaining boxes should be uniform → flood-filled)
        // We can't guarantee zero pushes (the differing border pixels were pushed
        // before the comparator flagged them), but after the flush they are gone.
        $display("     [TC2] fill entries: %0d", fill_log_count);
    endtask

    task automatic tc3();
        // Impurity chain forces full descent to zoom=4 (16×16 tiles).
        //   zoom-0 border: (128, 0) = 4'hF
        //   zoom-1 box-00 border: ( 64, 0) = 4'hF
        //   zoom-2 box-00 border: ( 32, 0) = 4'hF
        //   zoom-3 box-00 border: ( 16, 0) = 4'hF
        // At zoom=4:
        //   box-00 (0,0)→(15,15)  entirely colour 2 → flood-fill
        //   box-01 (16,0)→(32,15) mixed interior    → all pixels queued
        // Everything else is uniform colour 2.
        fill_rect(0,   0, 256, 256, 4'h2);
        set_pixel(128,  0, 4'hF);   // zoom-0 border impurity
        set_pixel( 64,  0, 4'hF);   // zoom-1 box-00 border impurity
        set_pixel( 32,  0, 4'hF);   // zoom-2 box-00 border impurity
        set_pixel( 16,  0, 4'hF);   // zoom-3 box-00 border impurity
        // Interior impurities in zoom-4 box-01 so its border check fails
        set_pixel( 20,  5, 4'h7);
        set_pixel( 25,  8, 4'h9);
        set_pixel( 18, 12, 4'hC);
        clear_coverage();
        dup_count      = 0;
        fill_log_count = 0;
        bad_fill_count = 0;
        run_test("TC3: full descent to zoom=4");

        // Extra: check that zoom-4 box-00 got a fill
        begin
            automatic int found_00 = 0;
            for (int i = 0; i < fill_log_count; i++) begin
                if (fill_log[i].x == 0 && fill_log[i].y == 0 &&
                    fill_log[i].sz == 16 && fill_log[i].col === 4'h2)
                    found_00 = 1;
            end
            if (found_00)
                $display("PASS [TC3-z4box00] zoom-4 box-00 flood-fill found");
            else begin
                $display("FAIL [TC3-z4box00] zoom-4 box-00 flood-fill NOT found");
                fail_count++;
            end
        end

        // Extra: check pixels in zoom-4 box-01 region were individually queued
        begin
            automatic int q01 = 0;
            // box-01 at zoom=4: right-column box, all_left=0 → width=17
            // top-row box, all_top=1 → height=16  (assuming box-00 path all-left/top)
            for (int y = 0; y <= 15; y++)
                for (int x = 16; x <= 32; x++)
                    if (queued[y][x]) q01++;
            if (q01 > 0)
                $display("PASS [TC3-z4box01] %0d pixel(s) individually queued in box-01 region",
                         q01);
            else begin
                $display("FAIL [TC3-z4box01] no pixels queued in zoom-4 box-01 region");
                fail_count++;
            end
        end

        $display("     [TC3] fill entries: %0d", fill_log_count);
        for (int i = 0; i < fill_log_count && i < 20; i++)
            $display("       fill[%0d]: (%0d,%0d) sz=%0d col=%0h",
                     i, fill_log[i].x, fill_log[i].y,
                     fill_log[i].sz, fill_log[i].col);
    endtask

    // ── top-level stimulus ────────────────────────────────────────────────

    initial begin
        $dumpfile("sim/waves/tb_scheduler.vcd");
        $dumpvars(0, tb_scheduler);

        pass_count     = 0;
        fail_count     = 0;
        test_count     = 0;
        dup_count      = 0;
        fill_log_count = 0;
        bad_fill_count = 0;

        rst   = 1'b1;
        start = 1'b0;
        comparator_flag_so_far = 1'b1;
        comparator_flag_done   = 1'b0;
        comparator_colour      = '0;

        repeat(4) @(posedge clk);
        rst = 1'b0;

        tc1();
        tc2();
        tc3();

        $display("");
        $display("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        $display("  Results: %0d/%0d passed", pass_count, test_count);
        if (fail_count == 0)
            $display("  ALL TESTS PASSED");
        $display("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        $finish;
    end

endmodule