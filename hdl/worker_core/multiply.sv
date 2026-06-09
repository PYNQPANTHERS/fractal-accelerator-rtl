module multiply #(parameter NARROW_WIDTH = 18)(
    input clk,
    input  signed [NARROW_WIDTH-1:0]   x,
    input  signed [NARROW_WIDTH-1:0]   y,
    input  [1:0]                       mode,

    input                              is_wide,

    output logic signed [2*NARROW_WIDTH-1:0] result
);

logic signed [2*NARROW_WIDTH-1:0] combinational_result;

always_comb begin
    case (mode)
        2'b00:   combinational_result = x * x;
        2'b01:   combinational_result = y * y;
        2'b10:   combinational_result = (x * y) <<< 1;  // arithmetic left shift = *2
        2'b11:   combinational_result = x * y;
        default: combinational_result = '0;
    endcase
end

always_ff @(posedge clk) begin
    result <= combinational_result;
end
endmodule