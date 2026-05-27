module sum_alter #(parameter NARROW_WIDTH = 18, INTEGER_BITS = 2)
(
input signed [2*NARROW_WIDTH-1:0] sum_x_reg_1,
input signed [2*NARROW_WIDTH-1:0] sum_x_reg_2,
input signed [2*NARROW_WIDTH-1:0] sum_y_reg_1,
input signed [2*NARROW_WIDTH-1:0] sum_y_reg_2,

input [3:0] magnitude_negation_encoding;



output signed [2*NARROW_WIDTH-1:0] changed_sum_x_reg_1,
output signed [2*NARROW_WIDTH-1:0] changed_sum_x_reg_2,
output signed [2*NARROW_WIDTH-1:0] changed_sum_y_reg_1,
output signed [2*NARROW_WIDTH-1:0] changed_sum_y_reg_2,
);
localparam SUM_INT_BITS = 2*INTEGER_BITS;
localparam SUM_FRACTIONAL_BITS = 2*(NARROW_WIDTH-INTEGER_BITS);

//{abs x, abs y, neg x, neg y}

// for x coords first:
always_comb begin
    changed_sum_x_reg_1 = sum_x_reg_1;
    changed_sum_x_reg_2 = sum_x_reg_2;
    changed_sum_y_reg_1 = sum_y_reg_1;
    changed_sum_y_reg_2 = sum_y_reg_2;
    if (magnitude_negation_encoding[3]) begin
        changed_sum_x_reg_1 = (sum_x_reg_1 < 0) ? -sum_x_reg_1 : sum_x_reg_1;
        changed_sum_x_reg_2 = (sum_x_reg_2 < 0) ? -sum_x_reg_2 : sum_x_reg_2;
    end
    if (magnitude_negation_encoding[1]) begin
        changed_sum_x_reg_1 = -changed_sum_x_reg_1;
        changed_sum_x_reg_2 = -changed_sum_x_reg_2;
    end

    if (magnitude_negation_encoding[2]) begin
        changed_sum_y_reg_1 = (sum_y_reg_1 < 0) ? -sum_y_reg_1 : sum_y_reg_1;
        changed_sum_y_reg_2 = (sum_y_reg_2 < 0) ? -sum_y_reg_2 : sum_y_reg_2;
    end
    if (magnitude_negation_encoding[0]) begin
        changed_sum_y_reg_1 = -changed_sum_y_reg_1;
        changed_sum_y_reg_2 = -changed_sum_y_reg_2;
    end
end


endmodule