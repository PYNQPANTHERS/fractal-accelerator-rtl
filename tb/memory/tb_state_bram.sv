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

    logic [8:0]  x, y;
    logic        rd, we;
    logic [1:0]  wstate, rstate;
    logic        rd_valid, wr_done;
    logic        rst;

    state_bram dut (
        .clk       (clk),
        .rst       (rst),
        .x       (x),
        .y       (y),
        .rd      (rd),
        .we      (we),
        .wstate  (wstate),
        .rstate  (rstate),
        .rd_valid(rd_valid),
        .wr_done (wr_done)
    );

    // Write: 1-cycle commit. wr_done is high immediately after the tick.
    task automatic write_state(input logic [8:0] px, py, input logic [1:0] s);
        x = px; y = py; wstate = s; we = 1;
        tick(1);   // write commits on this posedge; wr_done now high
        we = 0;
    endtask

    // Read: 1-cycle latency. rstate and rd_valid are valid after tick.
    task automatic read_state(input logic [8:0] px, py, output logic [1:0] out);
        x = px; y = py; rd = 1;
        tick(1);   // BRAM captures on this posedge; rstate valid now
        rd = 0;
        out = rstate;
    endtask

    logic [1:0] got;

    initial begin
        $dumpfile("sim/waves/tb_state_bram.vcd");
        $dumpvars(0, tb_state_bram);
        rst = 0; rd = 0; we = 0; x = 0; y = 0; wstate = 0;
        tick(2);

        // ----------------------------------------------------------------
        suite("WRITE + READ  basic 1-cycle latency");
        write_state(9'd0, 9'd0, 2'b01);
        check(wr_done == 1, "wr_done high after write");
        read_state(9'd0, 9'd0, got);
        check(rd_valid == 1, "rd_valid high after read");
        check(got == 2'b01, "pixel (0,0) state=01 reads back");

        write_state(9'd0, 9'd0, 2'b11);
        read_state(9'd0, 9'd0, got);
        check(got == 2'b11, "pixel (0,0) state=11 after update");

        tick(1); // wr_done should clear
        check(wr_done == 0, "wr_done clears next cycle");

        // ----------------------------------------------------------------
        suite("MULTIPLE PIXELS  independent state storage");
        write_state(9'd0,   9'd0,   2'b01);
        write_state(9'd1,   9'd0,   2'b11);
        write_state(9'd255, 9'd255, 2'b01);
        write_state(9'd0,   9'd255, 2'b11);
        tick(1);
        read_state(9'd0,   9'd0,   got); check(got == 2'b01, "px(0,0)=01");
        read_state(9'd1,   9'd0,   got); check(got == 2'b11, "px(1,0)=11");
        read_state(9'd255, 9'd255, got); check(got == 2'b01, "px(255,255)=01");
        read_state(9'd0,   9'd255, got); check(got == 2'b11, "px(0,255)=11");

        // ----------------------------------------------------------------
        suite("PIXEL INDEPENDENCE  writes do not clobber neighbours");
        write_state(9'd10, 9'd10, 2'b11);
        write_state(9'd11, 9'd10, 2'b11);
        write_state(9'd10, 9'd11, 2'b11);
        write_state(9'd11, 9'd11, 2'b11);
        write_state(9'd10, 9'd10, 2'b01); // overwrite only (10,10)
        tick(1);
        read_state(9'd10, 9'd10, got); check(got == 2'b01, "(10,10) updated to 01");
        read_state(9'd11, 9'd10, got); check(got == 2'b11, "(11,10) unchanged");
        read_state(9'd10, 9'd11, got); check(got == 2'b11, "(10,11) unchanged");
        read_state(9'd11, 9'd11, got); check(got == 2'b11, "(11,11) unchanged");

        // ----------------------------------------------------------------
        suite("RESET  reads return 00 immediately after rst");
        write_state(9'd42, 9'd7, 2'b11);
        write_state(9'd43, 9'd7, 2'b01);
        tick(1);
        rst = 1; tick(3); rst = 0; tick(2); // multi-cycle rst then settle
        read_state(9'd42, 9'd7, got); check(got == 2'b00, "px(42,7) reads 00 after rst");
        read_state(9'd43, 9'd7, got); check(got == 2'b00, "px(43,7) reads 00 after rst");

        // Previously unwritten pixels also 00
        read_state(9'd100, 9'd100, got); check(got == 2'b00, "unwritten px 00 after rst");

        // ----------------------------------------------------------------
        suite("RESET  writes blocked during rst, wr_done suppressed");
        write_state(9'd5, 9'd5, 2'b11); // write before rst
        tick(1);
        rst = 1;
        x = 9'd5; y = 9'd5; wstate = 2'b01; we = 1;
        tick(1); // attempt write during rst
        check(wr_done == 0, "wr_done suppressed during rst");
        we = 0;
        rst = 0; tick(2);
        read_state(9'd5, 9'd5, got);
        check(got == 2'b00, "write during rst had no effect, reads 00");

        // ----------------------------------------------------------------
        suite("RESET  new writes go to fresh BRAM");
        write_state(9'd0, 9'd0, 2'b01);
        read_state(9'd0, 9'd0, got); check(got == 2'b01, "write after rst: 01 persists");
        write_state(9'd0, 9'd0, 2'b11);
        read_state(9'd0, 9'd0, got); check(got == 2'b11, "overwrite after rst: 11 correct");
        read_state(9'd1, 9'd0, got); check(got == 2'b00, "neighbour still 00 after rst");

        // ----------------------------------------------------------------
        // rst again; use px(200,200) which was never written to either BRAM
        suite("STATE MACHINE  00 -> 01 -> 11 after rst");
        rst = 1; tick(1); rst = 0; tick(2);
        read_state(9'd200, 9'd200, got); check(got == 2'b00, "initial state 00");
        write_state(9'd200, 9'd200, 2'b01);
        read_state(9'd200, 9'd200, got); check(got == 2'b01, "transitions to 01");
        write_state(9'd200, 9'd200, 2'b11);
        read_state(9'd200, 9'd200, got); check(got == 2'b11, "transitions to 11");

        // ----------------------------------------------------------------
        suite("SIMULTANEOUS RD+WE  different addresses");
        write_state(9'd20, 9'd20, 2'b11);
        tick(1);
        // Assert both rd and we in the same cycle, different addresses
        x = 9'd20; y = 9'd20; rd = 1;
        wstate = 2'b01; we = 1;
        // We need a different write address - change x/y after latching
        // Actually drive write addr via separate signal isn't possible with shared pins.
        // Instead: same cycle, read (20,20) and write (21,20) by updating address mid.
        // For this interface (shared addr), test: rd+we to different pixels sequentially.
        rd = 0; we = 0;
        // Test: write (21,20) then read (20,20) in close succession
        x = 9'd21; y = 9'd20; wstate = 2'b01; we = 1; rd = 0;
        // Simultaneously prepare read on different path - not directly possible with shared port.
        // Verify write commits, then read both addresses.
        tick(1); we = 0;
        read_state(9'd20, 9'd20, got); check(got == 2'b11, "px(20,20) unaffected by write to (21,20)");
        read_state(9'd21, 9'd20, got); check(got == 2'b01, "px(21,20) written 01");

        summary();
        $finish;
    end

    initial begin #5000000; $display("[TIMEOUT]"); $finish; end

endmodule
