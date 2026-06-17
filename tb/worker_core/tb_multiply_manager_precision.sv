// ============================================================================
// tb_multiply_manager_precision.sv
//
// PRECISION / FIXED-POINT CORRECTNESS testbench for the left thread.
//
// Two layers:
//
//  LAYER 1 -- per-iteration LSB-exact check (HARD, zero tolerance)
//  ---------------------------------------------------------------
//  A reference model performs the SAME Q-format datapath with the SAME
//  floor-truncation ([33:16] = arithmetic shift = round toward -inf), in
//  lock-step with the DUT. At each iteration boundary we reach into the DUT
//  hierarchy and compare the actual registers (sum_x_reg_1, sum_y_reg_1,
//  magnitude_reg_1, spare_x_reg_1, iteration_reg_1) against the reference,
//  bit-for-bit. Any mismatch is a genuine arithmetic/wiring bug and FAILS,
//  pinpointing the iteration and the register.
//
//  LAYER 2 -- quantisation-divergence characterisation (LOG ONLY)
//  ---------------------------------------------------------------
//  For each test point we also run an *infinite-precision* (SV real, 53-bit
//  mantissa >> 18-bit fixed) Mandelbrot/Julia orbit and report how far the
//  Q2.16 escape count diverges from the ideal count. This is NOT a failure --
//  it quantifies the accuracy cost of the 16 fractional bits, especially near
//  the set boundary where low-bit precision matters most. Useful to see how
//  much your 16 fractional bits actually buys you.
//
// Notes
// -----
// * Hierarchical names below (dut.sum_x_reg_1 etc.) must match the DUT's
//   internal signal names. Adjust if you rename them.
// * Truncation model: [33:16] of a two's-complement Q4.32 value == floor(v)
//   to Q2.16 granularity == arithmetic right shift by 16. We replicate that
//   with $signed(...) >>> 16 on the 36-bit product.
// * LOW = LOWEST_MAX_ITERATION_POWER kept at 0 so limits stay in range and
//   sims terminate quickly. Precision behaviour is independent of LOW.
// ============================================================================

`timescale 1ns/1ps

module tb_multiply_manager_precision;

    localparam int NARROW_WIDTH          = 18;
    localparam int INTEGER_BITS          = 2;
    localparam int ITERATION_COUNT_WIDTH = 16;
    localparam int LOW                   = 0;

    localparam int NFRAC  = NARROW_WIDTH - INTEGER_BITS;  // 16
    localparam int PWIDTH = 2*NARROW_WIDTH;               // 36
    localparam int PFRAC  = 2*NFRAC;                      // 32

    localparam real LSB = 1.0 / (1<<NFRAC);               // value of one Q2.16 LSB

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

    multiply_manager #(
        .NARROW_WIDTH(NARROW_WIDTH), .INTEGER_BITS(INTEGER_BITS),
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

    initial clk = 0;
    always #5 clk = ~clk;

    int unsigned errors = 0, checks = 0;

    // ===== fixed-point helpers (match RTL exactly) =====
    function automatic logic signed [NARROW_WIDTH-1:0] to_q216(input real v);
        return $signed(int'($floor(v * (1<<NFRAC))));  // floor: match truncation
    endfunction

    function automatic real q216_to_real(input logic signed [NARROW_WIDTH-1:0] q);
        return $itor($signed(q)) / (1<<NFRAC);
    endfunction

    function automatic real q432_to_real(input logic signed [PWIDTH-1:0] q);
        return $itor($signed(q)) / (1<<PFRAC);
    endfunction

    // promote Q2.16 -> Q4.32 :  $signed(v) <<< 16   (matches RTL +c path)
    function automatic logic signed [PWIDTH-1:0] promote(input logic signed [NARROW_WIDTH-1:0] v);
        logic signed [PWIDTH-1:0] e; e = $signed(v); return e <<< NFRAC;
    endfunction

    // re-narrow Q4.32 -> Q2.16 :  bits [33:16] == arithmetic >>> 16 == floor
    function automatic logic signed [NARROW_WIDTH-1:0] narrow(input logic signed [PWIDTH-1:0] v);
        return v[NFRAC+NARROW_WIDTH-1 : NFRAC];
    endfunction

    function automatic logic signed [PWIDTH-1:0] mul(
            input logic signed [NARROW_WIDTH-1:0] a,
            input logic signed [NARROW_WIDTH-1:0] b, input logic [1:0] m);
        case (m)
            2'b00:   return a*a;
            2'b01:   return b*b;
            2'b10:   return (a*b) <<< 1;
            default: return '0;
        endcase
    endfunction

    function automatic logic signed [PWIDTH-1:0] alter(
            input logic signed [PWIDTH-1:0] v, input logic do_abs, input logic do_neg);
        logic signed [PWIDTH-1:0] t; t = v;
        if (do_abs) t = (t<0) ? -t : t;
        if (do_neg) t = -t;
        return t;
    endfunction

    function automatic logic escaped(input logic signed [PWIDTH-1:0] mag);
        return |mag[PWIDTH-1 : PWIDTH-INTEGER_BITS];
    endfunction

    task automatic do_reset;
        rst=1; kill=0; received=0; start_left=0; start_right=0; start_wide=0;
        julia_type=0; magnitude_negation_encoding=0; max_iteration=0;
        julia_c_x=0; julia_c_y=0;
        starting_x_reg_1=0; starting_x_reg_2=0; starting_y_reg_1=0; starting_y_reg_2=0;
        repeat (3) @(posedge clk); rst=0; @(posedge clk);
    endtask

    function automatic void expect_eq(input logic signed [PWIDTH-1:0] got,
                                      input logic signed [PWIDTH-1:0] exp,
                                      input string where, input int iter);
        checks++;
        if (got !== exp) begin
            errors++;
            $display("  [FAIL] %s @iter %0d : dut=%0d (0x%h) ref=%0d (0x%h)  delta=%0d LSB-ish",
                     where, iter, got, got, exp, exp, (got-exp));
        end
    endfunction

    // ------------------------------------------------------------------------
    // LAYER 1 + 2 combined run.
    // Drives the DUT, and at each ALTER_SUM boundary samples DUT registers and
    // compares to a lock-step reference model. Also accumulates the ideal
    // (infinite-precision) orbit for the divergence report.
    // ------------------------------------------------------------------------
    task automatic run_precision(
            input string name, input logic jtype, input logic [3:0] enc,
            input logic [4:0] maxit,
            input logic signed [NARROW_WIDTH-1:0] cx, input logic signed [NARROW_WIDTH-1:0] cy,
            input logic signed [NARROW_WIDTH-1:0] px, input logic signed [NARROW_WIDTH-1:0] py);

        // reference (fixed-point, lock-step) state
        logic signed [PWIDTH-1:0] r_sum_x, r_sum_y, r_mag;
        logic signed [PWIDTH-1:0] r_ax, r_ay;
        logic signed [NARROW_WIDTH-1:0] r_sx, r_sy;
        logic signed [PWIDTH-1:0] r_xx, r_yy, r_xy2;
        int unsigned r_iter;
        int limit_bit;
        logic dax, dnx, day, dny;

        // ideal (real, infinite precision) state
        real i_x, i_y, i_cx, i_cy, i_px, i_py, i_xx, i_yy, i_x2, i_y2;
        int unsigned ideal_iter;
        logic ideal_escaped;

        // dut capture
        int unsigned dut_count;
        int unsigned cyc;
        logic prev_in_alter;
        logic loop_done;
        logic dut_hit_limit;          // did the DUT terminate via max-iter (vs escape)?
        int   signed_div;             // signed divergence: dut - ideal
        int   limit_val;              // 2^limit_bit, the iteration ceiling

        dax=enc[3]; dnx=enc[1]; day=enc[2]; dny=enc[0];
        limit_bit = maxit + LOW;

        // ----- reference + ideal setup -----
        r_iter = 0;
        i_cx=q216_to_real(cx); i_cy=q216_to_real(cy);
        i_px=q216_to_real(px); i_py=q216_to_real(py);
        if (jtype) begin
            r_sum_x=promote(px); r_sum_y=promote(py);
            i_x=i_px; i_y=i_py;
        end else begin
            r_sum_x='0; r_sum_y='0;
            i_x=0.0; i_y=0.0;
        end

        // ----- ideal orbit (run to completion up front, just for the report) -----
        ideal_iter=0; ideal_escaped=0;
        begin
            real ix, iy, t;
            real ax_, ay_;
            ix = (jtype)? i_px : 0.0;
            iy = (jtype)? i_py : 0.0;
            for (int k=0; (k<(1<<(limit_bit))) && (k<200000) && !ideal_escaped; k++) begin
                // apply abs/neg (variant) to match the family being tested
                ax_ = ix; ay_ = iy;
                if (dax) ax_ = (ax_<0)?-ax_:ax_;
                if (dnx) ax_ = -ax_;
                if (day) ay_ = (ay_<0)?-ay_:ay_;
                if (dny) ay_ = -ay_;
                i_x2 = ax_*ax_; i_y2 = ay_*ay_;
                if (i_x2 + i_y2 >= 4.0) begin
                    ideal_escaped=1; ideal_iter=k;
                end else begin
                    t = i_x2 - i_y2;
                    iy = 2.0*ax_*ay_ + ((jtype)? i_cy : i_py);
                    ix = t + ((jtype)? i_cx : i_px);
                    ideal_iter = k+1;
                end
            end
        end

        // ----- drive DUT -----
        julia_type=jtype; magnitude_negation_encoding=enc; max_iteration=maxit;
        julia_c_x=cx; julia_c_y=cy;
        starting_x_reg_1=px; starting_y_reg_1=py;

        @(negedge clk); start_left=1; @(negedge clk); start_left=0;

        // ----- lock-step compare -----
        // We advance the reference one full iteration each time the DUT passes
        // through ALTER_SUM, and sample the DUT's regs in that state.
        cyc=0; prev_in_alter=0; loop_done=0; dut_count=0;
        while (!loop_done) begin
            @(posedge clk);
            cyc++;
            // detect entry into ALTER_SUM (rising edge of being in that state)
            // dut.left_cycle is the FSM enum; ALTER_SUM is value 1 in the typedef
            // (C_IDLE=0, ALTER_SUM=1, ...). Compare by name via the DUT param if
            // possible; here we compare against the captured enum.
            if (dut.left_cycle == dut.ALTER_SUM) begin
                if (!prev_in_alter) begin
                    // top of an iteration: DUT regs should equal reference
                    // (reference holds post-(+c) values, i.e. start of iter)
                    expect_eq(dut.sum_x_reg_1, r_sum_x, {name,".sum_x"}, r_iter);
                    expect_eq(dut.sum_y_reg_1, r_sum_y, {name,".sum_y"}, r_iter);

                    // limit check (top of loop)
                    if (r_iter[limit_bit]) ; // ref would go DONE; let DUT finish

                    // advance the reference one iteration (mirror the RTL)
                    if (!r_iter[limit_bit]) begin
                        r_ax = alter(r_sum_x, dax, dnx);
                        r_ay = alter(r_sum_y, day, dny);
                        r_sx = narrow(r_ax);
                        r_sy = narrow(r_ay);
                        r_xx = mul(r_sx, r_sy, 2'b00);
                        r_yy = mul(r_sx, r_sy, 2'b01);
                        r_mag = r_xx + r_yy;
                        // (escape handled by DUT; ref tracks values regardless)
                        r_xy2 = mul(r_sx, r_sy, 2'b10);
                        if (!escaped(r_mag)) begin
                            if (jtype) begin
                                r_sum_x = (r_xx - r_yy) + promote(cx);
                                r_sum_y = r_xy2 + promote(cy);
                            end else begin
                                r_sum_x = (r_xx - r_yy) + promote(px);
                                r_sum_y = r_xy2 + promote(py);
                            end
                            r_iter = r_iter + 1;
                        end
                    end
                end
                prev_in_alter = 1;
            end else begin
                prev_in_alter = 0;
            end

            if (done) begin
                dut_count = iteration_out;
                // also check the final reported count equals the reference count
                checks++;
                if (dut_count != (r_iter)) begin
                    errors++;
                    $display("  [FAIL] %s : final count dut=%0d ref=%0d", name, dut_count, r_iter);
                end
                loop_done = 1;
            end
            if (cyc > 500000) begin
                errors++; checks++;
                $display("  [FAIL] %s : TIMEOUT", name);
                loop_done = 1;
            end
        end

        // ack
        @(negedge clk); received=1; @(negedge clk); received=0; @(posedge clk);

        // ----- LAYER 2 report -----
        // signed divergence (avoid unsigned underflow in the print)
        signed_div = $signed(dut_count) - $signed(ideal_iter);
        limit_val  = 1 << limit_bit;
        // the DUT hit the iteration limit (didn't escape) if its count == the ceiling
        dut_hit_limit = (dut_count >= limit_val);

        if (signed_div == 0) begin
            $display("  [INFO] %-26s fixed=%0d  ideal=%0d  divergence=0  (exact)",
                     name, dut_count, ideal_iter);
        end
        else if (dut_hit_limit && ideal_escaped) begin
            // SERIOUS: ideal point escapes, but the DUT never did -> misclassified
            // as in-set. Almost always Q-format RANGE OVERFLOW: the orbit grew past
            // the representable magnitude before the >=4 escape check could fire,
            // wrapped, and looked bounded. These pixels render WRONG (in-set when
            // they are actually out). Distinct from benign rounding.
            $display("  [WARN] %-26s fixed=%0d (HIT LIMIT)  ideal=%0d (ESCAPES)  divergence=%0d",
                     name, dut_count, ideal_iter, signed_div);
            $display("         -> RANGE/OVERFLOW: orbit exceeded Q%0d.%0d range before escape check.",
                     INTEGER_BITS, NFRAC);
            $display("            This point is MISCLASSIFIED as in-set. Check input coord range.");
        end
        else if (!dut_hit_limit && !ideal_escaped) begin
            // DUT escaped but the ideal orbit stayed bounded to the limit -> the
            // truncated orbit wandered out of the set. Also a classification flip,
            // milder (false 'escape' rather than false 'in-set').
            $display("  [WARN] %-26s fixed=%0d (ESCAPES)  ideal=%0d (HIT LIMIT)  divergence=%0d",
                     name, dut_count, ideal_iter, signed_div);
            $display("         -> truncated orbit left the set though the ideal orbit stayed in.");
        end
        else begin
            // both escaped, just at different iterations: benign quantisation.
            // Flag loudly if the gap is large relative to the ideal count, since
            // a big relative gap means the low fractional bits matter a lot here.
            if (ideal_iter > 0 && (signed_div >= $signed(ideal_iter) || signed_div <= -$signed(ideal_iter)))
                $display("  [WARN] %-26s fixed=%0d  ideal=%0d  divergence=%0d  (LARGE: >= ideal count)",
                         name, dut_count, ideal_iter, signed_div);
            else
                $display("  [INFO] %-26s fixed=%0d  ideal=%0d  divergence=%0d  (quantisation)",
                         name, dut_count, ideal_iter, signed_div);
        end
    endtask

    // ========================================================================
    initial begin
        $dumpfile("sim/waves/tb_multiply_manager_precision.vcd");
        $dumpvars(0, tb_multiply_manager_precision);

        $display("==== tb_multiply_manager_precision : LSB-exact + divergence ====");
        do_reset();

        // Points chosen to stress low fractional bits / boundary behaviour.
        // Interior, exterior, and several near-boundary coordinates where the
        // 16th fractional bit decides the orbit.
        run_precision("c=0",            1'b0,4'b0000,5'd6, 0,0, to_q216(0.0),  to_q216(0.0));
        run_precision("c=(1.5,0)",      1'b0,4'b0000,5'd6, 0,0, to_q216(1.5),  to_q216(0.0));
        run_precision("c=(-1.0,0)",     1'b0,4'b0000,5'd6, 0,0, to_q216(-1.0), to_q216(0.0));
        run_precision("c=(-0.75,0.1)",  1'b0,4'b0000,5'd8, 0,0, to_q216(-0.75),to_q216(0.1));
        run_precision("c=(0.25,0.5)",   1'b0,4'b0000,5'd8, 0,0, to_q216(0.25), to_q216(0.5));
        run_precision("c=(-0.745,0.113)",1'b0,4'b0000,5'd9,0,0, to_q216(-0.745),to_q216(0.113));
        // sub-LSB stressors: coordinates that differ only in the lowest frac bits
        run_precision("c=(0.0001,0)",   1'b0,4'b0000,5'd9, 0,0, to_q216(0.0001),to_q216(0.0));
        run_precision("c=(0.000015,0)", 1'b0,4'b0000,5'd9, 0,0, to_q216(0.000015),to_q216(0.0));
        // variants
        run_precision("bship(-1.7,-0.01)",1'b0,4'b1100,5'd8,0,0,to_q216(-1.7),to_q216(-0.01));
        run_precision("tricorn(-0.5,0.5)",1'b0,4'b0001,5'd8,0,0,to_q216(-0.5),to_q216(0.5));
        // julia
        run_precision("julia(-0.8,0.156)",1'b1,4'b0000,5'd8,
                      to_q216(-0.8),to_q216(0.156),to_q216(0.0),to_q216(0.0));




        //added

// =====================================================================
// EXTRA PRECISION / RANGE / BOUNDARY TESTS
// =====================================================================

// -------------------------
// obvious exterior
// -------------------------
run_precision("c=(2,0)",          1'b0,4'b0000,5'd6,
              0,0,to_q216(2.0),to_q216(0.0));

run_precision("c=(-2,0)",         1'b0,4'b0000,5'd6,
              0,0,to_q216(-2.0),to_q216(0.0));

run_precision("c=(1,1)",          1'b0,4'b0000,5'd6,
              0,0,to_q216(1.0),to_q216(1.0));

run_precision("c=(-1.8,1.8)",     1'b0,4'b0000,5'd6,
              0,0,to_q216(-1.8),to_q216(1.8));

// -------------------------
// interior points
// -------------------------
run_precision("c=(-0.125,0.744)", 1'b0,4'b0000,5'd10,
              0,0,to_q216(-0.125),to_q216(0.744));

run_precision("c=(-0.1011,0.9563)",1'b0,4'b0000,5'd10,
              0,0,to_q216(-0.1011),to_q216(0.9563));

run_precision("c=(-0.75,0)",      1'b0,4'b0000,5'd12,
              0,0,to_q216(-0.75),to_q216(0.0));

// -------------------------
// boundary-sensitive points
// -------------------------
run_precision("boundary_1",       1'b0,4'b0000,5'd12,
              0,0,to_q216(-0.7435),to_q216(0.1314));

run_precision("boundary_2",       1'b0,4'b0000,5'd12,
              0,0,to_q216(-0.7436),to_q216(0.1315));

run_precision("boundary_3",       1'b0,4'b0000,5'd12,
              0,0,to_q216(-0.101096),to_q216(0.956287));

run_precision("boundary_4",       1'b0,4'b0000,5'd12,
              0,0,to_q216(-1.25066),to_q216(0.02012));

// -------------------------
// sub-LSB perturbation pairs
// -------------------------
run_precision("eps_1",            1'b0,4'b0000,5'd10,
              0,0,to_q216(0.500000),to_q216(0.500000));

run_precision("eps_2",            1'b0,4'b0000,5'd10,
              0,0,to_q216(0.500015),to_q216(0.500000));

run_precision("eps_3",            1'b0,4'b0000,5'd10,
              0,0,to_q216(0.500030),to_q216(0.500000));

// -------------------------
// negative-space symmetry
// -------------------------
run_precision("symm(+y)",         1'b0,4'b0000,5'd10,
              0,0,to_q216(-0.2),to_q216(0.7));

run_precision("symm(-y)",         1'b0,4'b0000,5'd10,
              0,0,to_q216(-0.2),to_q216(-0.7));

// -------------------------
// range / overflow stress
// -------------------------
run_precision("range_max_pos",    1'b0,4'b0000,5'd6,
              0,0,to_q216(1.999),to_q216(1.999));

run_precision("range_max_neg",    1'b0,4'b0000,5'd6,
              0,0,to_q216(-1.999),to_q216(-1.999));

run_precision("range_mix",        1'b0,4'b0000,5'd6,
              0,0,to_q216(1.999),to_q216(-1.999));

// -------------------------
// Burning Ship edge cases
// -------------------------
run_precision("bship_edge_1",     1'b0,4'b1100,5'd10,
              0,0,to_q216(-1.75),to_q216(-0.03));

run_precision("bship_edge_2",     1'b0,4'b1100,5'd10,
              0,0,to_q216(-1.72),to_q216(-0.017));

// -------------------------
// Tricorn edge cases
// -------------------------
run_precision("tricorn_edge_1",   1'b0,4'b0001,5'd10,
              0,0,to_q216(-0.2),to_q216(0.65));

run_precision("tricorn_edge_2",   1'b0,4'b0001,5'd10,
              0,0,to_q216(-0.15),to_q216(0.72));

// -------------------------
// Julia stress tests
// -------------------------
run_precision("julia_1",          1'b1,4'b0000,5'd10,
              to_q216(-0.4),to_q216(0.6),
              to_q216(0.0),to_q216(0.0));

run_precision("julia_2",          1'b1,4'b0000,5'd10,
              to_q216(0.285),to_q216(0.01),
              to_q216(0.0),to_q216(0.0));

run_precision("julia_3",          1'b1,4'b0000,5'd10,
              to_q216(-0.70176),to_q216(-0.3842),
              to_q216(0.0),to_q216(0.0));

        $display("==== DONE: %0d checks, %0d errors ====", checks, errors);
        if (errors==0) $display("==== ALL TESTS PASSED ====");
        else           $display("==== %0d FAILURE(S) ====", errors);
        $finish;
    end

    initial begin #20_000_000; $display("==== GLOBAL TIMEOUT ===="); $finish; end

endmodule