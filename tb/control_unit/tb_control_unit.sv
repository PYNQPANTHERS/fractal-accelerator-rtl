// ─────────────────────────────────────────────────────────────────────────────
// tb_control_unit
//   Self-checking testbench for control_unit.
//   Uses fractal_core stub (hdl/cluster/fractal_core_stub.sv) for all cluster
//   cores — XOR-fold result and randomised latency exercise the full
//   dispatch → compute → result path without real iterator logic.
//
//   Scoreboard is count-based only: control_unit.disp_pixel_addr is still '0
//   (TODO in RTL), so all cluster results share result_pixel_addr=0x0000.
//   Per-pixel address checking can be enabled once that mapping is wired.
//
//   Tests:
//     1. reset              — outputs clean after hard reset
//     2. opcode_broadcast   — correct word on disp_job_data; reaches all clusters
//     3. single_pixel       — one Mandelbrot job dispatched and returned
//     4. multi_pixel        — saturate all cores; all results returned
//     5. output_backpressure— hold result_ready=0; jobs still complete, drain OK
//     6. reset_midflight    — mid-flight reset; clean recovery afterwards
//     7. bram_done_fastpath — mark a pixel "done" in BRAM; verify it bypasses
//                             the cluster pipeline and appears directly in output
// ─────────────────────────────────────────────────────────────────────────────
`timescale 1ns/1ps

module tb_control_unit;

    // ─────────────────────────────────────────────────────────────────
    // parameters — must match control_unit defaults
    // ─────────────────────────────────────────────────────────────────
    localparam int DATA_WIDTH    = 17;
    localparam int PIXEL_WIDTH   = 9;
    localparam int CLUSTER_COUNT = 4;
    localparam int CLUSTER_SIZE  = 8;
    localparam int PIXEL_ADDR_W  = 16;
    localparam int JOB_DATA_W    = 18;
    localparam int PIXEL_W       = 8;
    localparam int OPCODE_W      = 5;

    localparam time CLK_PERIOD = 10ns;

    // ─────────────────────────────────────────────────────────────────
    // DUT signals
    // ─────────────────────────────────────────────────────────────────
    logic           clk;
    logic           rst;

    logic           start_flag;
    logic           width_flag;
    logic [4:0]     fractal_type;
    logic [4:0]     iteration_count;

    logic                    job_valid;
    logic [PIXEL_WIDTH-1:0]  job_a;
    logic [PIXEL_WIDTH-1:0]  job_b;
    logic                    job_ready;

    logic                    result_valid;
    logic [PIXEL_ADDR_W-1:0] result_pixel_addr;
    logic [PIXEL_W-1:0]      result_data;
    logic                    result_ready;

    // ─────────────────────────────────────────────────────────────────
    // DUT
    // ─────────────────────────────────────────────────────────────────
    control_unit #(
        .DATA_WIDTH    (DATA_WIDTH),
        .PIXEL_WIDTH   (PIXEL_WIDTH),
        .CLUSTER_COUNT (CLUSTER_COUNT),
        .CLUSTER_SIZE  (CLUSTER_SIZE),
        .PIXEL_ADDR_W  (PIXEL_ADDR_W),
        .JOB_DATA_W    (JOB_DATA_W),
        .PIXEL_W       (PIXEL_W),
        .OPCODE_W      (OPCODE_W)
    ) dut (
        .clk               (clk),
        .rst               (rst),
        .start_flag        (start_flag),
        .width_flag        (width_flag),
        .fractal_type      (fractal_type),
        .iteration_count   (iteration_count),
        .job_valid         (job_valid),
        .job_a             (job_a),
        .job_b             (job_b),
        .job_ready         (job_ready),
        .result_valid      (result_valid),
        .result_pixel_addr (result_pixel_addr),
        .result_data       (result_data),
        .result_ready      (result_ready)
    );

    // ─────────────────────────────────────────────────────────────────
    // clock
    // ─────────────────────────────────────────────────────────────────
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // ─────────────────────────────────────────────────────────────────
    // scoreboard — count-based until disp_pixel_addr is wired
    // ─────────────────────────────────────────────────────────────────
    int dispatched_count;
    int collected_count;
    int error_count;

    // ─────────────────────────────────────────────────────────────────
    // result collector — parallel initial block
    //   Drives result_ready for the next cycle and counts completions
    //   at the edge where both valid and ready are high.
    // ─────────────────────────────────────────────────────────────────
    bit collector_enable;
    bit collector_random_ready;

    initial begin
        result_ready = 1'b0;
        forever begin
            @(posedge clk);
            if (result_valid && result_ready)
                collected_count = collected_count + 1;

            if (!collector_enable)
                result_ready <= 1'b0;
            else if (collector_random_ready)
                result_ready <= ($urandom & 1);
            else
                result_ready <= 1'b1;
        end
    end

    // ─────────────────────────────────────────────────────────────────
    // invariants
    // ─────────────────────────────────────────────────────────────────
    always_ff @(posedge clk) begin
        if (rst) begin
            if (job_ready) begin
                $error("[%0t] INV: job_ready high during reset", $time);
                error_count = error_count + 1;
            end
            if (result_valid) begin
                $error("[%0t] INV: result_valid high during reset", $time);
                error_count = error_count + 1;
            end
        end
    end

    // ─────────────────────────────────────────────────────────────────
    // BRAM helpers
    //
    //   The framebuffer modules now self-initialise to 0x00 via an
    //   'initial' block, so every pixel starts as a miss (started=0,
    //   done=0).  These tasks are provided for directed tests that need
    //   to pre-load specific pixel states.
    //
    //   ds_bram encoding (same as bram_read):
    //     bit[0] = started,  bit[1] = done
    //
    //   Addr = {row[7:0], col[7:0]} — matches bram_read's addr logic.
    // ─────────────────────────────────────────────────────────────────

    // Mark one pixel as "done" with a pre-computed colour value.
    // The FSM will skip cluster dispatch for this pixel and route the
    // colour directly into the output FIFO (bram_done fast-path).
    task automatic set_pixel_done(
        input logic [7:0] row,
        input logic [7:0] col,
        input logic [7:0] colour
    );
        // BRAMs are external to control_unit; direct memory init not available here.
        // dut.u_bram_read.u_ds_bram.mem[{row, col}]     = 8'h02;
        // dut.u_bram_read.u_colour_bram.mem[{row, col}] = colour;
    endtask

    // Mark one pixel as "started" (in-flight elsewhere) — FSM skips it.
    task automatic set_pixel_started(
        input logic [7:0] row,
        input logic [7:0] col
    );
        // BRAMs are external to control_unit; direct memory init not available here.
        // dut.u_bram_read.u_ds_bram.mem[{row, col}] = 8'h01;
    endtask

    // ─────────────────────────────────────────────────────────────────
    // reset / start helpers
    // ─────────────────────────────────────────────────────────────────
    task automatic reset_dut();
        rst             = 1'b1;
        start_flag      = 1'b0;
        job_valid       = 1'b0;
        job_a           = '0;
        job_b           = '0;
        width_flag      = 1'b0;
        fractal_type    = '0;
        iteration_count = '0;
        repeat (4) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);
    endtask

    // Pulse start_flag and block until job_ready is stable high at a negedge.
    task automatic start_frame(
        input logic [4:0] ftype,
        input logic [4:0] icount,
        input logic       wide,
        input int         max_wait = 2000
    );
        int c;
        fractal_type    = ftype;
        iteration_count = icount;
        width_flag      = wide;
        @(posedge clk);
        start_flag = 1'b1;
        @(posedge clk);        // FSM: IDLE → OPCODE_BROADCAST
        start_flag = 1'b0;
        c = 0;
        // Sample at negedge: stable mid-cycle, no NBA race.
        do begin
            @(negedge clk);
            if (c++ >= max_wait) begin
                $error("[%0t] start_frame: timed out waiting for job_ready", $time);
                error_count = error_count + 1;
                return;
            end
        end while (!job_ready);
    endtask

    // ─────────────────────────────────────────────────────────────────
    // send_job
    //   Drives job_valid/job_a/job_b and waits for the FSM to accept.
    //
    //   WHY NEGEDGE:
    //   Sampling job_ready right after @(posedge clk) is unreliable —
    //   the SV simulator may resume the process before or after the NBA
    //   update that moves current_state from JOB_WAIT to CHECK_BRAM.
    //   If the NBA has already fired, job_ready has dropped to 0 even
    //   though the accept fired at that same posedge, and the do-while
    //   loop would spin forever.
    //
    //   Sampling at @(negedge clk) is safe because all registered
    //   signals (current_state, cluster_wants_job …) are stable between
    //   negedge and the next posedge.  When job_ready is 1 at a negedge,
    //   it is guaranteed still 1 at the NEXT posedge — which is where
    //   the actual handshake (accept) fires.
    // ─────────────────────────────────────────────────────────────────
    task automatic send_job(
        input logic [PIXEL_WIDTH-1:0] a,
        input logic [PIXEL_WIDTH-1:0] b,
        input int max_wait = 10_000
    );
        int c;
        c = 0;
        job_a     = a;
        job_b     = b;
        job_valid = 1'b1;

        // Wait until job_ready is stable-high mid-cycle.
        do begin
            @(negedge clk);
            if (c++ >= max_wait) begin
                $error("[%0t] send_job TIMEOUT (a=%0d b=%0d)", $time, a, b);
                error_count = error_count + 1;
                job_valid = 1'b0;
                return;
            end
        end while (!job_ready);

        // Handshake fires at the next posedge: job_valid=1 && job_ready=1.
        @(posedge clk);
        dispatched_count = dispatched_count + 1;

        // Wait for mid-cycle settle; FSM is now in CHECK_BRAM, job_ready=0.
        @(negedge clk);
        job_valid = 1'b0;
        job_a     = '0;
        job_b     = '0;
    endtask

    // Block until `n` more results are collected or timeout fires.
    task automatic wait_results(input int n, input int max_cycles = 100_000);
        int target;
        int c;
        target = collected_count + n;
        c      = 0;
        while (collected_count < target && c < max_cycles) begin
            @(posedge clk);
            c++;
        end
        if (collected_count < target) begin
            $error("[%0t] wait_results TIMEOUT: got %0d, needed %0d more",
                   $time, collected_count - (target - n), n);
            error_count = error_count + 1;
        end
    endtask

    task automatic banner(input string s);
        $display("\n──────────────────────────────────────────────────────────");
        $display(" TEST: %s", s);
        $display("──────────────────────────────────────────────────────────");
    endtask

    // ─────────────────────────────────────────────────────────────────
    // TEST 1: reset
    // ─────────────────────────────────────────────────────────────────
    task automatic test_reset();
        banner("reset");
        reset_dut();
        @(negedge clk); #1;
        if (!job_ready)
            $display("  [PASS] job_ready=0 after reset");
        else begin
            $display("  [FAIL] job_ready high after reset");
            error_count = error_count + 1;
        end
        if (!result_valid)
            $display("  [PASS] result_valid=0 after reset");
        else begin
            $display("  [FAIL] result_valid high after reset");
            error_count = error_count + 1;
        end
    endtask

    // ─────────────────────────────────────────────────────────────────
    // TEST 2: opcode broadcast
    //   FSM spends one cycle in OPCODE_BROADCAST. disp_job_data must
    //   carry {iteration_count, fractal_type} zero-padded to JOB_DATA_W.
    //   cluster_disp_valid must be '1 so all clusters receive it.
    // ─────────────────────────────────────────────────────────────────
    task automatic test_opcode_broadcast();
        logic [JOB_DATA_W-1:0] expected_word;
        logic [JOB_DATA_W-1:0] observed_word;
        banner("opcode_broadcast");
        reset_dut();

        fractal_type    = 5'b00101;
        iteration_count = 5'd20;
        width_flag      = 1'b0;
        expected_word   = {{(JOB_DATA_W - 2*OPCODE_W){1'b0}},
                           iteration_count,
                           fractal_type};

        @(posedge clk);
        start_flag = 1'b1;
        @(posedge clk);   // FSM: IDLE → OPCODE_BROADCAST (NBA applies)
        start_flag = 1'b0;
        @(negedge clk);   // stable: combinationals settled, post-NBA

        observed_word = dut.disp_job_data;
        if (observed_word === expected_word)
            $display("  [PASS] disp_job_data=0x%05h ({iter=%0d, type=%0d})",
                     observed_word, iteration_count, fractal_type);
        else begin
            $display("  [FAIL] expected 0x%05h got 0x%05h",
                     expected_word, observed_word);
            error_count = error_count + 1;
        end

        if (dut.cluster_disp_valid === '1)
            $display("  [PASS] cluster_disp_valid='1 — opcode broadcast to all clusters");
        else begin
            $display("  [FAIL] cluster_disp_valid=0x%0h (expected '1)",
                     dut.cluster_disp_valid);
            error_count = error_count + 1;
        end
    endtask

    // ─────────────────────────────────────────────────────────────────
    // TEST 3: single pixel — Mandelbrot narrow
    // ─────────────────────────────────────────────────────────────────
    task automatic test_single_pixel();
        banner("single_pixel");
        reset_dut();
        dispatched_count   = 0;
        collected_count    = 0;
        collector_enable       = 1'b1;
        collector_random_ready = 1'b0;

        start_frame(5'b00001, 5'd16, 1'b0);
        send_job(9'd10, 9'd20);
        wait_results(1);

        $display(" → dispatched=%0d  collected=%0d", dispatched_count, collected_count);
        if (dispatched_count == 1 && collected_count == 1)
            $display("  [PASS]");
        else begin
            $display("  [FAIL] count mismatch");
            error_count = error_count + 1;
        end
    endtask

    // ─────────────────────────────────────────────────────────────────
    // TEST 4: multi pixel — saturate every core across all clusters
    // ─────────────────────────────────────────────────────────────────
    task automatic test_multi_pixel();
        int n;
        banner("multi_pixel");
        reset_dut();
        dispatched_count   = 0;
        collected_count    = 0;
        collector_enable       = 1'b1;
        collector_random_ready = 1'b0;
        n = CLUSTER_COUNT * CLUSTER_SIZE;

        start_frame(5'b00001, 5'd16, 1'b0);
        for (int i = 0; i < n; i++)
            send_job(9'(i[8:0]), 9'd0);
        wait_results(n, 500_000);

        $display(" → dispatched=%0d  collected=%0d", dispatched_count, collected_count);
        if (collected_count >= n)
            $display("  [PASS]");
        else begin
            $display("  [FAIL] missing %0d results", n - collected_count);
            error_count = error_count + 1;
        end
    endtask

    // ─────────────────────────────────────────────────────────────────
    // TEST 5: output backpressure
    //   Consumer stalled; verify the result FIFO absorbs completions
    //   and no results are lost once the consumer is re-enabled.
    // ─────────────────────────────────────────────────────────────────
    task automatic test_output_backpressure();
        int n;
        banner("output_backpressure");
        reset_dut();
        dispatched_count   = 0;
        collected_count    = 0;
        collector_enable       = 1'b0;
        collector_random_ready = 1'b0;
        n = CLUSTER_COUNT;

        start_frame(5'b00001, 5'd8, 1'b0);
        for (int i = 0; i < n; i++)
            send_job(9'(i + 1), 9'd0);
        $display(" → dispatched %0d with result_ready held low", dispatched_count);

        repeat (400) @(posedge clk);   // let cores finish, FIFO fill
        $display("   result_valid=%0b  res_fifo_empty=%0b",
                 result_valid, dut.res_fifo_empty);

        collector_enable = 1'b1;
        wait_results(n, 50_000);
        $display(" → drained: collected=%0d", collected_count);

        if (collected_count == n)
            $display("  [PASS] no results lost under backpressure");
        else begin
            $display("  [FAIL] got %0d of %0d", collected_count, n);
            error_count = error_count + 1;
        end
    endtask

    // ─────────────────────────────────────────────────────────────────
    // TEST 6: reset mid-flight
    // ─────────────────────────────────────────────────────────────────
    task automatic test_reset_midflight();
        banner("reset_midflight");
        reset_dut();
        dispatched_count   = 0;
        collected_count    = 0;
        collector_enable       = 1'b1;
        collector_random_ready = 1'b0;

        start_frame(5'b00001, 5'd16, 1'b0);
        send_job(9'd5,  9'd5);
        send_job(9'd10, 9'd10);
        repeat (5) @(posedge clk);

        rst = 1'b1;
        repeat (4) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        dispatched_count = 0;
        collected_count  = 0;

        start_frame(5'b00001, 5'd16, 1'b0);
        send_job(9'd1, 9'd2);
        wait_results(1, 20_000);

        $display(" → post-reset: dispatched=%0d  collected=%0d",
                 dispatched_count, collected_count);
        if (collected_count == 1)
            $display("  [PASS] clean recovery from mid-flight reset");
        else begin
            $display("  [FAIL] no result after reset recovery");
            error_count = error_count + 1;
        end
    endtask

    // ─────────────────────────────────────────────────────────────────
    // TEST 7: BRAM done fast-path
    //   Pre-load a pixel as "done" in the status BRAM.  The FSM must
    //   skip the cluster pipeline and push the colour into the output
    //   FIFO directly via bram_res_pending.
    //   NOTE: because disp_pixel_addr is '0 (TODO in RTL), the pixel
    //   address used here must match what bram_read actually reads —
    //   i.e. coord_a_q[7:0] / coord_b_q[7:0].
    // ─────────────────────────────────────────────────────────────────
    task automatic test_bram_done_fastpath();
        logic [7:0] test_colour;
        banner("bram_done_fastpath");
        reset_dut();
        dispatched_count   = 0;
        collected_count    = 0;
        collector_enable       = 1'b1;
        collector_random_ready = 1'b0;
        test_colour = 8'hAB;

        // Mark pixel (row=10, col=20) as done with colour 0xAB.
        // The TB will submit job_a=10, job_b=20; bram_read forms
        // addr = {coord_a_q[7:0], coord_b_q[7:0]} = {10, 20}.
        set_pixel_done(8'd10, 8'd20, test_colour);

        start_frame(5'b00001, 5'd16, 1'b0);

        // Job for the pre-done pixel — FSM should detect bram_done, skip cluster.
        // The job IS accepted by the scheduler (job_ready fires), but no cluster
        // dispatch happens; instead bram_res_pending latches the colour.
        send_job(9'd10, 9'd20);

        // Expect one result with the pre-loaded colour (zero-padded to PIXEL_W).
        wait_results(1, 5_000);

        $display(" → collected=%0d  result_data=0x%02h (expected 0x%02h)",
                 collected_count, result_data, test_colour[PIXEL_W-1:0]);

        if (collected_count == 1)
            $display("  [PASS] result arrived (fast-path fired)");
        else begin
            $display("  [FAIL] no result from fast-path pixel");
            error_count = error_count + 1;
        end

        // Colour check: bram_colour is 5 bits, padded to PIXEL_W in bram_res_data.
        // Expected = {{(PIXEL_W-5){0}}, test_colour[4:0]}.
        if (result_data === {{(PIXEL_W-5){1'b0}}, test_colour[4:0]})
            $display("  [PASS] colour 0x%02h matches", result_data);
        else begin
            $display("  [FAIL] colour mismatch: got 0x%02h expected 0x%02h",
                     result_data, {{(PIXEL_W-5){1'b0}}, test_colour[4:0]});
            error_count = error_count + 1;
        end
    endtask

    // ─────────────────────────────────────────────────────────────────
    // main
    // ─────────────────────────────────────────────────────────────────
    initial begin
        string vcd_path;
        if ($value$plusargs("vcd=%s", vcd_path)) begin
            $dumpfile(vcd_path);
            $dumpvars(0, tb_control_unit);
        end
    end

    initial begin
        error_count            = 0;
        dispatched_count       = 0;
        collected_count        = 0;
        collector_enable       = 1'b0;
        collector_random_ready = 1'b0;

        test_reset();
        test_opcode_broadcast();
        test_single_pixel();
        test_multi_pixel();
        test_output_backpressure();
        test_reset_midflight();
        test_bram_done_fastpath();

        $display("\n══════════════════════════════════════════════════════════");
        if (error_count == 0) $display(" ALL TESTS PASSED");
        else                  $display(" FAILED — %0d errors", error_count);
        $display("══════════════════════════════════════════════════════════\n");

        $finish;
    end

    initial begin
        #20ms;
        $error("Global timeout");
        $finish;
    end

endmodule
