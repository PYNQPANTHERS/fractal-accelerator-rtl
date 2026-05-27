// tb_queues.sv
// Testbench for fifo, job_queue, complete_queue,
// job_queue_handler, complete_queue_handler

`timescale 1ns/1ps

module tb_queues;

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

    // Clock - 100 MHz
    localparam int CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;

    task automatic tick(input int n = 1);
        repeat(n) @(posedge clk);
        #1;
    endtask

    // DUT 1 - raw fifo (depth=8 for speed)
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

    task automatic fifo_push(input logic [17:0] d);
        f_push=1; f_data_in=d; tick(1); f_push=0;
    endtask

    task automatic fifo_pop_wait();
        f_pop=1; tick(1); f_pop=0; tick(1);
    endtask

    // DUT 2 - job_queue_handler
    logic        jh_rst, jh_flush;
    logic [17:0] jh_sched_coord;
    logic        jh_sched_push, jh_sched_stall;
    logic        jh_wants_job, jh_grant;
    logic [17:0] jh_coord_out;

    job_queue_handler u_jqh (
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

    // Request one job and wait for grant
    task automatic jh_request(output logic [8:0] ox, output logic [8:0] oy);
        jh_wants_job = 1;
        tick(1);
        while (!jh_grant) tick(1);
        ox = jh_coord_out[8:0];
        oy = jh_coord_out[17:9];
        jh_wants_job = 0;
    endtask

    // DUT 3 - complete_queue_handler
    logic        cqh_rst;
    logic        cqh_done;
    logic [8:0]  cqh_iter_x, cqh_iter_y;
    logic [3:0]  cqh_iter_colour;
    logic        cqh_comp_valid, cqh_comp_pop, cqh_full_err;
    logic [21:0] cqh_comp_data;

    complete_queue_handler u_cqh (
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
        cqh_iter_x=0; cqh_iter_y=0; cqh_iter_colour=0;
        tick(2); cqh_rst=0; tick(1);
    endtask

    task automatic cqh_finish(input logic [8:0] x, y,
                               input logic [3:0] col);
        cqh_iter_x=x; cqh_iter_y=y; cqh_iter_colour=col;
        cqh_done=1; tick(1); cqh_done=0; tick(1);
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

    // Module-level vars
    logic [8:0] got_x, got_y;
    logic [3:0] got_col;
    int count, received;

    initial begin
        $dumpfile("sim/waves/tb_queues.vcd");
        $dumpvars(0, tb_queues);

        suite("FIFO - reset state");
        fifo_reset();
        check(f_empty,  "empty asserted on reset");
        check(!f_full,  "full deasserted on reset");

        suite("FIFO - single push then pop");
        fifo_reset();
        fifo_push(18'hAAAA);
        tick(1);
        check(!f_empty,               "not empty after push");
        check(!f_full,                "not full after one push");
        check(f_data_out == 18'hAAAA, "data_out correct after push");
        fifo_pop_wait();
        check(f_empty, "empty after single pop");

        suite("FIFO - fill to capacity");
        fifo_reset();
        for (int i=0; i<8; i++) fifo_push(18'(i));
        tick(1);
        check(f_full,   "full after 8 pushes");
        check(!f_empty, "not empty when full");

        suite("FIFO - push ignored when full");
        fifo_push(18'hFF);
        tick(1);
        check(f_full, "still full after push-when-full");
        for (int i=0; i<8; i++) fifo_pop_wait();
        check(f_empty, "empty after draining exactly 8 - no extra entry added");

        suite("FIFO - FIFO ordering");
        fifo_reset();
        fifo_push(18'h111); fifo_push(18'h222); fifo_push(18'h333);
        tick(1);
        check(f_data_out == 18'h111, "first pushed is first out");
        fifo_pop_wait(); check(f_data_out == 18'h222, "second entry correct");
        fifo_pop_wait(); check(f_data_out == 18'h333, "third entry correct");

        suite("FIFO - simultaneous push and pop");
        fifo_reset();
        fifo_push(18'h001); fifo_push(18'h002);
        tick(1);
        f_push=1; f_data_in=18'h003; f_pop=1;
        tick(1); f_push=0; f_pop=0; tick(1);
        check(f_data_out == 18'h002, "simultaneous: 002 now at head");
        fifo_pop_wait();
        check(f_data_out == 18'h003, "simultaneous: 003 follows");

        suite("FIFO - flush");
        fifo_reset();
        for (int i=0; i<5; i++) fifo_push(18'(i));
        tick(1);
        f_flush=1; tick(1); f_flush=0; tick(1);
        check(f_empty,  "empty after flush");
        check(!f_full,  "not full after flush");

        suite("FIFO - wrap-around");
        fifo_reset();
        for (int round=0; round<4; round++) begin
            for (int i=0; i<8; i++) fifo_push(18'(i + round*10));
            for (int i=0; i<8; i++) fifo_pop_wait();
        end
        check(f_empty,  "empty after 4x fill-drain cycles");
        check(!f_full,  "not full after wrap-around cycles");

        suite("FIFO - data integrity after wrap");
        fifo_reset();
        for (int i=0; i<8; i++) fifo_push(18'(i));
        for (int i=0; i<4; i++) fifo_pop_wait();
        for (int i=0; i<4; i++) fifo_push(18'(i+100));
        tick(1);
        check(f_data_out == 18'h4,  "post-wrap: entry 4");
        fifo_pop_wait(); check(f_data_out == 18'h5,  "entry 5");
        fifo_pop_wait(); check(f_data_out == 18'h6,  "entry 6");
        fifo_pop_wait(); check(f_data_out == 18'h7,  "entry 7");
        fifo_pop_wait(); check(f_data_out == 18'h64, "entry 100");
        fifo_pop_wait(); check(f_data_out == 18'h65, "entry 101");
        fifo_pop_wait(); check(f_data_out == 18'h66, "entry 102");
        fifo_pop_wait(); check(f_data_out == 18'h67, "entry 103");

        suite("JOB QUEUE HANDLER - no grant when empty");
        jh_reset();
        jh_wants_job = 1;
        tick(5);
        check(!jh_grant, "no grant when queue empty");
        jh_wants_job = 0;

        suite("JOB QUEUE HANDLER - single request gets job");
        jh_reset();
        jh_enqueue(9'd42, 9'd17);
        jh_wants_job = 1;
        tick(1);
        check(jh_grant,                        "grant asserted");
        check(jh_coord_out == {9'd17, 9'd42},  "coord_out correct {y=17,x=42}");
        jh_wants_job = 0;

        suite("JOB QUEUE HANDLER - grant deasserts when wants_job low");
        jh_reset();
        jh_enqueue(9'd10, 9'd20);
        jh_wants_job = 1; tick(1); jh_wants_job = 0; tick(1);
        check(!jh_grant, "grant low after wants_job deasserts");

        suite("JOB QUEUE HANDLER - sequential requests get correct coords");
        jh_reset();
        jh_enqueue(9'd10, 9'd20);
        jh_enqueue(9'd30, 9'd40);
        jh_enqueue(9'd50, 9'd60);
        // request 1
        jh_wants_job = 1; tick(1);
        check(jh_grant,                        "req 1: grant asserted");
        check(jh_coord_out == {9'd20, 9'd10},  "req 1: coord {y=20,x=10}");
        // request 2
        tick(1);
        check(jh_grant,                        "req 2: grant asserted");
        check(jh_coord_out == {9'd40, 9'd30},  "req 2: coord {y=40,x=30}");
        // request 3
        tick(1);
        check(jh_grant,                        "req 3: grant asserted");
        check(jh_coord_out == {9'd60, 9'd50},  "req 3: coord {y=60,x=50}");
        // queue now empty - next request should not grant
        tick(1);
        check(!jh_grant, "no grant after queue drained");
        jh_wants_job = 0;

        suite("JOB QUEUE HANDLER - no grant when wants_job low");
        jh_reset();
        jh_enqueue(9'd5, 9'd5);
        jh_wants_job = 0;
        tick(5);
        check(!jh_grant, "no grant when wants_job not asserted");

        suite("JOB QUEUE HANDLER - stall on full");
        jh_reset();
        begin
            int pushed = 0;
            jh_sched_push = 1;
            while (!jh_sched_stall && pushed < 2100) begin
                jh_sched_coord = 18'(pushed);
                @(posedge clk); #1;
                if (!jh_sched_stall) pushed++;
            end
            jh_sched_push = 0; tick(1);
            check(jh_sched_stall,
                $sformatf("stall asserted after %0d entries", pushed));
        end

        suite("JOB QUEUE HANDLER - flush clears queue");
        jh_reset();
        for (int i=0; i<10; i++) jh_enqueue(9'(i), 9'(0));
        jh_flush=1; tick(1); jh_flush=0; tick(2);
        jh_wants_job = 1; tick(3);
        check(!jh_grant, "no grant after flush");
        jh_wants_job = 0;

        suite("JOB QUEUE HANDLER - stall clears after pop");
        jh_reset();
        begin
            int pushed = 0;
            jh_sched_push = 1;
            while (!jh_sched_stall && pushed < 2100) begin
                jh_sched_coord = 18'(pushed);
                @(posedge clk); #1;
                if (!jh_sched_stall) pushed++;
            end
            jh_sched_push = 0;
            // pop one entry
            jh_wants_job = 1; tick(2); jh_wants_job = 0; tick(1);
            check(!jh_sched_stall, "stall clears after one pop");
        end

        suite("COMPLETE QUEUE HANDLER - single done");
        cqh_reset();
        cqh_finish(9'd10, 9'd20, 4'hA);
        check(cqh_comp_valid,                 "comp_valid after done");
        check(cqh_comp_data[8:0]   == 9'd10,  "x correct");
        check(cqh_comp_data[17:9]  == 9'd20,  "y correct");
        check(cqh_comp_data[21:18] == 4'hA,   "colour correct");

        suite("COMPLETE QUEUE HANDLER - pop clears entry");
        cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);
        check(!cqh_comp_valid, "comp_valid low after pop");

        suite("COMPLETE QUEUE HANDLER - not valid when empty");
        cqh_reset();
        check(!cqh_comp_valid, "comp_valid low on reset");

        suite("COMPLETE QUEUE HANDLER - sequential pushes maintain order");
        cqh_reset();
        for (int i=0; i<5; i++) cqh_finish(9'(i*3), 9'(i*7), 4'(i));
        for (int i=0; i<5; i++) begin
            cqh_drain(got_x, got_y, got_col);
            check(got_x   == 9'(i*3), $sformatf("entry %0d x=%0d", i, i*3));
            check(got_y   == 9'(i*7), $sformatf("entry %0d y=%0d", i, i*7));
            check(got_col == 4'(i),   $sformatf("entry %0d colour=%0d", i, i));
        end

        suite("COMPLETE QUEUE HANDLER - comp_valid low when not popped between pushes");
        cqh_reset();
        cqh_finish(9'd1, 9'd2, 4'h1);
        cqh_finish(9'd3, 9'd4, 4'h2);
        check(cqh_comp_valid, "comp_valid stays high with entries pending");

        suite("COMPLETE QUEUE HANDLER - fill to depth then drain");
        cqh_reset();
        count = 0;
        for (int i=0; i<32; i++) cqh_finish(9'(i), 9'(i), 4'(i%16));
        repeat(32 + 5) begin
            if (cqh_comp_valid) begin
                cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);
                count++;
            end else tick(1);
        end
        check(count == 32, $sformatf("drained all 32 entries (got %0d)", count));
        check(!cqh_comp_valid, "comp_valid low after full drain");

        suite("COMPLETE QUEUE HANDLER - full_err never fires under normal use");
        cqh_reset();
        for (int i=0; i<32; i++) begin
            cqh_finish(9'(i), 9'(i), 4'(i%16));
            cqh_comp_pop=1; tick(1); cqh_comp_pop=0;
        end
        check(!cqh_full_err, "full_err never asserted");

        suite("COMPLETE QUEUE HANDLER - full_err fires when full");
        cqh_reset();
        // fill queue without draining
        for (int i=0; i<32; i++) cqh_finish(9'(i), 9'(i), 4'(i%16));
        // one more push should trigger full_err
        cqh_iter_x=9'd99; cqh_iter_y=9'd99; cqh_iter_colour=4'hF;
        cqh_done=1; tick(1); cqh_done=0;
        check(cqh_full_err, "full_err asserts when pushing to full queue");

        suite("INTEGRATION - enqueue 20 coords, request all, push results, drain");
        jh_reset(); cqh_reset();
        // load 20 pixel coords into job queue
        for (int i=0; i<20; i++) jh_enqueue(9'(i*2), 9'(i*3));
        received = 0;
        // request each job, immediately push a result, drain complete queue
        for (int i=0; i<20; i++) begin
            // request job
            jh_wants_job = 1; tick(1);
            check(jh_grant, $sformatf("job %0d: grant received", i));
            jh_wants_job = 0;
            // push result with coord from job queue
            cqh_iter_x      = jh_coord_out[8:0];
            cqh_iter_y      = jh_coord_out[17:9];
            cqh_iter_colour = 4'(i % 16);
            cqh_done = 1; tick(1); cqh_done = 0; tick(1);
            // drain result
            if (cqh_comp_valid) begin
                cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);
                received++;
            end
        end
        // drain any remaining
        repeat(10) begin
            if (cqh_comp_valid) begin
                cqh_comp_pop=1; tick(1); cqh_comp_pop=0; tick(1);
                received++;
            end else tick(1);
        end
        check(received == 20,
            $sformatf("all 20 results received (got %0d)", received));

        summary();
        $finish;
    end

    // Watchdog
    initial begin
        #2000000;
        $display("\n[TIMEOUT] simulation exceeded limit - possible hang");
        $finish;
    end

endmodule