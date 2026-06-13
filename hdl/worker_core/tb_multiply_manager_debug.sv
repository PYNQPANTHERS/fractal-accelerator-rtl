// ============================================================================
// tb_multiply_manager_debug.sv
//
// Runs a handful of pixels through the DUT.
// Expected counts computed in full float precision (software reference).
// DUT output compared against expected — pass/fail reported.
// ============================================================================

`timescale 1ns/1ps

module tb_multiply_manager_debug;

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
    task automatic run_left(
            input string                          name,
            input logic                           jtype,
            input logic [3:0]                     enc,
            input logic [4:0]                     maxit,
            input logic signed [NARROW_WIDTH-1:0] cx, cy, px, py,
            input int unsigned                    expected,
            input int unsigned                    timeout_cycles = 200000);

        int unsigned cyc;
        int unsigned max_iter;
        max_iter = 1 << (int'(maxit) + LOW);

        $display("\n--- TEST: %s ---", name);
        $display("    px=%0d py=%0d  cx=%0d cy=%0d  maxit=%0d (limit=%0d)  float_expected=%0d",
                 px, py, cx, cy, maxit, max_iter, expected);

        julia_type                  = jtype;
        magnitude_negation_encoding = enc;
        max_iteration               = maxit;
        julia_c_x = cx; julia_c_y = cy;
        starting_x_reg_1 = px; starting_y_reg_1 = py;

        @(negedge clk); start_left = 1;
        @(negedge clk); start_left = 0;

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
        $dumpfile("sim/waves/tb_mm_debug.vcd");
        $dumpvars(0, tb_multiply_manager_debug);

        $display("======== multiply_manager debug testbench ========");
        do_reset();

        // maxit=3, LOW=0 -> limit = 2^3 = 8 iterations
        // c=(0,0): z stays 0 forever -> hits limit = 8
        // run_left("mandel (0,0) hits limit",
        //          1'b0, 4'b0000, 5'd5,
        //          to_q216(0.0), to_q216(0.0),
        //          to_q216(0.0), to_q216(0.0),
        //          float_mandel(0.0, 0.0, 32));

        // // c=(1.5,0): well outside set, fast escape
        // run_left("mandel (1.5,0) fast escape",
        //          1'b0, 4'b0000, 5'd5,
        //          to_q216(0.0), to_q216(0.0),
        //          to_q216(1.5), to_q216(0.0),
        //          float_mandel(1.5, 0.0, 32));

        // // c=(-1,0): period-2 bulb interior, hits limit
        // run_left("mandel (-1,0) interior",
        //          1'b0, 4'b0000, 5'd4,
        //          to_q216(0.0), to_q216(0.0),
        //          to_q216(-1.0), to_q216(0.0),
        //          float_mandel(-1.0, 0.0, 16));

        // c=(0.3,0.5): boundary, intermediate count
        run_left("mandel (-1,1) boundary",
                 1'b0, 4'b0000, 5'd9,
                 to_q216(0.0), to_q216(0.0),
                 to_q216(0.913725), to_q216(0.003922),
                 float_mandel(0.913725, 0.003922, 512));

// for (real x = 1.7; x <= 2.0; x = x + 0.002) begin
//     run_left($sformatf("mandel (%.5f,0)", x),
//              1'b0, 4'b0000, 5'd5,
//              to_q216(0.0), to_q216(0.0),
//              to_q216(x), to_q216(0),
//              float_mandel(x, 0, 32));
// end
        // // Julia: c=(-0.8,0.156), z0=(0,0)
        // run_left("julia c=(-0.8,0.156) z0=(0,0)",
        //          1'b1, 4'b0000, 5'd5,
        //          to_q216(-0.8), to_q216(0.156),
        //          to_q216(0.0),  to_q216(0.0),
        //          float_julia(0.0, 0.0, -0.8, 0.156, 32));

        // // Burning Ship: c=(-1.7,-0.01)
        // run_left("bship (-1.7,-0.01)",
        //          1'b0, 4'b1100, 5'd5,
        //          to_q216(0.0), to_q216(0.0),
        //          to_q216(-1.7), to_q216(-0.01),
        //          float_bship(-1.7, -0.01, 32));

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