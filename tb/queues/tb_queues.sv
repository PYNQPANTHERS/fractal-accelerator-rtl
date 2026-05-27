// tb_queues.sv
// Testbench for fifo, job_queue, complete_queue,
// job_queue_handler, complete_queue_handler
`timescale 1ns/1ps

module tb_queues;

    // ----------------------------------------------------------------
    // Test infrastructure
    // ----------------------------------------------------------------
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

    // ----------------------------------------------------------------
    // Clock — 100 MHz
    // ----------------------------------------------------------------
    localparam int CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;

    // Rise to posedge then small delta so outputs settle
    task automatic tick(input int n = 1);
        repeat(n) @(posedge clk);
        #1;
    endtask

    // ================================================================
    // DUT 1 — raw fifo (small depth=8 for speed)
    // ================================================================
    localparam int NUM_ITER = 20;

    logic        f_rst, f_flush, f_push, f_pop;
    logic [17:0] f_data_in, f_data_out;
    logic        f_full, f_empty;

    fifo #(.DATA_WIDTH(18), .DEPTH(8)) u_fifo (
        .clk(clk), .rst(f_rst), .flush(f_flush),
        .push(f_push), .data_in(f_data_in),
        .pop(f_pop),   .data_out(f_data_out),
        .full(f_full), .empty(f_empty)
    );

    task automatic fifo_reset();
        f_rst=1; f_flush=0; f_push=0; f_pop=0; f_data_in=0;
        tick(2); f_rst=0; tick(1);
    endtask

    // Push data and wait one cycle for mem write to settle
    task automatic fifo_push(input logic [17:0] d);
        f_push=1; f_data_in=d; tick(1); f_push=0;
    endtask

    // Pop and wait one cycle for tail pointer to advance
    task automatic fifo_pop_wait();
        f_pop=1; tick(1); f_pop=0; tick(1);
    endtask

    // ================================================================
    // DUT 2 — job_queue_handler
    // ================================================================
    logic        jh_rst, jh_flush;
    logic [17:0] jh_sched_coord;
    logic        jh_sched_push, jh_sched_stall;
    logic [NUM_ITER-1:0] jh_wants_job, jh_grant;
    logic [17:0] jh_coord_out;

    job_queue_handler #(.NUM_ITER(NUM_ITER)) u_jqh (
        .clk(clk), .rst(jh_rst), .flush(jh_flush),
        .sched_coord(jh_sched_coord), .sched_push(jh_sched_push),
        .sched_stall(jh_sched_stall),
        .wants_job(jh_wants_job), .grant(jh_grant),
        .coord_out(jh_coord_out)
    );

    task automatic jh_reset();
        jh_rst=1; jh_flush=0; jh_sched_push=0;
        jh_sched_coord=0; jh_wants_job=0;
        tick(2); jh_rst=0; tick(1);
    endtask

    task automatic jh_enqueue(input logic [8:0] x, input logic [8:0] y);
        jh_sched_coord = {y, x};
        jh_sched_push  = 1;
        tick(1);
        while (jh_sched_stall) tick(1);
        jh_sched_push = 0;
        tick(1);
    endtask

    // ================================================================
    // DUT 3 — complete_queue_handler
    // ================================================================
    logic                     cqh_rst;
    logic [NUM_ITER-1:0]      cqh_done;
    logic [NUM_ITER-1:0][8:0] cqh_iter_x, cqh_iter_y;
    logic [NUM_ITER-1:0][3:0] cqh_iter_colour;
    logic                     cqh_comp_valid, cqh_comp_pop, cqh_full_err;
    logic [21:0]              cqh_comp_data;

    complete_queue_handler #(.NUM_ITER(NUM_ITER)) u_cqh (
        .clk(clk), .rst(cqh_rst),
        .done(cqh_done),
        .iter_x(cqh_iter_x), .iter_y(cqh_iter_y),
        .iter_colour(cqh_iter_colour),
        .comp_valid(cqh_comp_valid), .comp_data(cqh_comp_data),
        .comp_pop(cqh_comp_pop),
        .full_err(cqh_full_err)
    );

    task automatic cqh_reset();
        cqh_rst=1; cqh_done=0; cqh_comp_pop=0;
        for (int i=0; i<NUM_ITER; i++) begin
            cqh_iter_x[i]=0; cqh_iter_y[i]=0; cqh_iter_colour[i]=0;
        end
        tick(2); cqh_rst=0; tick(1);
    endtask

    task automatic cqh_finish(input int idx,
                               input logic [8:0] x, y,
                               input logic [3:0] col);
        cqh_iter_x[idx]=x; cqh_iter_y[idx]=y; cqh_iter_colour[idx]=col;
        cqh_done[idx]=1; tick(1); cqh_done[idx]=0; tick(1);
    endtask

    task automatic cqh_drain(output logic [8:0] ox, oy,
                              output logic [3:0] oc);
        int timeout = 0;
        while (!cqh_comp_valid && timeout < 100) begin tick(1); timeout++; end
        ox = cqh_comp_data[8:0];
        oy = cqh_comp_data[17:9];
        oc = cqh_comp_data[21:18];
        cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);
    endtask

    // ================================================================
    // TEST BODY
    // Module-level vars (Icarus does not support automatic inside initial)
    // ================================================================
    logic [8:0] got_x, got_y;
    logic [3:0] got_col;
    int pushed, count, received;

    initial begin
        $dumpfile("sim/waves/tb_queues.vcd");
        $dumpvars(0, tb_queues);

        // ============================================================
        suite("FIFO — reset state");
        // ============================================================
        fifo_reset();
        check(f_empty,  "empty asserted on reset");
        check(!f_full,  "full deasserted on reset");
        // data_out from uninitialised mem on reset is undefined — not checked

        // ============================================================
        suite("FIFO — single push then pop");
        // ============================================================
        fifo_reset();
        fifo_push(18'hAAAA);
        // one cycle after push: mem written, tail still 0 so data_out = mem[0]
        tick(1);
        check(!f_empty,              "not empty after push");
        check(!f_full,               "not full after one push");
        check(f_data_out == 18'hAAAA,"data_out correct after push");
        fifo_pop_wait();
        check(f_empty, "empty after single pop");

        // ============================================================
        suite("FIFO — fill to capacity");
        // ============================================================
        fifo_reset();
        for (int i=0; i<8; i++) fifo_push(18'(i));
        tick(1);
        check(f_full,  "full after 8 pushes");
        check(!f_empty,"not empty when full");

        // ============================================================
        suite("FIFO — push ignored when full");
        // ============================================================
        fifo_push(18'hFF); // should be dropped
        tick(1);
        check(f_full, "still full after push-when-full");
        for (int i=0; i<8; i++) fifo_pop_wait();
        check(f_empty, "empty after draining exactly 8 — no extra entry added");

        // ============================================================
        suite("FIFO — FIFO ordering");
        // ============================================================
        fifo_reset();
        fifo_push(18'h111); fifo_push(18'h222); fifo_push(18'h333);
        tick(1);
        check(f_data_out == 18'h111, "first pushed is first out");
        fifo_pop_wait();
        check(f_data_out == 18'h222, "second entry correct");
        fifo_pop_wait();
        check(f_data_out == 18'h333, "third entry correct");

        // ============================================================
        suite("FIFO — simultaneous push and pop");
        // ============================================================
        fifo_reset();
        fifo_push(18'h001); fifo_push(18'h002);
        tick(1);
        // assert push+pop in same cycle
        f_push=1; f_data_in=18'h003; f_pop=1;
        tick(1); f_push=0; f_pop=0; tick(1);
        // head should now be 002, 003 behind it
        check(f_data_out == 18'h002, "simultaneous: 002 now at head");
        fifo_pop_wait();
        check(f_data_out == 18'h003, "simultaneous: 003 follows");

        // ============================================================
        suite("FIFO — flush");
        // ============================================================
        fifo_reset();
        for (int i=0; i<5; i++) fifo_push(18'(i));
        tick(1);
        f_flush=1; tick(1); f_flush=0; tick(1);
        check(f_empty, "empty after flush");
        check(!f_full, "not full after flush");

        // ============================================================
        suite("FIFO — wrap-around");
        // ============================================================
        fifo_reset();
        for (int round=0; round<4; round++) begin
            for (int i=0; i<8; i++) fifo_push(18'(i + round*10));
            for (int i=0; i<8; i++) fifo_pop_wait();
        end
        check(f_empty, "empty after 4x fill-drain cycles");
        check(!f_full, "not full after wrap-around cycles");

        // ============================================================
        suite("FIFO — data integrity after wrap");
        // ============================================================
        fifo_reset();
        // drain half, refill to exercise the wrap point
        for (int i=0; i<8; i++) fifo_push(18'(i));
        for (int i=0; i<4; i++) fifo_pop_wait();
        for (int i=0; i<4; i++) fifo_push(18'(i+100));
        tick(1);
        check(f_data_out == 18'h4, "data integrity post-wrap: entry 4 correct");
        fifo_pop_wait(); check(f_data_out == 18'h5, "entry 5");
        fifo_pop_wait(); check(f_data_out == 18'h6, "entry 6");
        fifo_pop_wait(); check(f_data_out == 18'h7, "entry 7");
        fifo_pop_wait(); check(f_data_out == 18'h64,"entry 100");
        fifo_pop_wait(); check(f_data_out == 18'h65,"entry 101");
        fifo_pop_wait(); check(f_data_out == 18'h66,"entry 102");
        fifo_pop_wait(); check(f_data_out == 18'h67,"entry 103");

        // ============================================================
        suite("JOB QUEUE HANDLER — no grant when empty");
        // ============================================================
        jh_reset();
        jh_wants_job = '1;
        tick(5);
        check(jh_grant == 0, "no grant issued when queue empty");
        jh_wants_job = 0;

        // ============================================================
        suite("JOB QUEUE HANDLER — single iterator gets job");
        // ============================================================
        jh_reset();
        jh_enqueue(9'd42, 9'd17);
        jh_wants_job = 20'b1;
        tick(1); // grant fires one cycle after wants_job asserted
        check(jh_grant[0],                         "grant[0] for sole requester");
        check(jh_coord_out == {9'd17, 9'd42},      "coord_out matches enqueued {y,x}");
        jh_wants_job = 0;

        // ============================================================
        suite("JOB QUEUE HANDLER — correct coord per iterator");
        // ============================================================
        jh_reset();
        jh_enqueue(9'd10, 9'd20);
        jh_enqueue(9'd30, 9'd40);
        jh_wants_job = 20'b1; // only iterator 0
        tick(1); // first grant fires this cycle
        check(jh_coord_out == {9'd20, 9'd10}, "first coord: {y=20,x=10}");
        tick(1); // second grant fires next cycle
        check(jh_coord_out == {9'd40, 9'd30}, "second coord: {y=40,x=30}");
        jh_wants_job = 0;

        // ============================================================
        suite("JOB QUEUE HANDLER — round robin across 20 iterators");
        // ============================================================
        jh_reset();
        for (int i=0; i<20; i++) jh_enqueue(9'(i), 9'(0));
        jh_wants_job = '1; // all 20 request simultaneously
        for (int i=0; i<20; i++) begin
            tick(1);
            check(jh_grant == (20'(1) << i),
                $sformatf("cycle %0d: only iterator %0d granted", i, i));
        end
        jh_wants_job = 0;

        // ============================================================
        suite("JOB QUEUE HANDLER — round robin wraps correctly");
        // ============================================================
        jh_reset();
        for (int i=0; i<6; i++) jh_enqueue(9'(i), 9'(0));
        // only iterators 18 and 19 want work — ptr starts at 0
        // phase A from 0: first match >= 0 is 18
        jh_wants_job = 0;
        jh_wants_job[18] = 1; jh_wants_job[19] = 1;
        tick(1);
        check(jh_grant[18], "wrap: iterator 18 first (lowest in phase A from ptr=0)");
        tick(1);
        check(jh_grant[19], "wrap: iterator 19 second");
        // ptr now = 0 again (wrapped past 19), 18 should win again
        tick(1);
        check(jh_grant[18], "wrap: iterator 18 again after pointer wraps");
        jh_wants_job = 0;

        // ============================================================
        suite("JOB QUEUE HANDLER — flush clears mid-fill");
        // ============================================================
        jh_reset();
        for (int i=0; i<10; i++) jh_enqueue(9'(i), 9'(0));
        jh_flush=1; tick(1); jh_flush=0; tick(2);
        jh_wants_job = '1;
        tick(5);
        check(jh_grant == 0, "no grants after flush");
        jh_wants_job = 0;

        // ============================================================
        suite("JOB QUEUE HANDLER — stall on full");
        // ============================================================
        // Use a small trick: fill until stall fires, check it holds
        jh_reset();
        begin
            pushed = 0;
            jh_sched_push = 1;
            while (!jh_sched_stall && pushed < 2100) begin
                jh_sched_coord = 18'(pushed);
                @(posedge clk); #1;
                if (!jh_sched_stall) pushed++;
            end
            jh_sched_push = 0;
            tick(1);
            check(jh_sched_stall, $sformatf("stall asserted after %0d entries", pushed));
        end

        // ============================================================
        suite("COMPLETE QUEUE HANDLER — single done");
        // ============================================================
        cqh_reset();
        cqh_finish(0, 9'd10, 9'd20, 4'hA);
        check(cqh_comp_valid,                "comp_valid after one done");
        check(cqh_comp_data[8:0]   == 9'd10, "x correct");
        check(cqh_comp_data[17:9]  == 9'd20, "y correct");
        check(cqh_comp_data[21:18] == 4'hA,  "colour correct");

        // ============================================================
        suite("COMPLETE QUEUE HANDLER — pop clears entry");
        // ============================================================
        cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);
        check(!cqh_comp_valid, "comp_valid low after pop");

        // ============================================================
        suite("COMPLETE QUEUE HANDLER — round robin on simultaneous done");
        // ============================================================
        cqh_reset();
        cqh_iter_x[3]=9'd33; cqh_iter_y[3]=9'd3; cqh_iter_colour[3]=4'h3;
        cqh_iter_x[7]=9'd77; cqh_iter_y[7]=9'd7; cqh_iter_colour[7]=4'h7;
        // Both done asserted simultaneously — handler pushes one per cycle.
        // Keep done high for 2 cycles so both iterators get their entries pushed.
        // Cycle 1: iterator 3 wins (lower index), pushed
        // Cycle 2: iterator 7 wins (only remaining), pushed
        cqh_done[3]=1; cqh_done[7]=1;
        tick(1); // cycle 1: 3 wins and is pushed, 7 still asserting
        tick(1); // cycle 2: 7 wins and is pushed
        cqh_done=0; tick(1);
        // drain and verify order
        check(cqh_comp_data[8:0] == 9'd33, "simultaneous done: lower index (3) wins first");
        cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);
        check(cqh_comp_valid,               "second entry present");
        check(cqh_comp_data[8:0] == 9'd77, "iterator 7 arrives second");
        cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);

        // ============================================================
        suite("COMPLETE QUEUE HANDLER — data integrity sequential");
        // ============================================================
        cqh_reset();
        for (int i=0; i<5; i++) cqh_finish(0, 9'(i*3), 9'(i*7), 4'(i));
        for (int i=0; i<5; i++) begin
            cqh_drain(got_x, got_y, got_col);
            check(got_x   == 9'(i*3), $sformatf("entry %0d x=%0d", i, i*3));
            check(got_y   == 9'(i*7), $sformatf("entry %0d y=%0d", i, i*7));
            check(got_col == 4'(i),   $sformatf("entry %0d colour=%0d", i, i));
        end

        // ============================================================
        suite("COMPLETE QUEUE HANDLER — all 20 simultaneous");
        // ============================================================
        cqh_reset();
        for (int i=0; i<NUM_ITER; i++) begin
            cqh_iter_x[i]=9'(i); cqh_iter_y[i]=9'(i+50); cqh_iter_colour[i]=4'(i%16);
        end
        // Assert all done simultaneously. Handler pushes one per cycle.
        // complete_queue depth=32 > NUM_ITER=20 so no overflow.
        // Assert for NUM_ITER cycles so every iterator gets one push slot,
        // then drain and count — must be exactly NUM_ITER.
        begin
            count = 0;
            // Push phase: hold done='1 for NUM_ITER cycles, one push per cycle
            cqh_done = '1;
            tick(NUM_ITER);
            cqh_done = 0;
            tick(2); // settle
            // Drain phase: pop all entries and count them
            repeat(NUM_ITER + 5) begin
                if (cqh_comp_valid) begin
                    cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);
                    count++;
                end else tick(1);
            end
            check(count == NUM_ITER,
                $sformatf("all %0d results drained (got %0d)", NUM_ITER, count));
        end

        // ============================================================
        suite("COMPLETE QUEUE HANDLER — full_err never fires");
        // ============================================================
        cqh_reset();
        for (int i=0; i<32; i++) begin
            cqh_finish(0, 9'(i), 9'(i), 4'(i%16));
            cqh_comp_pop=1; tick(1); cqh_comp_pop=0;
        end
        check(!cqh_full_err, "full_err never asserted under normal drain rate");

        // ============================================================
        suite("INTEGRATION — enqueue 20, all iterators drain, all results arrive");
        // ============================================================
        jh_reset(); cqh_reset();
        for (int i=0; i<20; i++) jh_enqueue(9'(i*2), 9'(i*3));
        jh_wants_job = '1;
        begin
            received = 0;
            // Phase 1: run until all 20 grants have fired and done has been asserted
            // Each cycle: check grant -> set done payload, check comp_valid -> drain
            // done stays high for 2 cycles after each grant so handler can push
            repeat(60) begin
                @(posedge clk); #1;
                // Clear done from previous cycle first
                cqh_done = 0;
                // Set done for any iterator just granted this cycle
                for (int j=0; j<NUM_ITER; j++) begin
                    if (jh_grant[j]) begin
                        cqh_iter_x[j]      = jh_coord_out[8:0];
                        cqh_iter_y[j]      = jh_coord_out[17:9];
                        cqh_iter_colour[j] = 4'(j % 16);
                        cqh_done[j]        = 1;
                    end
                end
            end
            jh_wants_job = 0;
            // One more cycle for last done to be pushed, then clear
            tick(1); cqh_done = 0; tick(2);
            // Phase 2: drain everything from complete queue
            repeat(40) begin
                if (cqh_comp_valid) begin
                    cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);
                    received++;
                end else tick(1);
            end
            check(received == 20,
                $sformatf("integration: all 20 results received (got %0d)", received));
        end

        summary();
        $finish;
    end

    // Watchdog
    initial begin
        #2000000;
        $display("\n[TIMEOUT] simulation exceeded limit — possible hang");
        $finish;
    end

endmodule