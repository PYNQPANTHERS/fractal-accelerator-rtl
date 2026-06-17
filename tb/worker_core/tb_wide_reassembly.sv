`timescale 1ns/1ps
//
// Proves the wide-mode coordinate reassembly bug + fix in multiply_manager.sv.
//
// In wide mode, job_datapath splits the full 35-bit coordinate z[34:0] into two
// 18-bit halves carried by starting_x_reg_1 (upper) and starting_x_reg_2 (lower):
//     reg_1 = {sign, z[34:18]}   (17 real bits in reg_1[16:0])
//     reg_2 = z[17:0]            (18 real bits)
// multiply_manager reassembles them into the 72-bit wide accumulator. The OLD
// formula  {2'sign, reg_1[17:0], reg_2[16:0], 35'0}  used reg_1's redundant sign
// bit as data (shift up 1 => coord/2) and dropped reg_2 bit[17] (mangling the low
// bits where the per-pixel px*scale term lives). The FIXED formula
//     {2'sign, reg_1[16:0], reg_2[17:0], 35'0}
// reassembles z exactly.
//
// This TB drives both formulas with several known z values and checks that the
// reassembled coordinate's high bits equal z. No DUT instance needed — we evaluate
// the two concatenations directly so the proof is unambiguous and instant.
//
module tb_wide_reassembly;

    localparam int NARROW_WIDTH = 18;
    localparam int INTEGER_BITS = 2;
    localparam int Z_WIDE       = 35;

    // job_datapath split of a 35-bit z into the two 18-bit wide-mode words
    function automatic logic [NARROW_WIDTH-1:0] split_upper(input logic [Z_WIDE-1:0] z);
        // real_upper (gen_upper_pad): {sign, z[34:18]} — UPPER_W=17 data bits
        split_upper = {{(NARROW_WIDTH-(Z_WIDE-NARROW_WIDTH)){z[Z_WIDE-1]}}, z[Z_WIDE-1:NARROW_WIDTH]};
    endfunction
    function automatic logic [NARROW_WIDTH-1:0] split_lower(input logic [Z_WIDE-1:0] z);
        split_lower = z[NARROW_WIDTH-1:0];   // z[17:0]
    endfunction

    // OLD (buggy) reassembly
    function automatic logic [2*2*NARROW_WIDTH-1:0] reassemble_old(
            input logic [NARROW_WIDTH-1:0] r1, r2);
        reassemble_old = {{INTEGER_BITS{r1[NARROW_WIDTH-1]}}, r1,
                          r2[NARROW_WIDTH-2:0], {2*NARROW_WIDTH-1{1'b0}}};
    endfunction

    // NEW (fixed) reassembly
    function automatic logic [2*2*NARROW_WIDTH-1:0] reassemble_new(
            input logic [NARROW_WIDTH-1:0] r1, r2);
        reassemble_new = {{INTEGER_BITS{r1[NARROW_WIDTH-1]}}, r1[NARROW_WIDTH-2:0],
                          r2[NARROW_WIDTH-1:0], {2*NARROW_WIDTH-1{1'b0}}};
    endfunction

    // Extract the reassembled coordinate's integer+fraction field. The coordinate
    // z[34:0] should appear in the accumulator's top 35 bits (above the 35-bit zero
    // pad and the 2 sign bits): bits [71:37] of the 72-bit value.
    function automatic logic [Z_WIDE-1:0] coord_of(input logic [2*2*NARROW_WIDTH-1:0] acc);
        coord_of = acc[2*2*NARROW_WIDTH-1 - INTEGER_BITS -: Z_WIDE];
    endfunction

    int pass=0, fail=0;
    task automatic check(input logic c, input string m);
        if (c) begin pass++; $display("  [PASS] %s", m); end
        else   begin fail++; $display("  [FAIL] %s", m); end
    endtask

    logic [Z_WIDE-1:0] z, got_old, got_new;
    logic [NARROW_WIDTH-1:0] r1, r2;

    task automatic test_z(input logic [Z_WIDE-1:0] zv, input string name);
        z = zv;
        r1 = split_upper(z);
        r2 = split_lower(z);
        got_old = coord_of(reassemble_old(r1, r2));
        got_new = coord_of(reassemble_new(r1, r2));
        $display("  z=0x%09X  split{r1=0x%05X r2=0x%05X}  old=0x%09X  new=0x%09X",
                 z, r1, r2, got_old, got_new);
        check(got_new === z, {name, ": NEW reassembles z exactly"});
        // the old one should be WRONG for any z with non-zero low/odd bits
    endtask

    initial begin
        $display("\n== wide-mode coordinate reassembly proof ==");

        // a centre with a per-pixel term in the low bits (the realistic case)
        test_z(35'h6_8000_0001, "centre+px low bit");   // low bit set = px term
        test_z(35'h1_2345_6789, "arbitrary");
        test_z(35'h0_0000_0001, "single low bit (pure px term)");
        test_z(35'h4_AAAA_AAAA, "alternating bits");
        test_z(35'h7_FFFF_FFFF, "all ones (max)");

        // demonstrate the OLD bug explicitly on one value: old != z
        z = 35'h2_4000_0002; r1 = split_upper(z); r2 = split_lower(z);
        got_old = coord_of(reassemble_old(r1, r2));
        $display("\n  OLD-bug demo: z=0x%09X -> old reassembled=0x%09X (should differ)", z, got_old);
        check(got_old !== z, "OLD formula corrupts the coordinate (confirms the bug)");

        $display("\n  RESULTS: %0d / %0d passed", pass, pass+fail);
        if (fail==0) $display("  ALL TESTS PASSED"); else $display("  %0d TEST(S) FAILED", fail);
        $finish;
    end

endmodule
