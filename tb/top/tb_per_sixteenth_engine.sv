// Integration testbench for per_sixteenth_engine

// Stub behaviour:
//   scheduler  - pushes 4 border pixels of a 16x16 quad, waits for comparator
//                complete, then flood-fills tile 0 and asserts engine_done.
//   control_unit - 4-cycle pipeline; always responds with colour 5 (4'd5).

`timescale 1ns/1ps

module tb_per_sixteenth_engine;

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

    // 100 MHz clock
    logic clk = 0;
    always #5 clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // DUT ports
    logic        rst;
    logic        start;
    logic        engine_done;
    logic        quarter_complete;
    logic [4:0]  equation_id;
    logic [31:0] centre_x, centre_y, zoom_level;
    logic [11:0] max_iter;
    logic [9:0]  x_offset, y_offset;
    logic [31:0] sixteenth_base_addr;
    logic [31:0] axi_wr_addr;
    logic [63:0] axi_wr_data;
    logic        axi_wr_en;
    logic        axi_wr_ready;

    per_sixteenth_engine dut (
        .clk                (clk),
        .rst                (rst),
        .start              (start),
        .engine_done        (engine_done),
        .quarter_complete   (quarter_complete),
        .equation_id        (equation_id),
        .centre_x           (centre_x),
        .centre_y           (centre_y),
        .zoom_level         (zoom_level),
        .max_iter           (max_iter),
        .x_offset           (x_offset),
        .y_offset           (y_offset),
        .sixteenth_base_addr(sixteenth_base_addr),
        .axi_wr_addr        (axi_wr_addr),
        .axi_wr_data        (axi_wr_data),
        .axi_wr_en          (axi_wr_en),
        .axi_wr_ready       (axi_wr_ready)
    );

    // AXI write capture
    logic [31:0] axi_addr_log [0:255];
    logic [63:0] axi_data_log [0:255];
    int          axi_log_count;

    // Collect exactly n AXI writes (axi_wr_ready must already be held high)
    task automatic collect_axi(input int n, input int timeout_ticks);
        int collected, t;
        collected = 0; t = 0;
        axi_log_count = 0;
        while (collected < n && t < timeout_ticks) begin
            @(posedge clk); #1;
            t++;
            if (axi_wr_en) begin
                if (collected < 256) begin
                    axi_addr_log[collected] = axi_wr_addr;
                    axi_data_log[collected] = axi_wr_data;
                end
                collected++;
                axi_log_count = collected;
            end
        end
    endtask

    task automatic do_reset();
        rst = 1; start = 0;
        tick(3);
        rst = 0;
        tick(1);
    endtask

    // Wait up to timeout cycles for engine_done, return cycles elapsed
    task automatic wait_engine_done(input int timeout, output int elapsed, output int fired);
        elapsed = 0; fired = 0;
        while (elapsed < timeout && !engine_done) begin
            tick(1);
            elapsed++;
        end
        if (engine_done) fired = 1;
    endtask

    // module-level variables (Icarus: must be at module scope)
    int  ok, elapsed;
    logic [7:0] exp_byte;

    initial begin
        $dumpfile("sim/waves/tb_per_sixteenth_engine.vcd");
        $dumpvars(0, tb_per_sixteenth_engine);

        // Default config inputs (values don't affect stub behaviour)
        equation_id         = 5'd0;
        centre_x            = 32'h0;
        centre_y            = 32'h0;
        zoom_level          = 32'h0;
        max_iter            = 12'd64;
        x_offset            = 10'd0;
        y_offset            = 10'd0;
        sixteenth_base_addr = 32'h0000_0000;
        axi_wr_ready        = 1'b1;
        start               = 1'b0;
        rst                 = 1'b0;

        suite("RESET STATE");
        do_reset();
        check(!engine_done,      "engine_done low after reset");
        check(!quarter_complete, "quarter_complete low after reset");
        check(!axi_wr_en,        "axi_wr_en low after reset");

        suite("ENGINE DONE - fires after start");
        do_reset();
        start = 1; tick(1); start = 0;
        // Scheduler: CONFIG(1) + PUSH(4) + pipeline latency(4) + comp(1) + FILL(1)
        // ≈ 15 cycles min; allow 200 for queue latency
        wait_engine_done(200, elapsed, ok);
        check(ok, "engine_done asserts within 200 cycles of start");
        $display("    (fired after ~%0d cycles)", elapsed);

        suite("JOB QUEUE - pixels flow through full pipeline");
        do_reset();
        start = 1; tick(1); start = 0;
        wait_engine_done(200, elapsed, ok);
        // engine_done only fires after comparator sees 'complete', which
        // requires all 4 pixels to flow through control_unit → complete_queue
        check(ok, "engine_done confirms full scheduler→CU→comparator pipeline");
        tick(5);
        check(!dut.u_complete_queue_handler.full_err,
              "complete_queue no overflow error");

        suite("FLOOD FILL - tile 0 written to AXI after engine_done");
        // Tile 0 is flood-filled (solid colour 5), producing 32 AXI writes.
        do_reset();
        axi_wr_ready = 1;
        start = 1; tick(1); start = 0;
        wait_engine_done(200, elapsed, ok);
        collect_axi(32, 500);
        check(axi_log_count >= 32,
              $sformatf("tile 0: at least 32 AXI writes (got %0d)", axi_log_count));
        // Tile 0 base address = sixteenth_base_addr + tile_index*256 = 0
        if (axi_log_count >= 1)
            check(axi_addr_log[0] == 32'h000,
                  $sformatf("first write addr = 0x000 (got 0x%08X)", axi_addr_log[0]));
        if (axi_log_count >= 32)
            check(axi_addr_log[31] == 32'h0F8,
                  $sformatf("last write addr = 0x0F8 (got 0x%08X)", axi_addr_log[31]));
        // Flood-fill colour 5: each pixel byte = {2'b0, colour[5:0]} = 8'h05
        exp_byte = 8'h05;
        if (axi_log_count >= 1)
            check(axi_data_log[0][7:0] == exp_byte,
                  $sformatf("flood-fill pixel byte = 0x%02X (got 0x%02X)",
                             exp_byte, axi_data_log[0][7:0]));

        suite("AXI BACKPRESSURE - all 32 writes complete with toggling ready");
        do_reset();
        start = 1; tick(1); start = 0;
        wait_engine_done(200, elapsed, ok);
        begin
            int w, t, rdy_cnt;
            w = 0; t = 0; rdy_cnt = 0;
            axi_log_count = 0;
            while (w < 32 && t < 1000) begin
                @(posedge clk); #1; t++;
                rdy_cnt++;
                if      (rdy_cnt == 3) axi_wr_ready = 1;
                else if (rdy_cnt == 5) begin axi_wr_ready = 0; rdy_cnt = 0; end
                if (axi_wr_en) begin
                    if (w < 256) axi_addr_log[w] = axi_wr_addr;
                    w++; axi_log_count = w;
                end
            end
            axi_wr_ready = 1;
        end
        check(axi_log_count >= 32,
              $sformatf("backpressure: all 32 writes complete (got %0d)", axi_log_count));

        suite("RE-RUN - engine restarts cleanly after reset");
        do_reset();
        start = 1; tick(1); start = 0;
        wait_engine_done(200, elapsed, ok);
        check(ok, "first run: engine_done fires");
        do_reset();
        check(!engine_done, "after reset: engine_done deasserted");
        start = 1; tick(1); start = 0;
        wait_engine_done(200, elapsed, ok);
        check(ok, "second run: engine_done fires again");

        summary();
        $finish;
    end

    // Watchdog
    initial begin
        #5_000_000;
        $display("\n[TIMEOUT] simulation exceeded 5 ms wall - possible hang");
        $finish;
    end

endmodule
