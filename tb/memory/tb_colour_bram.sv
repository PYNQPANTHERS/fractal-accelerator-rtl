`timescale 1ns/1ps

module tb_colour_bram;

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

    logic        clk = 0;
    always #5 clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    logic [8:0]  a_x, a_y;
    logic        a_rd, a_we;
    logic [7:0]  a_wdata, a_rdata;
    logic [12:0] b_word_addr;
    logic        b_rd, b_rd_grant;
    logic [63:0] b_rdata;
    logic        ctrl_wr_en;
    logic [8:0]  ctrl_wr_x, ctrl_wr_y;
    logic [7:0]  ctrl_wr_data;

    colour_bram dut (
        .clk           (clk),
        .ctrl_rd_x     (a_x),
        .ctrl_rd_y     (a_y),
        .ctrl_rd_en    (a_rd),
        .ctrl_rd_data  (a_rdata),
        .ctrl_wr_x     (ctrl_wr_x),
        .ctrl_wr_y     (ctrl_wr_y),
        .ctrl_wr_en    (ctrl_wr_en),
        .ctrl_wr_data  (ctrl_wr_data),
        .b2d_word_addr (b_word_addr),
        .b2d_rd_en     (b_rd),
        .b2d_rd_grant  (b_rd_grant),
        .b2d_rd_data   (b_rdata)
    );

    task automatic write_pixel(input logic [8:0] x, y, input logic [7:0] col);
        ctrl_wr_x = x; ctrl_wr_y = y; ctrl_wr_data = col; ctrl_wr_en = 1;
        tick(1); ctrl_wr_en = 0;
    endtask

    task automatic read_pixel(input logic [8:0] x, y, output logic [7:0] out);
        a_x = x; a_y = y; a_rd = 1; tick(1); a_rd = 0; tick(1);
        out = a_rdata;
    endtask

    logic [7:0] got;
    int         col_idx;

    initial begin
        $dumpfile("sim/waves/tb_colour_bram.vcd");
        $dumpvars(0, tb_colour_bram);
        a_rd=0; a_we=0; a_x=0; a_y=0; a_wdata=0;
        b_rd=0; b_word_addr=0;
        ctrl_wr_en=0; ctrl_wr_x=0; ctrl_wr_y=0; ctrl_wr_data=0;
        tick(2);

        // ============================================================
        suite("PORT A — basic write then read");
        // ============================================================
        write_pixel(9'd0, 9'd0, 8'h3F);
        read_pixel(9'd0, 9'd0, got);
        check(got == 8'h3F, "pixel (0,0) reads back correct colour");

        write_pixel(9'd15, 9'd0, 8'h2A);
        read_pixel(9'd15, 9'd0, got);
        check(got == 8'h2A, "pixel (15,0) reads back correct colour");

        write_pixel(9'd0, 9'd15, 8'h15);
        read_pixel(9'd0, 9'd15, got);
        check(got == 8'h15, "pixel (0,15) reads back correct — different tile row");

        // ============================================================
        suite("PORT A — tile boundary pixels");
        // ============================================================
        // pixels at tile boundaries to verify tile-ordered addressing
        write_pixel(9'd16, 9'd0,  8'h01); // start of tile (1,0)
        write_pixel(9'd31, 9'd0,  8'h02); // end of tile (1,0) first row
        write_pixel(9'd0,  9'd16, 8'h03); // start of tile (0,1)
        write_pixel(9'd16, 9'd16, 8'h04); // start of tile (1,1)
        tick(1);
        read_pixel(9'd16, 9'd0,  got); check(got == 8'h01, "tile (1,0) first pixel");
        read_pixel(9'd31, 9'd0,  got); check(got == 8'h02, "tile (1,0) last col first row");
        read_pixel(9'd0,  9'd16, got); check(got == 8'h03, "tile (0,1) first pixel");
        read_pixel(9'd16, 9'd16, got); check(got == 8'h04, "tile (1,1) first pixel");

        // ============================================================
        suite("PORT A — overwrite same pixel");
        // ============================================================
        write_pixel(9'd5, 9'd5, 8'h10);
        read_pixel(9'd5, 9'd5, got);
        check(got == 8'h10, "first write");
        write_pixel(9'd5, 9'd5, 8'h3E);
        read_pixel(9'd5, 9'd5, got);
        check(got == 8'h3E, "overwrite succeeds");

        // ============================================================
        suite("PORT A — adjacent pixels in same 64-bit word independent");
        // ============================================================
        // pixels (0,0)..(7,0) share the same 64-bit word (tile 0, word 0)
        for (int i = 0; i < 8; i++) write_pixel(9'(i), 9'd0, 8'(i + 1));
        tick(1);
        for (int i = 0; i < 8; i++) begin
            read_pixel(9'(i), 9'd0, got);
            check(got == 8'(i+1), $sformatf("word-shared pixel (%0d,0) correct", i));
        end

        // ============================================================
        suite("PORT A — write does not corrupt adjacent pixels");
        // ============================================================
        write_pixel(9'd0, 9'd0, 8'hAA);
        write_pixel(9'd1, 9'd0, 8'hBB);
        write_pixel(9'd2, 9'd0, 8'hCC);
        // overwrite middle one
        write_pixel(9'd1, 9'd0, 8'h11);
        tick(1);
        read_pixel(9'd0, 9'd0, got); check(got == 8'hAA, "left neighbour unchanged");
        read_pixel(9'd1, 9'd0, got); check(got == 8'h11, "overwritten pixel correct");
        read_pixel(9'd2, 9'd0, got); check(got == 8'hCC, "right neighbour unchanged");

        // ============================================================
        suite("PORT B — 64-bit read returns 8 correct pixels");
        // ============================================================
        // write 8 known pixels into tile 0, row 0 (word address 0)
        for (int i = 0; i < 8; i++) write_pixel(9'(i), 9'd0, 8'(i + 10));
        tick(2);
        b_word_addr = 13'd0; b_rd = 1; tick(1);
        check(b_rd_grant, "b2d_rd_grant asserted when no controller write");
        b_rd = 0; tick(1);
        for (int i = 0; i < 8; i++)
            check(b_rdata[i*8 +: 8] == 8'(i+10),
                $sformatf("Port B word[%0d] = pixel (%0d,0) correct", i, i));

        // ============================================================
        suite("PORT B — grant denied when controller write in same cycle");
        // ============================================================
        ctrl_wr_en = 1; ctrl_wr_x = 9'd0; ctrl_wr_y = 9'd0; ctrl_wr_data = 8'hFF;
        b_rd = 1; b_word_addr = 13'd0;
        tick(1);
        check(!b_rd_grant, "b2d_rd_grant denied when controller write active");
        ctrl_wr_en = 0; b_rd = 0;

        // ============================================================
        suite("PORT B — grant given next cycle after write clears");
        // ============================================================
        tick(1);
        b_rd = 1; b_word_addr = 13'd0;
        tick(1);
        check(b_rd_grant, "b2d_rd_grant asserted cycle after write clears");
        b_rd = 0; tick(1);

        // ============================================================
        suite("SIMULTANEOUS — read port A and Port B different tiles");
        // ============================================================
        write_pixel(9'd0, 9'd0,   8'h21); // tile 0
        write_pixel(9'd0, 9'd16,  8'h42); // tile (0,1), word addr = 16*32 = 512
        tick(2);
        a_x = 9'd0; a_y = 9'd0; a_rd = 1;
        b_word_addr = 13'd512; b_rd = 1;
        tick(1); a_rd = 0; b_rd = 0; tick(1);
        check(axi_rdata_byte(b_rdata, 0) == 8'h42, "Port B reads tile (0,1) correctly");
        check(a_rdata == 8'h21, "Port A reads tile (0,0) correctly same cycle");

        // ============================================================
        suite("SIMULTANEOUS — write and Port B read to different tiles");
        // ============================================================
        write_pixel(9'd0, 9'd32, 8'hDE); // tile (0,2) = word addr 1024
        b_word_addr = 13'd0; b_rd = 1;   // read tile 0 simultaneously
        tick(1); b_rd = 0;
        // write to tile (0,2), b2d reading tile 0 — no conflict
        check(b_rd_grant, "b2d granted when write targets different tile");

        summary();
        $finish;
    end

    // helper — extract byte 0 from a 64-bit word
    function automatic logic [7:0] axi_rdata_byte(input logic [63:0] w, input int idx);
        return w[idx*8 +: 8];
    endfunction

    initial begin #5000000; $display("[TIMEOUT]"); $finish; end

endmodule