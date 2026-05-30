module magnitude_comparison_unit #(parameter NARROW_WIDTH = 18, INTEGER_BITS = 2)
(
input wire signed [2*NARROW_WIDTH-1:0] magnitude,
output logic mag_flag
);

localparam TOP = 2*NARROW_WIDTH-1;
localparam BOTTOM = 2*NARROW_WIDTH-INTEGER_BITS;


always_comb begin
    mag_flag = (|magnitude[TOP:BOTTOM]);
end

endmodule
