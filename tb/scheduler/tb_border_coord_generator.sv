// Testbench for border_pixel_chooser (border_coord_generator.sv)
//
// NOTE – before this compiles, three issues in border_coord_generator.sv must be fixed:
//   1. Port list ends with "done_flag;"  →  remove the semicolon (it's a syntax error)
//   2. "left: next_state = left;"       →  left state never exits; needs a transition to right
//   3. "assign next_tmp_val = tmp <= …" →  <= is a comparison, not assignment; should be =
//
// NOTE – the scheduler.sv instantiation passes zoom_level/box_number but the module
//        now expects all_left_flag/all_top_flag.  The scheduler connection needs updating.
//
// NOTE – to compile this TB, hdl/scheduler must be on the include path.  Either:
//   - Uncomment hdl/scheduler in Makefile HDL_DIRS once scheduler.sv issues are resolved, or
//   - Run manually:
//       iverilog -g2012 -Wall -o sim/build/tb_border_coord_generator.out \
//           hdl/scheduler/border_coord_generator.sv \
//           tb/scheduler/tb_border_coord_generator.sv && \
//       vvp sim/build/tb_border_coord_generator.out
//
// Verification strategy:
//   - Drive rst_start for one clock, then collect (x_coord, y_coord) every cycle
//   - Stop on done_flag rising edge or TIMEOUT cycles
//   - PASS if: every output is a border pixel, no duplicate coords, coverage == expected

`timescale 1ns/1ps

module tb_border_coord_generator;

    localparam int N       = 10;
    localparam int HALF    = 5;
    localparam int TIMEOUT = 25000;   // cycles before declaring stuck

    logic          clk, rst, rst_start;
    logic          all_left_flag, all_top_flag;
    logic [N-1:0]  top_left_x, top_left_y;
    logic [N-1:0]  width_pixels_x, width_pixels_y;
    logic [N-1:0]  x_coord, y_coord;
    logic          done_flag;

    border_pixel_chooser #(.N(N)) dut (
        .clk            (clk),
        .rst            (rst),
        .rst_start      (rst_start),
        .all_left_flag  (all_left_flag),
        .all_top_flag   (all_top_flag),
        .top_left_x     (top_left_x),
        .top_left_y     (top_left_y),
        .width_pixels_x (width_pixels_x),
        .width_pixels_y (width_pixels_y),
        .x_coord        (x_coord),
        .y_coord        (y_coord),
        .done_flag      (done_flag)
    );

    initial clk = 0;
    always #HALF clk = ~clk;

    // Module-level seen bitmap: seen[x][y] – large enough for coords up to 511
    // (N=10 coords can reach 1023 but actual box widths in use are ≤ 257)
    localparam int MAP = 512;
    bit seen [0:MAP-1][0:MAP-1];

    integer pass_count, fail_count, test_count;

    // ── helpers ────────────────────────────────────────────────────────────

    function automatic bit is_border(integer x, integer y, integer W, integer H);
        if (x < 0 || x >= W || y < 0 || y >= H) return 0;
        return (x == 0) || (x == W-1) || (y == 0) || (y == H-1);
    endfunction

    // Clear the seen bitmap (only cells within the current box size)
    task automatic clear_seen(input integer W, H);
        integer i, j;
        for (i = 0; i < W && i < MAP; i++)
            for (j = 0; j < H && j < MAP; j++)
                seen[i][j] = 0;
    endtask

    // Count unique border pixels that were seen
    function automatic integer unique_border(input integer W, H);
        integer i, j, cnt;
        cnt = 0;
        for (i = 0; i < W; i++) begin
            if (seen[i][0])   cnt++;
            if (seen[i][H-1]) cnt++;
        end
        for (j = 1; j < H-1; j++) begin
            if (seen[0][j])   cnt++;
            if (seen[W-1][j]) cnt++;
        end
        return cnt;
    endfunction

    // Print first few missing border pixels (for debugging failures)
    task automatic print_missing(input integer W, H);
        integer i, j, shown;
        shown = 0;
        for (i = 0; i < W && shown < 8; i++) begin
            if (!seen[i][0])   begin $display("       missing top    (%0d, 0)",    i); shown++; end
            if (!seen[i][H-1]) begin $display("       missing bottom (%0d, %0d)",  i, H-1); shown++; end
        end
        for (j = 1; j < H-1 && shown < 8; j++) begin
            if (!seen[0][j])   begin $display("       missing left   (0, %0d)",    j); shown++; end
            if (!seen[W-1][j]) begin $display("       missing right  (%0d, %0d)", W-1, j); shown++; end
        end
    endtask

    // ── main test task ─────────────────────────────────────────────────────

    task automatic run_test(
        input integer W, H,
        input logic   al, at,
        input string  label
    );
        integer cx, cy;
        integer timeout_ctr, bad, dups;
        integer expected, got_unique;
        bit     found_done, prev_done;

        // Hard reset
        @(negedge clk);
        rst = 1; rst_start = 0;
        @(negedge clk);
        rst = 0;

        // Settle inputs
        top_left_x      = '0;
        top_left_y      = '0;
        width_pixels_x  = N'(W);
        width_pixels_y  = N'(H);
        all_left_flag   = al;
        all_top_flag    = at;
        @(negedge clk);

        clear_seen(W < MAP ? W : MAP, H < MAP ? H : MAP);
        bad        = 0;
        dups       = 0;
        found_done = 0;
        prev_done  = 0;
        timeout_ctr = 0;

        // Pulse rst_start for exactly one clock period
        rst_start = 1;
        @(negedge clk);
        rst_start = 0;

        // Sample every rising edge until done_flag or timeout
        @(posedge clk); #1;
        while (!found_done && timeout_ctr < TIMEOUT) begin
            cx = int'(x_coord);
            cy = int'(y_coord);

            if (!is_border(cx, cy, W, H)) begin
                bad++;
            end else if (cx < MAP && cy < MAP) begin
                if (seen[cx][cy]) dups++;
                seen[cx][cy] = 1;
            end

            // Detect rising edge of done_flag (latch may hold stale 1)
            if (!prev_done && (done_flag === 1'b1))
                found_done = 1;
            prev_done = (done_flag === 1'b1);

            if (!found_done) begin
                @(posedge clk); #1;
            end
            timeout_ctr++;
        end

        test_count++;
        expected   = 2*W + 2*(H - 2);    // = 2W + 2H - 4
        got_unique = unique_border(W < MAP ? W : MAP, H < MAP ? H : MAP);

        if (!found_done) begin
            $display("FAIL [%0d] %-24s TIMEOUT after %0d cycles  unique=%0d/%0d  bad=%0d",
                     test_count, label, TIMEOUT, got_unique, expected, bad);
            fail_count++;
        end else if (bad == 0 && dups == 0 && got_unique == expected) begin
            $display("PASS [%0d] %-24s %0d/%0d border pixels in %0d cycles",
                     test_count, label, got_unique, expected, timeout_ctr);
            pass_count++;
        end else begin
            $display("FAIL [%0d] %-24s got %0d/%0d unique, %0d interior, %0d dups, %0d cycles",
                     test_count, label, got_unique, expected, bad, dups, timeout_ctr);
            print_missing(W < MAP ? W : MAP, H < MAP ? H : MAP);
            fail_count++;
        end
    endtask

    // ── test suite ─────────────────────────────────────────────────────────

    initial begin
        $dumpfile("sim/waves/tb_border_coord_generator.vcd");
        $dumpvars(0, tb_border_coord_generator);

        pass_count = 0; fail_count = 0; test_count = 0;
        rst = 1; rst_start = 0;
        all_left_flag = 0; all_top_flag = 0;
        top_left_x = 0; top_left_y = 0;
        width_pixels_x = 0; width_pixels_y = 0;
        repeat(4) @(posedge clk);
        rst = 0;

        // ── 16/17 group  (scheduler zoom≈2: normal_width=16) ──────────────
        run_test(16, 16, 1, 1, "16x16  al=1 at=1");
        run_test(17, 17, 0, 0, "17x17  al=0 at=0");
        run_test(16, 17, 1, 0, "16x17  al=1 at=0");
        run_test(17, 16, 0, 1, "17x16  al=0 at=1");

        // ── 32/33 group  (scheduler zoom≈1: normal_width=32) ──────────────
        run_test(32, 32, 1, 1, "32x32  al=1 at=1");
        run_test(33, 33, 0, 0, "33x33  al=0 at=0");
        run_test(32, 33, 1, 0, "32x33  al=1 at=0");
        run_test(33, 32, 0, 1, "33x32  al=0 at=1");

        // ── 64/65 group  (scheduler zoom≈0: normal_width=64) ──────────────
        run_test(64, 64, 1, 1, "64x64  al=1 at=1");
        run_test(65, 65, 0, 0, "65x65  al=0 at=0");
        run_test(64, 65, 1, 0, "64x65  al=1 at=0");
        run_test(65, 64, 0, 1, "65x64  al=0 at=1");

        // ── 126/127 group  (user-specified) ───────────────────────────────
        run_test(126, 126, 1, 1, "126x126 al=1 at=1");
        run_test(127, 127, 0, 0, "127x127 al=0 at=0");
        run_test(126, 127, 1, 0, "126x127 al=1 at=0");
        run_test(127, 126, 0, 1, "127x126 al=0 at=1");

        // ── 128/129 group  (first-split level: normal_width=128) ──────────
        run_test(128, 128, 1, 1, "128x128 al=1 at=1");
        run_test(129, 129, 0, 0, "129x129 al=0 at=0");
        run_test(128, 129, 1, 0, "128x129 al=1 at=0");
        run_test(129, 128, 0, 1, "129x128 al=0 at=1");

        // ── 256x256  (root-level box, both flags high) ─────────────────────
        run_test(256, 256, 1, 1, "256x256 al=1 at=1");

        $display("");
        $display("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        $display("  Results: %0d/%0d passed", pass_count, test_count);
        if (fail_count == 0)
            $display("  ALL TESTS PASSED");
        $display("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        $finish;
    end

endmodule
