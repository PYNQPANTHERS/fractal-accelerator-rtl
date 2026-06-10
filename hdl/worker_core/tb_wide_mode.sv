// ============================================================================
// tb_wide_mode.sv
//
// Runs a handful of pixels through the DUT.
// Expected counts computed in full float precision (software reference).
// DUT output compared against expected — pass/fail reported.
// ============================================================================

`timescale 1ns/1ps

module tb_wide_mode;

    localparam int NARROW_WIDTH          = 18;
    localparam int INTEGER_BITS          = 2;
    localparam int ITERATION_COUNT_WIDTH = 16;
    localparam int LOW                   = 0;
    localparam int NFRAC                 = NARROW_WIDTH - INTEGER_BITS; // 16

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

    // Declare at top of initial block
    logic signed [NARROW_WIDTH-1:0] hi, lo, hi2, lo2;

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
    // Helpers
    // =========================================================================
    function automatic logic signed [NARROW_WIDTH-1:0] to_q216(input real v);
        return $signed(int'($rtoi(v * (1 << NFRAC))));
    endfunction
    
    // Pack a real value into wide Q2.33 format
    // HIGH word = signed 18-bit in reg[35:18], LOW word = unsigned 17-bit in reg[17:1], bit 0 forced 0
    // Returns {high_word, low_word} as a 36-bit value packed into 2*NARROW_WIDTH bits
    function automatic void pack_wide_q233(
            input real v,
            output logic signed [NARROW_WIDTH-1:0] hi,
            output logic signed [NARROW_WIDTH-1:0] lo);
        longint signed full;
        full = longint'($rtoi(v * (2.0**33)));
        // Extract low 17 bits using modulo arithmetic - no bit manipulation
        lo = NARROW_WIDTH'({1'b0, 17'(unsigned'(full) % 131072)});
        // Extract hi by arithmetic right shift - well defined for signed longint
        hi = NARROW_WIDTH'(full >>> 17);
    endfunction

    // Full floating-point Mandelbrot reference.
    // Returns iteration count at which |z|^2 >= 4, or max_iter if interior.
    function automatic int unsigned float_mandel(
            input real cx, real cy,
            input int unsigned max_iter);
        real zx, zy, zx2, zy2;
        int unsigned i;
        zx = 0.0; zy = 0.0;
        for (i = 0; i < max_iter; i++) begin
            zx2 = zx*zx; zy2 = zy*zy;
            if (zx2 + zy2 >= 4.0) return i;
            zy  = 2.0*zx*zy + cy;
            zx  = zx2 - zy2 + cx;
        end
        return max_iter;
    endfunction

    function automatic int unsigned float_mandel_q233(
        input real cx, real cy,
        input int unsigned max_iter);
        // Quantise c to Q2.33 the same way the hardware does
        longint signed cx_q, cy_q;
        real cx_r, cy_r, zx, zy, zx2, zy2;
        int unsigned i;
        cx_q = longint'($rtoi(cx * (2.0**33)));
        cy_q = longint'($rtoi(cy * (2.0**33)));
        cx_r = real'(cx_q) / (2.0**33);
        cy_r = real'(cy_q) / (2.0**33);
        zx = 0.0; zy = 0.0;
        for (i = 0; i < max_iter; i++) begin
            zx2 = zx*zx; zy2 = zy*zy;
            if (zx2 + zy2 >= 4.0) return i;
            zy  = 2.0*zx*zy + cy_r;
            zx  = zx2 - zy2 + cx_r;
        end
        return max_iter;
    endfunction

    function automatic int unsigned float_bship_q233(
            input real cx, real cy,
            input int unsigned max_iter);
        longint signed cx_q, cy_q;
        real cx_r, cy_r, zx, zy, zx2, zy2;
        int unsigned i;
        cx_q = longint'($rtoi(cx * (2.0**33)));
        cy_q = longint'($rtoi(cy * (2.0**33)));
        cx_r = real'(cx_q) / (2.0**33);
        cy_r = real'(cy_q) / (2.0**33);
        zx = 0.0; zy = 0.0;
        for (i = 0; i < max_iter; i++) begin
            zx2 = zx*zx; zy2 = zy*zy;
            if (zx2 + zy2 >= 4.0) return i;
            zy  = 2.0*(zx < 0 ? -zx : zx)*(zy < 0 ? -zy : zy) + cy_r;
            zx  = zx2 - zy2 + cx_r;
        end
        return max_iter;
    endfunction

    // Full floating-point Julia reference.
    function automatic int unsigned float_julia(
            input real zx0, real zy0,   // starting point
            input real cx,  real cy,    // julia constant
            input int unsigned max_iter);
        real zx, zy, zx2, zy2;
        int unsigned i;
        zx = zx0; zy = zy0;
        for (i = 0; i < max_iter; i++) begin
            zx2 = zx*zx; zy2 = zy*zy;
            if (zx2 + zy2 >= 4.0) return i;
            zy  = 2.0*zx*zy + cy;
            zx  = zx2 - zy2 + cx;
        end
        return max_iter;
    endfunction

    // Full floating-point Burning Ship reference.
    function automatic int unsigned float_bship(
            input real cx, real cy,
            input int unsigned max_iter);
        real zx, zy, zx2, zy2;
        int unsigned i;
        zx = 0.0; zy = 0.0;
        for (i = 0; i < max_iter; i++) begin
            zx2 = zx*zx; zy2 = zy*zy;
            if (zx2 + zy2 >= 4.0) return i;
            zy  = 2.0*(zx < 0 ? -zx : zx)*(zy < 0 ? -zy : zy) + cy;
            zx  = zx2 - zy2 + cx;
        end
        return max_iter;
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
        $display("[tb] reset complete");
    endtask

    // =========================================================================
    // Run one left-thread pixel
    // =========================================================================
    task automatic run_wide(
            input string                          name,
            input logic                           jtype,
            input logic [3:0]                     enc,
            input logic [4:0]                     maxit,
            input logic signed [NARROW_WIDTH-1:0] cx, cy,
            input logic signed [NARROW_WIDTH-1:0] px_hi, px_lo,
            input logic signed [NARROW_WIDTH-1:0] py_hi, py_lo,
            input int unsigned                    expected,
            input int unsigned                    timeout_cycles = 200000);

        int unsigned cyc;
        int unsigned max_iter;
        max_iter = 1 << (int'(maxit) + LOW);

        $display("\n--- TEST: %s ---", name);
        $display("    px_hi=%0d px_lo=%0d  py_hi=%0d py_lo=%0d  cx=%0d cy=%0d  maxit=%0d expected=%0d",
                px_hi, px_lo, py_hi, py_lo, cx, cy, maxit, expected);

        julia_type                  = jtype;
        magnitude_negation_encoding = enc;
        max_iteration               = maxit;
        julia_c_x = cx; julia_c_y = cy;
        starting_x_reg_1 = px_hi;
        starting_x_reg_2 = px_lo;
        starting_y_reg_1 = py_hi;
        starting_y_reg_2 = py_lo;

        @(negedge clk); start_wide = 1;
        @(negedge clk); start_wide = 0;

        cyc = 0;
        while (!done && cyc < timeout_cycles) begin
            @(posedge clk);
            cyc++;
        end

        if (!done) begin
            $display("    [TIMEOUT] done never asserted after %0d cycles", cyc);
            errors++;
        end else begin
            $display("    [dut] done after %0d cycles  iteration_out=%0d  float_ref=%0d",
                    cyc, iteration_out, expected);
            if (int'(iteration_out) == int'(expected))
                $display("    [PASS]");
            else begin
                $display("    [FAIL] dut=%0d  expected=%0d  diff=%0d",
                        iteration_out, expected, int'(iteration_out) - int'(expected));
                errors++;
            end
        end

        @(negedge clk); received = 1;
        @(negedge clk); received = 0;
        @(posedge clk);
        if (done) begin
            $display("    [FAIL] done still high after received");
            errors++;
        end
    endtask

    // =========================================================================
    // Test sequence
    // =========================================================================
    initial begin

        

        $dumpfile("sim/waves/tb_wide_mode.vcd");
        $dumpvars(0, tb_wide_mode);

        $display("======== multiply_manager wide debug testbench ========");
        do_reset();

        run_wide("mandel (0,0) hits limit",
                1'b0, 4'b0000, 5'd3,
                to_q216(0.0), to_q216(0.0),
                to_q216(0.0), '0,
                to_q216(0.0), '0,
                float_mandel(0.0, 0.0, 8));

        // ---- Burning Ship wide-mode test cases ----
        run_wide("bship (-1.7, -0.01)",
                1'b0, 4'b1100, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd150732), 18'd104858,
                $signed(18'd261488), 18'd83886,
                11);

        run_wide("bship (-1.8, -0.01)",
                1'b0, 4'b1100, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd144179), 18'd26214,
                $signed(18'd261488), 18'd83886,
                10);

        run_wide("bship (0.3, 0.5)",
                1'b0, 4'b1100, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd19660), 18'd104858,
                $signed(18'd32768), 18'd0,
                8);

        run_wide("bship (1.5, 0.0)",
                1'b0, 4'b1100, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd98304), 18'd0,
                $signed(18'd0), 18'd0,
                2);

        run_wide("bship (-2.1, 0.0)",
                1'b0, 4'b1100, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd124518), 18'd52429,
                $signed(18'd0), 18'd0,
                1);

        run_wide("bship (-1.7, 0.1)",
                1'b0, 4'b1100, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd150732), 18'd104858,
                $signed(18'd6553), 18'd78643,
                4);

        run_wide("bship (-0.1275, 0.6513)",
                1'b0, 4'b1100, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd253788), 18'd20972,
                $signed(18'd42683), 18'd78224,
                4);

        run_wide("bship (0.5, 0.5)",
                1'b0, 4'b1100, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd32768), 18'd0,
                $signed(18'd32768), 18'd0,
                4);

        run_wide("bship (-1.5, 0.2)",
                1'b0, 4'b1100, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd163840), 18'd0,
                $signed(18'd13107), 18'd26214,
                3);

        // ---- Mandelbrot wide-mode test cases ----
        run_wide("mandel (-1.7, -0.01)",
                1'b0, 4'b0000, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd150732), 18'd104858,
                $signed(18'd261488), 18'd83886,
                10);

        run_wide("mandel (-1.8, -0.01)",
                1'b0, 4'b0000, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd144179), 18'd26214,
                $signed(18'd261488), 18'd83886,
                10);

        run_wide("mandel (1.5, 0.0)",
                1'b0, 4'b0000, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd98304), 18'd0,
                $signed(18'd0), 18'd0,
                2);

        run_wide("mandel (-2.1, 0.0)",
                1'b0, 4'b0000, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd124518), 18'd52429,
                $signed(18'd0), 18'd0,
                1);

        run_wide("mandel (-1.7, 0.1)",
                1'b0, 4'b0000, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd150732), 18'd104858,
                $signed(18'd6553), 18'd78643,
                6);

        run_wide("mandel (0.5, 0.5)",
                1'b0, 4'b0000, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd32768), 18'd0,
                $signed(18'd32768), 18'd0,
                5);

        run_wide("mandel (-1.5, 0.2)",
                1'b0, 4'b0000, 5'd6,
                to_q216(0.0), to_q216(0.0),
                $signed(18'd163840), 18'd0,
                $signed(18'd13107), 18'd26214,
                5);

        

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