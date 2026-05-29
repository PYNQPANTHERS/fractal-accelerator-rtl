// ============================================================================
// tb_multiply_manager_precision.sv
//
// QUANTISATION DIVERGENCE testbench for the left thread.
//
// For each test point the DUT is driven to completion and its escape-iteration
// count is compared against an infinite-precision (SV real, 53-bit mantissa)
// Mandelbrot/Julia orbit. This characterises the accuracy cost of the Q2.16
// fixed-point representation, especially near the set boundary where low-bit
// precision matters most.
//
// Classification of divergence results:
//   exact       -- DUT and ideal agree to the iteration
//   quantisation -- both escaped, different iteration (benign rounding)
//   WARN: RANGE/OVERFLOW -- ideal escapes but DUT hit limit (misclassified in-set)
//   WARN: false escape   -- DUT escaped but ideal stayed in to the limit
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

    // ===== Q2.16 helpers =====
    function automatic logic signed [NARROW_WIDTH-1:0] to_q216(input real v);
        return $signed(int'($floor(v * (1<<NFRAC))));
    endfunction

    function automatic real q216_to_real(input logic signed [NARROW_WIDTH-1:0] q);
        return $itor($signed(q)) / (1<<NFRAC);
    endfunction

    // ===== reset =====
    task automatic do_reset;
        rst=1; kill=0; received=0; start_left=0; start_right=0; start_wide=0;
        julia_type=0; magnitude_negation_encoding=0; max_iteration=0;
        julia_c_x=0; julia_c_y=0;
        starting_x_reg_1=0; starting_x_reg_2=0; starting_y_reg_1=0; starting_y_reg_2=0;
        repeat (3) @(posedge clk); rst=0; @(posedge clk);
    endtask

    // ========================================================================
    // run_precision
    // Drives the DUT for one point, runs the ideal orbit, and reports
    // the divergence between the two escape counts.
    // ========================================================================
    task automatic run_precision(
            input string name, input logic jtype, input logic [3:0] enc,
            input logic [4:0] maxit,
            input logic signed [NARROW_WIDTH-1:0] cx, input logic signed [NARROW_WIDTH-1:0] cy,
            input logic signed [NARROW_WIDTH-1:0] px, input logic signed [NARROW_WIDTH-1:0] py);

        logic dax, dnx, day, dny;
        int   limit_bit;

        // ideal orbit
        int unsigned ideal_iter;
        logic        ideal_escaped;

        // DUT result
        int unsigned dut_count;
        int unsigned cyc;
        logic        loop_done;
        logic        dut_hit_limit;
        int          signed_div;
        int          limit_val;

        dax=enc[3]; dnx=enc[1]; day=enc[2]; dny=enc[0];
        limit_bit = maxit + LOW;

        // ----- ideal (infinite-precision) orbit -----
        ideal_iter=0; ideal_escaped=0;
        begin
            real ix, iy, t, ax_, ay_;
            real i_px, i_py, i_cx, i_cy;
            i_cx = q216_to_real(cx); i_cy = q216_to_real(cy);
            i_px = q216_to_real(px); i_py = q216_to_real(py);
            ix = jtype ? i_px : 0.0;
            iy = jtype ? i_py : 0.0;
            for (int k=0; (k < (1<<limit_bit)) && (k < 200000) && !ideal_escaped; k++) begin
                ax_ = ix; ay_ = iy;
                if (dax) ax_ = (ax_ < 0) ? -ax_ : ax_;
                if (dnx) ax_ = -ax_;
                if (day) ay_ = (ay_ < 0) ? -ay_ : ay_;
                if (dny) ay_ = -ay_;
                if (ax_*ax_ + ay_*ay_ >= 4.0) begin
                    ideal_escaped = 1; ideal_iter = k;
                end else begin
                    t  = ax_*ax_ - ay_*ay_;
                    iy = 2.0*ax_*ay_ + (jtype ? i_cy : i_py);
                    ix = t          + (jtype ? i_cx : i_px);
                    ideal_iter = k + 1;
                end
            end
        end

        // ----- drive DUT -----
        julia_type                  = jtype;
        magnitude_negation_encoding = enc;
        max_iteration               = maxit;
        julia_c_x                   = cx;
        julia_c_y                   = cy;
        starting_x_reg_1            = px;
        starting_y_reg_1            = py;

        @(negedge clk); start_left=1; @(negedge clk); start_left=0;

        // ----- wait for done -----
        cyc=0; loop_done=0;
        while (!loop_done) begin
            @(posedge clk);
            cyc++;
            if (done) begin
                dut_count = iteration_out;
                loop_done = 1;
            end
            if (cyc > 500000) begin
                errors++; checks++;
                $display("  [FAIL] %s : TIMEOUT", name);
                loop_done = 1;
            end
        end

        // ----- acknowledge -----
        @(negedge clk); received=1; @(negedge clk); received=0; @(posedge clk);

        // ----- divergence report -----
        signed_div    = $signed(dut_count) - $signed(ideal_iter);
        limit_val     = 1 << limit_bit;
        dut_hit_limit = (dut_count >= limit_val);

        if (signed_div == 0) begin
            $display("  [INFO] %-26s fixed=%0d  ideal=%0d  divergence=0  (exact)",
                     name, dut_count, ideal_iter);
        end
        else if (dut_hit_limit && ideal_escaped) begin
            $display("  [WARN] %-26s fixed=%0d (HIT LIMIT)  ideal=%0d (ESCAPES)  divergence=%0d",
                     name, dut_count, ideal_iter, signed_div);
            $display("         -> RANGE/OVERFLOW: orbit exceeded Q%0d.%0d range before escape check.",
                     INTEGER_BITS, NFRAC);
            $display("            This point is MISCLASSIFIED as in-set. Check input coord range.");
        end
        else if (!dut_hit_limit && !ideal_escaped) begin
            $display("  [WARN] %-26s fixed=%0d (ESCAPES)  ideal=%0d (HIT LIMIT)  divergence=%0d",
                     name, dut_count, ideal_iter, signed_div);
            $display("         -> truncated orbit left the set though the ideal orbit stayed in.");
        end
        else begin
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

        $display("==== tb_multiply_manager_precision : divergence characterisation ====");
        do_reset();

        // ---- standard Mandelbrot ----
        run_precision("c=0",              1'b0,4'b0000,5'd6,  0,0, to_q216( 0.0),    to_q216( 0.0));
        run_precision("c=(1.5,0)",        1'b0,4'b0000,5'd6,  0,0, to_q216( 1.5),    to_q216( 0.0));
        run_precision("c=(-1.0,0)",       1'b0,4'b0000,5'd6,  0,0, to_q216(-1.0),    to_q216( 0.0));
        run_precision("c=(-0.75,0.1)",    1'b0,4'b0000,5'd8,  0,0, to_q216(-0.75),   to_q216( 0.1));
        run_precision("c=(0.25,0.5)",     1'b0,4'b0000,5'd8,  0,0, to_q216( 0.25),   to_q216( 0.5));
        run_precision("c=(-0.745,0.113)", 1'b0,4'b0000,5'd9,  0,0, to_q216(-0.745),  to_q216( 0.113));
        run_precision("c=(0.0001,0)",     1'b0,4'b0000,5'd9,  0,0, to_q216( 0.0001), to_q216( 0.0));
        run_precision("c=(0.000015,0)",   1'b0,4'b0000,5'd9,  0,0, to_q216( 0.000015),to_q216(0.0));

        // ---- obvious exterior ----
        run_precision("c=(2,0)",          1'b0,4'b0000,5'd6,  0,0, to_q216( 2.0),    to_q216( 0.0));
        run_precision("c=(-2,0)",         1'b0,4'b0000,5'd6,  0,0, to_q216(-2.0),    to_q216( 0.0));
        run_precision("c=(1,1)",          1'b0,4'b0000,5'd6,  0,0, to_q216( 1.0),    to_q216( 1.0));
        run_precision("c=(-1.8,1.8)",     1'b0,4'b0000,5'd6,  0,0, to_q216(-1.8),    to_q216( 1.8));

        // ---- interior ----
        run_precision("c=(-0.125,0.744)", 1'b0,4'b0000,5'd10, 0,0, to_q216(-0.125),  to_q216( 0.744));
        run_precision("c=(-0.1011,0.9563)",1'b0,4'b0000,5'd10,0,0, to_q216(-0.1011), to_q216( 0.9563));
        run_precision("c=(-0.75,0)",      1'b0,4'b0000,5'd12, 0,0, to_q216(-0.75),   to_q216( 0.0));

        // ---- boundary-sensitive ----
        run_precision("boundary_1",       1'b0,4'b0000,5'd12, 0,0, to_q216(-0.7435),  to_q216( 0.1314));
        run_precision("boundary_2",       1'b0,4'b0000,5'd12, 0,0, to_q216(-0.7436),  to_q216( 0.1315));
        run_precision("boundary_3",       1'b0,4'b0000,5'd12, 0,0, to_q216(-0.101096),to_q216( 0.956287));
        run_precision("boundary_4",       1'b0,4'b0000,5'd12, 0,0, to_q216(-1.25066), to_q216( 0.02012));

        // ---- sub-LSB perturbation pairs ----
        run_precision("eps_1",            1'b0,4'b0000,5'd10, 0,0, to_q216(0.500000), to_q216(0.500000));
        run_precision("eps_2",            1'b0,4'b0000,5'd10, 0,0, to_q216(0.500015), to_q216(0.500000));
        run_precision("eps_3",            1'b0,4'b0000,5'd10, 0,0, to_q216(0.500030), to_q216(0.500000));

        // ---- negative-space symmetry ----
        run_precision("symm(+y)",         1'b0,4'b0000,5'd10, 0,0, to_q216(-0.2),    to_q216( 0.7));
        run_precision("symm(-y)",         1'b0,4'b0000,5'd10, 0,0, to_q216(-0.2),    to_q216(-0.7));

        // ---- range / overflow stress ----
        run_precision("range_max_pos",    1'b0,4'b0000,5'd6,  0,0, to_q216( 1.999),  to_q216( 1.999));
        run_precision("range_max_neg",    1'b0,4'b0000,5'd6,  0,0, to_q216(-1.999),  to_q216(-1.999));
        run_precision("range_mix",        1'b0,4'b0000,5'd6,  0,0, to_q216( 1.999),  to_q216(-1.999));

        // ---- Burning Ship ----
        run_precision("bship(-1.7,-0.01)",  1'b0,4'b1100,5'd8,  0,0, to_q216(-1.7),   to_q216(-0.01));
        run_precision("bship_edge_1",       1'b0,4'b1100,5'd10, 0,0, to_q216(-1.75),  to_q216(-0.03));
        run_precision("bship_edge_2",       1'b0,4'b1100,5'd10, 0,0, to_q216(-1.72),  to_q216(-0.017));

        // ---- Tricorn ----
        run_precision("tricorn(-0.5,0.5)",  1'b0,4'b0001,5'd8,  0,0, to_q216(-0.5),   to_q216( 0.5));
        run_precision("tricorn_edge_1",     1'b0,4'b0001,5'd10, 0,0, to_q216(-0.2),   to_q216( 0.65));
        run_precision("tricorn_edge_2",     1'b0,4'b0001,5'd10, 0,0, to_q216(-0.15),  to_q216( 0.72));

        // ---- Julia ----
        run_precision("julia(-0.8,0.156)",  1'b1,4'b0000,5'd8,
                      to_q216(-0.8),  to_q216( 0.156), to_q216(0.0), to_q216(0.0));
        run_precision("julia_1",            1'b1,4'b0000,5'd10,
                      to_q216(-0.4),  to_q216( 0.6),   to_q216(0.0), to_q216(0.0));
        run_precision("julia_2",            1'b1,4'b0000,5'd10,
                      to_q216( 0.285),to_q216( 0.01),  to_q216(0.0), to_q216(0.0));
        run_precision("julia_3",            1'b1,4'b0000,5'd10,
                      to_q216(-0.70176),to_q216(-0.3842),to_q216(0.0),to_q216(0.0));

        $display("==== DONE: %0d checks, %0d errors ====", checks, errors);
        if (errors == 0) $display("==== ALL TESTS PASSED ====");
        else             $display("==== %0d FAILURE(S) ====", errors);
        $finish;
    end

    initial begin #20_000_000; $display("==== GLOBAL TIMEOUT ===="); $finish; end

endmodule