module magnitude_comparison_unit #(parameter NARROW_WIDTH = 18, INTEGER_BITS = 2)
(
input wire signed [2*NARROW_WIDTH-1:0] magnitude,
output logic mag_flag
);

always_comb begin
    mag_flag = (|magnitude[2*NARROW_WIDTH-1:2*NARROW_WIDTH-INTEGER_BITS]);
end

endmodule
