`timescale 1ns/1ps

module tb_sum_alter;

  // Parameters
  localparam NARROW_WIDTH  = 18;
  localparam INTEGER_BITS  = 2;
  localparam W             = 2*NARROW_WIDTH; // 36-bit

  // DUT ports
  logic signed [W-1:0] sum_x_reg_1, sum_x_reg_2;
  logic signed [W-1:0] sum_y_reg_1, sum_y_reg_2;
  logic [3:0]          magnitude_negation_encoding;

  logic signed [W-1:0] changed_sum_x_reg_1, changed_sum_x_reg_2;
  logic signed [W-1:0] changed_sum_y_reg_1, changed_sum_y_reg_2;

  // DUT
  sum_alter #(.NARROW_WIDTH(NARROW_WIDTH), .INTEGER_BITS(INTEGER_BITS)) dut (
    .sum_x_reg_1(sum_x_reg_1),
    .sum_x_reg_2(sum_x_reg_2),
    .sum_y_reg_1(sum_y_reg_1),
    .sum_y_reg_2(sum_y_reg_2),
    .magnitude_negation_encoding(magnitude_negation_encoding),
    .changed_sum_x_reg_1(changed_sum_x_reg_1),
    .changed_sum_x_reg_2(changed_sum_x_reg_2),
    .changed_sum_y_reg_1(changed_sum_y_reg_1),
    .changed_sum_y_reg_2(changed_sum_y_reg_2)
  );

  // Waveform dump
  initial begin
    $dumpfile("sim/waves/tb_sum_alter.vcd");
    $dumpvars(0, tb_sum_alter);
  end

  // Test tracking
  int pass_count = 0;
  int fail_count = 0;
  string current_section = "";

  // Section printer
  task automatic begin_section(input string name);
    current_section = name;
    $display("");
    $display("  ── %s ──", name);
  endtask

  // Helper task
  task automatic check(
    input string          test_name,
    input signed [W-1:0]  got_x1, exp_x1,
    input signed [W-1:0]  got_x2, exp_x2,
    input signed [W-1:0]  got_y1, exp_y1,
    input signed [W-1:0]  got_y2, exp_y2
  );
    if (got_x1 === exp_x1 && got_x2 === exp_x2 &&
        got_y1 === exp_y1 && got_y2 === exp_y2) begin
      $display("    PASS: %s", test_name);
      pass_count++;
    end else begin
      $display("    FAIL: %s", test_name);
      if (got_x1 !== exp_x1) $display("      x1: got %0d, exp %0d", got_x1, exp_x1);
      if (got_x2 !== exp_x2) $display("      x2: got %0d, exp %0d", got_x2, exp_x2);
      if (got_y1 !== exp_y1) $display("      y1: got %0d, exp %0d", got_y1, exp_y1);
      if (got_y2 !== exp_y2) $display("      y2: got %0d, exp %0d", got_y2, exp_y2);
      fail_count++;
    end
  endtask

  // Common values
  localparam signed [W-1:0] POS      =  36'sd100;
  localparam signed [W-1:0] NEG      = -36'sd100;
  localparam signed [W-1:0] ZRO      =  36'sd0;
  localparam signed [W-1:0] ONE      =  36'sd1;
  localparam signed [W-1:0] NEG_ONE  = -36'sd1;
  localparam signed [W-1:0] LARGE    =  36'sd1000000;
  localparam signed [W-1:0] NEG_LARGE= -36'sd1000000;
  // Max positive for 36-bit signed: 2^35 - 1
  localparam signed [W-1:0] MAX_POS  =  36'sh7FFFFFFFF;
  // Most negative for 36-bit signed: -2^35
  localparam signed [W-1:0] MIN_NEG  =  36'sh800000000;

  initial begin
    $display("");
    $display("════════════════════════════════════════════════════");
    $display("  tb_sum_alter");
    $display("════════════════════════════════════════════════════");

    // ═════════════════════════════════════════════════════
    // SECTION 1: Passthrough (0000)
    // ═════════════════════════════════════════════════════
    begin_section("PASSTHROUGH encoding=4'b0000");

    sum_x_reg_1 = POS;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = NEG;  sum_y_reg_2 = POS;
    magnitude_negation_encoding = 4'b0000; #1;
    check("pos/neg inputs unchanged",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, NEG,
          changed_sum_y_reg_1, NEG,  changed_sum_y_reg_2, POS);

    sum_x_reg_1 = ZRO;  sum_x_reg_2 = ZRO;
    sum_y_reg_1 = ZRO;  sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b0000; #1;
    check("all zeros unchanged",
          changed_sum_x_reg_1, ZRO,  changed_sum_x_reg_2, ZRO,
          changed_sum_y_reg_1, ZRO,  changed_sum_y_reg_2, ZRO);

    sum_x_reg_1 = MAX_POS; sum_x_reg_2 = MIN_NEG;
    sum_y_reg_1 = MIN_NEG; sum_y_reg_2 = MAX_POS;
    magnitude_negation_encoding = 4'b0000; #1;
    check("max/min boundary values unchanged",
          changed_sum_x_reg_1, MAX_POS, changed_sum_x_reg_2, MIN_NEG,
          changed_sum_y_reg_1, MIN_NEG, changed_sum_y_reg_2, MAX_POS);

    // ═════════════════════════════════════════════════════
    // SECTION 2: abs(x) only (1000)
    // ═════════════════════════════════════════════════════
    begin_section("ABS(X) only — encoding=4'b1000");

    sum_x_reg_1 = NEG;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = NEG;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b1000; #1;
    check("both x negative → positive, y unchanged",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, POS,
          changed_sum_y_reg_1, NEG,  changed_sum_y_reg_2, NEG);

    sum_x_reg_1 = POS;  sum_x_reg_2 = POS;
    sum_y_reg_1 = POS;  sum_y_reg_2 = POS;
    magnitude_negation_encoding = 4'b1000; #1;
    check("both x already positive → unchanged",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, POS,
          changed_sum_y_reg_1, POS,  changed_sum_y_reg_2, POS);

    sum_x_reg_1 = NEG;  sum_x_reg_2 = POS;
    sum_y_reg_1 = ZRO;  sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b1000; #1;
    check("x1 negative x2 positive → both positive",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, POS,
          changed_sum_y_reg_1, ZRO,  changed_sum_y_reg_2, ZRO);

    sum_x_reg_1 = ZRO;  sum_x_reg_2 = ZRO;
    sum_y_reg_1 = NEG;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b1000; #1;
    check("x=0, y unchanged",
          changed_sum_x_reg_1, ZRO,  changed_sum_x_reg_2, ZRO,
          changed_sum_y_reg_1, NEG,  changed_sum_y_reg_2, NEG);

    sum_x_reg_1 = NEG_ONE; sum_x_reg_2 = ONE;
    sum_y_reg_1 = ZRO;     sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b1000; #1;
    check("x=-1,+1 → both +1",
          changed_sum_x_reg_1, ONE,  changed_sum_x_reg_2, ONE,
          changed_sum_y_reg_1, ZRO,  changed_sum_y_reg_2, ZRO);

    sum_x_reg_1 = MAX_POS; sum_x_reg_2 = NEG_LARGE;
    sum_y_reg_1 = ZRO;     sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b1000; #1;
    check("abs(x) with large values",
          changed_sum_x_reg_1, MAX_POS,  changed_sum_x_reg_2, LARGE,
          changed_sum_y_reg_1, ZRO,      changed_sum_y_reg_2, ZRO);

    // ═════════════════════════════════════════════════════
    // SECTION 3: abs(y) only (0100)
    // ═════════════════════════════════════════════════════
    begin_section("ABS(Y) only — encoding=4'b0100");

    sum_x_reg_1 = NEG;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = NEG;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b0100; #1;
    check("both y negative → positive, x unchanged",
          changed_sum_x_reg_1, NEG,  changed_sum_x_reg_2, NEG,
          changed_sum_y_reg_1, POS,  changed_sum_y_reg_2, POS);

    sum_x_reg_1 = POS;  sum_x_reg_2 = POS;
    sum_y_reg_1 = POS;  sum_y_reg_2 = POS;
    magnitude_negation_encoding = 4'b0100; #1;
    check("both y already positive → unchanged",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, POS,
          changed_sum_y_reg_1, POS,  changed_sum_y_reg_2, POS);

    sum_x_reg_1 = ZRO;  sum_x_reg_2 = ZRO;
    sum_y_reg_1 = NEG;  sum_y_reg_2 = POS;
    magnitude_negation_encoding = 4'b0100; #1;
    check("y1 negative y2 positive → both positive",
          changed_sum_x_reg_1, ZRO,  changed_sum_x_reg_2, ZRO,
          changed_sum_y_reg_1, POS,  changed_sum_y_reg_2, POS);

    // ═════════════════════════════════════════════════════
    // SECTION 4: negate(x) only (0010)
    // ═════════════════════════════════════════════════════
    begin_section("NEG(X) only — encoding=4'b0010");

    sum_x_reg_1 = POS;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = POS;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b0010; #1;
    check("negate x, y unchanged",
          changed_sum_x_reg_1, NEG,  changed_sum_x_reg_2, POS,
          changed_sum_y_reg_1, POS,  changed_sum_y_reg_2, NEG);

    sum_x_reg_1 = ZRO;  sum_x_reg_2 = ZRO;
    sum_y_reg_1 = POS;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b0010; #1;
    check("negate x=0 → still 0",
          changed_sum_x_reg_1, ZRO,  changed_sum_x_reg_2, ZRO,
          changed_sum_y_reg_1, POS,  changed_sum_y_reg_2, NEG);

    sum_x_reg_1 = ONE;  sum_x_reg_2 = NEG_ONE;
    sum_y_reg_1 = ZRO;  sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b0010; #1;
    check("negate x=+1/-1",
          changed_sum_x_reg_1, NEG_ONE, changed_sum_x_reg_2, ONE,
          changed_sum_y_reg_1, ZRO,     changed_sum_y_reg_2, ZRO);

    sum_x_reg_1 = LARGE;     sum_x_reg_2 = NEG_LARGE;
    sum_y_reg_1 = ZRO;       sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b0010; #1;
    check("negate large x values",
          changed_sum_x_reg_1, NEG_LARGE, changed_sum_x_reg_2, LARGE,
          changed_sum_y_reg_1, ZRO,       changed_sum_y_reg_2, ZRO);

    // ═════════════════════════════════════════════════════
    // SECTION 5: negate(y) only (0001)
    // ═════════════════════════════════════════════════════
    begin_section("NEG(Y) only — encoding=4'b0001");

    sum_x_reg_1 = POS;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = POS;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b0001; #1;
    check("negate y, x unchanged",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, NEG,
          changed_sum_y_reg_1, NEG,  changed_sum_y_reg_2, POS);

    sum_x_reg_1 = POS;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = ZRO;  sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b0001; #1;
    check("negate y=0 → still 0",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, NEG,
          changed_sum_y_reg_1, ZRO,  changed_sum_y_reg_2, ZRO);

    // ═════════════════════════════════════════════════════
    // SECTION 6: abs(x) + abs(y) (1100)
    // ═════════════════════════════════════════════════════
    begin_section("ABS(X)+ABS(Y) — encoding=4'b1100");

    sum_x_reg_1 = NEG;  sum_x_reg_2 = POS;
    sum_y_reg_1 = NEG;  sum_y_reg_2 = POS;
    magnitude_negation_encoding = 4'b1100; #1;
    check("mixed x and y → all positive",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, POS,
          changed_sum_y_reg_1, POS,  changed_sum_y_reg_2, POS);

    sum_x_reg_1 = NEG_LARGE; sum_x_reg_2 = NEG_LARGE;
    sum_y_reg_1 = NEG_LARGE; sum_y_reg_2 = NEG_LARGE;
    magnitude_negation_encoding = 4'b1100; #1;
    check("large negatives → large positives",
          changed_sum_x_reg_1, LARGE,  changed_sum_x_reg_2, LARGE,
          changed_sum_y_reg_1, LARGE,  changed_sum_y_reg_2, LARGE);

    // ═════════════════════════════════════════════════════
    // SECTION 7: negate(x) + negate(y) (0011)
    // ═════════════════════════════════════════════════════
    begin_section("NEG(X)+NEG(Y) — encoding=4'b0011");

    sum_x_reg_1 = POS;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = POS;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b0011; #1;
    check("negate both x and y",
          changed_sum_x_reg_1, NEG,  changed_sum_x_reg_2, POS,
          changed_sum_y_reg_1, NEG,  changed_sum_y_reg_2, POS);

    sum_x_reg_1 = ZRO;  sum_x_reg_2 = ZRO;
    sum_y_reg_1 = ZRO;  sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b0011; #1;
    check("negate zeros → zeros",
          changed_sum_x_reg_1, ZRO,  changed_sum_x_reg_2, ZRO,
          changed_sum_y_reg_1, ZRO,  changed_sum_y_reg_2, ZRO);

    // ═════════════════════════════════════════════════════
    // SECTION 8: abs(x) + negate(y) (1001)
    // ═════════════════════════════════════════════════════
    begin_section("ABS(X)+NEG(Y) — encoding=4'b1001");

    sum_x_reg_1 = NEG;  sum_x_reg_2 = POS;
    sum_y_reg_1 = POS;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b1001; #1;
    check("abs x, negate y",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, POS,
          changed_sum_y_reg_1, NEG,  changed_sum_y_reg_2, POS);

    // ═════════════════════════════════════════════════════
    // SECTION 9: negate(x) + abs(y) (0110)
    // ═════════════════════════════════════════════════════
    begin_section("NEG(X)+ABS(Y) — encoding=4'b0110");

    sum_x_reg_1 = POS;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = NEG;  sum_y_reg_2 = POS;
    magnitude_negation_encoding = 4'b0110; #1;
    check("negate x, abs y",
          changed_sum_x_reg_1, NEG,  changed_sum_x_reg_2, POS,
          changed_sum_y_reg_1, POS,  changed_sum_y_reg_2, POS);

    // ═════════════════════════════════════════════════════
    // SECTION 10: abs(x) then negate(x) → always negative (1010)
    // ═════════════════════════════════════════════════════
    begin_section("ABS(X)+NEG(X) — encoding=4'b1010 (always negative x)");

    sum_x_reg_1 = POS;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = ZRO;  sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b1010; #1;
    check("pos and neg x → both forced negative",
          changed_sum_x_reg_1, NEG,  changed_sum_x_reg_2, NEG,
          changed_sum_y_reg_1, ZRO,  changed_sum_y_reg_2, ZRO);

    sum_x_reg_1 = ZRO;  sum_x_reg_2 = ZRO;
    sum_y_reg_1 = POS;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b1010; #1;
    check("x=0 → abs then negate still 0",
          changed_sum_x_reg_1, ZRO,  changed_sum_x_reg_2, ZRO,
          changed_sum_y_reg_1, POS,  changed_sum_y_reg_2, NEG);

    sum_x_reg_1 = LARGE;  sum_x_reg_2 = NEG_LARGE;
    sum_y_reg_1 = ZRO;    sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b1010; #1;
    check("large values forced negative",
          changed_sum_x_reg_1, NEG_LARGE, changed_sum_x_reg_2, NEG_LARGE,
          changed_sum_y_reg_1, ZRO,       changed_sum_y_reg_2, ZRO);

    // ═════════════════════════════════════════════════════
    // SECTION 11: abs(y) then negate(y) → always negative (0101)
    // ═════════════════════════════════════════════════════
    begin_section("ABS(Y)+NEG(Y) — encoding=4'b0101 (always negative y)");

    sum_x_reg_1 = ZRO;  sum_x_reg_2 = ZRO;
    sum_y_reg_1 = POS;  sum_y_reg_2 = NEG;
    magnitude_negation_encoding = 4'b0101; #1;
    check("pos and neg y → both forced negative",
          changed_sum_x_reg_1, ZRO,  changed_sum_x_reg_2, ZRO,
          changed_sum_y_reg_1, NEG,  changed_sum_y_reg_2, NEG);

    sum_x_reg_1 = POS;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = ZRO;  sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b0101; #1;
    check("y=0 → abs then negate still 0",
          changed_sum_x_reg_1, POS,  changed_sum_x_reg_2, NEG,
          changed_sum_y_reg_1, ZRO,  changed_sum_y_reg_2, ZRO);

    // ═════════════════════════════════════════════════════
    // SECTION 12: All bits set (1111)
    // ═════════════════════════════════════════════════════
    begin_section("ALL BITS — encoding=4'b1111 (always negative x and y)");

    sum_x_reg_1 = POS;  sum_x_reg_2 = NEG;
    sum_y_reg_1 = NEG;  sum_y_reg_2 = POS;
    magnitude_negation_encoding = 4'b1111; #1;
    check("mixed inputs → all forced negative",
          changed_sum_x_reg_1, NEG,  changed_sum_x_reg_2, NEG,
          changed_sum_y_reg_1, NEG,  changed_sum_y_reg_2, NEG);

    sum_x_reg_1 = ZRO;  sum_x_reg_2 = ZRO;
    sum_y_reg_1 = ZRO;  sum_y_reg_2 = ZRO;
    magnitude_negation_encoding = 4'b1111; #1;
    check("all zeros → all zeros",
          changed_sum_x_reg_1, ZRO,  changed_sum_x_reg_2, ZRO,
          changed_sum_y_reg_1, ZRO,  changed_sum_y_reg_2, ZRO);

    sum_x_reg_1 = LARGE;  sum_x_reg_2 = NEG_LARGE;
    sum_y_reg_1 = LARGE;  sum_y_reg_2 = NEG_LARGE;
    magnitude_negation_encoding = 4'b1111; #1;
    check("large values all forced negative",
          changed_sum_x_reg_1, NEG_LARGE, changed_sum_x_reg_2, NEG_LARGE,
          changed_sum_y_reg_1, NEG_LARGE, changed_sum_y_reg_2, NEG_LARGE);

    sum_x_reg_1 = ONE;  sum_x_reg_2 = NEG_ONE;
    sum_y_reg_1 = ONE;  sum_y_reg_2 = NEG_ONE;
    magnitude_negation_encoding = 4'b1111; #1;
    check("unit values all forced negative",
          changed_sum_x_reg_1, NEG_ONE, changed_sum_x_reg_2, NEG_ONE,
          changed_sum_y_reg_1, NEG_ONE, changed_sum_y_reg_2, NEG_ONE);

    // ═════════════════════════════════════════════════════
    // SECTION 13: Boundary / edge values
    // ═════════════════════════════════════════════════════
    begin_section("BOUNDARY VALUES");

    sum_x_reg_1 = MAX_POS; sum_x_reg_2 = MAX_POS;
    sum_y_reg_1 = MAX_POS; sum_y_reg_2 = MAX_POS;
    magnitude_negation_encoding = 4'b1000; #1;
    check("abs(x) on max positive → unchanged",
          changed_sum_x_reg_1, MAX_POS, changed_sum_x_reg_2, MAX_POS,
          changed_sum_y_reg_1, MAX_POS, changed_sum_y_reg_2, MAX_POS);

    sum_x_reg_1 = ONE;  sum_x_reg_2 = NEG_ONE;
    sum_y_reg_1 = ONE;  sum_y_reg_2 = NEG_ONE;
    magnitude_negation_encoding = 4'b1100; #1;
    check("abs on unit values",
          changed_sum_x_reg_1, ONE, changed_sum_x_reg_2, ONE,
          changed_sum_y_reg_1, ONE, changed_sum_y_reg_2, ONE);

    sum_x_reg_1 = NEG_ONE; sum_x_reg_2 = NEG_ONE;
    sum_y_reg_1 = NEG_ONE; sum_y_reg_2 = NEG_ONE;
    magnitude_negation_encoding = 4'b0011; #1;
    check("negate -1 → +1",
          changed_sum_x_reg_1, ONE, changed_sum_x_reg_2, ONE,
          changed_sum_y_reg_1, ONE, changed_sum_y_reg_2, ONE);

    sum_x_reg_1 = ONE;  sum_x_reg_2 = ONE;
    sum_y_reg_1 = ONE;  sum_y_reg_2 = ONE;
    magnitude_negation_encoding = 4'b0011; #1;
    check("negate +1 → -1",
          changed_sum_x_reg_1, NEG_ONE, changed_sum_x_reg_2, NEG_ONE,
          changed_sum_y_reg_1, NEG_ONE, changed_sum_y_reg_2, NEG_ONE);

    // ═════════════════════════════════════════════════════
    // SUMMARY
    // ═════════════════════════════════════════════════════
    $display("");
    $display("════════════════════════════════════════════════════");
    $display("  Results: %0d passed, %0d failed", pass_count, fail_count);
    $display("════════════════════════════════════════════════════");
    if (fail_count == 0)
      $display("  ALL TESTS PASSED");
    else
      $display("  SOME TESTS FAILED");
    $display("");
    $finish;
  end

endmodule