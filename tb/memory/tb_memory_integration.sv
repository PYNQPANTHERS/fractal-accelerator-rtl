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

    // This integration TB exercises the 16x16-tile path (32 words/tile), so the
    // AXI address expectations below (0x008, 0x0F8, tile-5 = 0x500, ...) assume it.
    localparam int TILE_W    = 16;
    localparam int TILE_BITS = $clog2(TILE_W);
    localparam int BRAM_ADDR_W = $clog2(256*256/8);

    // word-address + byte-offset for a pixel (mirrors colour_bram encoding)
    function automatic logic [15:0] ta_of(input logic [7:0] x, y);
        ta_of = {y[7:TILE_BITS], x[7:TILE_BITS], y[TILE_BITS-1:0], x[TILE_BITS-1:0]};
    endfunction

    // colour_bram (word-addressed write; per-pixel byte read)
    logic [7:0]  cb_rd_x, cb_rd_y;
    logic        cb_rd_en;
    logic [7:0]  cb_rd_data;
    logic [BRAM_ADDR_W-1:0] cb_wr_waddr;
    logic [63:0] cb_wr_word;
    logic        cb_wr_en;
    logic [BRAM_ADDR_W-1:0] b2d_word_addr;
    logic        b2d_rd_en, b2d_rd_grant;
    logic [63:0] b2d_rd_data;
    wire  [(256/TILE_W)*(256/TILE_W)-1:0] cb_tile_done;

    colour_bram #(.TILE_W(TILE_W)) u_cbram (
        .clk           (clk),        .rst          (1'b0),
        .ctrl_rd_x     (cb_rd_x),    .ctrl_rd_y    (cb_rd_y),
        .ctrl_rd_en    (cb_rd_en),   .ctrl_rd_data (cb_rd_data),
        .ctrl_wr_waddr (cb_wr_waddr),.ctrl_wr_word (cb_wr_word),
        .ctrl_wr_en    (cb_wr_en),
        .b2d_word_addr (b2d_word_addr),
        .b2d_rd_en     (b2d_rd_en),  .b2d_rd_grant (b2d_rd_grant),
        .b2d_rd_data   (b2d_rd_data),
        .ctrl_rmw_rd_addr(cb_rmw_addr), .ctrl_rmw_rd_en(cb_rmw_en),
        .ctrl_rmw_rd_data(cb_rmw_data),
        .tile_done     (cb_tile_done)
    );
    logic [BRAM_ADDR_W-1:0] cb_rmw_addr;
    logic                   cb_rmw_en;
    wire  [63:0]            cb_rmw_data;

    // tile_table (quad-write interface only; a tile is "filled" by writing a quad
    // covering it, "tiled" = simply left unfilled)
    logic       tt_rst;
    logic       tt_quad_en;
    logic [7:0] tt_quad_tlx, tt_quad_tly;
    logic [8:0] tt_quad_size;
    logic [5:0] tt_quad_colour;
    wire  [7:0] tt_rd_index;  // driven by bram_to_dram output, read by tile_table
    wire        tt_is_filled;
    wire  [5:0] tt_fill_colour;
    wire  [(256/TILE_W)*(256/TILE_W)-1:0] tt_filled_vec;

    tile_table #(.TILE_W(TILE_W)) u_ttable (
        .clk             (clk),       .rst             (tt_rst),
        .wr_quad_en      (tt_quad_en),
        .wr_quad_tlx     (tt_quad_tlx), .wr_quad_tly  (tt_quad_tly),
        .wr_quad_size    (tt_quad_size),.wr_quad_colour(tt_quad_colour),
        .rd_index        (tt_rd_index),
        .rd_is_filled    (tt_is_filled),.rd_fill_colour(tt_fill_colour),
        .rd_filled_vec   (tt_filled_vec)
    );

    // map a tile index (row-major, TILES_P_AXIS per row) to its top-left pixel
    localparam int TILES_P_AXIS = 256 / TILE_W;
    function automatic logic [7:0] tile_tlx(input logic [7:0] idx);
        tile_tlx = 8'((idx % TILES_P_AXIS) * TILE_W);
    endfunction
    function automatic logic [7:0] tile_tly(input logic [7:0] idx);
        tile_tly = 8'((idx / TILES_P_AXIS) * TILE_W);
    endfunction

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

    bram_to_dram #(.TILE_W(TILE_W)) u_b2d (
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
        .sixteenth_complete (quarter_complete)
    );

    // AXI capture
    logic [63:0] axi_data_log [0:255];
    logic [31:0] axi_addr_log [0:255];
    int          axi_log_count;

    task automatic collect_writes(input int n);
        int collected;
        collected = 0;
        axi_log_count = 0;
        while (collected < n) begin
            @(posedge clk); #1;
            if (axi_wr_en && axi_wr_ready) begin
                axi_data_log[collected] = axi_wr_data;
                axi_addr_log[collected] = axi_wr_addr;
                collected++;
                axi_log_count = collected;
            end
        end
    endtask

    // module-level vars - Icarus requires all vars at module scope
    int          errors, w, b, p, px, py, n;
    int          rdy_timer;
    logic [7:0]  exp_byte;
    logic        got_cache, got_val;

    task automatic reset_all();
        tt_rst = 1; b2d_rst = 1; tick(2);
        tt_rst = 0; b2d_rst = 0;
        cb_rd_en=0; cb_wr_en=0;
        tt_quad_en=0;
        tile_done='0; engine_done=0;
        axi_wr_ready=1; sixteenth_base_addr=32'h0;
        tick(1);
    endtask

    // Per-pixel write becomes a read-modify-write of the word holding that pixel:
    // pre-read the 64-bit word, replace the byte at the pixel's offset, write back.
    logic [15:0] cw_ta; logic [63:0] cw_word;
    task automatic ctrl_write(input logic [8:0] x, y, input logic [5:0] col);
        cw_ta      = ta_of(x[7:0], y[7:0]);
        cb_rmw_addr = cw_ta[15:3];
        cb_rmw_en   = 1; tick(1); cb_rmw_en = 0;   // word now in cb_rmw_data next tick
        #1;
        cw_word               = cb_rmw_data;
        cw_word[cw_ta[2:0]*8 +: 8] = {2'b0, col};
        cb_wr_waddr = cw_ta[15:3]; cb_wr_word = cw_word;
        cb_wr_en = 1; tick(1); cb_wr_en = 0;
    endtask

    // "tiled" = not flood-filled (tile_table defaults unfilled, so this is a no-op
    // beyond a tick for timing symmetry with the old single-write interface)
    task automatic mark_tiled(input logic [7:0] idx);
        tt_quad_en=0; tick(1);
    endtask

    // "filled" = write a quad covering exactly this tile with the fill colour
    task automatic mark_filled(input logic [7:0] idx, input logic [5:0] col);
        tt_quad_tlx=tile_tlx(idx); tt_quad_tly=tile_tly(idx);
        tt_quad_size=9'(TILE_W); tt_quad_colour=col; tt_quad_en=1;
        tick(1); tt_quad_en=0;
    endtask



    initial begin
        $dumpfile("sim/waves/tb_memory_integration.vcd");
        $dumpvars(0, tb_memory_integration);
        cb_rd_en=0; cb_wr_en=0; tt_rst=0; b2d_rst=1;
        tile_done='0; engine_done=0; axi_wr_ready=1;
        sixteenth_base_addr=0; axi_log_count=0;
        tt_quad_en=0;
        tt_quad_tlx=0; tt_quad_tly=0; tt_quad_size=0; tt_quad_colour=0;
        // tt_rd_index driven by bram_to_dram - do not drive from testbench
        tick(3);

        suite("TILED TILE - pixels written by ctrl, verified in AXI output");
        reset_all();
        for (int y = 0; y < 16; y++)
            for (int x = 0; x < 16; x++)
                ctrl_write(9'(x), 9'(y), 6'((x + y) % 64));
        tick(2);
        mark_tiled(8'd0);
        tick(2);
        tile_done[0] = 1;
        collect_writes(32);
        check(axi_log_count == 32,
            $sformatf("tiled: 32 AXI writes from real BRAM (got %0d)", axi_log_count));
        check(axi_addr_log[0]  == 32'h000, "first addr = 0");
        check(axi_addr_log[1]  == 32'h008, "second addr = 8");
        check(axi_addr_log[31] == 32'h0F8, "last addr = 248");

        suite("FLOOD FILLED TILE - no BRAM reads, solid colour in AXI");
        reset_all();
        mark_filled(8'd5, 6'h15);
        tick(2);
        tile_done[5] = 1;
        collect_writes(32);
        check(axi_log_count == 32, "flood fill: 32 AXI writes");
        check(axi_addr_log[0]  == 32'h500,
            $sformatf("flood fill: first addr = tile 5 base (got 0x%03X)", axi_addr_log[0]));
        check(axi_addr_log[31] == 32'h5F8,
            $sformatf("flood fill: last addr = tile 5 base+248 (got 0x%03X)", axi_addr_log[31]));

        suite("MIXED - tiled and filled tiles sequentially");
        reset_all();
        for (int y = 0; y < 16; y++)
            for (int x = 0; x < 16; x++)
                ctrl_write(9'(x), 9'(y), 6'(x % 64));
        tick(2);
        mark_tiled(8'd0);
        mark_filled(8'd1, 6'h3F);
        tile_done[0] = 1; tile_done[1] = 1;
        collect_writes(64);
        check(axi_log_count == 64,
            $sformatf("mixed: 64 total writes (got %0d)", axi_log_count));
        check(axi_addr_log[0]  == 32'h000, "tile 0 first addr");
        check(axi_addr_log[32] == 32'h100, "tile 1 first addr");

        suite("CTRL WRITE CONFLICT - data intact despite BRAM stalls");
        reset_all();
        for (int y = 0; y < 16; y++)
            for (int x = 0; x < 16; x++)
                ctrl_write(9'(x), 9'(y), 6'((x * y) % 64));
        tick(2);
        mark_tiled(8'd0);
        tile_done[0] = 1;
        // inject controller writes while b2d is reading - inline, no fork/join
        rdy_timer = 0; w = 0; axi_log_count = 0; n = 0;
        while (w < 32) begin
            @(posedge clk); #1;
            rdy_timer++;
            if (n < 10 && rdy_timer % 4 == 0) begin
                // inject a full-word controller write to a DIFFERENT tile (100,100)
                // while b2d streams tile 0 — must not disturb tile 0's data.
                cb_wr_waddr = ta_of(8'd100, 8'd100) >> 3;
                cb_wr_word  = 64'hFFFF_FFFF_FFFF_FFFF; cb_wr_en=1; n++;
            end else begin
                cb_wr_en=0;
            end
            if (axi_wr_en && axi_wr_ready) begin
                axi_data_log[w]=axi_wr_data; axi_addr_log[w]=axi_wr_addr;
                w++; axi_log_count=w;
            end
        end
        cb_wr_en=0;
        check(axi_log_count == 32,
            $sformatf("conflict: all 32 writes complete (got %0d)", axi_log_count));
        check(axi_addr_log[0]  == 32'h000, "conflict: first addr correct");
        check(axi_addr_log[31] == 32'h0F8, "conflict: last addr correct");

        suite("QUARTER COMPLETE - all tiles + engine_done");
        reset_all();
        for (int i = 0; i < 256; i++) mark_filled(8'(i), 6'h01);
        tile_done   = '1;
        engine_done = 0;
        repeat(15000) tick(1);
        check(!quarter_complete, "quarter_complete low without engine_done");
        engine_done = 1; repeat(500) tick(1);
        check(quarter_complete, "quarter_complete with engine_done");

        suite("AXI BACKPRESSURE - tiled tile, all 32 writes despite ready toggling");
        // Capture on axi_wr_en alone - DUT pre-validates ready at decision cycle,
        // axi_wr_en appears one cycle later so ready may have changed at output time.
        reset_all();
        for (int y = 0; y < 16; y++)
            for (int x = 0; x < 16; x++)
                ctrl_write(9'(x), 9'(y), 6'(x + 1));
        tick(2);
        mark_tiled(8'd0);
        tile_done[0] = 1;
        rdy_timer = 0; w = 0; axi_log_count = 0;
        while (w < 32) begin
            @(posedge clk); #1;
            rdy_timer++;
            if      (rdy_timer == 3) axi_wr_ready = 1;
            else if (rdy_timer == 6) begin axi_wr_ready = 0; rdy_timer = 0; end
            if (axi_wr_en) begin
                axi_data_log[w]=axi_wr_data; axi_addr_log[w]=axi_wr_addr;
                w++; axi_log_count=w;
            end
        end
        axi_wr_ready = 1;
        check(axi_log_count == 32,
            $sformatf("backpressure: 32 writes (got %0d)", axi_log_count));

        summary();
        $finish;
    end

    initial begin #100000000; $display("[TIMEOUT]"); $finish; end

endmodule