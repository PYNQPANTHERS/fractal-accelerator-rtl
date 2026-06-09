// ============================================================================
// tb_multiply_manager_render.sv
//
// Renders fractal frames by sweeping pixel coordinates through the DUT and
// collecting iteration counts.  Two render passes are issued back-to-back:
//
//   Pass 1 — NARROW MODE  (start_right / start_left)
//     512×512, coordinate range [-1.5, 1.5].
//     18-bit Q2.16 fixed-point.  One pixel submitted at a time via start_right.
//     Output: sim/render/frame_narrow.csv
//
//   Pass 2 — WIDE MODE  (start_wide)
//     512×512, deep-zoom window centred on Seahorse Valley:
//       centre (-0.743643135, 0.131825963), half-width 3e-4.
//     35-bit Q2.33 fixed-point (18-bit signed high word + 17-bit unsigned low
//     word, packed into the same 18-bit register ports as narrow mode).
//     Output: sim/render/frame_wide.csv
//
// Port mapping for wide mode:
//   starting_x_reg_1  ← x high word  (signed 18-bit, Q2.16)
//   starting_x_reg_2  ← x low word   ({1'b0, 17-bit magnitude})
//   starting_y_reg_1  ← y high word  (signed 18-bit, Q2.16)
//   starting_y_reg_2  ← y low word   ({1'b0, 17-bit magnitude})
//
//   julia_c_x / julia_c_y are always 18-bit Q2.16 regardless of mode.
//   The Julia constant selects which Julia set to render; it does not need
//   wide precision.  In wide mode it is simply zero-padded (low word = 0),
//   exactly the same encoding used in narrow mode.
//
// Wide-mode fixed-point encoding (Q2.33, 35 bits total):
//   full_int = floor(v * 2^33)                    [35-bit two's-complement]
//   high[17:0] = full_int[34:17]                  [signed, carries integer+MSBs]
//   low[17:0]  = {1'b0, full_int[16:0]}           [MSB forced 0 → always +ve]
//   Reconstruction: v ≈ high * 2^17 + low (in the fractional domain)
//
// After simulation, run:
//   python3 render.py --input sim/render/frame_narrow.csv --output frame_narrow.png
//   python3 render.py --input sim/render/frame_wide.csv   --output frame_wide.png
// ============================================================================

`timescale 1ns/1ps

module tb_multiply_manager_render;

    // =========================================================================
    // Parameters (mirror DUT generics)
    // =========================================================================
    localparam int NARROW_WIDTH          = 18;
    localparam int INTEGER_BITS          = 2;
    localparam int ITERATION_COUNT_WIDTH = 16;
    localparam int LOW                   = 0;

    localparam int NFRAC   = NARROW_WIDTH - INTEGER_BITS;  // 16
    localparam int WIDTH   = 128;
    localparam int HEIGHT  = 128;
    localparam real XMIN   = -1.5;
    localparam real XMAX   =  1.5;
    localparam real YMIN   = -1.5;
    localparam real YMAX   =  1.5;

    // max_iteration field: DUT iteration ceiling = 2^(max_iteration + LOW)
    // 5'd9 -> 512 iterations, a good balance of detail vs sim time
    localparam logic [4:0] MAX_ITER = 5'd6;

    // Narrow render window
    localparam real N_XMIN = -1.5;
    localparam real N_XMAX =  1.5;
    localparam real N_YMIN = -1.5;
    localparam real N_YMAX =  1.5;

    // Wide render window — Seahorse Valley, needs ~31 bits of fractional
    // precision to resolve detail; 35-bit Q2.33 provides 33 fractional bits.
    /*localparam real W_CX   = -0.743643135;
    localparam real W_CY   =  0.131825963;
    localparam real W_HALF =  3.0e-4;
    localparam real W_XMIN = W_CX - W_HALF;
    localparam real W_XMAX = W_CX + W_HALF;
    localparam real W_YMIN = W_CY - W_HALF;
    localparam real W_YMAX = W_CY + W_HALF;*/

    // Wide render window matches narrow render
    localparam real W_XMIN = N_XMIN;
    localparam real W_XMAX = N_XMAX;
    localparam real W_YMIN = N_YMIN;
    localparam real W_YMAX = N_YMAX;

    // Iteration ceiling: 2^(MAX_ITER + LOW)
    //   8 → 256 iters  (fast simulation; increase for denser images)
    localparam logic [4:0] MAX_ITER = 5'd200;

    // =========================================================================
    // DUT I/O
    // =========================================================================
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
        .NARROW_WIDTH              (NARROW_WIDTH),
        .INTEGER_BITS              (INTEGER_BITS),
        .ITERATION_COUNT_WIDTH     (ITERATION_COUNT_WIDTH),
        .LOWEST_MAX_ITERATION_POWER(LOW)
    ) dut (
        .clk                        (clk),
        .rst                        (rst),
        .kill                       (kill),
        .received                   (received),
        .start_left                 (start_left),
        .start_right                (start_right),
        .start_wide                 (start_wide),
        .julia_type                 (julia_type),
        .magnitude_negation_encoding(magnitude_negation_encoding),
        .max_iteration              (max_iteration),
        .julia_c_x                  (julia_c_x),
        .julia_c_y                  (julia_c_y),
        .starting_x_reg_1           (starting_x_reg_1),
        .starting_x_reg_2           (starting_x_reg_2),
        .starting_y_reg_1           (starting_y_reg_1),
        .starting_y_reg_2           (starting_y_reg_2),
        .done                       (done),
        .done_side                  (done_side),
        .iteration_out              (iteration_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // =========================================================================
    // Fixed-point conversion helpers
    // =========================================================================

    // Narrow: Q2.16, fits in a single signed 18-bit word.
    function automatic logic signed [NARROW_WIDTH-1:0] to_q216(input real v);
        return $signed(int'($floor(v * (1 << NFRAC))));
    endfunction

    // Wide high word: bits[34:17] of the 35-bit Q2.33 representation.
    // This has the same bit weight as the narrow Q2.16 word (integer part in
    // bits[17:16], 16 fractional bits in bits[15:0]), so it is numerically
    // identical to to_q216 — the extra precision lives entirely in the low word.
    function automatic logic signed [NARROW_WIDTH-1:0] to_wide_high(input real v);
        // Truncate to the coarse 18-bit grid (same as narrow Q2.16).
        return $signed(int'($floor(v * (1 << NFRAC))));
    endfunction

    // Wide low word: residual fractional bits [16:0] of the Q2.33 integer,
    // packed into an 18-bit word with bit[17] forced to 0.
    //
    // Derivation:
    //   full_int  = floor(v * 2^33)          [35-bit signed]
    //   coarse    = floor(v * 2^16)          [18-bit signed — same as to_q216]
    //   residual  = full_int - coarse * 2^17 [always in [0, 2^17) because
    //                                         coarse = floor(v*2^16) so
    //                                         v*2^33 - coarse*2^17 ∈ [0, 2^17)]
    //   low word  = {1'b0, residual[16:0]}
    //
    // The MSB of the low word is permanently 0, making it an unsigned 17-bit
    // magnitude.  This prevents sign-extension errors when the partial products
    // involving the low word are accumulated as positive contributions.
    function automatic logic [NARROW_WIDTH-1:0] to_wide_low(input real v);
        longint full_int;
        longint coarse;
        longint residual;
        full_int = longint'($floor(v * (1.0 * (1 << 16) * (1 << 17))));  // v * 2^33
        coarse   = longint'($floor(v * (1 << NFRAC)));                    // v * 2^16
        residual = full_int - (coarse << 17);
        // residual is guaranteed non-negative; mask to 17 bits and force MSB=0
        return {1'b0, residual[16:0]};
    endfunction

    // =========================================================================
    // Reset
    // =========================================================================
    task automatic do_reset;
        rst=1; kill=0; received=0;
        start_left=0; start_right=0; start_wide=0;
        julia_type=0; magnitude_negation_encoding=4'b0000;
        max_iteration=MAX_ITER;
        julia_c_x=0; julia_c_y=0;
        starting_x_reg_1=0; starting_x_reg_2=0;
        starting_y_reg_1=0; starting_y_reg_2=0;
        repeat(3) @(posedge clk); rst=0; @(posedge clk);
    endtask

    // =========================================================================
    // run_pixel — narrow mode (start_right, single 18-bit coordinate pair)
    // =========================================================================
    task automatic run_pixel(
            input logic signed [NARROW_WIDTH-1:0] px,
            input logic signed [NARROW_WIDTH-1:0] py,
            output int unsigned count);
        int unsigned cyc;

        // reg_2 carries the pixel coordinate; reg_1 unused in single-pixel narrow
        starting_x_reg_2 = px;
        starting_y_reg_2 = py;

        @(negedge clk); start_right=1; @(negedge clk); start_right=0;

        cyc = 0;
        while (!done && cyc <= 1_000_000) begin
            @(posedge clk);
            cyc++;
        end
        count = done ? iteration_out : 0;
        if (!done) $display("NARROW TIMEOUT at (%0d,%0d)", px, py);

        @(negedge clk); received=1; @(negedge clk); received=0; @(posedge clk);
    endtask

    // =========================================================================
    // run_pixel_wide — wide mode (start_wide, 35-bit coordinate pair split
    // across reg_1 [high] and reg_2 [low] for each axis)
    // =========================================================================
    task automatic run_pixel_wide(
            input logic signed [NARROW_WIDTH-1:0] xh,  // x high word (Q2.16, signed)
            input logic  [NARROW_WIDTH-1:0] xl,  // x low word  ({1'b0, 17-bit})
            input logic signed [NARROW_WIDTH-1:0] yh,  // y high word (Q2.16, signed)
            input logic  [NARROW_WIDTH-1:0] yl,  // y low word  ({1'b0, 17-bit})
            output int unsigned count);
        int unsigned cyc;

        // reg_1 → high word, reg_2 → low word for each axis
        starting_x_reg_1 = xh;
        starting_x_reg_2 = xl;
        starting_y_reg_1 = yh;
        starting_y_reg_2 = yl;

        @(negedge clk); start_wide=1; @(negedge clk); start_wide=0;

        cyc = 0;
        while (!done && cyc <= 10_000_000) begin
            @(posedge clk);
            cyc++;
        end
        count = done ? iteration_out : 0;
        if (!done) $display("WIDE TIMEOUT at xh=%0d xl=%0d yh=%0d yl=%0d", xh, xl, yh, yl);

        @(negedge clk); received=1; @(negedge clk); received=0; @(posedge clk);
    endtask

    // =========================================================================
    // Main stimulus
    // =========================================================================
    integer  fd;
    int unsigned pixel_count, iter_result;
    real     cx, cy;

    // narrow temporaries
    logic signed [NARROW_WIDTH-1:0] qx, qy;

    // wide temporaries
    logic signed [NARROW_WIDTH-1:0] wxh, wyh;
    logic        [NARROW_WIDTH-1:0] wxl, wyl;

    initial begin
        do_reset();

        // =====================================================================
        // PASS 1 — Narrow mode render
        // =====================================================================
        $display("=== NARROW MODE RENDER: %0dx%0d, range [%.2f,%.2f] ===",
                 WIDTH, HEIGHT, N_XMIN, N_XMAX);
        // fixed config for all pixels: standard Mandelbrot
        julia_type                  = 1'b0;
        magnitude_negation_encoding = 4'b0000;
        max_iteration               = MAX_ITER;
        julia_c_x                   = to_q216(-0.74);
        julia_c_y                   = to_q216(0);

        


        fd = $fopen("sim/render/frame_narrow.csv", "w");
        if (!fd) begin $display("ERROR: cannot open frame_narrow.csv"); $finish; end
        $fwrite(fd, "px,py,iterations\n");

        pixel_count = 0;
        for (int row = 0; row < HEIGHT; row++) begin
            cy = N_YMIN + (N_YMAX - N_YMIN) * row / (HEIGHT - 1);
            qy = to_q216(cy);
            for (int col = 0; col < WIDTH; col++) begin
                cx = N_XMIN + (N_XMAX - N_XMIN) * col / (WIDTH - 1);
                qx = to_q216(cx);
                run_pixel(qx, qy, iter_result);
                $fwrite(fd, "%0d,%0d,%0d\n", col, row, iter_result);
                pixel_count++;
            end
            if ((row % 32) == 31)
                $display("  [narrow] row %0d / %0d  (%0d pixels)", row+1, HEIGHT, pixel_count);
        end

        $fclose(fd);
        $display("Narrow render complete. %0d pixels → sim/render/frame_narrow.csv\n", pixel_count);

        // =====================================================================
        // PASS 2 — Wide mode render
        //
        // Window: Seahorse Valley at centre (W_CX, W_CY) ± W_HALF.
        // This region requires ~31 bits of fractional precision to resolve
        // the fine spiral detail.  Narrow Q2.16 (16 fractional bits) would
        // produce visible quantisation banding here; wide Q2.33 resolves it.
        // =====================================================================
        //$display("=== WIDE MODE RENDER: %0dx%0d, centre (%.9f, %.9f) ± %.1e ===",
        //         WIDTH, HEIGHT, W_CX, W_CY, W_HALF);

        $display("=== WIDE MODE RENDER: same view as narrow ===");

        // Same fractal variant as narrow pass for a direct precision comparison.
        // julia_c_x/y remain at Q2.16 in both modes — the Julia constant always
        // uses narrow precision, zero-padded.  No change needed from the narrow
        // pass setup; the DUT ignores them here since julia_type=0.
        julia_type                   = 1'b0;
        magnitude_negation_encoding  = 4'b0000;
        max_iteration                = MAX_ITER;
        julia_c_x                    = '0;
        julia_c_y                    = '0;

        fd = $fopen("sim/render/frame_wide.csv", "w");
        if (!fd) begin $display("ERROR: cannot open frame_wide.csv"); $finish; end
        $fwrite(fd, "px,py,iterations\n");

        pixel_count = 0;
        for (int row = 0; row < HEIGHT; row++) begin
            cy = W_YMIN + (W_YMAX - W_YMIN) * row / (HEIGHT - 1);
            wyh = to_wide_high(cy);
            wyl = to_wide_low(cy);
            for (int col = 0; col < WIDTH; col++) begin
                cx = W_XMIN + (W_XMAX - W_XMIN) * col / (WIDTH - 1);
                wxh = to_wide_high(cx);
                wxl = to_wide_low(cx);
                run_pixel_wide(wxh, wxl, wyh, wyl, iter_result);
                $fwrite(fd, "%0d,%0d,%0d\n", col, row, iter_result);
                pixel_count++;
            end
            if ((row % 32) == 31)
                $display("  [wide]   row %0d / %0d  (%0d pixels)", row+1, HEIGHT, pixel_count);
        end

        $fclose(fd);
        $display("Wide render complete. %0d pixels → sim/render/frame_wide.csv", pixel_count);
        $display("Run:  python3 render.py --input sim/render/frame_narrow.csv --output frame_narrow.png");
        $display("      python3 render.py --input sim/render/frame_wide.csv   --output frame_wide.png");
        $finish;
    end

    // =========================================================================
    // Global timeout — two full 512×512 passes back-to-back.
    // Wide mode takes ~2× longer per pixel (6 cycles vs 3 cycles), so budget
    // accordingly: 2 × 512×512 × 800 cycles/pixel × 10 ns ≈ 4.2 s sim time.
    // =========================================================================
    initial begin
        #10_000_000_000;
        $display("==== GLOBAL TIMEOUT ====");
        $finish;
    end

endmodule