// ============================================================================
// tb_multiply_manager_debug.sv
//
// Minimal debug-focused testbench for multiply_manager.
// Runs a handful of pixels, prints every iteration of the golden model
// so you can compare against waveforms, then checks the DUT output.
// ============================================================================

`timescale 1ns/1ps

module tb_multiply_manager_debug;

    localparam int NARROW_WIDTH          = 18;
    localparam int INTEGER_BITS          = 2;
    localparam int ITERATION_COUNT_WIDTH = 16;
    localparam int LOW                   = 0;

    localparam int NFRAC  = NARROW_WIDTH - INTEGER_BITS;  // 16
    localparam int PWIDTH = 2 * NARROW_WIDTH;             // 36

    // =========================================================================
    // DUT wiring
    // =========================================================================
    logic clk, rst, kill, received;
    logic start_left, start_right, start_wide;
    logic julia_type;
    logic [3:0]  magnitude_negation_encoding;
    logic [4:0]  max_iteration;
    logic signed [NARROW_WIDTH-1:0] julia_c_x, julia_c_y;
    logic signed [NARROW_WIDTH-1:0] starting_x_reg_1, starting_x_reg_2;
    logic signed [NARROW_WIDTH-1:0] starting_y_reg_1, starting_y_reg_2;
    logic done, done_side;
    logic [ITERATION_COUNT_WIDTH-1:0] iteration_out;

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

    initial clk = 0;
    always #5 clk = ~clk;

    int unsigned errors = 0;

    // =========================================================================
    // Fixed-point helpers
    // =========================================================================

    function automatic logic signed [NARROW_WIDTH-1:0] to_q216(input real v);
        return $signed(int'($rtoi(v * (1 << NFRAC))));
    endfunction

    function automatic real from_q216(input logic signed [NARROW_WIDTH-1:0] v);
        return real'($signed(v)) / real'(1 << NFRAC);
    endfunction

    function automatic real from_q432(input logic signed [PWIDTH-1:0] v);
        return real'($signed(v)) / real'(1 << (2*NFRAC));
    endfunction

    function automatic logic signed [PWIDTH-1:0] promote(
            input logic signed [NARROW_WIDTH-1:0] v);
        logic signed [PWIDTH-1:0] ext;
        ext = $signed(v);
        return ext <<< NFRAC;
    endfunction

    function automatic logic signed [NARROW_WIDTH-1:0] narrow_slice(
            input logic signed [PWIDTH-1:0] v);
        return v[NFRAC+NARROW_WIDTH-1 : NFRAC];
    endfunction

    function automatic logic signed [PWIDTH-1:0] do_alter(
            input logic signed [PWIDTH-1:0] v,
            input logic do_abs, input logic do_neg);
        logic signed [PWIDTH-1:0] t;
        t = (do_abs && v[PWIDTH-1]) ? -v : v;
        if (do_neg) t = -t;
        return t;
    endfunction

    // Does magnitude[35:34] != 0?
    function automatic logic escaped(input logic signed [PWIDTH-1:0] mag);
        return mag[PWIDTH-1] | mag[PWIDTH-2];  // bits 35 and 34 explicitly
    endfunction

    // =========================================================================
    // Golden model — prints every iteration step for debugging
    // =========================================================================
    function automatic int unsigned golden_iterations(
            input logic                           jtype,
            input logic [3:0]                     enc,
            input logic [4:0]                     maxit,
            input logic signed [NARROW_WIDTH-1:0] cx,
            input logic signed [NARROW_WIDTH-1:0] cy,
            input logic signed [NARROW_WIDTH-1:0] px,
            input logic signed [NARROW_WIDTH-1:0] py,
            input logic                           verbose);

        logic signed [PWIDTH-1:0] sum_x, sum_y, mag;
        logic signed [PWIDTH-1:0] ax, ay;
        logic signed [NARROW_WIDTH-1:0] sx, sy;
        logic signed [PWIDTH-1:0] xx, yy, xy2;
        int unsigned iter;
        int          limit_bit;

        limit_bit = int'(maxit) + LOW;

        iter  = 0;
        sum_x = jtype ? promote(px) : '0;
        sum_y = jtype ? promote(py) : '0;

        if (verbose)
            $display("    [golden] init: sum_x=%.6f sum_y=%.6f  (jtype=%0d)",
                     from_q432(sum_x), from_q432(sum_y), jtype);

        forever begin
            // ---- ALTER_SUM: overflow check first ----
            // Overflow: top INTEGER_BITS of the narrow slice are non-zero
            // (mirrors coord_flagger checking the integer bits of the wide reg)
            begin
                logic signed [NARROW_WIDTH-1:0] nx, ny;
                nx = narrow_slice(sum_x);
                ny = narrow_slice(sum_y);
                // overflow flag: integer part > 1 in magnitude
                // coord_flagger checks magnitude[35:34] of the WIDE reg
                // for the sum regs this is: |sum[35:34]|
                if (sum_x[PWIDTH-1] | sum_x[PWIDTH-2] |
                    sum_y[PWIDTH-1] | sum_y[PWIDTH-2]) begin
                    if (verbose)
                        $display("    [golden] iter=%0d  OVERFLOW escape  sum_x=%.6f sum_y=%.6f",
                                 iter, from_q432(sum_x), from_q432(sum_y));
                    return iter;
                end
            end

            // ---- ALTER_SUM: max iteration check ----
            if (iter[limit_bit]) begin
                if (verbose)
                    $display("    [golden] iter=%0d  MAX ITER hit (bit %0d of count)", iter, limit_bit);
                return iter;
            end

            // ---- ALTER_SUM: apply abs/neg, narrow ----
            ax = do_alter(sum_x, enc[3], enc[1]);
            ay = do_alter(sum_y, enc[2], enc[0]);
            sx = narrow_slice(ax);
            sy = narrow_slice(ay);

            if (verbose)
                $display("    [golden] iter=%0d  sx=%.6f sy=%.6f",
                         iter, from_q216(sx), from_q216(sy));

            // ---- X_SQUARED, Y_SQUARED ----
            xx  = sx * sx;
            yy  = sy * sy;
            mag = xx + yy;
            sum_x = xx - yy;  // partial: will add c later

            if (verbose)
                $display("    [golden] iter=%0d  xx=%.6f yy=%.6f mag=%.6f  escape=%0d",
                         iter, from_q432(xx), from_q432(yy), from_q432(mag), escaped(mag));

            if (escaped(mag)) begin
                if (verbose) $display("    [golden] iter=%0d  ESCAPE after Y_SQUARED", iter);
                return iter;
            end

            // ---- TWO_I_XY ----
            xy2   = (sx * sy) <<< 1;
            mag   = mag; // magnitude_reg not updated here in RTL
            sum_y = xy2;

            // RTL checks left_magnitude_flag in TWO_I_XY — this is still
            // the Y_SQUARED magnitude (not updated by xy2)
            if (escaped(mag)) begin
                if (verbose) $display("    [golden] iter=%0d  ESCAPE in TWO_I_XY (same mag as Y_SQUARED)", iter);
                return iter;
            end

            // ---- ADD_COORD / ADD_JULIA ----
            if (jtype) begin
                sum_x = sum_x + promote(cx);
                sum_y = sum_y + promote(cy);
            end else begin
                sum_x = sum_x + promote(px);
                sum_y = sum_y + promote(py);
            end
            iter = iter + 1;

            if (verbose)
                $display("    [golden] iter=%0d  after +c: sum_x=%.6f sum_y=%.6f",
                         iter, from_q432(sum_x), from_q432(sum_y));
        end
    endfunction

    // =========================================================================
    // Reset
    // =========================================================================
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
        $display("[reset] done, t=%0t", $time);
    endtask

    // =========================================================================
    // Run one left-thread pixel, compare to golden
    // =========================================================================
    task automatic run_left(
            input string                          name,
            input logic                           jtype,
            input logic [3:0]                     enc,
            input logic [4:0]                     maxit,
            input logic signed [NARROW_WIDTH-1:0] cx, cy, px, py,
            input logic                           verbose,
            input int unsigned                    timeout_cycles = 200000);

        int unsigned expected;
        int unsigned cyc;

        $display("\n--- TEST: %s ---", name);
        $display("    px=%.6f py=%.6f  cx=%.6f cy=%.6f  jtype=%0d enc=%04b maxit=%0d (limit=2^%0d=%0d)",
                 from_q216(px), from_q216(py),
                 from_q216(cx), from_q216(cy),
                 jtype, enc, maxit, int'(maxit)+LOW, 1<<(int'(maxit)+LOW));

        expected = golden_iterations(jtype, enc, maxit, cx, cy, px, py, verbose);
        $display("    [golden] predicted count = %0d", expected);

        // set DUT inputs
        julia_type                  = jtype;
        magnitude_negation_encoding = enc;
        max_iteration               = maxit;
        julia_c_x = cx; julia_c_y = cy;
        starting_x_reg_1 = px; starting_y_reg_1 = py;

        @(negedge clk); start_left = 1;
        @(negedge clk); start_left = 0;
        $display("    [dut]    start_left pulsed at t=%0t", $time);

        cyc = 0;
        while (!done && cyc < timeout_cycles) begin
            @(posedge clk);
            cyc++;
        end

        if (!done) begin
            $display("    [dut]    TIMEOUT after %0d cycles — done never asserted!", cyc);
            errors++;
        end else begin
            $display("    [dut]    done=1 after %0d cycles, done_side=%0d, iteration_out=%0d",
                     cyc, done_side, iteration_out);
            if (done_side !== 1'b0)
                $display("    [WARN]   done_side=%0d (expected 0 for left thread)", done_side);
            if (iteration_out == expected[ITERATION_COUNT_WIDTH-1:0])
                $display("    [PASS]   count matches: %0d", iteration_out);
            else begin
                $display("    [FAIL]   count mismatch: dut=%0d  golden=%0d  diff=%0d",
                         iteration_out, expected,
                         int'(iteration_out) - int'(expected));
                errors++;
            end
        end

        // acknowledge and check done drops
        @(negedge clk); received = 1;
        @(negedge clk); received = 0;
        @(posedge clk);
        if (done)
            $display("    [FAIL]   done still high one cycle after received!");
        else
            $display("    [dut]    done dropped correctly after received");

    endtask

    // =========================================================================
    // Test sequence
    // =========================================================================
    initial begin
        $dumpfile("sim/waves/tb_mm_debug.vcd");
        $dumpvars(0, tb_multiply_manager_debug);

        $display("======== multiply_manager debug testbench ========");
        do_reset();

        // 1. c=(0,0) Mandelbrot — stays at origin, hits max iter
        //    maxit=3 -> limit bit 3 -> 8 iterations. Easy ground truth.
        run_left("mandel (0,0) max=8",
                 1'b0, 4'b0000, 5'd3,
                 to_q216(0.0), to_q216(0.0),
                 to_q216(0.0), to_q216(0.0),
                 1'b1);   // verbose ON

        // 2. c=(1.5,0) Mandelbrot — escapes very quickly, easy to hand-trace
        //    z0=0 -> z1=1.5 -> z2=1.5^2+1.5=3.75 -> z3>4 -> escapes at iter=2
        run_left("mandel (1.5,0) fast escape",
                 1'b0, 4'b0000, 5'd5,
                 to_q216(0.0), to_q216(0.0),
                 to_q216(1.5), to_q216(0.0),
                 1'b1);   // verbose ON — watch the escape cycle

        // 3. c=(-1,0) Mandelbrot — period-2 interior, should hit max iter
        run_left("mandel (-1,0) interior",
                 1'b0, 4'b0000, 5'd4,
                 to_q216(0.0), to_q216(0.0),
                 to_q216(-1.0), to_q216(0.0),
                 1'b0);   // verbose OFF — just check count

        // 4. Julia c=(-0.8, 0.156), z0=(0,0) — classic Julia, moderate count
        run_left("julia (-0.8,0.156) z0=(0,0)",
                 1'b1, 4'b0000, 5'd5,
                 to_q216(-0.8), to_q216(0.156),
                 to_q216(0.0),  to_q216(0.0),
                 1'b1);

        // 5. Burning Ship c=(-1.7,-0.01) — enc={abs_x, abs_y}=4'b1100
        run_left("bship (-1.7,-0.01)",
                 1'b0, 4'b1100, 5'd5,
                 to_q216(0.0), to_q216(0.0),
                 to_q216(-1.7), to_q216(-0.01),
                 1'b0);

        $display("\n======== DONE: %0d error(s) ========", errors);
        if (errors == 0) $display("ALL TESTS PASSED");
        $finish;
    end

    initial begin
        #10_000_000;
        $display("==== GLOBAL TIMEOUT ====");
        $finish;
    end

endmodule