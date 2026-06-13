`timescale 1ns/1ps

module tb_wide_single;

    localparam int NARROW_WIDTH          = 18;
    localparam int INTEGER_BITS          = 2;
    localparam int ITERATION_COUNT_WIDTH = 16;
    localparam int LOW                   = 0;

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

    initial begin
        // =====================================================================
        // EDIT THESE VALUES
        // =====================================================================
        julia_type                  = 1'b0;
        magnitude_negation_encoding = 4'b0000;
        max_iteration               = 5'd8;       // limit = 2^6 = 64

        julia_c_x = 18'd0;
        julia_c_y = 18'd0;

        // starting_x_reg_1 = 18'b01_0000_0000_0000_0000;
        // starting_x_reg_2 = 18'b00_0000_0000_0000_0000;  
        // starting_y_reg_1 = 18'b00_0000_0000_0000_0000;
        // starting_y_reg_2 = 18'b00_0000_0000_0000_0000;

        // (-1.7, -0.01)
        //   mandel=10  bship=11
        starting_x_reg_1 = 18'b100100110011001100;  // -111412
        starting_x_reg_2 = 18'b011001100110011010;  // 104858
        starting_y_reg_1 = 18'b111111110101110000;  // -656
        starting_y_reg_2 = 18'b010100011110101110;  // 83886
        // =====================================================================

        rst = 1; kill = 0; received = 0;
        start_left = 0; start_right = 0; start_wide = 0;
        repeat(3) @(posedge clk);
        rst = 0;
        @(posedge clk);

        @(negedge clk); start_wide = 1;
        @(negedge clk); start_wide = 0;

        @(posedge done);
        $display("iteration_out = %0d", iteration_out);

        @(negedge clk); received = 1;
        @(negedge clk); received = 0;

        #100;
        $finish;
    end

    initial begin
        #10_000_000;
        $display("TIMEOUT");
        $finish;
    end

endmodule