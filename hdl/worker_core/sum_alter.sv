module sum_alter #(parameter NARROW_WIDTH = 18, INTEGER_BITS = 2)
(
input signed [2*NARROW_WIDTH-1:0] sum_x_reg_1,
input signed [2*NARROW_WIDTH-1:0] sum_x_reg_2,
input signed [2*NARROW_WIDTH-1:0] sum_y_reg_1,
input signed [2*NARROW_WIDTH-1:0] sum_y_reg_2,

input [3:0] magnitude_negation_encoding,



output logic signed [2*NARROW_WIDTH-1:0] changed_sum_x_reg_1,
output logic signed [2*NARROW_WIDTH-1:0] changed_sum_x_reg_2,
output logic signed [2*NARROW_WIDTH-1:0] changed_sum_y_reg_1,
output logic signed [2*NARROW_WIDTH-1:0] changed_sum_y_reg_2
);
localparam SUM_INT_BITS = 2*INTEGER_BITS;
localparam SUM_FRACTIONAL_BITS = 2*(NARROW_WIDTH-INTEGER_BITS);


wire abs_x  = magnitude_negation_encoding[3];
wire neg_x  = magnitude_negation_encoding[1];
wire abs_y  = magnitude_negation_encoding[2];
wire neg_y  = magnitude_negation_encoding[0];


//{abs x, abs y, neg x, neg y}

// for x coords first:
always_comb begin
    changed_sum_x_reg_1 = sum_x_reg_1;
    changed_sum_x_reg_2 = sum_x_reg_2;
    changed_sum_y_reg_1 = sum_y_reg_1;
    changed_sum_y_reg_2 = sum_y_reg_2;
    if (abs_x) begin
        changed_sum_x_reg_1 = (sum_x_reg_1 < 0) ? -sum_x_reg_1 : sum_x_reg_1;
        changed_sum_x_reg_2 = (sum_x_reg_2 < 0) ? -sum_x_reg_2 : sum_x_reg_2;
    end
    if (neg_x) begin
        changed_sum_x_reg_1 = -changed_sum_x_reg_1;
        changed_sum_x_reg_2 = -changed_sum_x_reg_2;
    end

    if (abs_y) begin
        changed_sum_y_reg_1 = (sum_y_reg_1 < 0) ? -sum_y_reg_1 : sum_y_reg_1;
        changed_sum_y_reg_2 = (sum_y_reg_2 < 0) ? -sum_y_reg_2 : sum_y_reg_2;
    end
    if (neg_y) begin
        changed_sum_y_reg_1 = -changed_sum_y_reg_1;
        changed_sum_y_reg_2 = -changed_sum_y_reg_2;
    end
end


endmodule