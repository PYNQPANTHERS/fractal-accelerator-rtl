module adder #(parameter NARROW_WIDTH = 18)(
    input logic signed [2*NARROW_WIDTH-1:0] operand_A,
    input logic signed [2*NARROW_WIDTH-1:0] operand_B,
    input logic cin,

    output logic signed [2*NARROW_WIDTH-1:0] result,
    output logic cout
);

always_comb begin
    {cout, result} = operand_A + operand_B + cin;
end

endmodule