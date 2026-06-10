// tb_comparator.sv — comparator testbench
// Coordinates and comp_data use 8-bit x/y to match the parameterised
// comparator (COORD_W=8). The comp_data bus is 20 bits: {colour[3:0], y[7:0], x[7:0]}.
`timescale 1ns/1ps

module tb_comparator;

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

    // DUT signals — all widths match comparator (COORD_W=8)
    logic        rst;
    logic        sched_reset;
    logic [7:0]  top_left_x, top_left_y, quad_size;  // 8-bit coords
    logic [10:0] expected_count;
    logic        comp_valid;
    logic [19:0] comp_data;   // { colour[3:0], y[7:0], x[7:0] }
    logic        comp_pop;
    logic [5:0]  ref_colour_o;
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
        .ref_colour_o  (ref_colour_o),
        .differ        (differ),
        .complete      (complete)
    );

    // Feed one pixel result to the comparator for one clock cycle.
    // comp_data = { colour[3:0], y[7:0], x[7:0] }
    task automatic feed(input logic [7:0] x, y, input logic [3:0] col);
        comp_data  = { col, y, x };
        comp_valid = 1;
        $display("    feed: x=%0d y=%0d col=%0h", x, y, col);
        tick(1);
        comp_valid = 0;
    endtask

    // Configure comparator for a new quad and pulse sched_reset.
    task automatic load_quad(
        input logic [7:0]  tlx, tly, qsize,
        input logic [10:0] exp_count
    );
        top_left_x    = tlx;
        top_left_y    = tly;
        quad_size     = qsize;
        expected_count = exp_count;
        sched_reset   = 1;
        $display("    load_quad: tlx=%0d tly=%0d sz=%0d exp=%0d",
                  tlx, tly, qsize, exp_count);
        tick(1);
        sched_reset   = 0;
        tick(1);
    endtask

    task automatic hard_reset();
        rst = 1; tick(2); rst = 0; tick(1);
        $display("    hard_reset done");
    endtask

    // ── Tests ────────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("sim/waves/tb_comparator.vcd");
        $dumpvars(0, tb_comparator);

        // Init
        rst=0; sched_reset=0; comp_valid=0; comp_data=0;
        top_left_x=0; top_left_y=0; quad_size=0; expected_count=0;

        // ── RESET ────────────────────────────────────────────────────────────
        suite("RESET — hard reset clears all state");
        hard_reset();
        $display("    State after reset: differ=%b complete=%b comp_pop=%b",
                  differ, complete, comp_pop);
        check(!differ,   "differ low on reset");
        check(!complete, "complete low on reset");
        check(!comp_pop, "comp_pop low when no valid data");

        suite("RESET — sched_reset clears differ and complete");
        hard_reset();
        // Force differ high: feed two mismatched entries
        load_quad(8'd0, 8'd0, 8'd16, 11'd4);
        feed(8'd0, 8'd0, 4'hA);
        feed(8'd1, 8'd0, 4'hB);   // mismatch — differ should latch
        tick(1);
        $display("    Before sched_reset: differ=%b complete=%b", differ, complete);
        check(differ, "differ latched before sched_reset");
        load_quad(8'd0, 8'd0, 8'd16, 11'd4);
        $display("    After sched_reset:  differ=%b complete=%b", differ, complete);
        check(!differ,   "differ cleared by sched_reset");
        check(!complete, "complete cleared by sched_reset");

        // ── BOUNDS ───────────────────────────────────────────────────────────
        suite("BOUNDS — in-bounds entry is processed");
        hard_reset();
        load_quad(8'd10, 8'd10, 8'd8, 11'd1);
        $display("    Quad: tlx=10 tly=10 sz=8 covers x=[10..17] y=[10..17]");
        feed(8'd10, 8'd10, 4'hC);   // top-left corner — should become reference
        tick(1);
        $display("    After corner feed: differ=%b complete=%b ref=%0h",
                  differ, complete, ref_colour_o);
        check(!differ, "no differ for single in-bounds entry (becomes reference)");

        suite("BOUNDS — out-of-bounds entry is discarded");
        hard_reset();
        load_quad(8'd10, 8'd10, 8'd8, 11'd2);
        $display("    Feeding OOB entry (5,5) — outside quad (10,10)+8");
        feed(8'd5, 8'd5, 4'hA);     // out of bounds
        tick(1);
        $display("    After OOB: differ=%b complete=%b", differ, complete);
        check(!differ,   "differ not set by out-of-bounds entry");
        check(!complete, "complete not set by out-of-bounds entry");
        feed(8'd10, 8'd10, 4'hA);   // valid, becomes reference
        tick(1);
        check(!differ, "in-bounds after OOB correctly becomes reference");

        suite("BOUNDS — out-of-bounds after reference does not affect differ");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd4, 11'd2);
        $display("    Quad: tlx=0 tly=0 sz=4 covers x=[0..3] y=[0..3]");
        feed(8'd0, 8'd0, 4'hA);     // reference = A
        feed(8'd9, 8'd9, 4'hB);     // OOB — different colour but must not trigger differ
        tick(1);
        $display("    After OOB with different colour: differ=%b", differ);
        check(!differ, "OOB entry with different colour does not set differ");

        suite("BOUNDS — all four corners of bounding box");
        hard_reset();
        // Quad from (5,5) size=4: covers x=[5..8], y=[5..8]
        // Border pixel count for a 4x4 quad = 4*4 - 4 = 12
        load_quad(8'd5, 8'd5, 8'd4, 11'd4);
        $display("    Quad: tlx=5 tly=5 sz=4 covers x=[5..8] y=[5..8]; expected_count=4");
        feed(8'd5, 8'd5, 4'h1);     // top-left
        feed(8'd8, 8'd5, 4'h1);     // top-right  (5+4-1=8)
        feed(8'd5, 8'd8, 4'h1);     // bottom-left
        feed(8'd8, 8'd8, 4'h1);     // bottom-right
        tick(1);
        $display("    After 4 corner feeds: differ=%b complete=%b", differ, complete);
        check(!differ,  "all four corners in-bounds, same colour — no differ");
        check(complete, "complete after 4 in-bounds entries with expected=4");

        suite("BOUNDS — one pixel exactly at boundary (exclusive)");
        hard_reset();
        load_quad(8'd5, 8'd5, 8'd4, 11'd1);
        $display("    Feeding x=%0d (= tlx+sz, exclusive upper bound) — should be OOB", 5+4);
        feed(8'd9, 8'd5, 4'h1);     // x=9 = 5+4, which is out of [5..8]
        tick(1);
        $display("    After OOB boundary pixel: differ=%b complete=%b", differ, complete);
        check(!differ,   "x=top_left+quad_size is out of bounds (exclusive)");
        check(!complete, "complete not set — OOB entry not counted");

        // ── COLOUR ───────────────────────────────────────────────────────────
        suite("COLOUR — first entry becomes reference, no differ");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd16, 11'd3);
        feed(8'd0, 8'd0, 4'h7);
        tick(1);
        $display("    ref_colour_o=%0h differ=%b", ref_colour_o, differ);
        check(!differ, "first entry sets reference — no differ");

        suite("COLOUR — matching colours do not set differ");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd16, 11'd4);
        feed(8'd0,  8'd0,  4'h5);
        feed(8'd1,  8'd0,  4'h5);
        feed(8'd2,  8'd0,  4'h5);
        feed(8'd3,  8'd0,  4'h5);
        tick(1);
        $display("    Four identical-colour feeds: differ=%b", differ);
        check(!differ, "four identical colours — no differ");

        suite("COLOUR — mismatch sets differ, registered on next cycle");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd16, 11'd4);
        feed(8'd0, 8'd0, 4'hA);   // reference = A
        feed(8'd1, 8'd0, 4'hB);   // mismatch — differ registered after this tick
        // differ latches in the FF at the posedge inside feed; check after one more cycle
        tick(1);
        $display("    After mismatch + 1 extra tick: differ=%b", differ);
        check(differ, "differ set on first mismatch");

        suite("COLOUR — differ latches and stays high");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd16, 11'd4);
        feed(8'd0, 8'd0, 4'hA);
        feed(8'd1, 8'd0, 4'hB);   // triggers differ
        feed(8'd2, 8'd0, 4'hA);   // back to reference colour — should not clear differ
        feed(8'd3, 8'd0, 4'hA);
        tick(1);
        $display("    After matching entries after mismatch: differ=%b", differ);
        check(differ, "differ stays latched even after matching entries follow");

        suite("COLOUR — mismatch on last entry still sets differ");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd16, 11'd3);
        feed(8'd0, 8'd0, 4'h3);
        feed(8'd1, 8'd0, 4'h3);
        feed(8'd2, 8'd0, 4'hF);   // mismatch on last entry
        // differ is registered on the posedge inside the last feed(); already committed
        tick(1);
        $display("    After last-entry mismatch + tick: differ=%b complete=%b",
                  differ, complete);
        check(differ,   "differ set on last entry mismatch");
        check(complete, "complete also set (all 3 entries seen)");

        // ── COMPLETE ─────────────────────────────────────────────────────────
        suite("COMPLETE — asserts when seen == expected");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd16, 11'd4);
        feed(8'd0, 8'd0, 4'h2);
        feed(8'd1, 8'd0, 4'h2);
        feed(8'd2, 8'd0, 4'h2);
        $display("    After 3 of 4 feeds: complete=%b", complete);
        check(!complete, "complete not yet after 3 of 4");
        feed(8'd3, 8'd0, 4'h2);   // 4th entry — complete registers on this posedge
        tick(1);                   // wait one more cycle for FF to update
        $display("    After 4th feed + tick: complete=%b", complete);
        check(complete, "complete asserts after 4th entry");

        suite("COMPLETE — latches and stays high");
        tick(5);
        $display("    After 5 more ticks: complete=%b", complete);
        check(complete, "complete stays latched after asserting");

        suite("COMPLETE — differ and complete can both be high simultaneously");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd16, 11'd3);
        feed(8'd0, 8'd0, 4'hA);
        feed(8'd1, 8'd0, 4'hB);   // differ
        feed(8'd2, 8'd0, 4'hA);   // 3rd entry — complete
        tick(1);
        $display("    differ=%b complete=%b (both should be high)", differ, complete);
        check(differ,   "differ asserted");
        check(complete, "complete asserted simultaneously with differ");

        suite("COMPLETE — expected_count=1 completes on first entry");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd16, 11'd1);
        feed(8'd0, 8'd0, 4'h9);
        tick(1);
        $display("    Single-entry complete: complete=%b differ=%b", complete, differ);
        check(complete, "complete after single entry when expected=1");
        check(!differ,  "no differ for single entry");

        // ── COMP_POP ─────────────────────────────────────────────────────────
        suite("COMP_POP — asserts combinationally when comp_valid high");
        hard_reset();
        load_quad(8'd0, 8'd0, 8'd16, 11'd2);
        comp_valid = 1; comp_data = {4'h1, 8'd0, 8'd0};
        #1;  // combinational settle — no clock edge
        $display("    comp_valid=1: comp_pop=%b (should be 1 combinationally)", comp_pop);
        check(comp_pop, "comp_pop asserts combinationally when comp_valid high");
        tick(1);
        comp_valid = 0;
        #1;
        $display("    comp_valid=0: comp_pop=%b (should be 0)", comp_pop);
        check(!comp_pop, "comp_pop deasserts when comp_valid low");

        suite("COMP_POP — out-of-bounds entries still consumed");
        hard_reset();
        load_quad(8'd10, 8'd10, 8'd4, 11'd1);
        comp_valid = 1; comp_data = {4'hF, 8'd0, 8'd0};  // OOB x=0,y=0
        #1;
        $display("    OOB entry: comp_pop=%b (should still be 1)", comp_pop);
        check(comp_pop, "comp_pop fires for OOB entry — entry consumed regardless");
        tick(1); comp_valid = 0;

        // ── MULTI-QUAD ───────────────────────────────────────────────────────
        suite("MULTI-QUAD — sched_reset correctly transitions between quads");
        hard_reset();
        // Quad 1: 4x4 at (0,0), expected_count=4 (just testing 4 corner entries)
        load_quad(8'd0, 8'd0, 8'd4, 11'd4);
        $display("    Quad 1: tlx=0 tly=0 sz=4");
        feed(8'd0, 8'd0, 4'hA);
        feed(8'd3, 8'd0, 4'hA);
        feed(8'd0, 8'd3, 4'hA);
        feed(8'd3, 8'd3, 4'hA);
        tick(1);
        $display("    Quad 1 result: differ=%b complete=%b", differ, complete);
        check(!differ,  "quad 1: no differ");
        check(complete, "quad 1: complete");
        // Quad 2: 4x4 at (4,0), mixed colours
        load_quad(8'd4, 8'd0, 8'd4, 11'd4);
        $display("    Quad 2: tlx=4 tly=0 sz=4 (after sched_reset)");
        $display("    State immediately after sched_reset: differ=%b complete=%b",
                  differ, complete);
        check(!differ,  "quad 2: differ cleared by sched_reset");
        check(!complete,"quad 2: complete cleared by sched_reset");
        feed(8'd4, 8'd0, 4'hB);
        feed(8'd7, 8'd0, 4'hC);   // mismatch
        feed(8'd4, 8'd3, 4'hB);
        feed(8'd7, 8'd3, 4'hB);
        tick(1);
        $display("    Quad 2 result: differ=%b complete=%b", differ, complete);
        check(differ,   "quad 2: differ set");
        check(complete, "quad 2: complete set");

        suite("MULTI-QUAD — stale entries from previous quad are discarded");
        hard_reset();
        // Quad 1 at (0,0) size 4
        load_quad(8'd0, 8'd0, 8'd4, 11'd2);
        feed(8'd0, 8'd0, 4'hA);   // quad 1 entry — becomes reference for q1
        // Switch to quad 2 at (8,8) before feeding second entry
        load_quad(8'd8, 8'd8, 8'd4, 11'd2);
        $display("    Switched to quad 2 (8,8); feeding stale quad-1 coord (0,0)");
        // Feed a coordinate valid for quad 1 but OOB for quad 2 — must be discarded
        feed(8'd0, 8'd0, 4'hF);
        tick(1);
        $display("    After stale entry: differ=%b complete=%b", differ, complete);
        check(!differ,   "stale quad-1 entry discarded by quad-2 bounds check");
        check(!complete, "complete not set by discarded entry");
        // Feed a valid quad-2 entry — ref_valid was reset so this becomes the new ref
        feed(8'd8, 8'd8, 4'h1);
        tick(1);
        $display("    After first valid quad-2 entry: differ=%b", differ);
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
