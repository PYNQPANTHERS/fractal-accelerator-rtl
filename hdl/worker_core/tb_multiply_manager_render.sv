// ============================================================================
// tb_multiply_manager_render.sv
//
// Renders a 512x512 Mandelbrot frame by sweeping every pixel coordinate
// through the DUT and collecting iteration counts.
//
// Coordinate range: [-1.5, 1.5] in both real and imaginary axes.
// Output: sim/render/frame.csv  (one row per pixel: x,y,iteration_count)
//
// Run the companion render.py script after simulation to produce frame.png.
// ============================================================================

`timescale 1ns/1ps

module tb_multiply_manager_render;

    localparam int NARROW_WIDTH          = 18;
    localparam int INTEGER_BITS          = 2;
    localparam int ITERATION_COUNT_WIDTH = 16;
    localparam int LOW                   = 0;

    localparam int NFRAC   = NARROW_WIDTH - INTEGER_BITS;  // 16
    localparam int WIDTH   = 512;
    localparam int HEIGHT  = 512;
    localparam real XMIN   = -1.5;
    localparam real XMAX   =  1.5;
    localparam real YMIN   = -1.5;
    localparam real YMAX   =  1.5;

    // max_iteration field: DUT iteration ceiling = 2^(max_iteration + LOW)
    // 5'd9 -> 512 iterations, a good balance of detail vs sim time
    localparam logic [4:0] MAX_ITER = 5'd10;

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

    // ===== Q2.16 conversion =====
    function automatic logic signed [NARROW_WIDTH-1:0] to_q216(input real v);
        return $signed(int'($floor(v * (1 << NFRAC))));
    endfunction

    // ===== reset =====
    task automatic do_reset;
        rst=1; kill=0; received=0;
        start_left=0; start_right=0; start_wide=0;
        julia_type=0; magnitude_negation_encoding=4'b0000;
        max_iteration=MAX_ITER;
        julia_c_x=0; julia_c_y=0;
        starting_x_reg_1=0; starting_x_reg_2=0;
        starting_y_reg_1=0; starting_y_reg_2=0;
        repeat (3) @(posedge clk); rst=0; @(posedge clk);
    endtask

    // ===== run one pixel =====
    task automatic run_pixel(
            input logic signed [NARROW_WIDTH-1:0] px,
            input logic signed [NARROW_WIDTH-1:0] py,
            output int unsigned count);

        int unsigned cyc;

        starting_x_reg_1 = px;
        starting_y_reg_1 = py;

        @(negedge clk); start_left=1; @(negedge clk); start_left=0;

        cyc = 0;
        while (!done && cyc <= 1_000_000) begin
            @(posedge clk);
            cyc++;
        end
        if (done) count = iteration_out;
        else begin
            $display("TIMEOUT at pixel (%0d,%0d)", px, py);
            count = 0;
        end

        @(negedge clk); received=1; @(negedge clk); received=0; @(posedge clk);
    endtask

    // ========================================================================
    integer fd;
    int unsigned pixel_count;
    int unsigned iter_result;
    real cx, cy;
    logic signed [NARROW_WIDTH-1:0] qx, qy;

    initial begin
        do_reset();

        // fixed config for all pixels: standard Mandelbrot
        julia_type                  = 1'b1;
        magnitude_negation_encoding = 4'b0000;
        max_iteration               = MAX_ITER;
        julia_c_x                   = to_q216(-0.74);
        julia_c_y                   = to_q216(-0.16);

        fd = $fopen("sim/render/frame.csv", "w");
        if (!fd) begin
            $display("ERROR: could not open sim/render/frame.csv");
            $finish;
        end
        $fwrite(fd, "px,py,iterations\n");

        $display("Starting render: %0dx%0d pixels, max_iter=2^%0d=%0d",
                 WIDTH, HEIGHT, MAX_ITER+LOW, 1<<(MAX_ITER+LOW));

        pixel_count = 0;
        for (int py = 0; py < HEIGHT; py++) begin
            cy = YMIN + (YMAX - YMIN) * py / (HEIGHT - 1);
            qy = to_q216(cy);
            for (int px = 0; px < WIDTH; px++) begin
                cx = XMIN + (XMAX - XMIN) * px / (WIDTH - 1);
                qx = to_q216(cx);
                run_pixel(qx, qy, iter_result);
                $fwrite(fd, "%0d,%0d,%0d\n", px, py, iter_result);
                pixel_count++;
            end
            // progress every 32 rows
            if ((py % 32) == 31)
                $display("  row %0d / %0d  (%0d pixels done)",
                         py+1, HEIGHT, pixel_count);
        end

        $fclose(fd);
        $display("Render complete. %0d pixels written to sim/render/frame.csv", pixel_count);
        $display("Run:  python3 render.py  to produce frame.png");
        $finish;
    end

    // global timeout: 512x512 * ~600 cycles/pixel * 10ns = ~1.57 s sim time
    initial begin
        #2_000_000_000;
        $display("==== GLOBAL TIMEOUT ====");
        $finish;
    end

endmodule