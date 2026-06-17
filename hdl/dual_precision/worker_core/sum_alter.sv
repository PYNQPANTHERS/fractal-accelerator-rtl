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


wire abs_x  = magnitude_negation_encoding[3];
wire neg_x  = magnitude_negation_encoding[1];
wire abs_y  = magnitude_negation_encoding[2];
wire neg_y  = magnitude_negation_encoding[0];


logic flip_x_1;
logic flip_x_2;
logic flip_y_1;
logic flip_y_2; 

logic flip_wide_x;
logic flip_wide_y;


logic signed [2*NARROW_WIDTH-1:0] flipped_x_1;
logic signed [2*NARROW_WIDTH-1:0] flipped_x_2;
logic signed [2*NARROW_WIDTH-1:0] flipped_y_1;
logic signed [2*NARROW_WIDTH-1:0] flipped_y_2;

logic x_1_carry;
logic y_1_carry;

always_comb begin

    flip_x_1 = neg_x^(sum_x_reg_1[2*NARROW_WIDTH-1] && abs_x);
    flip_x_2 = neg_x^(sum_x_reg_2[2*NARROW_WIDTH-1] && abs_x);
    flip_y_1 = neg_y^(sum_y_reg_1[2*NARROW_WIDTH-1] && abs_y);
    flip_y_2 = neg_y^(sum_y_reg_2[2*NARROW_WIDTH-1] && abs_y); 


    flip_wide_x = flip_x_1 && is_wide;
    flip_wide_y = flip_y_1 && is_wide;

    x_1_carry = !is_wide || (sum_x_reg_2 == '0);
    y_1_carry = !is_wide || (sum_y_reg_2 == '0);
    
    flipped_x_1 = ~sum_x_reg_1 + x_1_carry;
    flipped_x_2 = ~sum_x_reg_2 + 1;
    flipped_y_1 = ~sum_y_reg_1 + y_1_carry;
    flipped_y_2 = ~sum_y_reg_2 + 1;


    if(is_wide) begin
        {changed_sum_x_reg_1, changed_sum_x_reg_2} = flip_wide_x ? {flipped_x_1,flipped_x_2} : {sum_x_reg_1,sum_x_reg_2};
        {changed_sum_y_reg_1, changed_sum_y_reg_2} = flip_wide_y ? {flipped_y_1,flipped_y_2} : {sum_y_reg_1,sum_y_reg_2};    
    end
    else begin
        changed_sum_x_reg_1 = flip_x_1 ? flipped_x_1 : sum_x_reg_1;
        changed_sum_x_reg_2 = flip_x_2 ? flipped_x_2 : sum_x_reg_2;
        changed_sum_y_reg_1 = flip_y_1 ? flipped_y_1 : sum_y_reg_1;
        changed_sum_y_reg_2 = flip_y_2 ? flipped_y_2 : sum_y_reg_2;
    end
end
endmodule