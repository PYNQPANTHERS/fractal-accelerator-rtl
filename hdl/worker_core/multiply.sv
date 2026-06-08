module multiply #(parameter NARROW_WIDTH = 18)(
    input  signed [NARROW_WIDTH-1:0]   x,
    input  signed [NARROW_WIDTH-1:0]   y,
    input  [1:0]                       mode,

    input                              is_wide,

    output logic signed [2*NARROW_WIDTH-1:0] result
);

always_comb begin

    if (is_wide) begin
        case (mode)
            2'b00:   result = x * x;
            2'b01:   result = y * y;
            2'b10:   result = (x * y) <<< 1;  // arithmetic left shift = *2
            2'b11:   result = x * y; // cross product, no shift
            default: result = '0;
        endcase
        
    end else begin
        case (mode)
            2'b00:   result = x * x;
            2'b01:   result = y * y;
            2'b10:   result = (x * y) <<< 1;  // arithmetic left shift = *2
            default: result = '0;
        endcase
    end
    
end

endmodule