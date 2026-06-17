`timescale 1ns/1ps

module tb_tile_table;

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

    logic       clk = 0;
    always #5 clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    logic       rst;
    logic       wr_quad_en;
    logic [7:0] wr_quad_tlx, wr_quad_tly, wr_quad_size;
    logic [5:0] wr_quad_colour;
    logic [7:0] rd_index;
    logic       rd_is_filled;
    logic [5:0] rd_fill_colour;

    tile_table dut (
        .clk             (clk),
        .rst             (rst),
        .wr_quad_en      (wr_quad_en),
        .wr_quad_tlx     (wr_quad_tlx),
        .wr_quad_tly     (wr_quad_tly),
        .wr_quad_size    (wr_quad_size),
        .wr_quad_colour  (wr_quad_colour),
        .rd_index        (rd_index),
        .rd_is_filled    (rd_is_filled),
        .rd_fill_colour  (rd_fill_colour)
    );

    task automatic quad_write(input logic [7:0] tlx, tly, size,
                               input logic [5:0] col);
        wr_quad_tlx    = tlx;
        wr_quad_tly    = tly;
        wr_quad_size   = size;
        wr_quad_colour = col;
        wr_quad_en     = 1;
        tick(1);
        wr_quad_en = 0; tick(1);
    endtask

    task automatic read_tile(input logic [7:0] idx,
                              output logic filled, output logic [5:0] col);
        rd_index = idx; #1; // combinational — sample immediately
        filled = rd_is_filled;
        col    = rd_fill_colour;
    endtask

    logic       got_filled;
    logic [5:0] got_col;
    int         fail_count;
    int         reset_fails;

    initial begin
        $dumpfile("sim/waves/tb_tile_table.vcd");
        $dumpvars(0, tb_tile_table);
        rst=0; wr_quad_en=0;
        wr_quad_tlx=0; wr_quad_tly=0; wr_quad_size=0; wr_quad_colour=0;
        rd_index=0;
        tick(2);

        suite("RESET - all entries clear");
        rst = 1; tick(2); rst = 0; tick(1);
        reset_fails = 0;
        for (int i = 0; i < 256; i++) begin
            read_tile(8'(i), got_filled, got_col);
            if (got_filled != 0 || got_col != 0) reset_fails++;
        end
        check(reset_fails == 0, "all 256 entries zero after reset");

        suite("QUAD WRITE - 16x16 quad (1 tile)");
        rst = 1; tick(2); rst = 0; tick(1);
        // 16x16 at (0,0) covers exactly tile index 0
        quad_write(8'd0, 8'd0, 8'd16, 6'h0F);
        read_tile(8'd0, got_filled, got_col);
        check(got_filled,           "16x16 quad: tile 0 is_filled=1");
        check(got_col == 6'h0F,     "16x16 quad: tile 0 colour correct");
        read_tile(8'd1, got_filled, got_col);
        check(!got_filled,          "16x16 quad: tile 1 not affected");

        suite("QUAD WRITE - 32x32 quad (4 tiles)");
        rst = 1; tick(2); rst = 0; tick(1);
        // 32x32 at (0,0) covers tile rows 0..1, tile cols 0..1
        // indices: 0*16+0=0, 0*16+1=1, 1*16+0=16, 1*16+1=17
        quad_write(8'd0, 8'd0, 8'd32, 6'h15);
        read_tile(8'd0,  got_filled, got_col); check(got_filled && got_col==6'h15, "tile 0 filled");
        read_tile(8'd1,  got_filled, got_col); check(got_filled && got_col==6'h15, "tile 1 filled");
        read_tile(8'd16, got_filled, got_col); check(got_filled && got_col==6'h15, "tile 16 filled");
        read_tile(8'd17, got_filled, got_col); check(got_filled && got_col==6'h15, "tile 17 filled");
        read_tile(8'd2,  got_filled, got_col); check(!got_filled, "tile 2 not affected");
        read_tile(8'd32, got_filled, got_col); check(!got_filled, "tile 32 not affected");

        suite("QUAD WRITE - 128x128 quad (64 tiles)");
        rst = 1; tick(2); rst = 0; tick(1);
        // 128x128 at (0,0): tile rows 0..7, tile cols 0..7 = 64 tiles
        quad_write(8'd0, 8'd0, 8'd128, 6'h3A);
        begin
            fail_count = 0;
            for (int row = 0; row < 8; row++) begin
                for (int col = 0; col < 8; col++) begin
                    read_tile(8'(row * 16 + col), got_filled, got_col);
                    if (!got_filled || got_col != 6'h3A) fail_count++;
                end
            end
            check(fail_count == 0, "all 64 tiles in 128x128 quad correctly filled");
            read_tile(8'd8,   got_filled, got_col); check(!got_filled, "tile col 8 untouched");
            read_tile(8'd128, got_filled, got_col); check(!got_filled, "tile row 8 untouched");
        end

        suite("QUAD WRITE - non-zero offset quad");
        rst = 1; tick(2); rst = 0; tick(1);
        // 32x32 at (128,128): tile rows 8..9, tile cols 8..9
        // indices: 8*16+8=136, 8*16+9=137, 9*16+8=152, 9*16+9=153
        quad_write(8'd128, 8'd128, 8'd32, 6'h2B);
        read_tile(8'd136, got_filled, got_col); check(got_filled && got_col==6'h2B, "offset tile 136");
        read_tile(8'd137, got_filled, got_col); check(got_filled && got_col==6'h2B, "offset tile 137");
        read_tile(8'd152, got_filled, got_col); check(got_filled && got_col==6'h2B, "offset tile 152");
        read_tile(8'd153, got_filled, got_col); check(got_filled && got_col==6'h2B, "offset tile 153");
        read_tile(8'd135, got_filled, got_col); check(!got_filled, "tile before quad untouched");
        read_tile(8'd154, got_filled, got_col); check(!got_filled, "tile after quad untouched");

        suite("QUAD WRITE - quad does not set bit[6]=0 entries");
        // After a quad write, is_filled must be 1 — tiled entries (bit[6]=0) only come
        // from bram_to_dram reading colour_bram directly; tile_table never writes them.
        rst = 1; tick(2); rst = 0; tick(1);
        quad_write(8'd0, 8'd0, 8'd16, 6'h00);
        read_tile(8'd0, got_filled, got_col);
        check(got_filled,  "flood-fill quad always sets is_filled=1");

        suite("QUAD WRITE - overwrite with new colour");
        rst = 1; tick(2); rst = 0; tick(1);
        quad_write(8'd0, 8'd0, 8'd16, 6'h0A);
        quad_write(8'd0, 8'd0, 8'd16, 6'h1F);
        read_tile(8'd0, got_filled, got_col);
        check(got_filled && got_col==6'h1F, "second quad write overwrites colour");

        suite("COMBINATIONAL READ - zero latency");
        rst = 1; tick(2); rst = 0; tick(1);
        quad_write(8'd0, 8'd0, 8'd16, 6'h1C);
        rd_index = 8'd0; #1;
        check(rd_is_filled,            "combinational read: is_filled correct");
        check(rd_fill_colour == 6'h1C, "combinational read: fill_colour correct");

        summary();
        $finish;
    end

    initial begin #5000000; $display("[TIMEOUT]"); $finish; end

endmodule
