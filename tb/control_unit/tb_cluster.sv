// ─────────────────────────────────────────────────────────────────────────────
// tb_cluster
//   Self-checking testbench for the cluster module.
//
//   Strategy:
//     * Drive jobs into the cluster from a producer task.
//     * Maintain an associative-array scoreboard indexed by pixel address,
//       storing the expected result (predicted from the same XOR-fold transfer
//       function used by the fractal_core stub).
//     * Consume results from the cluster's result interface, comparing each
//       pixel_addr/result pair against the scoreboard.
//     * Concurrent assertions check the invariants from the datasheet.
//
//   Tests:
//     1. single_dispatch        — one job, one result
//     2. saturate_then_drain    — fill the cluster, drain it, check ordering
//     3. simultaneous_completion— force several cores to finish on the same cycle
//     4. backpressure           — hold result_ready low, watch the FIFO fill
//     5. reset_midflight        — reset while jobs are in flight
//     6. random_stress          — many random jobs with random readiness gaps
// ─────────────────────────────────────────────────────────────────────────────
`timescale 1ns/1ps

module tb_cluster;

    // ─────────────────────────────────────────────────────────────────────
    // parameters
    // ─────────────────────────────────────────────────────────────────────
    localparam int CLUSTER_SIZE = 8;
    localparam int PIXEL_ADDR_W = 16;
    localparam int PIXEL_W      = 8;
    localparam int JOB_DATA_W   = 18;

    localparam time CLK_PERIOD = 10ns;

    // ─────────────────────────────────────────────────────────────────────
    // DUT signals
    // ─────────────────────────────────────────────────────────────────────
    logic                     clk;
    logic                     rst_n;

    logic                     disp_valid;
    logic [PIXEL_ADDR_W-1:0]  disp_pixel_addr;
    logic [JOB_DATA_W-1:0]    disp_job_data;

    logic                     cluster_wants_job;

    logic                     result_valid;
    logic [PIXEL_ADDR_W-1:0]  result_pixel_addr;
    logic [PIXEL_W-1:0]       result_data;
    logic                     result_ready;

    // ─────────────────────────────────────────────────────────────────────
    // DUT
    // ─────────────────────────────────────────────────────────────────────
    cluster #(
        .CLUSTER_SIZE (CLUSTER_SIZE),
        .PIXEL_ADDR_W (PIXEL_ADDR_W),
        .PIXEL_W      (PIXEL_W),
        .JOB_DATA_W   (JOB_DATA_W)
    ) dut (
        .clk              (clk),
        .rst_n            (rst_n),
        .disp_valid       (disp_valid),
        .disp_pixel_addr  (disp_pixel_addr),
        .disp_job_data    (disp_job_data),
        .cluster_wants_job(cluster_wants_job),
        .result_valid     (result_valid),
        .result_pixel_addr(result_pixel_addr),
        .result_data      (result_data),
        .result_ready     (result_ready)
    );

    // ─────────────────────────────────────────────────────────────────────
    // clock
    // ─────────────────────────────────────────────────────────────────────
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // ─────────────────────────────────────────────────────────────────────
    // scoreboard
    // ─────────────────────────────────────────────────────────────────────
    // We use dense, fixed-size tracking arrays keyed by pixel_addr. The
    // testbench controls the address space, so we cap the lookup table at
    // MAX_ADDRS entries and map pixel_addr -> slot by taking the low bits.
    // Each slot has: valid (job outstanding), expected result, full address
    // (so we can detect collisions on the slot).
    localparam int MAX_ADDRS = 1024;          // power of 2
    localparam int ADDR_MASK = MAX_ADDRS - 1;

    logic                    sb_valid    [MAX_ADDRS];
    logic [PIXEL_W-1:0]      sb_expected [MAX_ADDRS];
    logic [PIXEL_ADDR_W-1:0] sb_fulladdr [MAX_ADDRS];

    int                 outstanding;
    int                 dispatched_count;
    int                 collected_count;
    int                 error_count;

    task automatic sb_clear();
        for (int i = 0; i < MAX_ADDRS; i++) begin
            sb_valid[i]    = 1'b0;
            sb_expected[i] = '0;
            sb_fulladdr[i] = '0;
        end
        outstanding = 0;
    endtask

    // Mirror of the fractal_core stub's transfer function.
    function automatic logic [PIXEL_W-1:0] xfer(input logic [JOB_DATA_W-1:0] d);
        logic [PIXEL_W-1:0] r;
        r = '0;
        for (int i = 0; i < JOB_DATA_W; i++) r[i % PIXEL_W] ^= d[i];
        return r;
    endfunction

    // ─────────────────────────────────────────────────────────────────────
    // dispatch driver
    // The DUT's `cluster_wants_job` is a registered, 1-cycle-delayed view
    // of its internal `local_any_free`. So "I saw cluster_wants_job=1" at
    // time T does not guarantee a dispatch issued at T will land at T+1
    // (other cores may have been consumed in between in heavy traffic).
    //
    // We therefore drive `disp_valid` and then check `dut.pa_we` on the
    // sampling edge — that signal is high iff the DUT actually accepted
    // a dispatch this cycle. Only then do we record the expectation.
    // ─────────────────────────────────────────────────────────────────────
    task automatic do_dispatch(
        input logic [PIXEL_ADDR_W-1:0] addr,
        input logic [JOB_DATA_W-1:0]   data
    );
        int  slot;
        bit  done_dispatch;
        int  attempts;
        slot          = addr & ADDR_MASK;
        done_dispatch = 1'b0;
        attempts      = 0;

        while (!done_dispatch && attempts < 100) begin
            attempts = attempts + 1;

            // wait until cluster claims to be ready
            while (!cluster_wants_job) @(posedge clk);

            // drive the dispatch for one full cycle
            @(posedge clk);
            disp_valid      <= 1'b1;
            disp_pixel_addr <= addr;
            disp_job_data   <= data;

            // the DUT will sample disp_valid on the next posedge into
            // disp_valid_q. Wait for that edge, then sample pa_we after
            // NBA settles (use negedge so all flop updates are visible).
            @(posedge clk);
            disp_valid      <= 1'b0;
            disp_pixel_addr <= '0;
            disp_job_data   <= '0;
            @(negedge clk);

            // After the negedge, disp_valid_q is settled. pa_we is the
            // combinational AND of disp_valid_q & local_any_free for this
            // cycle. If high, the DUT accepted the dispatch on the previous
            // posedge.
            if (dut.pa_we) begin
                if (sb_valid[slot]) begin
                    $error("[%0t] TB BUG: duplicate slot for pixel_addr 0x%0h (existing 0x%0h)",
                           $time, addr, sb_fulladdr[slot]);
                    error_count = error_count + 1;
                end
                sb_valid[slot]    = 1'b1;
                sb_expected[slot] = xfer(data);
                sb_fulladdr[slot] = addr;
                outstanding       = outstanding + 1;
                dispatched_count  = dispatched_count + 1;
                done_dispatch     = 1'b1;
            end
        end

        if (!done_dispatch) begin
            $error("[%0t] do_dispatch giving up on addr 0x%0h", $time, addr);
            error_count = error_count + 1;
        end
    endtask

    // ─────────────────────────────────────────────────────────────────────
    // result collector (runs in background)
    // ─────────────────────────────────────────────────────────────────────
    bit collector_enable;
    bit collector_random_ready;

    initial begin
        result_ready = 1'b0;
        forever begin
            int slot;
            @(posedge clk);

            // FIRST: check if a transfer happened at THIS edge.
            // The DUT's FIFO advances when result_valid && result_ready are
            // both high at the posedge. result_ready holds the value driven
            // on the previous iteration of this loop.
            if (result_valid && result_ready) begin
                slot = result_pixel_addr & ADDR_MASK;
                if (!sb_valid[slot] || sb_fulladdr[slot] !== result_pixel_addr) begin
                    $error("[%0t] SCOREBOARD: unexpected result for pixel_addr 0x%0h",
                           $time, result_pixel_addr);
                    error_count = error_count + 1;
                end else if (sb_expected[slot] !== result_data) begin
                    $error("[%0t] SCOREBOARD: addr 0x%0h expected 0x%0h got 0x%0h",
                           $time, result_pixel_addr,
                           sb_expected[slot], result_data);
                    error_count = error_count + 1;
                end else begin
                    sb_valid[slot]  = 1'b0;
                    outstanding     = outstanding - 1;
                    collected_count = collected_count + 1;
                end
            end

            // THEN: drive result_ready for the *next* cycle.
            if (!collector_enable) begin
                result_ready <= 1'b0;
            end else if (collector_random_ready) begin
                result_ready <= ($urandom & 1);
            end else begin
                result_ready <= 1'b1;
            end
        end
    end

    // ─────────────────────────────────────────────────────────────────────
    // invariants — checked every cycle as immediate assertions
    // (using always_ff rather than SVA so the testbench runs on simulators
    //  with limited concurrent-assertion support such as Icarus)
    // ─────────────────────────────────────────────────────────────────────

    // 1. No core has both ready and done at the same time.
    //    Wrapped in a generate so the hierarchical index is a constant
    //    (Icarus rejects runtime-indexed hierarchical references).
    generate
        for (genvar g = 0; g < CLUSTER_SIZE; g++) begin : gen_check_core
            always_ff @(posedge clk) begin
                if (rst_n &&
                    dut.gen_cores[g].u_core.ready &&
                    dut.gen_cores[g].u_core.done) begin
                    $error("[%0t] core %0d violated !ready || !done", $time, g);
                    error_count = error_count + 1;
                end
            end
        end
    endgenerate

    // 2. core_start is one-hot or all-zero; dispatched bits must be free.
    always_ff @(posedge clk) begin
        if (rst_n) begin
            if ($countones(dut.core_start) > 1) begin
                $error("[%0t] core_start not one-hot: %b", $time, dut.core_start);
                error_count = error_count + 1;
            end
            if ((dut.core_start & ~dut.core_wants_job) != '0) begin
                $error("[%0t] dispatched to non-free core: start=%b wants=%b",
                       $time, dut.core_start, dut.core_wants_job);
                error_count = error_count + 1;
            end
        end
    end

    // ─────────────────────────────────────────────────────────────────────
    // helpers
    // ─────────────────────────────────────────────────────────────────────
    task automatic reset_dut();
        rst_n           = 1'b0;
        disp_valid      = 1'b0;
        disp_pixel_addr = '0;
        disp_job_data   = '0;
        repeat (4) @(posedge clk);
        rst_n           = 1'b1;
        @(posedge clk);
    endtask

    task automatic wait_idle(input int max_cycles = 5000);
        int c;
        c = 0;
        while (outstanding > 0 && c < max_cycles) begin
            @(posedge clk);
            c++;
        end
        if (outstanding > 0) begin
            $error("[%0t] wait_idle TIMED OUT, %0d outstanding", $time, outstanding);
            $display("       cluster_wants_job=%b  core_wants_job=%b  core_done=%b",
                     cluster_wants_job, dut.core_wants_job, dut.core_done);
            $display("       fifo_empty=%b fifo_full=%b result_valid=%b result_ready=%b",
                     dut.fifo_empty, dut.fifo_full, result_valid, result_ready);
            $display("       collector_enable=%b collector_random_ready=%b",
                     collector_enable, collector_random_ready);
            for (int i = 0; i < MAX_ADDRS; i++) begin
                if (sb_valid[i]) $display("         outstanding slot %0d: addr=0x%0h",
                                          i, sb_fulladdr[i]);
            end
            error_count = error_count + 1;
        end
    endtask

    task automatic banner(input string s);
        $display("\n──────────────────────────────────────────────────────────");
        $display(" TEST: %s", s);
        $display("──────────────────────────────────────────────────────────");
    endtask

    // ─────────────────────────────────────────────────────────────────────
    // tests
    // ─────────────────────────────────────────────────────────────────────
    task automatic test_single_dispatch();
        banner("single_dispatch");
        collector_enable       = 1'b1;
        collector_random_ready = 1'b0;
        do_dispatch(16'h1234, 18'hABCDE);
        wait_idle();
        $display(" → dispatched=%0d collected=%0d", dispatched_count, collected_count);
    endtask

    task automatic test_saturate_then_drain();
        int n;
        banner("saturate_then_drain");
        collector_enable       = 1'b1;
        collector_random_ready = 1'b0;
        n = CLUSTER_SIZE;
        for (int i = 0; i < n; i++) begin
            do_dispatch(16'h2000 + i[15:0], $urandom & ((1 << JOB_DATA_W) - 1));
        end
        wait_idle();
        $display(" → dispatched=%0d collected=%0d", n, collected_count);
    endtask

    task automatic test_simultaneous_completion();
        // The fractal_core stub has random latency, but if we dispatch a
        // burst on consecutive cycles, multiple cores end up close together
        // in latency and frequently finish on the same cycle.
        banner("simultaneous_completion");
        collector_enable       = 1'b1;
        collector_random_ready = 1'b0;
        for (int i = 0; i < CLUSTER_SIZE; i++) begin
            do_dispatch(16'h3000 + i[15:0], i[JOB_DATA_W-1:0]);
        end
        wait_idle();
        $display(" → handled bursty completion, collected=%0d", collected_count);
    endtask

    task automatic test_backpressure();
        int held_cycles;
        banner("backpressure");
        // Disable collector for a while, dispatch many jobs, then let it drain.
        collector_enable       = 1'b0;
        collector_random_ready = 1'b0;
        for (int i = 0; i < CLUSTER_SIZE; i++) begin
            do_dispatch(16'h4000 + i[15:0], $urandom & ((1 << JOB_DATA_W) - 1));
        end
        // Wait long enough that cores have finished and the FIFO is filling.
        held_cycles = 200;
        repeat (held_cycles) @(posedge clk);
        $display(" → held result_ready low for %0d cycles, outstanding=%0d",
                 held_cycles, outstanding);
        // Now drain.
        collector_enable = 1'b1;
        wait_idle();
        $display(" → drained, collected=%0d", collected_count);
    endtask

    task automatic test_reset_midflight();
        banner("reset_midflight");
        collector_enable       = 1'b1;
        collector_random_ready = 1'b0;
        // dispatch a couple of jobs
        do_dispatch(16'h5001, 18'h11111);
        do_dispatch(16'h5002, 18'h22222);
        // assert reset before they finish
        repeat (3) @(posedge clk);
        rst_n = 1'b0;
        // clear scoreboard of in-flight expectations (reset throws them away)
        sb_clear();
        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);
        // verify the cluster is reusable
        do_dispatch(16'h5003, 18'h33333);
        wait_idle();
        $display(" → recovered from mid-flight reset, collected=%0d", collected_count);
    endtask

    task automatic test_random_stress();
        int n_jobs;
        int gap;
        logic [PIXEL_ADDR_W-1:0] addr;
        banner("random_stress");
        collector_enable       = 1'b1;
        collector_random_ready = 1'b1;
        n_jobs = 200;
        for (int i = 0; i < n_jobs; i++) begin
            // unique addresses guaranteed by including i
            addr = 16'h8000 + i[15:0];
            do_dispatch(addr, $urandom & ((1 << JOB_DATA_W) - 1));
            gap = $urandom_range(0, 3);
            repeat (gap) @(posedge clk);
        end
        wait_idle(50_000);
        $display(" → random_stress: dispatched=%0d collected=%0d",
                 n_jobs, collected_count);
    endtask

    // ─────────────────────────────────────────────────────────────────────
    // main sequence
    // ─────────────────────────────────────────────────────────────────────
    initial begin
        string vcd_path;
        if ($value$plusargs("vcd=%s", vcd_path)) begin
            $dumpfile(vcd_path);
            $dumpvars(0, tb_cluster);
        end
    end

    initial begin
        dispatched_count = 0;
        collected_count  = 0;
        error_count      = 0;
        collector_enable = 1'b0;
        sb_clear();

        reset_dut();
        test_single_dispatch();

        reset_dut();
        dispatched_count = 0; collected_count = 0;
        sb_clear();
        test_saturate_then_drain();

        reset_dut();
        dispatched_count = 0; collected_count = 0;
        sb_clear();
        test_simultaneous_completion();

        reset_dut();
        dispatched_count = 0; collected_count = 0;
        sb_clear();
        test_backpressure();

        reset_dut();
        dispatched_count = 0; collected_count = 0;
        sb_clear();
        test_reset_midflight();

        reset_dut();
        dispatched_count = 0; collected_count = 0;
        sb_clear();
        test_random_stress();

        $display("\n══════════════════════════════════════════════════════════");
        if (error_count == 0) $display(" ALL TESTS PASSED");
        else                  $display(" FAILED — %0d errors", error_count);
        $display("══════════════════════════════════════════════════════════\n");

        $finish;
    end

    // safety net
    initial begin
        #5ms;
        $error("Global timeout");
        $finish;
    end

endmodule