`timescale 1ns/1ps

module tb_border_coord_generator;

    localparam int N       = 10;
    localparam int HALF    = 5;
    localparam int TIMEOUT = 25000;

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

    localparam int MAP = 512;
    bit seen [0:MAP-1][0:MAP-1];

    integer pass_count, fail_count, test_count;

    // ── helpers ────────────────────────────────────────────────────────────

    function automatic bit is_border(integer x, integer y, integer W, integer H);
        if (x < 0 || x >= W || y < 0 || y >= H) return 0;
        return (x == 0) || (x == W-1) || (y == 0) || (y == H-1);
    endfunction

    task automatic clear_seen(input integer W, H);
        integer i, j;
        for (i = 0; i < W && i < MAP; i++)
            for (j = 0; j < H && j < MAP; j++)
                seen[i][j] = 0;
    endtask

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

        @(negedge clk);
        rst = 1; rst_start = 0;
        @(negedge clk);
        rst = 0;

        top_left_x      = '0;
        top_left_y      = '0;
        width_pixels_x  = N'(W);
        width_pixels_y  = N'(H);
        all_left_flag   = al;
        all_top_flag    = at;
        @(negedge clk);

        clear_seen(W < MAP ? W : MAP, H < MAP ? H : MAP);
        bad         = 0;
        dups        = 0;
        found_done  = 0;
        prev_done   = 0;
        timeout_ctr = 0;

        $display("\n--- BEGIN %s (W=%0d H=%0d al=%0b at=%0b) ---", label, W, H, al, at);
        $display("%-6s %-8s %-6s %-6s %-6s %-6s %-8s %-10s %-12s",
                 "cycle", "state", "x", "y", "tmp", "mid", "1st_rnd", "last_cyc", "done");

        rst_start = 1;
        @(negedge clk);
        rst_start = 0;

        @(posedge clk); #1;
        while (!found_done && timeout_ctr < TIMEOUT) begin
            cx = int'(x_coord);
            cy = int'(y_coord);

            // Per-cycle trace
            $display("%-6d %-8s %-6d %-6d %-6d %-6d %-8b %-10b %-12b",
                     timeout_ctr,
                     dut.current_state.name(),
                     cx, cy,
                     int'(dut.tmp),
                     int'(dut.midpoint),
                     dut.first_round,
                     dut.last_cycle,
                     done_flag);

            if (!is_border(cx, cy, W, H)) begin
                bad++;
                $display("       *** NON-BORDER pixel (%0d,%0d) ***", cx, cy);
            end else if (cx < MAP && cy < MAP) begin
                if (seen[cx][cy]) begin
                    dups++;
                    $display("       *** DUPLICATE pixel (%0d,%0d) ***", cx, cy);
                end
                seen[cx][cy] = 1;
            end

            if (!prev_done && (done_flag === 1'b1))
                found_done = 1;
            prev_done = (done_flag === 1'b1);

            if (!found_done) begin
                @(posedge clk); #1;
            end
            timeout_ctr++;
        end

        test_count++;
        expected   = 2*W + 2*(H - 2);
        got_unique = unique_border(W < MAP ? W : MAP, H < MAP ? H : MAP);

        $display("--- END %s ---", label);

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

        // ── Active tests ───────────────────────────────────────────────────
        run_test(16, 16, 1, 1, "16x16  al=1 at=1");
        run_test(17, 17, 0, 0, "17x17  al=0 at=0");

        // ── Commented out tests ────────────────────────────────────────────
        // run_test(16, 17, 1, 0, "16x17  al=1 at=0");
        // run_test(17, 16, 0, 1, "17x16  al=0 at=1");
        // run_test(32, 32, 1, 1, "32x32  al=1 at=1");
        // run_test(33, 33, 0, 0, "33x33  al=0 at=0");
        // run_test(32, 33, 1, 0, "32x33  al=1 at=0");
        // run_test(33, 32, 0, 1, "33x32  al=0 at=1");
        // run_test(64, 64, 1, 1, "64x64  al=1 at=1");
        // run_test(65, 65, 0, 0, "65x65  al=0 at=0");
        // run_test(64, 65, 1, 0, "64x65  al=1 at=0");
        // run_test(65, 64, 0, 1, "65x64  al=0 at=1");
        // run_test(128, 128, 1, 1, "128x128 al=1 at=1 (2)");
        // run_test(129, 129, 0, 0, "129x129 al=0 at=0 (2)");
        // run_test(128, 129, 1, 0, "128x129 al=1 at=0 (2)");
        // run_test(129, 128, 0, 1, "129x128 al=0 at=1 (2)");
        // run_test(128, 128, 1, 1, "128x128 al=1 at=1");
        // run_test(129, 129, 0, 0, "129x129 al=0 at=0");
        // run_test(128, 129, 1, 0, "128x129 al=1 at=0");
        // run_test(129, 128, 0, 1, "129x128 al=0 at=1");
        // run_test(256, 256, 1, 1, "256x256 al=1 at=1");

        $display("");
        $display("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        $display("  Results: %0d/%0d passed", pass_count, test_count);
        if (fail_count == 0)
            $display("  ALL TESTS PASSED");
        $display("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        $finish;
    end

endmodule