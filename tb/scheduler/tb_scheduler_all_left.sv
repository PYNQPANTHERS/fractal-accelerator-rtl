// tb_scheduler_all_left.sv
// Self-contained unit test for the scheduler's all_left / all_top logic.
// Mirrors the relevant registers, combinational formula, and stack interactions
// from scheduler.sv without needing the full module.
`timescale 1ns/1ps

module tb_scheduler_all_left;

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
            $display("  [FAIL] %s  [z=%0d b=%0d  al=%b at=%b  pal=%b pat=%b]",
                     desc, zoom_level, box_id,
                     all_left_quadrants, all_top_quadrants,
                     popped_all_left, popped_all_top);
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
    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;

    task automatic tick(input int n = 1);
        repeat(n) @(posedge clk); #1;
    endtask

    // ── state registers (mirroring scheduler always_ff) ───────────────────
    logic       rst;
    logic [3:0] zoom_level;
    logic [1:0] box_id;
    logic       popped_all_left, popped_all_top;

    // ── combinational logic (mirrors scheduler always_comb) ───────────────
    // box layout:  00=top-left  01=top-right  10=bottom-left  11=bottom-right
    logic current_is_left, current_is_top;
    logic all_left_quadrants, all_top_quadrants;

    assign current_is_left = (box_id[0] == 1'b0);   // boxes 0 (00) and 2 (10)
    assign current_is_top  = (box_id[1] == 1'b0);   // boxes 0 (00) and 1 (01)

    always_comb begin
        if (zoom_level == 4'd0) begin
            all_left_quadrants = 1'b0;
            all_top_quadrants  = 1'b0;
        end else if (zoom_level == 4'd1) begin
            all_left_quadrants = current_is_left;
            all_top_quadrants  = current_is_top;
        end else begin
            all_left_quadrants = popped_all_left && current_is_left;
            all_top_quadrants  = popped_all_top  && current_is_top;
        end
    end

    // ── inline stack model ────────────────────────────────────────────────
    // Entry layout (7 bits): [6:4]=zoom[2:0]  [3:2]=box[1:0]  [1]=all_left  [0]=all_top
    // Key fix: [1] stores popped_all_left (pure ancestor info), NOT all_left_quadrants.
    localparam SW = 7;

    logic [SW-1:0] stack_mem [0:7];
    logic [2:0]    sp;
    logic [SW-1:0] stack_data_in, stack_data_out;
    logic          stack_push, stack_pop;
    logic          stack_empty, stack_full;

    assign stack_data_in = {zoom_level[2:0], box_id + 2'b01, popped_all_left, popped_all_top};
    assign stack_empty   = (sp == 3'd0);
    assign stack_full    = (sp == 3'd7);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sp             <= '0;
            stack_data_out <= '0;
        end else begin
            if (stack_push && !stack_full) begin
                stack_mem[sp] <= stack_data_in;
                sp            <= sp + 1;
            end else if (stack_pop && !stack_empty) begin
                sp             <= sp - 1;
                stack_data_out <= stack_mem[sp - 1];
            end
        end
    end

    // ── drive signals ─────────────────────────────────────────────────────
    // do_descend  → DESCEND_LEVEL:         push + zoom++ + box=0 + update pal/pat
    // do_pop      → INCREASE_LEVEL:        fires stack_pop only (one cycle)
    // do_restore  → INCREASE_LEVEL_SECOND: restore registers from stack_data_out
    // do_next     → NEXT_BOX:              box_id++
    logic do_descend = 0, do_pop = 0, do_restore = 0, do_next = 0;

    assign stack_push = do_descend;
    assign stack_pop  = do_pop;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            zoom_level      <= '0;
            box_id          <= '0;
            popped_all_left <= 1'b0;
            popped_all_top  <= 1'b0;
        end else begin
            if (do_descend) begin
                zoom_level      <= zoom_level + 1;
                box_id          <= 2'd0;
                popped_all_left <= all_left_quadrants;
                popped_all_top  <= all_top_quadrants;
            end
            if (do_restore) begin
                zoom_level      <= {1'b0, stack_data_out[6:4]};
                box_id          <= stack_data_out[3:2];
                popped_all_left <= stack_data_out[1];
                popped_all_top  <= stack_data_out[0];
            end
            if (do_next) begin
                box_id <= box_id + 1;
            end
        end
    end

    // ── helper tasks ──────────────────────────────────────────────────────
    task automatic do_reset();
        rst = 1; do_descend = 0; do_pop = 0; do_restore = 0; do_next = 0;
        tick(2);
        rst = 0;
        tick(1);
    endtask

    task automatic descend();   // one cycle: DESCEND_LEVEL
        @(negedge clk); do_descend = 1;
        @(posedge clk); #1;
        do_descend = 0;
    endtask

    task automatic ascend();    // two cycles: INCREASE_LEVEL then INCREASE_LEVEL_SECOND
        @(negedge clk); do_pop = 1;          // fire stack_pop
        @(posedge clk); #1; do_pop = 0;      // stack_data_out now valid
        @(negedge clk); do_restore = 1;      // restore registers
        @(posedge clk); #1; do_restore = 0;
    endtask

    task automatic next_box();
        @(negedge clk); do_next = 1;
        @(posedge clk); #1;
        do_next = 0;
    endtask

    // ── tests ─────────────────────────────────────────────────────────────
    initial begin
        $display("\n=== tb_scheduler_all_left ===");

        // ── 1. zoom=0: always zero ────────────────────────────────────────
        suite("1. zoom=0 — always zero regardless of box");
        do_reset();
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b0, "b=0: al=0 at=0");
        next_box(); check(all_left_quadrants===1'b0 && all_top_quadrants===1'b0, "b=1: al=0 at=0");
        next_box(); check(all_left_quadrants===1'b0 && all_top_quadrants===1'b0, "b=2: al=0 at=0");
        next_box(); check(all_left_quadrants===1'b0 && all_top_quadrants===1'b0, "b=3: al=0 at=0");

        // ── 2. zoom=1: purely current box position ────────────────────────
        suite("2. zoom=1 — only current box matters (no ancestor info)");
        do_reset();
        descend();  // zoom=1, box=0
        check(all_left_quadrants===1'b1 && all_top_quadrants===1'b1, "b=0(00): al=1 at=1");
        next_box(); check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1, "b=1(01): al=0 at=1");
        next_box(); check(all_left_quadrants===1'b1 && all_top_quadrants===1'b0, "b=2(10): al=1 at=0");
        next_box(); check(all_left_quadrants===1'b0 && all_top_quadrants===1'b0, "b=3(11): al=0 at=0");

        // ── 3. all-left-all-top descent z=0→1→2→3 ────────────────────────
        suite("3. all-left-all-top descent (every box on path is 00)");
        do_reset();
        descend(); descend(); descend();   // zoom=3, box=0 via all-left-top path
        check(all_left_quadrants===1'b1 && all_top_quadrants===1'b1, "z=3 b=0: al=1 at=1");
        next_box(); check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1, "z=3 b=1: al=0 at=1");
        next_box(); check(all_left_quadrants===1'b1 && all_top_quadrants===1'b0, "z=3 b=2: al=1 at=0");
        next_box(); check(all_left_quadrants===1'b0 && all_top_quadrants===1'b0, "z=3 b=3: al=0 at=0");

        // ── 4. non-left parent at z=1 propagates to every z=2 box ─────────
        suite("4. non-left parent (z=1 b=1) — al=0 for all z=2 boxes");
        do_reset();
        descend();       // zoom=1, box=0
        next_box();      // zoom=1, box=1 (right+top): al=0
        check(all_left_quadrants===1'b0, "z=1 b=1: al=0 (right)");
        descend();       // zoom=2, box=0
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1, "z=2 b=0: al=0 at=1");
        next_box(); check(all_left_quadrants===1'b0, "z=2 b=1: al=0");
        next_box(); check(all_left_quadrants===1'b0, "z=2 b=2: al=0");
        next_box(); check(all_left_quadrants===1'b0, "z=2 b=3: al=0");

        // ── 5. non-top parent at z=1 propagates to every z=2 box ──────────
        suite("5. non-top parent (z=1 b=2) — at=0 for all z=2 boxes");
        do_reset();
        descend();
        next_box(); next_box();  // zoom=1, box=2 (left+bottom): at=0
        check(all_top_quadrants===1'b0, "z=1 b=2: at=0 (bottom)");
        descend();
        check(all_left_quadrants===1'b1 && all_top_quadrants===1'b0, "z=2 b=0: al=1 at=0");
        next_box(); check(all_top_quadrants===1'b0, "z=2 b=1: at=0");
        next_box(); check(all_top_quadrants===1'b0, "z=2 b=2: at=0");
        next_box(); check(all_top_quadrants===1'b0, "z=2 b=3: at=0");

        // ── 6. THE BUG CASE: pop must restore pure ancestor info ──────────
        // Path: z=1 b=0(left) → z=2 b=0,b=1(right) → descend b=1 to z=3
        //       → pop back to z=2 b=2(left). al must be 1, not 0.
        // Before fix: stack stored all_left_quadrants (which baked in b=1 being right).
        // After fix:  stack stores popped_all_left (pure z=1 ancestor info = 1).
        suite("6. pop restores pure ancestor info — the key fix");
        do_reset();
        descend();          // z=1 b=0 (left+top)
        descend();          // z=2 b=0, pal=1
        check(all_left_quadrants===1'b1 && all_top_quadrants===1'b1, "z=2 b=0: al=1 at=1");
        next_box();         // z=2 b=1 (right+top): al=0, at=1
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1, "z=2 b=1: al=0 at=1");
        descend();          // z=3 b=0; parent b=1 was right
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1, "z=3 b=0: al=0 (parent right)");
        ascend();           // pop to z=2 b=2 (left+bottom)
        check(all_left_quadrants===1'b1 && all_top_quadrants===1'b0,
              "z=2 b=2 after pop: al=1 at=0 (z=1 b=0 was left+top)");
        next_box();
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b0, "z=2 b=3: al=0 at=0");

        // symmetric case for all_top:
        // z=2 b=2(left+bottom) → descend → pop to z=2 b=3. at must stay 0.
        do_reset();
        descend(); descend();            // z=2 b=0, pal=1 pat=1
        next_box(); next_box();          // z=2 b=2 (left+bottom): at=0
        check(all_top_quadrants===1'b0, "z=2 b=2: at=0 (bottom)");
        descend();
        check(all_top_quadrants===1'b0, "z=3 b=0: at=0 (parent was bottom)");
        ascend();                        // pop to z=2 b=3 (right+bottom)
        check(all_top_quadrants===1'b0, "z=2 b=3 after pop: at=0 (ancestor was bottom)");

        // ── 7. deep descent z=0→1→2→3→4, pop all the way back ───────────
        suite("7. deep descent (z=0→4) then full pop sequence");
        do_reset();
        descend(); descend(); descend(); descend();  // z=4, b=0, all-left-top chain
        check(all_left_quadrants===1'b1 && all_top_quadrants===1'b1, "z=4 b=0: al=1 at=1");
        ascend();   // pop to z=3 b=1 (right+top)
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1, "z=3 b=1: al=0 at=1");
        ascend();   // pop to z=2 b=1 (right+top)
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1, "z=2 b=1: al=0 at=1");
        ascend();   // pop to z=1 b=1 (zoom=1 rule: current_is_left)
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1, "z=1 b=1: al=0 at=1 (zoom=1 rule)");
        ascend();   // pop to z=0 (zoom=0 rule: always 0)
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b0, "z=0: al=0 at=0 (zoom=0 rule)");

        // ── 8. sequential descents from each of the four z=2 boxes ───────
        // After each descent to z=3, pop restores the correct z=2 pal/pat.
        suite("8. sequential descents from each z=2 box (all-left-top z=1 ancestor)");
        do_reset();
        descend(); descend();   // z=2 b=0, pal=1 pat=1

        // from b=0 (left+top, al=1 at=1)
        descend();
        check(all_left_quadrants===1'b1 && all_top_quadrants===1'b1,
              "z=3 b=0 from z=2 b=0: al=1 at=1");
        ascend();               // back to z=2 b=1 (right+top)
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1, "z=2 b=1: al=0 at=1");

        // from b=1 (right+top, al=0 at=1)
        descend();
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b1,
              "z=3 b=0 from z=2 b=1: al=0 at=1");
        ascend();               // back to z=2 b=2 (left+bottom); pal must still be 1
        check(all_left_quadrants===1'b1 && all_top_quadrants===1'b0, "z=2 b=2: al=1 at=0");

        // from b=2 (left+bottom, al=1 at=0)
        descend();
        check(all_left_quadrants===1'b1 && all_top_quadrants===1'b0,
              "z=3 b=0 from z=2 b=2: al=1 at=0");
        ascend();               // back to z=2 b=3 (right+bottom)
        check(all_left_quadrants===1'b0 && all_top_quadrants===1'b0, "z=2 b=3: al=0 at=0");

        // ── 9. broken left chain propagates through z=3 and z=4 ──────────
        // z=1 b=0(left+top) → z=2 b=1(right+top) → z=3 b=0 → z=4 b=0
        // al must be 0 all the way down; at must stay 1.
        suite("9. broken left chain propagates to z=4");
        do_reset();
        descend();       // z=1 b=0 (left+top): al=1
        descend();       // z=2 b=0, pal=1
        next_box();      // z=2 b=1 (right): al=0, at=1
        descend();       // z=3 b=0
        check(all_left_quadrants===1'b0, "z=3 b=0: al=0 (chain broken at z=2 b=1)");
        check(all_top_quadrants ===1'b1, "z=3 b=0: at=1 (top chain still intact)");
        descend();       // z=4 b=0
        check(all_left_quadrants===1'b0, "z=4 b=0: al=0 (still broken)");
        check(all_top_quadrants ===1'b1, "z=4 b=0: at=1 (top chain intact)");

        summary();
        $finish;
    end

endmodule
