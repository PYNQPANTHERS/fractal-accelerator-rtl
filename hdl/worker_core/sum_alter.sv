module sum_alter #(parameter NARROW_WIDTH = 18, INTEGER_BITS = 2)
(
input signed [2*NARROW_WIDTH-1:0] sum_x_reg_1,
input signed [2*NARROW_WIDTH-1:0] sum_x_reg_2,
input signed [2*NARROW_WIDTH-1:0] sum_y_reg_1,
input signed [2*NARROW_WIDTH-1:0] sum_y_reg_2,

input [3:0] magnitude_negation_encoding,

input logic is_wide,

output logic signed [2*NARROW_WIDTH-1:0] changed_sum_x_reg_1,
output logic signed [2*NARROW_WIDTH-1:0] changed_sum_x_reg_2,
output logic signed [2*NARROW_WIDTH-1:0] changed_sum_y_reg_1,
output logic signed [2*NARROW_WIDTH-1:0] changed_sum_y_reg_2
);
localparam SUM_INT_BITS = 2*INTEGER_BITS;
localparam SUM_FRACTIONAL_BITS = 2*(NARROW_WIDTH-INTEGER_BITS);

logic [4*NARROW_WIDTH-1:0] wide_x;
logic [4*NARROW_WIDTH-1:0] wide_y;

logic [4*NARROW_WIDTH-1:0] changed_wide_x;
logic [4*NARROW_WIDTH-1:0] changed_wide_y;

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

    wide_x = $signed({sum_x_reg_1, sum_x_reg_2});
    wide_y = $signed({sum_y_reg_1, sum_y_reg_2});
    changed_wide_x = wide_x;
    changed_wide_y = wide_y;

    if (is_wide) begin
        if (abs_x) begin
            changed_wide_x = wide_x[4*NARROW_WIDTH-1] ? -wide_x : wide_x;
        end
        if (neg_x) begin
            changed_wide_x = -changed_wide_x;
        end

        if (abs_y) begin
            changed_wide_y = wide_y[4*NARROW_WIDTH-1] ? -wide_y : wide_y;
        end
        if (neg_y) begin
            changed_wide_y = -changed_wide_y;
        end

        {changed_sum_x_reg_1, changed_sum_x_reg_2} = changed_wide_x;
        {changed_sum_y_reg_1, changed_sum_y_reg_2} = changed_wide_y;

    end else begin    
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
end


endmodule