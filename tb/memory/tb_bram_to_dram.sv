`timescale 1ns/1ps

module tb_bram_to_dram;

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

    logic clk = 0;
    always #5 clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    logic [255:0] tile_done;
    logic         engine_done;
    logic [7:0]   tt_rd_index;
    logic         tt_is_filled;
    logic [5:0]   tt_fill_colour;
    logic [12:0]  b2d_word_addr;
    logic         b2d_rd_en;
    logic         b2d_rd_grant;
    logic [63:0]  b2d_rd_data;
    logic [31:0]  axi_wr_addr;
    logic [63:0]  axi_wr_data;
    logic         axi_wr_en;
    logic         axi_wr_ready;
    logic         cache_valid_wr_en;
    logic [7:0]   cache_valid_index;
    logic         cache_valid_value;
    logic [31:0]  sixteenth_base_addr;
    logic         quarter_complete;
    logic         rst;

    bram_to_dram dut (
        .clk                (clk),
        .rst                (rst),
        .tile_done          (tile_done),
        .engine_done        (engine_done),
        .tt_rd_index        (tt_rd_index),
        .tt_is_filled       (tt_is_filled),
        .tt_fill_colour     (tt_fill_colour),
        .b2d_word_addr      (b2d_word_addr),
        .b2d_rd_en          (b2d_rd_en),
        .b2d_rd_grant       (b2d_rd_grant),
        .b2d_rd_data        (b2d_rd_data),
        .axi_wr_addr        (axi_wr_addr),
        .axi_wr_data        (axi_wr_data),
        .axi_wr_en          (axi_wr_en),
        .axi_wr_ready       (axi_wr_ready),
        .cache_valid_wr_en  (cache_valid_wr_en),
        .cache_valid_index  (cache_valid_index),
        .cache_valid_value  (cache_valid_value),
        .sixteenth_base_addr(sixteenth_base_addr),
        .quarter_complete   (quarter_complete)
    );

    // BRAM model — always grant, echo address in all bytes
    always_comb begin
        b2d_rd_grant = b2d_rd_en;
        b2d_rd_data  = {8{b2d_word_addr[7:0]}};
    end

    // AXI capture
    logic [63:0] axi_captured [0:31];
    logic [31:0] axi_addr_captured [0:31];
    int          axi_capture_count;

    // AXI capture — blocking assignments so initial block can reset count
    always @(posedge clk) begin
        #1; // wait for non-blocking assignments to settle
        if (axi_wr_en && axi_wr_ready && axi_capture_count < 32) begin
            axi_captured[axi_capture_count]      = axi_wr_data;
            axi_addr_captured[axi_capture_count] = axi_wr_addr;
            axi_capture_count                    = axi_capture_count + 1;
        end
    end

    task automatic do_reset();
        rst = 1; tick(2);
        rst = 0;
        tile_done = '0; engine_done = 0;
        tt_is_filled = 0; tt_fill_colour = 0;
        axi_wr_ready = 1; sixteenth_base_addr = 32'h0;
        axi_capture_count = 0;
        tick(1);
    endtask

    // module-level vars
    int          n, i;
    int          addr_errors, col_errors, writes_seen, denials;
    logic [31:0] expected_addr;
    logic        got_cache_pulse, got_cache_val;
    logic [7:0]  got_cache_idx;

    task automatic wait_tile(input logic [7:0] idx, input int maxc);
        n = 0;
        while (!(cache_valid_wr_en && cache_valid_index == idx) && n < maxc) begin
            tick(1); n++;
        end
        tick(2);
    endtask

    initial begin
        $dumpfile("sim/waves/tb_bram_to_dram.vcd");
        $dumpvars(0, tb_bram_to_dram);
        rst=1; tile_done='0; engine_done=0;
        tt_is_filled=0; tt_fill_colour=0;
        axi_wr_ready=1; sixteenth_base_addr=0;
        axi_capture_count=0;
        tick(3);

        // ============================================================
        suite("TILED TILE — basic transfer AXI always ready");
        // ============================================================
        do_reset();
        tt_is_filled = 0;
        tick(2);
        tile_done[0] = 1;
        wait_tile(8'd0, 200);
        check(axi_capture_count == 32,
            $sformatf("32 AXI writes issued (got %0d)", axi_capture_count));
        addr_errors = 0;
        for (i = 0; i < 32; i++) begin
            expected_addr = 32'h0 + (i * 8);
            if (axi_addr_captured[i] != expected_addr) addr_errors++;
        end
        check(addr_errors == 0,
            $sformatf("all 32 addresses sequential (%0d errors)", addr_errors));

        // ============================================================
        suite("TILED TILE — AXI backpressure");
        // ============================================================
        do_reset();
        tt_is_filled = 0;
        tile_done[1] = 1;
        fork
            begin
                repeat(300) begin
                    axi_wr_ready = 0; tick(2);
                    axi_wr_ready = 1; tick(3);
                end
            end
            begin wait_tile(8'd1, 1500); end
        join
        check(axi_capture_count == 32,
            $sformatf("backpressure: still 32 writes (got %0d)", axi_capture_count));

        // ============================================================
        suite("FLOOD FILLED TILE — solid colour in all AXI writes");
        // ============================================================
        do_reset();
        tt_is_filled   = 1;
        tt_fill_colour = 6'h2A;
        tile_done[0]   = 1;
        wait_tile(8'd0, 200);
        check(axi_capture_count == 32,
            $sformatf("flood fill: 32 AXI writes (got %0d)", axi_capture_count));
        col_errors = 0;
        for (i = 0; i < 32; i++) begin
            if (axi_captured[i][7:0]   != {2'b0, 6'h2A}) col_errors++;
            if (axi_captured[i][15:8]  != {2'b0, 6'h2A}) col_errors++;
            if (axi_captured[i][23:16] != {2'b0, 6'h2A}) col_errors++;
            if (axi_captured[i][31:24] != {2'b0, 6'h2A}) col_errors++;
            if (axi_captured[i][39:32] != {2'b0, 6'h2A}) col_errors++;
            if (axi_captured[i][47:40] != {2'b0, 6'h2A}) col_errors++;
            if (axi_captured[i][55:48] != {2'b0, 6'h2A}) col_errors++;
            if (axi_captured[i][63:56] != {2'b0, 6'h2A}) col_errors++;
        end
        check(col_errors == 0,
            $sformatf("flood fill: all words are fill colour (%0d errors)", col_errors));

        // ============================================================
        suite("FLOOD FILL — cache_valid=0");
        // ============================================================
        do_reset();
        tt_is_filled   = 1;
        tt_fill_colour = 6'h0F;
        tile_done[5]   = 1;
        got_cache_pulse = 0; got_cache_val = 0; got_cache_idx = 0;
        repeat(100) begin
            @(posedge clk); #1;
            if (cache_valid_wr_en) begin
                got_cache_pulse = 1;
                got_cache_val   = cache_valid_value;
                got_cache_idx   = cache_valid_index;
            end
        end
        check(got_cache_pulse,       "cache_valid_wr_en pulsed");
        check(got_cache_val == 1'b0, "cache_valid=0 for flood fill");
        check(got_cache_idx == 8'd5, "cache_valid_index=5");

        // ============================================================
        suite("TILED TILE — cache_valid=1");
        // ============================================================
        do_reset();
        tt_is_filled = 0;
        tile_done[3] = 1;
        got_cache_pulse = 0; got_cache_val = 0;
        repeat(150) begin
            @(posedge clk); #1;
            if (cache_valid_wr_en && cache_valid_index == 8'd3) begin
                got_cache_pulse = 1;
                got_cache_val   = cache_valid_value;
            end
        end
        check(got_cache_pulse,       "cache_valid_wr_en pulsed for tile 3");
        check(got_cache_val == 1'b1, "cache_valid=1 for tiled tile");

        // ============================================================
        suite("MULTIPLE TILES — 3 tiled tiles sequentially");
        // ============================================================
        do_reset();
        tt_is_filled = 0;
        tile_done[0] = 1; tile_done[1] = 1; tile_done[2] = 1;
        writes_seen = 0;
        repeat(300) begin
            @(posedge clk); #1;
            if (axi_wr_en && axi_wr_ready) writes_seen++;
        end
        check(writes_seen == 96,
            $sformatf("3 tiles: 96 total writes (got %0d)", writes_seen));

        // ============================================================
        suite("QUARTER COMPLETE — needs both all-transferred and engine_done");
        // ============================================================
        do_reset();
        tt_is_filled = 1; tt_fill_colour = 6'h01;
        tile_done    = '1;
        engine_done  = 0;
        repeat(10000) tick(1);
        check(!quarter_complete, "quarter_complete low without engine_done");
        engine_done = 1; tick(5);
        check(quarter_complete, "quarter_complete after engine_done");

        // ============================================================
        suite("QUARTER COMPLETE — engine_done before tiles");
        // ============================================================
        do_reset();
        tt_is_filled = 1; tt_fill_colour = 6'h01;
        engine_done  = 1;
        tick(2);
        check(!quarter_complete, "quarter_complete low before any tiles transferred");
        tile_done = '1;
        repeat(10000) tick(1);
        check(quarter_complete, "quarter_complete after all tiles transferred");

        // ============================================================
        suite("BASE ADDRESS — AXI addresses respect sixteenth_base_addr");
        // ============================================================
        do_reset();
        sixteenth_base_addr = 32'h00100000;
        tt_is_filled = 0;
        tick(2);
        tile_done[0] = 1;
        wait_tile(8'd0, 200);
        check(axi_addr_captured[0]  == 32'h00100000,
            $sformatf("first write at base (got 0x%08X)", axi_addr_captured[0]));
        check(axi_addr_captured[1]  == 32'h00100008,
            $sformatf("second write at base+8 (got 0x%08X)", axi_addr_captured[1]));
        check(axi_addr_captured[31] == 32'h001000F8,
            $sformatf("last write at base+248 (got 0x%08X)", axi_addr_captured[31]));

        summary();
        $finish;
    end

    initial begin #100000000; $display("[TIMEOUT]"); $finish; end

endmodule