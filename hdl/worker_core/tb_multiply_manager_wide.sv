// ============================================================================
// tb_multiply_manager_wide.sv
//
// Self-checking testbench for the WIDE (JOINED) thread of multiply_manager.
//
// Input coordinate format
// -----------------------
// A wide coordinate is a 36-bit packed value:
//
//   bits[35:18]  — signed 18-bit HIGH word  (carries sign and MSBs)
//   bits[17:0]   — unsigned 18-bit LOW word  (bit 17 permanently 0 → 17 usable bits)
//
// The mathematical value represented is:
//
//   V = HIGH * 2^17 + LOW
//
// In Q2.33 fixed-point, V represents the real number  V * 2^(-33).
// The representable range is therefore approximately (-2, +2) with
// 33 fractional bits of precision.
//
// Helper tasks pack a real number into this format:
//   to_wide(real v)  → 36-bit packed wide register value
//
// Golden model
// ------------
// wide_golden_iterations() replicates the RTL datapath exactly:
//
//   1. Each 35×35 multiply is decomposed into four 18×18 partial products
//      (HH, HL, LH, LL), accumulated into a 72-bit integer.
//   2. The 35-bit Q2.33 result is extracted from bits [68:34] of the 72-bit sum.
//      (Two Q2.33 operands multiply to give a Q4.66 product; the Q2.33 result
//       window starts at bit 34 to discard the low 34 fractional bits that lie
//       below the precision of the output format.)
//   3. Escape is checked on magnitude_reg[35:34] != 0, matching the RTL.
//   4. +c is added as a direct 36-bit wide addition to the packed result.
//   5. Iteration limit and kill/reset are not modelled; the golden model returns
//      a count that the RTL must match.
//
// The golden model uses $signed / $unsigned arithmetic that matches
// SystemVerilog's two's-complement semantics exactly.
// ============================================================================

`timescale 1ns/1ps

module tb_multiply_manager_wide;

    // ----- Parameters (match DUT) -----
    localparam int NARROW_WIDTH           = 18;
    localparam int INTEGER_BITS           = 2;
    localparam int ITERATION_COUNT_WIDTH  = 16;
    localparam int LOW                    = 0;   // LOWEST_MAX_ITERATION_POWER

    // Wide-mode geometry
    localparam int WIDE_HIGH_W  = 18;            // signed high word width
    localparam int WIDE_LOW_W   = 17;            // usable low word bits (bit 17 forced 0)
    localparam int WIDE_TOTAL   = 35;            // effective precision
    localparam int WIDE_REG_W   = 36;            // packed register width
    localparam int WIDE_FRAC    = 33;            // fractional bits in Q2.33
    localparam int ACC_W        = 72;            // accumulator width
    // Result window in 72-bit accumulator: two Q2.33 values multiply to Q4.66;
    // we extract a Q2.33 result by taking bits [68:34] (35 bits).
    localparam int RES_HI       = 68;
    localparam int RES_LO       = 34;

    // ----- DUT I/O -----
    logic clk, rst, kill, received;
    logic start_left, start_right, start_wide;
    logic julia_type;
    logic [3:0] magnitude_negation_encoding;
    logic [4:0] max_iteration;
    logic signed [NARROW_WIDTH-1:0] julia_c_x, julia_c_y;
    logic signed [NARROW_WIDTH-1:0] starting_x_reg_1, starting_x_reg_2;
    logic signed [NARROW_WIDTH-1:0] starting_y_reg_1, starting_y_reg_2;

    logic done, done_side;
    logic [ITERATION_COUNT_WIDTH-1:0] iteration_out;

    // ----- DUT -----
    multiply_manager #(
        .NARROW_WIDTH(NARROW_WIDTH),
        .INTEGER_BITS(INTEGER_BITS),
        .ITERATION_COUNT_WIDTH(ITERATION_COUNT_WIDTH),
        .LOWEST_MAX_ITERATION_POWER(LOW)
    ) dut (
        .clk(clk), .rst(rst), .kill(kill), .received(received),
        .start_left(start_left), .start_right(start_right), .start_wide(start_wide),
        .julia_type(julia_type),
        .magnitude_negation_encoding(magnitude_negation_encoding),
        .max_iteration(max_iteration),
        .julia_c_x(julia_c_x), .julia_c_y(julia_c_y),
        .starting_x_reg_1(starting_x_reg_1), .starting_x_reg_2(starting_x_reg_2),
        .starting_y_reg_1(starting_y_reg_1), .starting_y_reg_2(starting_y_reg_2),
        .done(done), .done_side(done_side), .iteration_out(iteration_out)
    );

    // ----- Clock -----
    initial clk = 0;
    always #5 clk = ~clk;   // 100 MHz

    // ----- Bookkeeping -----
    int unsigned errors = 0;
    int unsigned checks = 0;

    // ========================================================================
    // Format helpers
    // ========================================================================

    // Pack a real number into the 36-bit wide register format.
    // V = HIGH * 2^17 + LOW  represents  V * 2^(-33)  in Q2.33.
    // HIGH is signed 18-bit, LOW is unsigned 17-bit (bit 17 of the reg = 0).
    function automatic logic [WIDE_REG_W-1:0] to_wide(input real v);
        longint signed   raw;       // Q2.33 integer representation of v
        logic signed [WIDE_HIGH_W-1:0] hi;
        logic        [WIDE_LOW_W-1:0]  lo;
        logic        [WIDE_REG_W-1:0]  result;

        raw = longint'($rtoi(v * real'(1 << WIDE_FRAC)));  // v * 2^33, truncated

        // HIGH = raw >>> 17  (arithmetic right shift, keeping sign)
        hi = WIDE_HIGH_W'(raw >>> WIDE_LOW_W);

        // LOW  = raw[16:0]   (bottom 17 bits, always non-negative after the encoding)
        // Reconstruct to get the true low residual relative to hi * 2^17
        lo = WIDE_LOW_W'(raw - (longint'(hi) <<< WIDE_LOW_W));

        // Pack: bits[35:18] = hi, bit[17] = 0, bits[16:0] = lo
        result = {hi, 1'b0, lo};
        return result;
    endfunction

    // Convert a packed wide register value back to a real (for display).
    function automatic real wide_to_real(input logic [WIDE_REG_W-1:0] w);
        logic signed [WIDE_HIGH_W-1:0] hi;
        logic        [WIDE_LOW_W-1:0]  lo;
        longint signed raw;
        hi  = $signed(w[WIDE_REG_W-1 : WIDE_REG_W-WIDE_HIGH_W]);  // bits[35:18]
        lo  = w[WIDE_LOW_W-1 : 0];                                  // bits[16:0]
        raw = (longint'(hi) <<< WIDE_LOW_W) | longint'(lo);
        return real'(raw) / real'(1 << WIDE_FRAC);
    endfunction

    // Unpack HIGH and LOW from a packed wide register.
    function automatic logic signed [WIDE_HIGH_W-1:0] wide_hi(
            input logic [WIDE_REG_W-1:0] w);
        return $signed(w[WIDE_REG_W-1 : WIDE_REG_W-WIDE_HIGH_W]);
    endfunction

    function automatic logic [WIDE_LOW_W-1:0] wide_lo(
            input logic [WIDE_REG_W-1:0] w);
        return w[WIDE_LOW_W-1 : 0];  // bit 17 is 0, ignored
    endfunction

    // ========================================================================
    // Golden model
    // ========================================================================
    //
    // Represents wide values as Q2.33 integers (longint, 64-bit signed).
    // One 35×35 multiply:
    //   A = AH * 2^17 + AL,  B = BH * 2^17 + BL
    //   A*B = AH*BH*2^34 + (AH*BL + AL*BH)*2^17 + AL*BL   [72-bit accumulator]
    //   result = acc[68:34]  (35-bit window → Q2.33 output)
    //
    // Escape: magnitude (x² + y²) in Q2.33 integers ≥ 4 * 2^33
    //   Equivalently, magnitude_reg[35:34] != 0 when stored back as a packed wide.
    //
    // +c: direct addition of the packed 36-bit c value as a 36-bit integer to
    //   the packed 36-bit z result (HIGH and LOW add independently without
    //   carry between words because the addition is in the same packed space).
    //   NOTE: the RTL adds c by unpacking, adding 35-bit values, and repacking.
    //   Here we model that as a raw addition of the Q2.33 integers.

    // Perform one 35×35 multiply in the 72-bit accumulator model.
    // Returns the Q2.33 integer result (bits [68:34] of the 72-bit accumulated sum).
    function automatic longint wide_mul(
            input longint signed a,  // Q2.33 integer
            input longint signed b); // Q2.33 integer
        // a and b each fit in 35 signed bits when in range (-2,+2).
        // Decompose into 18-bit HIGH (signed) and 17-bit LOW (unsigned).
        longint signed  AH, BH;
        longint unsigned AL, BL;
        logic signed [127:0] acc;   // 128 bits is safe for 4 × 35² products
        logic signed [127:0] HH, HL, LH, LL;

        AH = a >>> 17;          // arithmetic shift → signed 18-bit high
        AL = a - (AH <<< 17);  // residual → unsigned 17-bit low
        BH = b >>> 17;
        BL = b - (BH <<< 17);

        HH = AH * BH;           // signed   × signed
        HL = AH * longint'(BL); // signed   × unsigned
        LH = longint'(AL) * BH; // unsigned × signed
        LL = longint'(AL) * longint'(BL); // unsigned × unsigned

        acc = (HH <<< 34) + (HL <<< 17) + (LH <<< 17) + LL;

        // Extract 35-bit result window at [68:34]
        return longint'(acc >>> RES_LO);  // arithmetic right-shift, then take low 35 bits
    endfunction

    // Mask result to 35 signed bits (discard carry out of bit 34 from the shift).
    function automatic longint signed mask35(input longint signed v);
        // sign-extend from bit 34
        logic [34:0] trunc;
        trunc = v[34:0];
        return longint'($signed(trunc));
    endfunction

    // Apply abs/negate to a Q2.33 integer.
    function automatic longint signed alter_wide(
            input longint signed v,
            input logic do_abs,
            input logic do_neg);
        longint signed t;
        t = v;
        if (do_abs) t = (t < 0) ? -t : t;
        if (do_neg) t = -t;
        return t;
    endfunction

    // Escape test: |z|² >= 4  in Q2.33 integer space.
    // 4 in Q2.33 = 4 * 2^33; but we test for overflow of the 35-bit packed field.
    // The RTL checks magnitude_reg[35:34] != 0 after storing the Q2.33 int back
    // into the 36-bit packed register.  The packed register is just the Q2.33
    // integer rescaled: store = (q2_33_int as 36-bit).
    // Bits[35:34] != 0 ↔ |value| >= 2^33  in magnitude reg, but since x²+y² is
    // always non-negative, overflow means x²+y² >= 2^33 in Q2.33 integer units,
    // i.e., x²+y² >= 1.0 in real.  That is < 4, which would be wrong.
    //
    // Correct interpretation: the escape condition x²+y² >= 4 in real corresponds
    // to x²+y² >= 4 * 2^33 in Q2.33 integer units.  In the 36-bit packed register
    // (Q2.33 stored as bits[35:18]=HIGH, bits[17:0] with bit17=0 as LOW), the value
    // 4 * 2^33 overflows the 35-bit signed range [-2^34, 2^34), so bits[35:34]
    // become non-zero — exactly the RTL escape check.
    //
    // Therefore the golden model escape test is:  magnitude_q2_33 >= (4 <<< 33).
    // But since 4 * 2^33 overflows a 35-bit signed field, we test via the
    // 36-bit packed form, matching the RTL exactly.
    function automatic logic wide_escaped(input longint signed mag_q2_33);
        // Repack into 36-bit to check bits[35:34].
        logic [35:0] repacked;
        logic [34:0] trunc35;
        trunc35  = mag_q2_33[34:0];
        repacked = {mag_q2_33[35], trunc35};  // sign-extend to 36 bits
        return |repacked[35:34];
    endfunction

    // BIT-EXACT WIDE-MODE REFERENCE EMULATOR
    //
    // Inputs are packed 36-bit wide registers (as the DUT receives them).
    // For Julia mode, julia_cx and julia_cy are NARROW Q2.16 values (not wide),
    // matching the design convention that julia_c always uses narrow encoding.
    function automatic int unsigned wide_golden_iterations(
            input logic                         jtype,
            input logic [3:0]                   enc,
            input logic [4:0]                   maxit,
            input logic signed [NARROW_WIDTH-1:0] jcx,    // julia c_x (narrow Q2.16)
            input logic signed [NARROW_WIDTH-1:0] jcy,    // julia c_y (narrow Q2.16)
            input logic [WIDE_REG_W-1:0]         px_wide, // pixel/coord x (wide)
            input logic [WIDE_REG_W-1:0]         py_wide); // pixel/coord y (wide)

        longint signed  zx, zy;   // current z in Q2.33 integer units
        longint signed  cx, cy;   // constant c in Q2.33 integer units
        longint signed  ax, ay;   // after abs/negate
        longint signed  x2, y2, xy, xy2;
        longint signed  mag;
        int unsigned    iter;
        int             limit_bit;
        logic do_abs_x, do_neg_x, do_abs_y, do_neg_y;

        do_abs_x = enc[3]; do_neg_x = enc[1];
        do_abs_y = enc[2]; do_neg_y = enc[0];
        limit_bit = maxit + LOW;

        // Unpack pixel coordinate to Q2.33 integer
        begin
            longint signed hi;
            longint unsigned lo;
            hi = longint'($signed(wide_hi(px_wide)));
            lo = longint'(wide_lo(px_wide));
            zx = (hi <<< WIDE_LOW_W) | longint'(lo);
        end
        begin
            longint signed hi;
            longint unsigned lo;
            hi = longint'($signed(wide_hi(py_wide)));
            lo = longint'(wide_lo(py_wide));
            zy = (hi <<< WIDE_LOW_W) | longint'(lo);
        end

        // c for Mandelbrot is the pixel coordinate; for Julia it's the julia constant.
        // Julia constant is always narrow Q2.16; promote to Q2.33 by shifting up 17 bits.
        if (jtype) begin
            // z0 = pixel; c = julia constant (narrow, promoted to Q2.33)
            cx = longint'($signed(jcx)) <<< 17;
            cy = longint'($signed(jcy)) <<< 17;
            // z0 already set from px/py above
        end else begin
            // z0 = 0; c = pixel coordinate (wide)
            cx = zx;
            cy = zy;
            zx = '0;
            zy = '0;
        end

        iter = 0;

        forever begin
            // Max iteration check (matches RTL ALTER_SUM check)
            if (iter[limit_bit]) return iter;

            // Apply abs/negate (fractal variant transform)
            ax = alter_wide(zx, do_abs_x, do_neg_x);
            ay = alter_wide(zy, do_abs_y, do_neg_y);

            // x² and y²
            x2 = mask35(wide_mul(ax, ax));
            y2 = mask35(wide_mul(ay, ay));

            // magnitude = x² + y² (escape check)
            mag = x2 + y2;
            if (wide_escaped(mag)) return iter;

            // 2xy
            xy  = mask35(wide_mul(ax, ay));
            xy2 = mask35(xy <<< 1);
            // magnitude re-check after TWO_I_XY (RTL checks escape flag again)
            if (wide_escaped(mag)) return iter;

            // new z = (x²-y², 2xy) + c
            zx = mask35(x2 - y2) + cx;
            zy = xy2 + cy;

            // Repack zx/zy back to 35-bit range after c addition
            // (RTL stores result in packed 36-bit regs; overflow wraps in hardware)
            zx = mask35(zx);
            zy = mask35(zy);

            iter = iter + 1;
        end
    endfunction

    // ========================================================================
    // Drivers / scoreboard tasks
    // ========================================================================

    task automatic run_fractional_cluster(
        input string name,
        input real cx,
        input real cy,
        input real dx,
        input real dy
    );
        run_wide({name, " base"}, 1'b0, 4'b0000, 5'd10,
                '0, '0,
                to_wide(cx), to_wide(cy));

        run_wide({name, " +dx"}, 1'b0, 4'b0000, 5'd10,
                '0, '0,
                to_wide(cx + dx), to_wide(cy));

        run_wide({name, " -dx"}, 1'b0, 4'b0000, 5'd10,
                '0, '0,
                to_wide(cx - dx), to_wide(cy));

        run_wide({name, " +dy"}, 1'b0, 4'b0000, 5'd10,
                '0, '0,
                to_wide(cx), to_wide(cy + dy));

        run_wide({name, " -dy"}, 1'b0, 4'b0000, 5'd10,
                '0, '0,
                to_wide(cx), to_wide(cy - dy));
    endtask

    task automatic do_reset();
        rst = 1; kill = 0; received = 0;
        start_left = 0; start_right = 0; start_wide = 0;
        julia_type = 0; magnitude_negation_encoding = 4'b0000;
        max_iteration = 0;
        julia_c_x = 0; julia_c_y = 0;
        starting_x_reg_1 = 0; starting_x_reg_2 = 0;
        starting_y_reg_1 = 0; starting_y_reg_2 = 0;
        repeat (3) @(posedge clk);
        rst = 0;
        @(posedge clk);
    endtask

    function automatic void check(input logic cond, input string msg);
        checks++;
        if (!cond) begin
            errors++;
            $display("  [FAIL] %s   (t=%0t)", msg, $time);
        end
    endfunction

    // Drive a wide pixel coordinate onto the DUT's starting_x/y register pair.
    // The DUT receives wide coordinates as two NARROW_WIDTH halves:
    //   starting_x_reg_1 = bits[35:18]  (HIGH word, signed 18-bit)
    //   starting_x_reg_2 = bits[17:0]   (LOW word, unsigned — bit 17 = 0)
    // For Mandelbrot, px/py are the pixel coordinate (wide).
    // For Julia, px/py are the z0 starting point (wide), jcx/jcy are narrow.
    task automatic drive_wide_inputs(
            input logic                         jtype,
            input logic [3:0]                   enc,
            input logic [4:0]                   maxit,
            input logic signed [NARROW_WIDTH-1:0] jcx,
            input logic signed [NARROW_WIDTH-1:0] jcy,
            input logic [WIDE_REG_W-1:0]         px_wide,
            input logic [WIDE_REG_W-1:0]         py_wide);
        julia_type                   = jtype;
        magnitude_negation_encoding  = enc;
        max_iteration                = maxit;
        julia_c_x                    = jcx;
        julia_c_y                    = jcy;
        // Split wide x into high/low halves for the two 18-bit input ports
        starting_x_reg_1 = $signed(px_wide[WIDE_REG_W-1 : WIDE_REG_W-NARROW_WIDTH]);  // [35:18]
        starting_x_reg_2 = NARROW_WIDTH'({1'b0, px_wide[WIDE_LOW_W-1:0]});             // 0,bits[16:0]
        starting_y_reg_1 = $signed(py_wide[WIDE_REG_W-1 : WIDE_REG_W-NARROW_WIDTH]);  // [35:18]
        starting_y_reg_2 = NARROW_WIDTH'({1'b0, py_wide[WIDE_LOW_W-1:0]});             // 0,bits[16:0]
    endtask

    // Run one wide-mode computation and verify against the golden model.
    task automatic run_wide(
            input string                        name,
            input logic                         jtype,
            input logic [3:0]                   enc,
            input logic [4:0]                   maxit,
            input logic signed [NARROW_WIDTH-1:0] jcx,
            input logic signed [NARROW_WIDTH-1:0] jcy,
            input logic [WIDE_REG_W-1:0]         px_wide,
            input logic [WIDE_REG_W-1:0]         py_wide,
            input int unsigned                  timeout_cycles = 500000);

        int unsigned expected;
        int unsigned cyc;
        logic captured;

        expected = wide_golden_iterations(jtype, enc, maxit, jcx, jcy, px_wide, py_wide);

        drive_wide_inputs(jtype, enc, maxit, jcx, jcy, px_wide, py_wide);

        // One-cycle start_wide pulse
        @(negedge clk);
        start_wide = 1;
        @(negedge clk);
        start_wide = 0;

        // Wait for done
        cyc = 0; captured = 0;
        while (!captured) begin
            @(posedge clk);
            cyc++;
            if (done) begin
                // done_side: wide mode uses left thread by convention (check your DUT)
                check(done_side == 1'b0, {name, ": done_side should be 0 (wide uses left thread)"});
                check(iteration_out == expected[ITERATION_COUNT_WIDTH-1:0],
                      $sformatf("%s: count mismatch  dut=%0d  expected=%0d",
                                name, iteration_out, expected));
                // done must hold until we acknowledge
                repeat (3) begin
                    @(posedge clk);
                    check(done == 1'b1, {name, ": done dropped before received"});
                    check(iteration_out == expected[ITERATION_COUNT_WIDTH-1:0],
                          {name, ": iteration_out changed while holding"});
                end
                captured = 1;
            end
            if (cyc > timeout_cycles) begin
                check(1'b0, {name, ": TIMEOUT waiting for done"});
                captured = 1;
            end
        end

        // Acknowledge
        @(negedge clk);
        received = 1;
        @(negedge clk);
        received = 0;

        // done must drop after ack
        @(posedge clk);
        check(done == 1'b0, {name, ": done did not drop after received"});

        $display("  [ OK ] %-40s  count=%0d  (%0d cycles)",
                 name, expected, cyc);
    endtask

    // ========================================================================
    // Test sequence
    // ========================================================================

    // Narrow-to-wide helper: convert a real to Q2.16 narrow, used for julia_c
    function automatic logic signed [NARROW_WIDTH-1:0] to_narrow(input real v);
        return $signed(int'($rtoi(v * real'(1 << (NARROW_WIDTH - INTEGER_BITS)))));
    endfunction

    initial begin
        $dumpfile("sim/waves/tb_multiply_manager_wide.vcd");
        $dumpvars(0, tb_multiply_manager_wide);

        $display("==== tb_multiply_manager_wide : wide (JOINED) thread ====");
        do_reset();
        check(done == 1'b0, "after reset: done should be low");

        // ----------------------------------------------------------------
        // 1. Origin — Mandelbrot c=(0,0).  z stays at 0 forever.
        //    Expect: hits iteration limit (no escape).
        // ----------------------------------------------------------------
        run_wide("mandel c=(0,0) max=8",
                 1'b0, 4'b0000, 5'd3,
                 '0, '0,
                 to_wide(0.0), to_wide(0.0));

        // ----------------------------------------------------------------
        // 2. Exterior point — immediate escape.
        //    c = (1.8, 0.0) is well outside the Mandelbrot set.
        // ----------------------------------------------------------------
        run_wide("mandel c=(1.8,0) escape",
                 1'b0, 4'b0000, 5'd6,
                 '0, '0,
                 to_wide(1.8), to_wide(0.0));

        run_wide("mandel c=(-1.9,0) escape",
                 1'b0, 4'b0000, 5'd6,
                 '0, '0,
                 to_wide(-1.9), to_wide(0.0));

        run_wide("mandel c=(0,1.8) escape",
                 1'b0, 4'b0000, 5'd6,
                 '0, '0,
                 to_wide(0.0), to_wide(1.8));

        // ----------------------------------------------------------------
        // 3. Interior points — must reach iteration limit.
        // ----------------------------------------------------------------
        run_wide("mandel c=(-1,0) interior max=16",
                 1'b0, 4'b0000, 5'd4,
                 '0, '0,
                 to_wide(-1.0), to_wide(0.0));

        run_wide("mandel c=(-0.5,0) interior max=16",
                 1'b0, 4'b0000, 5'd4,
                 '0, '0,
                 to_wide(-0.5), to_wide(0.0));

        // ----------------------------------------------------------------
        // 4. Boundary-region points — intermediate counts; golden is truth.
        // ----------------------------------------------------------------
        run_wide("mandel c=(0.3,0.5)",
                 1'b0, 4'b0000, 5'd6,
                 '0, '0,
                 to_wide(0.3), to_wide(0.5));

        run_wide("mandel c=(-0.7,0.3)",
                 1'b0, 4'b0000, 5'd6,
                 '0, '0,
                 to_wide(-0.7), to_wide(0.3));

        run_wide("mandel c=(-0.745,0.1)",
                 1'b0, 4'b0000, 5'd7,
                 '0, '0,
                 to_wide(-0.745), to_wide(0.1));

        // ----------------------------------------------------------------
        // 5. Deep zoom — the point of wide mode.
        //    Seahorse Valley neighbourhood: (-0.7436, 0.1319).
        //    At this precision the narrow mode would give wrong results;
        //    wide mode should give consistent counts matching the golden model.
        // ----------------------------------------------------------------
        run_wide("seahorse valley (-0.7436,0.1319) max=128",
                 1'b0, 4'b0000, 5'd7,
                 '0, '0,
                 to_wide(-0.7436), to_wide(0.1319));

        run_wide("seahorse valley (-0.74364,0.13182) max=128",
                 1'b0, 4'b0000, 5'd7,
                 '0, '0,
                 to_wide(-0.74364), to_wide(0.13182));
                 
        run_wide("test (2.0, 2.0) max=512",
                 1'b0, 4'b0000, 5'd9,
                 '0, '0,
                 to_wide(2.0), to_wide(2.0));

        // ------------------------------------------------------------------------
        // FRACTIONAL PRECISION STRESS BLOCK (Q2.33 LSB sensitivity)
        // ------------------------------------------------------------------------

        // ---- HIGH PRECISION FRACTIONAL TESTS ----

        // near boundary (high sensitivity region)
        run_fractional_cluster("fp A (-0.75, 0.10)",
            -0.75, 0.10,
            1.0 / (1 << 20),
            1.0 / (1 << 26));

        run_fractional_cluster("fp B (-0.7436, 0.1319)",
            -0.7436, 0.1319,
            1.0 / (1 << 22),
            1.0 / (1 << 28));

        run_fractional_cluster("fp C seahorse zoom",
            -0.74364, 0.13182,
            1.0 / (1 << 24),
            1.0 / (1 << 30));


        // ---- ULTRA LSB JITTER STRESS ----
        for (int i = 0; i < 8; i++) begin
            real eps;
            eps = (i - 4) * (1.0 / (1 << 32));

            run_wide($sformatf("LSB jitter %0d", i),
                    1'b0, 4'b0000, 5'd8,
                    '0, '0,
                    to_wide(-0.75 + eps),
                    to_wide(0.1 - eps));
        end

        // ----------------------------------------------------------------
        // 6. Julia mode — z0 = pixel (wide), c = julia constant (narrow).
        //    julia_c always uses narrow Q2.16 regardless of mode.
        // ----------------------------------------------------------------
        run_wide("julia c=(-0.8,0.156) z0=(0,0)",
                 1'b1, 4'b0000, 5'd6,
                 to_narrow(-0.8), to_narrow(0.156),
                 to_wide(0.0), to_wide(0.0));

        run_wide("julia c=(0.285,0.01) z0=(0.1,0.1)",
                 1'b1, 4'b0000, 5'd6,
                 to_narrow(0.285), to_narrow(0.01),
                 to_wide(0.1), to_wide(0.1));

        run_wide("julia c=(-0.4,0.6) z0=(-0.5,0.5)",
                 1'b1, 4'b0000, 5'd6,
                 to_narrow(-0.4), to_narrow(0.6),
                 to_wide(-0.5), to_wide(0.5));

        // ----------------------------------------------------------------
        // 7. Variants
        //    Burning Ship: abs both components  enc={1,1,0,0} = 4'b1100
        // ----------------------------------------------------------------
        run_wide("burning ship c=(-1.7,-0.01)",
                 1'b0, 4'b1100, 5'd6,
                 '0, '0,
                 to_wide(-1.7), to_wide(-0.01));

        // Tricorn / Mandelbar: negate y  enc={0,0,0,1} = 4'b0001
        run_wide("tricorn c=(-0.5,0.5)",
                 1'b0, 4'b0001, 5'd6,
                 '0, '0,
                 to_wide(-0.5), to_wide(0.5));

        // ----------------------------------------------------------------
        // 8. Back-to-back runs (no reset between)
        // ----------------------------------------------------------------
        run_wide("b2b run A  c=(0,0) max=8",
                 1'b0, 4'b0000, 5'd3,
                 '0, '0,
                 to_wide(0.0), to_wide(0.0));
        run_wide("b2b run B  c=(1.8,0) escape",
                 1'b0, 4'b0000, 5'd6,
                 '0, '0,
                 to_wide(1.8), to_wide(0.0));

        // ----------------------------------------------------------------
        // 9. KILL mid-computation
        // ----------------------------------------------------------------
        begin
            int unsigned cyc;
            // Start a long interior run (c=0 → never escapes)
            drive_wide_inputs(1'b0, 4'b0000, 5'd9, '0, '0,
                              to_wide(0.0), to_wide(0.0));
            @(negedge clk); start_wide = 1; @(negedge clk); start_wide = 0;
            repeat (20) @(posedge clk);
            check(done == 1'b0, "kill test: unexpected early done");
            @(negedge clk); kill = 1; @(negedge clk); kill = 0;
            repeat (10) begin
                @(posedge clk);
                check(done == 1'b0, "kill test: done asserted after kill");
            end
            $display("  [ OK ] kill mid-computation (wide)");
        end

        // ----------------------------------------------------------------
        // 10. RST mid-computation
        // ----------------------------------------------------------------
        begin
            drive_wide_inputs(1'b0, 4'b0000, 5'd9, '0, '0,
                              to_wide(0.0), to_wide(0.0));
            @(negedge clk); start_wide = 1; @(negedge clk); start_wide = 0;
            repeat (10) @(posedge clk);
            @(negedge clk); rst = 1; @(negedge clk); rst = 0;
            repeat (5) begin
                @(posedge clk);
                check(done == 1'b0, "rst test: done asserted after rst");
            end
            $display("  [ OK ] rst mid-computation (wide)");
        end

        // ----------------------------------------------------------------
        // Summary
        // ----------------------------------------------------------------
        $display("==== DONE: %0d checks, %0d errors ====", checks, errors);
        if (errors == 0) $display("==== ALL TESTS PASSED ====");
        else             $display("==== %0d FAILURE(S) ====", errors);
        $finish;
    end

    // Global watchdog
    initial begin
        #50_000_000;   // 50 ms — wide mode takes ~6× more cycles than narrow
        $display("==== GLOBAL TIMEOUT ====");
        $finish;
    end

endmodule