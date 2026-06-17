`timescale 1ns/1ps
//
// Unit test for colour_bram (current word-addressed interface).
//   - write path is FULL-WORD (ctrl_wr_waddr / ctrl_wr_word), one 64-bit word = 8
//     horizontally-adjacent pixels of a tile row.
//   - read path is per-pixel byte (ctrl_rd_x/y -> ctrl_rd_data, 1-cycle latency).
//   - RMW pre-read (ctrl_rmw_rd_*) returns the whole word.
//   - b2d word read (b2d_*).
//   - tile_done[t] sets once all PIX_PER_TILE pixels of tile t are written.
//
// Builds against both dual_core and dual_precision (identical colour_bram).
//
module tb_colour_bram;

    localparam int TILE_W       = 8;
    localparam int TILE_BITS    = $clog2(TILE_W);
    localparam int BRAM_ADDR_W  = $clog2(256*256/8);
    localparam int PIX_PER_TILE = TILE_W*TILE_W;

    logic clk = 0; always #5 clk = ~clk;
    task automatic tick(input int n=1); repeat(n) @(posedge clk); #1; endtask

    logic        rst;
    logic [7:0]  ctrl_rd_x, ctrl_rd_y;
    logic        ctrl_rd_en;
    wire  [7:0]  ctrl_rd_data;
    logic [BRAM_ADDR_W-1:0] ctrl_wr_waddr;
    logic [63:0]            ctrl_wr_word;
    logic                   ctrl_wr_en;
    logic [BRAM_ADDR_W-1:0] b2d_word_addr;
    logic                   b2d_rd_en;
    wire                    b2d_rd_grant;
    wire  [63:0]            b2d_rd_data;
    logic [BRAM_ADDR_W-1:0] ctrl_rmw_rd_addr;
    logic                   ctrl_rmw_rd_en;
    wire  [63:0]            ctrl_rmw_rd_data;
    wire  [(256/TILE_W)*(256/TILE_W)-1:0] tile_done;

    colour_bram #(.TILE_W(TILE_W)) dut (
        .clk(clk), .rst(rst),
        .ctrl_rd_x(ctrl_rd_x), .ctrl_rd_y(ctrl_rd_y), .ctrl_rd_en(ctrl_rd_en),
        .ctrl_rd_data(ctrl_rd_data),
        .ctrl_wr_waddr(ctrl_wr_waddr), .ctrl_wr_word(ctrl_wr_word), .ctrl_wr_en(ctrl_wr_en),
        .b2d_word_addr(b2d_word_addr), .b2d_rd_en(b2d_rd_en),
        .b2d_rd_grant(b2d_rd_grant), .b2d_rd_data(b2d_rd_data),
        .ctrl_rmw_rd_addr(ctrl_rmw_rd_addr), .ctrl_rmw_rd_en(ctrl_rmw_rd_en),
        .ctrl_rmw_rd_data(ctrl_rmw_rd_data),
        .tile_done(tile_done)
    );

    // ── address helpers (mirror the module's tile encoding) ───────────────────
    function automatic logic [15:0] ta_of(input logic [7:0] x, y);
        ta_of = {y[7:TILE_BITS], x[7:TILE_BITS], y[TILE_BITS-1:0], x[TILE_BITS-1:0]};
    endfunction
    function automatic logic [BRAM_ADDR_W-1:0] waddr_of(input logic [7:0] x, y);
        logic [15:0] ta; ta = ta_of(x,y); waddr_of = ta[15:3];
    endfunction

    // ── scoreboard ────────────────────────────────────────────────────────────
    int pass=0, fail=0;
    task automatic check(input logic cond, input string msg);
        if (cond) begin pass++; $display("  [PASS] %s", msg); end
        else      begin fail++; $display("  [FAIL] %s", msg); end
    endtask

    task automatic wr_word(input logic [BRAM_ADDR_W-1:0] wa, input logic [63:0] wd);
        ctrl_wr_waddr = wa; ctrl_wr_word = wd; ctrl_wr_en = 1;
        tick(1); ctrl_wr_en = 0;
    endtask

    task automatic rd_pixel(input logic [7:0] x, y, output logic [7:0] col);
        ctrl_rd_x = x; ctrl_rd_y = y; ctrl_rd_en = 1;
        tick(1); ctrl_rd_en = 0;
        #1; col = ctrl_rd_data;   // combinational from the registered word+offset
    endtask

    logic [7:0]  rcol;
    logic [63:0] rword;

    initial begin
        rst=1; ctrl_rd_en=0; ctrl_wr_en=0; b2d_rd_en=0; ctrl_rmw_rd_en=0;
        ctrl_rd_x=0; ctrl_rd_y=0; ctrl_wr_waddr=0; ctrl_wr_word=0;
        b2d_word_addr=0; ctrl_rmw_rd_addr=0;
        tick(3); rst=0; tick(2);

        $display("\n== colour_bram unit test (TILE_W=%0d) ==", TILE_W);

        // WRITE then READ-BACK a known word: pixels x=0..7,y=0 -> bytes 0..7
        wr_word(waddr_of(8'd0,8'd0), 64'h0807_0605_0403_0201);
        rd_pixel(8'd0, 8'd0, rcol); check(rcol==8'h01, "pixel (0,0) reads byte0=0x01");
        rd_pixel(8'd3, 8'd0, rcol); check(rcol==8'h04, "pixel (3,0) reads byte3=0x04");
        rd_pixel(8'd7, 8'd0, rcol); check(rcol==8'h08, "pixel (7,0) reads byte7=0x08");

        // A different word, different tile, no aliasing
        wr_word(waddr_of(8'd16,8'd16), 64'hAAAAAAAAAAAAAAAA);
        rd_pixel(8'd16,8'd16, rcol); check(rcol==8'hAA, "pixel (16,16) reads 0xAA");
        rd_pixel(8'd0, 8'd0,  rcol); check(rcol==8'h01, "earlier (0,0) still 0x01 (no aliasing)");

        // RMW pre-read returns the whole word
        ctrl_rmw_rd_addr = waddr_of(8'd0,8'd0); ctrl_rmw_rd_en = 1;
        tick(1); ctrl_rmw_rd_en = 0; #1;
        rword = ctrl_rmw_rd_data;
        check(rword==64'h0807_0605_0403_0201, "RMW pre-read returns full word");

        // b2d word read
        b2d_word_addr = waddr_of(8'd16,8'd16); b2d_rd_en = 1;
        tick(1); b2d_rd_en = 0; #1;
        check(b2d_rd_data==64'hAAAAAAAAAAAAAAAA, "b2d read returns the tile (16,16) word");

        // tile_done: the per-tile counter increments once per ctrl_wr_en that
        // targets that tile's word-address range, and tile_done sets when the count
        // reaches PIX_PER_TILE (=TILE_W*TILE_W). Drive PIX_PER_TILE writes to tile 0
        // (any word addr within the tile maps to the same tile index).
        check(!tile_done[0], "tile_done[0] low before tile-0 count reaches full");
        for (int i = 0; i < PIX_PER_TILE; i++)
            wr_word(waddr_of(8'd0, 8'd0), 64'h2222222222222222);
        tick(2);
        check(tile_done[0], "tile_done[0] set after PIX_PER_TILE writes to tile 0");

        $display("\n  RESULTS: %0d / %0d passed", pass, pass+fail);
        if (fail==0) $display("  ALL TESTS PASSED"); else $display("  %0d TEST(S) FAILED", fail);
        $finish;
    end

endmodule
