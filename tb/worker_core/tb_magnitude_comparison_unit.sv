`timescale 1ns/1ps

module tb_magnitude_comparison_unit;

  localparam NARROW_WIDTH  = 18;
  localparam INTEGER_BITS  = 2;
  localparam W             = 2*NARROW_WIDTH;
  localparam FRAC_BITS     = 2*(NARROW_WIDTH - INTEGER_BITS);
  localparam INT_BITS      = 2*INTEGER_BITS;

  localparam signed [W-1:0] FP_4   = 36'sh4_0000_0000;
  localparam signed [W-1:0] FP_3   = 36'sh3_0000_0000;
  localparam signed [W-1:0] FP_2   = 36'sh2_0000_0000;
  localparam signed [W-1:0] FP_0   = 36'sh0_0000_0000;
  localparam signed [W-1:0] FP_4P1 = 36'sh4_1999_999A;
  localparam signed [W-1:0] FP_7   = 36'sh7_0000_0000;
  localparam signed [W-1:0] FP_NEG = -36'sh1_0000_0000;

  logic signed [W-1:0] sum_sq;
  logic                mag_flag;

  magnitude_comparison_unit #(.NARROW_WIDTH(NARROW_WIDTH), .INTEGER_BITS(INTEGER_BITS)) dut (
    .magnitude(sum_sq),
    .mag_flag(mag_flag)
  );

  int pass_count = 0;
  int fail_count = 0;

  task automatic check(input string name, input logic got, input logic exp);
    if (got === exp) begin
      $display("  PASS: %s (flag=%0b)", name, got);
      pass_count++;
    end else begin
      $display("  FAIL: %s — got %0b, exp %0b", name, got, exp);
      fail_count++;
    end
  endtask

  // checks mag_flag=1 for negative (overflow indicator)
  task automatic check_negative(input string name, input logic signed [W-1:0] val);
    sum_sq = val; #1;
    if (mag_flag === 1'b1) begin
      $display("  PASS: %s — negative flagged as overflow (flag=1)", name);
      pass_count++;
    end else begin
      $display("  FAIL: %s — negative NOT flagged, got flag=%0b", name, mag_flag);
      fail_count++;
    end
  endtask

  initial begin
    $dumpfile("sim/waves/tb_magnitude_comparison_unit.vcd");
    $dumpvars(0, tb_magnitude_comparison_unit);

    $display("");
    $display("════════════════════════════════════════════════════");
    $display("  tb_magnitude_comparison_unit (4.32 fixed point)");
    $display("════════════════════════════════════════════════════");

    $display("\n  ── Below threshold (should NOT flag) ──");

    sum_sq = FP_0; #1;
    check("0.0 — zero", mag_flag, 1'b0);

    sum_sq = FP_2; #1;
    check("2.0 — below 4", mag_flag, 1'b0);

    sum_sq = FP_3; #1;
    check("3.0 — below 4", mag_flag, 1'b0);

    sum_sq = FP_4 - 1; #1;
    check("4.0 - 1 LSB — just below threshold", mag_flag, 1'b0);

    $display("\n  ── At / above threshold (should flag) ──");

    sum_sq = FP_4; #1;
    check("4.0 — exactly at threshold", mag_flag, 1'b1);

    sum_sq = FP_4P1; #1;
    check("~4.1 — just above 4", mag_flag, 1'b1);

    sum_sq = FP_7; #1;
    check("7.0 — well above 4", mag_flag, 1'b1);

    $display("\n  ── Negative values (should flag — indicates overflow) ──");

    check_negative("-1.0 — overflow indicator",   FP_NEG);
    check_negative("most negative (min signed)",  36'sh8_0000_0000);
    check_negative("-0.5",                        -36'sh0_8000_0000);
    check_negative("-7.0 — large negative",       -36'sh7_0000_0000);

    $display("");
    $display("════════════════════════════════════════════════════");
    $display("  Results: %0d passed, %0d failed", pass_count, fail_count);
    if (fail_count == 0) $display("  ALL TESTS PASSED");
    else                 $display("  SOME TESTS FAILED");
    $display("════════════════════════════════════════════════════");
    $display("");
    $finish;
  end

endmodule