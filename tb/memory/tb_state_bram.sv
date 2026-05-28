`timescale 1ns/1ps

module tb_state_bram;

    int tests_run = 0, tests_passed = 0, tests_failed = 0;
    string current_suite = "";

    task automatic suite(input string name);
        current_suite = name;
        $display("\n%0s", {72{"="}});
        $display("  SUITE: %s", name);
        $display("%0s", {72{"="}});
    endtask

    task automatic check(input logic cond, input string desc);
        tests_run++;
        if (cond) begin tests_passed++; $display("  [PASS] %s", desc); end
        else       begin tests_failed++; $display("  [FAIL] %s  (suite: %s)", desc, current_suite); end
    endtask

    task automatic summary();
        $display("\n%0s", {72{"="}});
        $display("  RESULTS: %0d / %0d passed", tests_passed, tests_run);
        if (tests_failed == 0) $display("  ALL TESTS PASSED");
        else $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%0s\n", {72{"="}});
    endtask

    logic       clk = 0;
    always #5 clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    logic [8:0] a_x, a_y;
    logic       a_rd, a_we;
    logic [1:0] a_wstate, a_rstate;
    logic       rst;

    state_bram dut (
        .clk     (clk),
        .rst     (rst),
        .a_x     (a_x),
        .a_y     (a_y),
        .a_rd    (a_rd),
        .a_we    (a_we),
        .a_wstate(a_wstate),
        .a_rstate(a_rstate)
    );

    task automatic write_state(input logic [8:0] x, y, input logic [1:0] s);
        a_x = x; a_y = y; a_wstate = s; a_we = 1; tick(1); a_we = 0;
    endtask

    task automatic read_state(input logic [8:0] x, y, output logic [1:0] out);
        a_x = x; a_y = y; a_rd = 1; tick(1); a_rd = 0; tick(1);
        out = a_rstate;
    endtask

    logic [1:0] got;

    initial begin
        $dumpfile("sim/waves/tb_state_bram.vcd");
        $dumpvars(0, tb_state_bram);
        rst=0; a_rd=0; a_we=0; a_x=0; a_y=0; a_wstate=0;
        tick(2);

        // ============================================================
        suite("WRITE + READ — basic state transitions");
        // ============================================================
        write_state(9'd0, 9'd0, 2'b01);
        read_state(9'd0, 9'd0, got);
        check(got == 2'b01, "pixel (0,0) state=01 reads back");

        write_state(9'd0, 9'd0, 2'b11);
        read_state(9'd0, 9'd0, got);
        check(got == 2'b11, "pixel (0,0) state=11 after update");

        // ============================================================
        suite("PACKING — 4 pixels per byte independent");
        // ============================================================
        // pixels (0,0),(1,0),(2,0),(3,0) share the same packed byte
        write_state(9'd0, 9'd0, 2'b01);
        write_state(9'd1, 9'd0, 2'b11);
        write_state(9'd2, 9'd0, 2'b01);
        write_state(9'd3, 9'd0, 2'b00);
        tick(1);
        read_state(9'd0, 9'd0, got); check(got == 2'b01, "packed px0 = 01");
        read_state(9'd1, 9'd0, got); check(got == 2'b11, "packed px1 = 11");
        read_state(9'd2, 9'd0, got); check(got == 2'b01, "packed px2 = 01");
        read_state(9'd3, 9'd0, got); check(got == 2'b00, "packed px3 = 00");

        // ============================================================
        suite("PACKING — write one slot does not corrupt others");
        // ============================================================
        write_state(9'd0, 9'd0, 2'b11);
        write_state(9'd1, 9'd0, 2'b11);
        write_state(9'd2, 9'd0, 2'b11);
        write_state(9'd3, 9'd0, 2'b11);
        write_state(9'd1, 9'd0, 2'b01); // overwrite only slot 1
        tick(1);
        read_state(9'd0, 9'd0, got); check(got == 2'b11, "slot 0 unchanged");
        read_state(9'd1, 9'd0, got); check(got == 2'b01, "slot 1 updated");
        read_state(9'd2, 9'd0, got); check(got == 2'b11, "slot 2 unchanged");
        read_state(9'd3, 9'd0, got); check(got == 2'b11, "slot 3 unchanged");

        // ============================================================
        suite("TILE BOUNDARY — pixels at tile edges");
        // ============================================================
        write_state(9'd15, 9'd0,  2'b11); // last pixel of tile 0 first row
        write_state(9'd16, 9'd0,  2'b01); // first pixel of tile 1 first row
        write_state(9'd0,  9'd16, 2'b11); // first pixel of tile in row 1
        tick(1);
        read_state(9'd15, 9'd0,  got); check(got == 2'b11, "last px tile 0 row 0");
        read_state(9'd16, 9'd0,  got); check(got == 2'b01, "first px tile 1 row 0");
        read_state(9'd0,  9'd16, got); check(got == 2'b11, "first px tile row 1");

        // ============================================================
        suite("CORNERS — extreme pixel coordinates");
        // ============================================================
        write_state(9'd255, 9'd255, 2'b11);
        read_state(9'd255, 9'd255, got);
        check(got == 2'b11, "pixel (255,255) — bottom right corner");

        write_state(9'd255, 9'd0, 2'b01);
        read_state(9'd255, 9'd0, got);
        check(got == 2'b01, "pixel (255,0) — top right corner");

        write_state(9'd0, 9'd255, 2'b11);
        read_state(9'd0, 9'd255, got);
        check(got == 2'b11, "pixel (0,255) — bottom left corner");

        // ============================================================
        suite("RESET — output register clears on rst");
        // ============================================================
        // Note: BRAM memory contents are NOT cleared by rst (hardware limitation).
        // In real use the sixteenth_controller writes 00 to every address before
        // starting. We test only that rst clears the output register (post_rst flag).
        write_state(9'd10, 9'd10, 2'b11);
        // assert rst — post_rst goes high, next read before any a_rd should return 00
        rst = 1; tick(1); rst = 0;
        // immediately read — post_rst still high so output is 00
        a_x = 9'd10; a_y = 9'd10; a_rd = 1; tick(1); a_rd = 0; tick(0);
        check(a_rstate == 2'b00, "output returns 00 immediately after rst (post_rst gating)");
        // second read — post_rst cleared by first a_rd, now returns real mem value
        a_x = 9'd10; a_y = 9'd10; a_rd = 1; tick(1); a_rd = 0; tick(1);
        check(a_rstate == 2'b11, "second read returns real mem value (11)");

        // ============================================================
        suite("STATE MACHINE — 00 -> 01 -> 11 sequence");
        // ============================================================
        rst = 1; tick(1); rst = 0; tick(1);
        read_state(9'd5, 9'd5, got); check(got == 2'b00, "initial state 00");
        write_state(9'd5, 9'd5, 2'b01);
        read_state(9'd5, 9'd5, got); check(got == 2'b01, "transitions to 01 on queue");
        write_state(9'd5, 9'd5, 2'b11);
        read_state(9'd5, 9'd5, got); check(got == 2'b11, "transitions to 11 on done");

        summary();
        $finish;
    end

    initial begin #2000000; $display("[TIMEOUT]"); $finish; end

endmodule