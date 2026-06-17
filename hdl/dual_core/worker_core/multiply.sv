module multiply #(parameter NARROW_WIDTH = 18)(
    input clk,
    input  signed [NARROW_WIDTH-1:0]   operand_A,
    input  signed [NARROW_WIDTH-1:0]   operand_B,
    input  [1:0]                       mode,


    output logic signed [2*NARROW_WIDTH-1:0] result
);

logic signed [NARROW_WIDTH-1:0]   mul_a, mul_b;

always_comb begin
    case (mode)
        2'b00:   begin mul_a = operand_A; mul_b = operand_A; end
        2'b01:   begin mul_a = operand_B; mul_b = operand_B; end
        2'b10:   begin mul_a = operand_A; mul_b = operand_B; end
        default: begin mul_a = operand_A; mul_b = operand_B; end
    endcase
end


always_ff @(posedge clk) begin
    result <= mul_a * mul_b;
end
endmodule