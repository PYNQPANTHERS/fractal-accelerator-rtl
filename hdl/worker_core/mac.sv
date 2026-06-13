module mac #(parameter NARROW_WIDTH = 18)(
    input clk,
    input  signed [NARROW_WIDTH-1:0]     operand_A,
    input  signed [NARROW_WIDTH-1:0]     operand_B,
    input  signed [2*NARROW_WIDTH-1:0]   add_operand,
    input  logic                         sub,
    input  [1:0]                         mode,
    output logic signed [2*NARROW_WIDTH-1:0] result
);

logic signed [NARROW_WIDTH-1:0]     mul_a, mul_b;
logic signed [2*NARROW_WIDTH-1:0]   product;
(* use_dsp = "yes" *) logic signed [2*NARROW_WIDTH-1:0] tmp_result;

always_comb begin
    case (mode)
        2'b00:   begin mul_a = operand_A; mul_b = operand_A; end
        2'b01:   begin mul_a = operand_B; mul_b = operand_B; end
        2'b10:   begin mul_a = operand_A; mul_b = operand_B; end
        default: begin mul_a = operand_A; mul_b = operand_B; end
    endcase
    product    = mul_a * mul_b;
    tmp_result = sub ? add_operand - product : add_operand + product;
end


always_ff @(posedge clk) begin
    
    result <= tmp_result;
    // $display("-----------------------mac top---------------");
    // $display("multiply_op_1 = %18b (raw int)", ((operand_A)));
    // $display("multiply_op_2 = %18b (raw int)", ((operand_B)));
    // $display("mac code = %2d " ,(mode));
    
    // $display("mac add input = %36b (raw int)", ((add_operand)));
    // $display("tmp_result = %36b (raw int)", ((tmp_result)));
    // $display("-----------------------mac bottom--------------");

end
endmodule