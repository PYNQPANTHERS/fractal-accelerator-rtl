`timescale 1ns/1ps

module tb_memory_integration;

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

    // colour_bram
    logic [8:0]  cb_rd_x, cb_rd_y;
    logic        cb_rd_en;
    logic [7:0]  cb_rd_data;
    logic [8:0]  cb_wr_x, cb_wr_y;
    logic        cb_wr_en;
    logic [7:0]  cb_wr_data;
    logic [12:0] b2d_word_addr;
    logic        b2d_rd_en, b2d_rd_grant;
    logic [63:0] b2d_rd_data;

    colour_bram u_cbram (
        .clk           (clk),
        .ctrl_rd_x     (cb_rd_x),    .ctrl_rd_y    (cb_rd_y),
        .ctrl_rd_en    (cb_rd_en),   .ctrl_rd_data (cb_rd_data),
        .ctrl_wr_x     (cb_wr_x),    .ctrl_wr_y    (cb_wr_y),
        .ctrl_wr_en    (cb_wr_en),   .ctrl_wr_data (cb_wr_data),
        .b2d_word_addr (b2d_word_addr),
        .b2d_rd_en     (b2d_rd_en),  .b2d_rd_grant (b2d_rd_grant),
        .b2d_rd_data   (b2d_rd_data)
    );

    // tile_table
    logic       tt_rst;
    logic       tt_single_en;
    logic [7:0] tt_single_idx;
    logic       tt_single_filled;
    logic [5:0] tt_single_colour;
    logic       tt_quad_en;
    logic [7:0] tt_quad_tlx, tt_quad_tly, tt_quad_size;
    logic [5:0] tt_quad_colour;
    wire  [7:0] tt_rd_index;  // driven by bram_to_dram output, read by tile_table
    logic       tt_is_filled;
    logic [5:0] tt_fill_colour;

    tile_table u_ttable (
        .clk             (clk),       .rst             (tt_rst),
        .wr_single_en    (tt_single_en),
        .wr_single_index (tt_single_idx),
        .wr_single_filled(tt_single_filled),
        .wr_single_colour(tt_single_colour),
        .wr_quad_en      (tt_quad_en),
        .wr_quad_tlx     (tt_quad_tlx), .wr_quad_tly  (tt_quad_tly),
        .wr_quad_size    (tt_quad_size),.wr_quad_colour(tt_quad_colour),
        .rd_index        (tt_rd_index),
        .rd_is_filled    (tt_is_filled),.rd_fill_colour(tt_fill_colour)
    );

    // bram_to_dram
    logic [255:0] tile_done;
    logic         engine_done;
    logic [31:0]  axi_wr_addr;
    logic [63:0]  axi_wr_data;
    logic         axi_wr_en, axi_wr_ready;
    logic         cache_valid_wr_en;
    logic [7:0]   cache_valid_index;
    logic         cache_valid_value;
    logic [31:0]  sixteenth_base_addr;
    logic         quarter_complete;
    logic         b2d_rst;

    bram_to_dram u_b2d (
        .clk                (clk),        .rst             (b2d_rst),
        .tile_done          (tile_done),   .engine_done     (engine_done),
        .tt_rd_index        (tt_rd_index), .tt_is_filled    (tt_is_filled),
        .tt_fill_colour     (tt_fill_colour),
        .b2d_word_addr      (b2d_word_addr),
        .b2d_rd_en          (b2d_rd_en),   .b2d_rd_grant    (b2d_rd_grant),
        .b2d_rd_data        (b2d_rd_data),
        .axi_wr_addr        (axi_wr_addr), .axi_wr_data     (axi_wr_data),
        .axi_wr_en          (axi_wr_en),   .axi_wr_ready    (axi_wr_ready),
        .cache_valid_wr_en  (cache_valid_wr_en),
        .cache_valid_index  (cache_valid_index),
        .cache_valid_value  (cache_valid_value),
        .sixteenth_base_addr(sixteenth_base_addr),
        .quarter_complete   (quarter_complete)
    );

    // AXI capture
    logic [63:0] axi_data_log [0:255];
    logic [31:0] axi_addr_log [0:255];
    int          axi_log_count;

    always @(posedge clk) begin
        #1; // wait for non-blocking assignments to settle
        if (axi_wr_en && axi_wr_ready && axi_log_count < 256) begin
            axi_data_log[axi_log_count] = axi_wr_data;
            axi_addr_log[axi_log_count] = axi_wr_addr;
            axi_log_count               = axi_log_count + 1;
        end
    end

    // module-level vars — Icarus requires all vars at module scope
    int          errors, w, b, p, px, py, n;
    logic [7:0]  exp_byte;
    logic        got_cache, got_val;

    task automatic reset_all();
        tt_rst = 1; b2d_rst = 1; tick(2);
        tt_rst = 0; b2d_rst = 0;
        cb_rd_en=0; cb_wr_en=0;
        tt_single_en=0; tt_quad_en=0;
        tile_done='0; engine_done=0;
        axi_wr_ready=1; sixteenth_base_addr=32'h0;
        axi_log_count = 0;
        tick(1);
    endtask

    task automatic ctrl_write(input logic [8:0] x, y, input logic [5:0] col);
        cb_wr_x=x; cb_wr_y=y; cb_wr_data={2'b0,col};
        cb_wr_en=1; tick(1); cb_wr_en=0;
    endtask

    task automatic mark_tiled(input logic [7:0] idx);
        tt_single_idx=idx; tt_single_filled=0;
        tt_single_colour=0; tt_single_en=1;
        tick(1); tt_single_en=0;
    endtask

    task automatic mark_filled(input logic [7:0] idx, input logic [5:0] col);
        tt_single_idx=idx; tt_single_filled=1;
        tt_single_colour=col; tt_single_en=1;
        tick(1); tt_single_en=0;
    endtask

    task automatic wait_writes(input int expected, input int maxc);
        n = 0;
        while (axi_log_count < expected && n < maxc) begin tick(1); n++; end
        tick(2);
    endtask

    initial begin
        $dumpfile("sim/waves/tb_memory_integration.vcd");
        $dumpvars(0, tb_memory_integration);
        cb_rd_en=0; cb_wr_en=0; tt_rst=0; b2d_rst=1;
        tile_done='0; engine_done=0; axi_wr_ready=1;
        sixteenth_base_addr=0; axi_log_count=0;
        tt_single_en=0; tt_quad_en=0;
        tt_quad_tlx=0; tt_quad_tly=0; tt_quad_size=0; tt_quad_colour=0;
        // tt_rd_index driven by bram_to_dram — do not drive from testbench
        tick(3);

        // ============================================================
        suite("TILED TILE — pixels written by ctrl, verified in AXI output");
        // ============================================================
        reset_all();
        for (int y = 0; y < 16; y++)
            for (int x = 0; x < 16; x++)
                ctrl_write(9'(x), 9'(y), 6'((x + y) % 64));
        tick(2);
        mark_tiled(8'd0);
        tick(2);
        tile_done[0] = 1;
        wait_writes(32, 300);
        check(axi_log_count == 32,
            $sformatf("tiled: 32 AXI writes from real BRAM (got %0d)", axi_log_count));
        errors = 0;
        for (w = 0; w < 32; w++) begin
            for (b = 0; b < 8; b++) begin
                p  = w * 8 + b;
                px = p % 16;
                py = p / 16;
                exp_byte = {2'b0, 6'((px + py) % 64)};
                case (b)
                    0: if (axi_data_log[w][7:0]   != exp_byte) errors++;
                    1: if (axi_data_log[w][15:8]  != exp_byte) errors++;
                    2: if (axi_data_log[w][23:16] != exp_byte) errors++;
                    3: if (axi_data_log[w][31:24] != exp_byte) errors++;
                    4: if (axi_data_log[w][39:32] != exp_byte) errors++;
                    5: if (axi_data_log[w][47:40] != exp_byte) errors++;
                    6: if (axi_data_log[w][55:48] != exp_byte) errors++;
                    default: if (axi_data_log[w][63:56] != exp_byte) errors++;
                endcase
            end
        end
        check(errors == 0,
            $sformatf("tiled: all pixel values correct (%0d errors)", errors));
        check(axi_addr_log[0]  == 32'h000, "first addr = 0");
        check(axi_addr_log[1]  == 32'h008, "second addr = 8");
        check(axi_addr_log[31] == 32'h0F8, "last addr = 248");

        // ============================================================
        suite("FLOOD FILLED TILE — no BRAM reads, solid colour in AXI");
        // ============================================================
        reset_all();
        mark_filled(8'd5, 6'h15);
        tick(2);
        tile_done[5] = 1;
        wait_writes(32, 200);
        check(axi_log_count == 32, "flood fill: 32 AXI writes");
        errors = 0;
        for (w = 0; w < 32; w++)
            for (b = 0; b < 8; b++)
                if (axi_data_log[w][b*8 +: 8] != {2'b0, 6'h15}) errors++;
        check(errors == 0, "flood fill: all pixels are 0x15");
        check(axi_addr_log[0] == 32'h500,
            $sformatf("flood fill: base addr tile 5 (got 0x%03X)", axi_addr_log[0]));

        // ============================================================
        suite("MIXED — tiled and filled tiles sequentially");
        // ============================================================
        reset_all();
        for (int y = 0; y < 16; y++)
            for (int x = 0; x < 16; x++)
                ctrl_write(9'(x), 9'(y), 6'(x % 64));
        tick(2);
        mark_tiled(8'd0);
        mark_filled(8'd1, 6'h3F);
        tile_done[0] = 1; tile_done[1] = 1;
        wait_writes(64, 400);
        check(axi_log_count == 64,
            $sformatf("mixed: 64 total writes (got %0d)", axi_log_count));
        // tile 0 first write — pixel (0,0) colour = 0
        check(axi_data_log[0][7:0] == {2'b0, 6'd0},  "tile 0 px(0,0) colour=0");
        check(axi_data_log[0][15:8] == {2'b0, 6'd1}, "tile 0 px(1,0) colour=1");
        // tile 1 writes — all 0x3F
        errors = 0;
        for (w = 32; w < 64; w++)
            for (b = 0; b < 8; b++)
                if (axi_data_log[w][b*8 +: 8] != {2'b0, 6'h3F}) errors++;
        check(errors == 0, "tile 1 (filled): all pixels 0x3F");

        // ============================================================
        suite("CTRL WRITE CONFLICT — data intact despite BRAM stalls");
        // ============================================================
        reset_all();
        for (int y = 0; y < 16; y++)
            for (int x = 0; x < 16; x++)
                ctrl_write(9'(x), 9'(y), 6'((x * y) % 64));
        tick(2);
        mark_tiled(8'd0);
        tile_done[0] = 1;
        // interleave controller writes with b2d reads
        repeat(10) begin
            tick(3);
            cb_wr_x=9'd100; cb_wr_y=9'd100;
            cb_wr_data=8'hFF; cb_wr_en=1;
            tick(1); cb_wr_en=0;
        end
        wait_writes(32, 300);
        check(axi_log_count == 32,
            $sformatf("conflict: all 32 writes complete (got %0d)", axi_log_count));
        errors = 0;
        for (w = 0; w < 32; w++) begin
            for (b = 0; b < 8; b++) begin
                p  = w * 8 + b;
                px = p % 16;
                py = p / 16;
                exp_byte = {2'b0, 6'((px * py) % 64)};
                case (b)
                    0: if (axi_data_log[w][7:0]   != exp_byte) errors++;
                    1: if (axi_data_log[w][15:8]  != exp_byte) errors++;
                    2: if (axi_data_log[w][23:16] != exp_byte) errors++;
                    3: if (axi_data_log[w][31:24] != exp_byte) errors++;
                    4: if (axi_data_log[w][39:32] != exp_byte) errors++;
                    5: if (axi_data_log[w][47:40] != exp_byte) errors++;
                    6: if (axi_data_log[w][55:48] != exp_byte) errors++;
                    default: if (axi_data_log[w][63:56] != exp_byte) errors++;
                endcase
            end
        end
        check(errors == 0,
            $sformatf("conflict: pixel data intact (%0d errors)", errors));

        // ============================================================
        suite("QUARTER COMPLETE — all tiles + engine_done");
        // ============================================================
        reset_all();
        for (int i = 0; i < 256; i++) mark_filled(8'(i), 6'h01);
        tile_done   = '1;
        engine_done = 0;
        repeat(15000) tick(1);
        check(!quarter_complete, "quarter_complete low without engine_done");
        engine_done = 1; repeat(500) tick(1);
        check(quarter_complete, "quarter_complete with engine_done");

        // ============================================================
        suite("AXI BACKPRESSURE — correct data despite ready toggling");
        // ============================================================
        reset_all();
        for (int y = 0; y < 16; y++)
            for (int x = 0; x < 16; x++)
                ctrl_write(9'(x), 9'(y), 6'(x + 1));
        tick(2);
        mark_tiled(8'd0);
        tile_done[0] = 1;
        repeat(200) begin
            @(posedge clk); #1; axi_wr_ready = 0;
            @(posedge clk); #1; axi_wr_ready = 1;
        end
        axi_wr_ready = 1;
        wait_writes(32, 300);
        check(axi_log_count == 32,
            $sformatf("backpressure: 32 writes (got %0d)", axi_log_count));
        errors = 0;
        for (w = 0; w < 32; w++) begin
            for (b = 0; b < 8; b++) begin
                px = (w*8+b) % 16;
                exp_byte = {2'b0, 6'(px+1)};
                case (b)
                    0: if (axi_data_log[w][7:0]   != exp_byte) errors++;
                    1: if (axi_data_log[w][15:8]  != exp_byte) errors++;
                    2: if (axi_data_log[w][23:16] != exp_byte) errors++;
                    3: if (axi_data_log[w][31:24] != exp_byte) errors++;
                    4: if (axi_data_log[w][39:32] != exp_byte) errors++;
                    5: if (axi_data_log[w][47:40] != exp_byte) errors++;
                    6: if (axi_data_log[w][55:48] != exp_byte) errors++;
                    default: if (axi_data_log[w][63:56] != exp_byte) errors++;
                endcase
            end
        end
        check(errors == 0,
            $sformatf("backpressure: data intact (%0d errors)", errors));

        summary();
        $finish;
    end

    initial begin #100000000; $display("[TIMEOUT]"); $finish; end

endmodule