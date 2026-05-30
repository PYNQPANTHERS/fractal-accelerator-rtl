// ============================================================================
// tb_multiply_manager.sv
//
// Self-checking testbench for the LEFT THREAD of multiply_manager.
//
// Strategy
// --------
// 1. A bit-exact REFERENCE EMULATOR (golden_iterations) replicates the EXACT
//    fixed-point datapath the RTL performs, in the same Q-format chain:
//        - inputs are Q2.16  (NARROW_WIDTH=18, INTEGER_BITS=2 -> 16 frac bits)
//        - multiply returns the raw product (Q4.32, 32 frac bits), no down-shift
//        - the FSM stores that straight into the 36-bit sum/magnitude regs
//        - ALTER_SUM re-narrows to Q2.16 by slicing bits [33:16] (truncation)
//        - escape when x^2 + y^2 >= 4.0  (magnitude[35:34] != 0)
//        - +c is added as (c <<< 16) so it aligns to Q4.32
//        - iteration limit = 2^(max_iteration + LOWEST_MAX_ITERATION_POWER),
//          detected via bit (max_iteration+LOW) of the count
//    Because it mirrors the hardware exactly (truncation included), the
//    predicted iteration count is the ground truth for THIS design.
//
// 2. The testbench drives start_left, waits for the hold-until-`received`
//    handshake, captures iteration_out, and compares against the emulator.
//
// 3. Separate directed checks cover the PROTOCOL/STATE behaviour:
//    reset/kill, done held high until received, return to idle, back-to-back
//    runs, done_side correctness.
//
// Notes
// -----
// - max_iteration drives a bit index of (max_iteration + LOWEST_MAX_ITERATION_POWER)
//   into a 16-bit count. With LOW=6 that means legal max_iteration is small
//   (index must stay < 16). Tests use LOW=0 and small limits so the bit index
//   is in range AND simulations terminate quickly. See `LOW` localparam below.
// - The DUT's `iteration_out` while DONE reads iteration_reg_1 directly.
// ============================================================================

`timescale 1ns/1ps

module tb_multiply_manager;

    // ----- Parameters (match DUT) -----
    localparam int NARROW_WIDTH           = 18;
    localparam int INTEGER_BITS           = 2;
    localparam int ITERATION_COUNT_WIDTH  = 16;
    localparam int LOW                    = 0;   // LOWEST_MAX_ITERATION_POWER for tests
                                                 // (0 so small limits keep bit index in range)

    localparam int NFRAC = NARROW_WIDTH - INTEGER_BITS;   // 16
    localparam int PWIDTH = 2*NARROW_WIDTH;               // 36
    localparam int PFRAC  = 2*NFRAC;                      // 32

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
    // Helpers
    // ========================================================================

    // Convert a real number to Q2.16 (the narrow input format)
    function automatic logic signed [NARROW_WIDTH-1:0] to_q216(input real v);
        return $signed(int'($rtoi(v * (1<<NFRAC))));
    endfunction

    // Sign-extend a narrow Q2.16 value to the 36-bit Q4.32 sum register,
    // matching the RTL's  ($signed(narrow) <<< NFRAC)
    function automatic logic signed [PWIDTH-1:0] promote_q216_to_q432(
            input logic signed [NARROW_WIDTH-1:0] v);
        logic signed [PWIDTH-1:0] ext;
        ext = $signed(v);          // sign-extend to 36 bits
        return ext <<< NFRAC;      // shift up by 16 -> binary point now at 32
    endfunction

    // Apply the sum_alter transform (abs/negate) to a Q4.32 value.
    // enc = {abs_x, abs_y, neg_x, neg_y} = bits [3:2:1:0]
    // For x: abs_x = enc[3], neg_x = enc[1].  For y: abs_y = enc[2], neg_y = enc[0].
    function automatic logic signed [PWIDTH-1:0] alter(
            input logic signed [PWIDTH-1:0] v,
            input logic do_abs,
            input logic do_neg);
        logic signed [PWIDTH-1:0] t;
        t = v;
        if (do_abs) t = (t < 0) ? -t : t;
        if (do_neg) t = -t;
        return t;
    endfunction

    // Re-narrow a Q4.32 value to Q2.16 exactly as ALTER_SUM does:
    //   spare = encoded[NFRAC+NARROW_WIDTH-1 : NFRAC]  = encoded[33:16]
    function automatic logic signed [NARROW_WIDTH-1:0] narrow_slice(
            input logic signed [PWIDTH-1:0] v);
        return v[NFRAC+NARROW_WIDTH-1 : NFRAC];
    endfunction

    // Multiply emulation (matches the `multiply` module exactly)
    // mode 00: x*x ; 01: y*y ; 10: (x*y)<<<1
    function automatic logic signed [PWIDTH-1:0] mul(
            input logic signed [NARROW_WIDTH-1:0] a,
            input logic signed [NARROW_WIDTH-1:0] b,
            input logic [1:0] m);
        case (m)
            2'b00:   return a * a;
            2'b01:   return b * b;
            2'b10:   return (a * b) <<< 1;
            default: return '0;
        endcase
    endfunction

    // Escape test: x^2+y^2 >= 4.0  <=>  magnitude[35:34] != 0
    function automatic logic escaped(input logic signed [PWIDTH-1:0] mag);
        return |mag[PWIDTH-1 : PWIDTH-INTEGER_BITS];   // bits [35:34]
    endfunction

    // ------------------------------------------------------------------------
    // BIT-EXACT REFERENCE EMULATOR
    //
    // Reproduces the left-thread datapath cycle-equivalently (per iteration,
    // not per micro-cycle) and returns the iteration count the RTL will report.
    //
    // Mirrors precisely:
    //   - sum_x/sum_y as 36-bit Q4.32 regs
    //   - the alter (abs/neg) applied each iteration in ALTER_SUM
    //   - x^2, y^2, 2xy via mul()
    //   - sum_x = x^2 - y^2 ; magnitude = x^2 + y^2 ; sum_y = 2xy
    //   - escape checks in Y_SQUARED and TWO_I_XY
    //   - max-iter check at top of loop (ALTER_SUM) BEFORE squaring
    //   - +c via promote_q216_to_q432
    // ------------------------------------------------------------------------
    function automatic int unsigned golden_iterations(
            input logic                       jtype,   // 0 mandel, 1 julia
            input logic [3:0]                 enc,
            input logic [4:0]                 maxit,
            input logic signed [NARROW_WIDTH-1:0] cx,   // julia const x (Q2.16)
            input logic signed [NARROW_WIDTH-1:0] cy,   // julia const y
            input logic signed [NARROW_WIDTH-1:0] px,   // pixel/coord x (Q2.16)
            input logic signed [NARROW_WIDTH-1:0] py);  // pixel/coord y
        logic signed [PWIDTH-1:0] sum_x, sum_y, mag;
        logic signed [PWIDTH-1:0] ax, ay;            // altered (post abs/neg)
        logic signed [NARROW_WIDTH-1:0] sx, sy;      // narrowed operands
        logic signed [PWIDTH-1:0] xx, yy, xy2;
        int unsigned iter;
        int          limit_bit;
        logic do_abs_x, do_neg_x, do_abs_y, do_neg_y;

        do_abs_x = enc[3]; do_neg_x = enc[1];
        do_abs_y = enc[2]; do_neg_y = enc[0];

        limit_bit = maxit + LOW;   // the bit of `iter` that flags the limit

        // ---- setup (start_left) ----
        iter = 0;
        if (jtype) begin
            sum_x = promote_q216_to_q432(px);
            sum_y = promote_q216_to_q432(py);
        end else begin
            sum_x = '0;
            sum_y = '0;
        end

        // ---- iterate ----
        forever begin
            // ALTER_SUM: limit check happens here (top of loop), BEFORE squaring
            if (iter[limit_bit]) return iter;   // hit max iteration -> DONE

            // apply abs/neg transform, then narrow to Q2.16 operands
            ax = alter(sum_x, do_abs_x, do_neg_x);
            ay = alter(sum_y, do_abs_y, do_neg_y);
            sx = narrow_slice(ax);
            sy = narrow_slice(ay);

            // X_SQUARED, Y_SQUARED
            xx = mul(sx, sy, 2'b00);   // x*x
            yy = mul(sx, sy, 2'b01);   // y*y

            mag   = xx + yy;           // magnitude_reg = x^2 + y^2  (set in Y_SQUARED)
            sum_x = xx - yy;           // sum_x         = x^2 - y^2

            // escape check (Y_SQUARED, then again in TWO_I_XY before the c add)
            if (escaped(mag)) return iter;

            // TWO_I_XY
            xy2   = mul(sx, sy, 2'b10); // 2xy
            if (escaped(mag)) return iter;   // (TWO_I_XY re-checks the same flag)
            sum_y = xy2;

            // ADD_COORD / ADD_JULIA  (+c, then iter++)
            if (jtype) begin
                sum_x = sum_x + promote_q216_to_q432(cx);
                sum_y = sum_y + promote_q216_to_q432(cy);
            end else begin
                sum_x = sum_x + promote_q216_to_q432(px);
                sum_y = sum_y + promote_q216_to_q432(py);
            end
            iter = iter + 1;
        end
    endfunction

    // ========================================================================
    // Drivers / scoreboard tasks
    // ========================================================================

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

    // Run one left-thread computation and check count + protocol.
    // Returns the captured iteration count.
    task automatic run_left(
            input string  name,
            input logic   jtype,
            input logic [3:0] enc,
            input logic [4:0] maxit,
            input logic signed [NARROW_WIDTH-1:0] cx,
            input logic signed [NARROW_WIDTH-1:0] cy,
            input logic signed [NARROW_WIDTH-1:0] px,
            input logic signed [NARROW_WIDTH-1:0] py,
            input int unsigned timeout_cycles = 100000);
        int unsigned expected;
        int unsigned cyc;
        logic captured;

        expected = golden_iterations(jtype, enc, maxit, cx, cy, px, py);

        // load inputs (must remain stable through the run: coords/const are
        // re-read every iteration by the DUT)
        julia_type                  = jtype;
        magnitude_negation_encoding = enc;
        max_iteration               = maxit;
        julia_c_x = cx; julia_c_y = cy;
        starting_x_reg_1 = px; starting_y_reg_1 = py;

        // one-cycle start pulse
        @(negedge clk);
        start_left = 1;
        @(negedge clk);
        start_left = 0;

        // wait for done (hold-high), with timeout
        cyc = 0; captured = 0;
        while (!captured) begin
            @(posedge clk);
            cyc++;
            // protocol: while running, done must be low
            if (!done) begin
                // still computing
            end else begin
                // done is high -> result must be on left side
                check(done_side == 1'b0, {name, ": done_side should be 0 (left)"});
                // check the count
                check(iteration_out == expected[ITERATION_COUNT_WIDTH-1:0],
                      $sformatf("%s: count mismatch dut=%0d exp=%0d",
                                name, iteration_out, expected));
                // done must STAY high until we ack (check it holds for a few cyc)
                repeat (3) begin
                    @(posedge clk);
                    check(done == 1'b1, {name, ": done dropped before received"});
                    check(iteration_out == expected[ITERATION_COUNT_WIDTH-1:0],
                          {name, ": iteration_out changed while waiting for ack"});
                end
                captured = 1;
            end
            if (cyc > timeout_cycles) begin
                check(1'b0, {name, ": TIMEOUT waiting for done"});
                captured = 1;
            end
        end

        // acknowledge
        @(negedge clk);
        received = 1;
        @(negedge clk);
        received = 0;

        // after ack, done must drop (return to idle)
        @(posedge clk);
        check(done == 1'b0, {name, ": done did not drop after received"});

        $display("  [ OK ] %-22s count = %0d", name, expected);
    endtask

    // ========================================================================
    // Test sequence
    // ========================================================================
    initial begin
        $dumpfile("sim/waves/tb_multiply_manager.vcd");
        $dumpvars(0, tb_multiply_manager);

        $display("==== tb_multiply_manager : left-thread ====");
        do_reset();

        // --- 1. Reset/idle sanity ---
        check(done == 1'b0, "after reset: done should be low");

        // --- 2. c = 0, Mandelbrot : never escapes -> hits the iteration limit ---
        //     limit = 2^(maxit+LOW). With LOW=0, maxit=3 -> limit bit 3 -> 8 iters.
        run_left("mandel c=0 (max=8)", 1'b0, 4'b0000, 5'd3,
                 0, 0, to_q216(0.0), to_q216(0.0));

        // --- 3. |c| > 2, Mandelbrot : escapes almost immediately ---
        run_left("mandel c=(1.5,0)",  1'b0, 4'b0000, 5'd5,
                 0, 0, to_q216(1.5), to_q216(0.0));
        run_left("mandel c=(-1.8,0)", 1'b0, 4'b0000, 5'd5,
                 0, 0, to_q216(-1.8), to_q216(0.0));
        run_left("mandel c=(0,1.5)",  1'b0, 4'b0000, 5'd5,
                 0, 0, to_q216(0.0), to_q216(1.5));

        // --- 4. Interior points : should run to the limit ---
        run_left("mandel c=(-1,0)",   1'b0, 4'b0000, 5'd4,
                 0, 0, to_q216(-1.0), to_q216(0.0));   // period-2, interior
        run_left("mandel c=(-0.5,0)", 1'b0, 4'b0000, 5'd4,
                 0, 0, to_q216(-0.5), to_q216(0.0));

        // --- 5. Boundary-ish points : intermediate counts (golden defines truth) ---
        run_left("mandel c=(0.3,0.5)",1'b0, 4'b0000, 5'd6,
                 0, 0, to_q216(0.3), to_q216(0.5));
        run_left("mandel c=(-0.7,0.3)",1'b0,4'b0000, 5'd6,
                 0, 0, to_q216(-0.7), to_q216(0.3));

        // --- 6. Julia mode : z0 = pixel, c = constant ---
        run_left("julia c=(-0.8,0.156)", 1'b1, 4'b0000, 5'd6,
                 to_q216(-0.8), to_q216(0.156), to_q216(0.0), to_q216(0.0));
        run_left("julia c=(0.285,0.01)", 1'b1, 4'b0000, 5'd6,
                 to_q216(0.285), to_q216(0.01), to_q216(0.1), to_q216(0.1));

        // --- 7. Variant: Burning Ship (abs x, abs y) enc = {1,1,0,0} = 4'b1100 ---
        run_left("bship c=(-1.7,-0.01)", 1'b0, 4'b1100, 5'd6,
                 0, 0, to_q216(-1.7), to_q216(-0.01));

        // --- 8. Variant: Tricorn / Mandelbar (negate y) enc = {0,0,0,1} = 4'b0001 ---
        run_left("tricorn c=(-0.5,0.5)", 1'b0, 4'b0001, 5'd6,
                 0, 0, to_q216(-0.5), to_q216(0.5));

        // --- 9. Back-to-back: a second run immediately after ack must work ---
        run_left("b2b run A",          1'b0, 4'b0000, 5'd4,
                 0, 0, to_q216(0.0), to_q216(0.0));
        run_left("b2b run B",          1'b0, 4'b0000, 5'd5,
                 0, 0, to_q216(1.5), to_q216(0.0));

        // --- 10. KILL mid-computation: done must never assert ---
        begin
            int unsigned cyc;
            julia_type = 0; magnitude_negation_encoding = 0; max_iteration = 5'd9;
            starting_x_reg_1 = 0; starting_y_reg_1 = 0;  // c=0 -> long run
            @(negedge clk); start_left = 1; @(negedge clk); start_left = 0;
            // let it run a bit
            repeat (10) @(posedge clk);
            check(done == 1'b0, "kill test: done high before kill (unexpected early finish)");
            @(negedge clk); kill = 1; @(negedge clk); kill = 0;
            // after kill, must be idle: done low, stays low
            repeat (10) begin
                @(posedge clk);
                check(done == 1'b0, "kill test: done asserted after kill");
            end
            $display("  [ OK ] kill mid-computation");
        end

        // --- 11. RST mid-computation ---
        begin
            @(negedge clk); start_left = 1; @(negedge clk); start_left = 0;
            repeat (8) @(posedge clk);
            @(negedge clk); rst = 1; @(negedge clk); rst = 0;
            repeat (5) begin
                @(posedge clk);
                check(done == 1'b0, "rst test: done asserted after rst");
            end
            $display("  [ OK ] rst mid-computation");
        end

        // --- summary ---
        $display("==== DONE: %0d checks, %0d errors ====", checks, errors);
        if (errors == 0) $display("==== ALL TESTS PASSED ====");
        else             $display("==== %0d FAILURE(S) ====", errors);
        $finish;
    end

    // Global watchdog
    initial begin
        #5_000_000;   // 5 ms sim time
        $display("==== GLOBAL TIMEOUT ====");
        $finish;
    end

endmodule