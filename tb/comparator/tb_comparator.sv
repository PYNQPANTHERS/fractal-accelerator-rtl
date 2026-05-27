// tb_comparator.sv
// Testbench for comparator.sv
`timescale 1ns/1ps

module tb_comparator;

    // Test infrastructure
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

    // Clock
    localparam int CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;

    task automatic tick(input int n = 1);
        repeat(n) @(posedge clk);
        #1;
    endtask

    // DUT signals
    logic        rst;
    logic        sched_reset;
    logic [8:0]  top_left_x, top_left_y, quad_size;
    logic [10:0] expected_count;
    logic        comp_valid;
    logic [21:0] comp_data;
    logic        comp_pop;
    logic        differ, complete;

    comparator u_comp (
        .clk           (clk),
        .rst           (rst),
        .sched_reset   (sched_reset),
        .top_left_x    (top_left_x),
        .top_left_y    (top_left_y),
        .quad_size     (quad_size),
        .expected_count(expected_count),
        .comp_valid    (comp_valid),
        .comp_data     (comp_data),
        .comp_pop      (comp_pop),
        .differ        (differ),
        .complete      (complete)
    );

    // Helpers

    // Pack an entry and present it as valid for one cycle
    task automatic feed(input logic [8:0] x, y, input logic [3:0] col);
        comp_data  = { col, y, x };
        comp_valid = 1;
        tick(1);
        comp_valid = 0;
    endtask

    // Configure comparator for a new quad
    task automatic load_quad(
        input logic [8:0]  tlx, tly, qsize,
        input logic [10:0] exp_count
    );
        top_left_x    = tlx;
        top_left_y    = tly;
        quad_size     = qsize;
        expected_count = exp_count;
        sched_reset   = 1;
        tick(1);
        sched_reset   = 0;
        tick(1);
    endtask

    task automatic hard_reset();
        rst = 1; tick(2); rst = 0; tick(1);
    endtask

    // Tests
    initial begin
        $dumpfile("sim/waves/tb_comparator.vcd");
        $dumpvars(0, tb_comparator);

        // Init
        rst=0; sched_reset=0; comp_valid=0; comp_data=0;
        top_left_x=0; top_left_y=0; quad_size=0; expected_count=0;

        suite("RESET — hard reset clears all state");
        hard_reset();
        check(!differ,   "differ low on reset");
        check(!complete, "complete low on reset");
        check(!comp_pop, "comp_pop low when no valid data");

        suite("RESET — sched_reset clears state");
        hard_reset();
        // manually force differ high by feeding mismatched colours
        load_quad(9'd0, 9'd0, 9'd4, 11'd4);
        feed(9'd0, 9'd0, 4'hA);
        feed(9'd1, 9'd0, 4'hB);
        tick(1);
        check(differ, "differ latched before sched_reset");
        load_quad(9'd0, 9'd0, 9'd4, 11'd4);
        check(!differ,   "differ cleared by sched_reset");
        check(!complete, "complete cleared by sched_reset");

        suite("BOUNDS — in-bounds entry is processed");
        hard_reset();
        load_quad(9'd10, 9'd10, 9'd8, 11'd1);
        feed(9'd10, 9'd10, 4'hC); // exactly top-left corner
        tick(1);
        check(!differ, "no differ for single in-bounds entry (becomes reference)");

        suite("BOUNDS — out-of-bounds entry is discarded");
        hard_reset();
        load_quad(9'd10, 9'd10, 9'd8, 11'd2);
        feed(9'd5, 9'd5, 4'hA);   // out of bounds — sets nothing
        tick(1);
        check(!differ,   "differ not set by out-of-bounds entry");
        check(!complete, "complete not set by out-of-bounds entry");
        // feed one valid in-bounds entry — should become reference (not trigger differ)
        feed(9'd10, 9'd10, 4'hA);
        tick(1);
        check(!differ, "in-bounds after OOB correctly becomes reference");

        suite("BOUNDS — out-of-bounds after reference does not affect differ");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd4, 11'd2);
        feed(9'd0, 9'd0, 4'hA); // reference = A
        feed(9'd9, 9'd9, 4'hB); // OOB — different colour but should not differ
        tick(1);
        check(!differ, "OOB entry with different colour does not set differ");

        suite("BOUNDS — corner cases of bounding box");
        hard_reset();
        // quad from (5,5) size 4 covers x=[5..8], y=[5..8]
        load_quad(9'd5, 9'd5, 9'd4, 11'd4);
        feed(9'd5, 9'd5, 4'h1); // top-left corner — in
        feed(9'd8, 9'd5, 4'h1); // top-right corner — in (5+4-1=8)
        feed(9'd5, 9'd8, 4'h1); // bottom-left — in
        feed(9'd8, 9'd8, 4'h1); // bottom-right — in
        tick(1);
        check(!differ,  "all four corners in-bounds, same colour — no differ");
        check(complete, "complete after 4 in-bounds entries with expected=4");

        suite("BOUNDS — one pixel outside boundary");
        hard_reset();
        load_quad(9'd5, 9'd5, 9'd4, 11'd1);
        feed(9'd9, 9'd5, 4'h1); // x=9 is one past boundary (5+4=9, exclusive)
        tick(1);
        check(!differ,   "x=top_left+quad_size is out of bounds");
        check(!complete, "complete not set — OOB entry not counted");

        suite("COLOUR — first entry becomes reference, no differ");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd16, 11'd3);
        feed(9'd0, 9'd0, 4'h7);
        tick(1);
        check(!differ, "first entry sets reference — no differ");

        suite("COLOUR — matching colours do not set differ");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd16, 11'd4);
        feed(9'd0,  9'd0,  4'h5);
        feed(9'd1,  9'd0,  4'h5);
        feed(9'd2,  9'd0,  4'h5);
        feed(9'd3,  9'd0,  4'h5);
        tick(1);
        check(!differ, "four identical colours — no differ");

        suite("COLOUR — mismatch sets differ immediately");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd16, 11'd4);
        feed(9'd0, 9'd0, 4'hA); // reference = A
        feed(9'd1, 9'd0, 4'hB); // mismatch
        tick(1);
        check(differ, "differ set immediately on first mismatch");

        suite("COLOUR — differ latches and stays high");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd16, 11'd4);
        feed(9'd0, 9'd0, 4'hA);
        feed(9'd1, 9'd0, 4'hB); // triggers differ
        feed(9'd2, 9'd0, 4'hA); // back to reference colour
        feed(9'd3, 9'd0, 4'hA);
        tick(1);
        check(differ, "differ stays latched even after matching entries follow");

        suite("COLOUR — mismatch on last entry still sets differ");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd16, 11'd3);
        feed(9'd0, 9'd0, 4'h3);
        feed(9'd1, 9'd0, 4'h3);
        feed(9'd2, 9'd0, 4'hF); // mismatch on last
        tick(1);
        check(differ, "differ set on last entry mismatch");

        suite("COMPLETE — asserts when seen == expected");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd16, 11'd4);
        feed(9'd0, 9'd0, 4'h2);
        feed(9'd1, 9'd0, 4'h2);
        feed(9'd2, 9'd0, 4'h2);
        check(!complete, "complete not yet after 3 of 4");
        feed(9'd3, 9'd0, 4'h2);
        tick(1);
        check(complete, "complete asserts after 4th entry");

        suite("COMPLETE — latches and stays high after asserting");
        tick(5);
        check(complete, "complete stays latched after asserting");

        suite("COMPLETE — differ and complete can both be high");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd16, 11'd3);
        feed(9'd0, 9'd0, 4'hA);
        feed(9'd1, 9'd0, 4'hB); // differ
        feed(9'd2, 9'd0, 4'hA); // complete
        tick(1);
        check(differ,   "differ asserted");
        check(complete, "complete asserted simultaneously with differ");

        suite("COMPLETE — expected_count=1 completes on first entry");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd16, 11'd1);
        feed(9'd0, 9'd0, 4'h9);
        tick(1);
        check(complete, "complete after single entry when expected=1");
        check(!differ,  "no differ for single entry");

        suite("COMP_POP — asserts whenever comp_valid high");
        hard_reset();
        load_quad(9'd0, 9'd0, 9'd16, 11'd2);
        comp_valid = 1; comp_data = {4'h1, 9'd0, 9'd0};
        tick(0); // combinational — check before clock edge
        check(comp_pop, "comp_pop asserts combinationally when comp_valid high");
        tick(1);
        comp_valid = 0;
        check(!comp_pop, "comp_pop deasserts when comp_valid low");

        suite("COMP_POP — out-of-bounds entries still consumed");
        hard_reset();
        load_quad(9'd10, 9'd10, 9'd4, 11'd1);
        comp_valid = 1; comp_data = {4'hF, 9'd0, 9'd0}; // OOB
        tick(0);
        check(comp_pop, "comp_pop fires for OOB entry — entry consumed");
        tick(1); comp_valid = 0;

        suite("MULTI-QUAD — sched_reset correctly transitions between quads");
        hard_reset();
        // Quad 1: 4x4 at (0,0), 4 border pixels, all colour A
        load_quad(9'd0, 9'd0, 9'd4, 11'd4);
        feed(9'd0, 9'd0, 4'hA);
        feed(9'd3, 9'd0, 4'hA);
        feed(9'd0, 9'd3, 4'hA);
        feed(9'd3, 9'd3, 4'hA);
        tick(1);
        check(!differ,  "quad 1: no differ");
        check(complete, "quad 1: complete");
        // Quad 2: 4x4 at (4,0), 4 border pixels, mixed colours
        load_quad(9'd4, 9'd0, 9'd4, 11'd4);
        check(!differ,  "quad 2: differ cleared by sched_reset");
        check(!complete,"quad 2: complete cleared by sched_reset");
        feed(9'd4, 9'd0, 4'hB);
        feed(9'd7, 9'd0, 4'hC); // mismatch
        feed(9'd4, 9'd3, 4'hB);
        feed(9'd7, 9'd3, 4'hB);
        tick(1);
        check(differ,   "quad 2: differ set");
        check(complete, "quad 2: complete set");

        suite("MULTI-QUAD — stale entries from previous quad are discarded");
        hard_reset();
        // Quad 1 at (0,0) size 4
        load_quad(9'd0, 9'd0, 9'd4, 11'd2);
        feed(9'd0, 9'd0, 4'hA); // quad 1 entry
        // Switch to quad 2 at (8,8) before feeding second entry
        load_quad(9'd8, 9'd8, 9'd4, 11'd2);
        // Feed a coordinate that was valid for quad 1 but not quad 2
        feed(9'd0, 9'd0, 4'hF); // OOB for quad 2 — should be discarded
        tick(1);
        check(!differ,   "stale quad-1 entry discarded by quad-2 bounds check");
        check(!complete, "complete not set by discarded entry");
        // Feed a valid quad 2 entry with different colour — should not differ
        // since ref_valid was reset and this becomes the new reference
        feed(9'd8, 9'd8, 4'h1);
        tick(1);
        check(!differ, "first valid quad-2 entry becomes reference — no differ");

        summary();
        $finish;
    end

    // Watchdog
    initial begin
        #1000000;
        $display("\n[TIMEOUT] simulation exceeded limit");
        $finish;
    end

endmodule