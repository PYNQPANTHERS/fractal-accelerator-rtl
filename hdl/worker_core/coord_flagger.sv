
// if the magnitude of the x or y coordinate of z is greater than 2 after addition, we cnanot represent this in the multiplication or in the temp register
// we also know if this is the case then z has escaped anyway.
// so this module flags if this is the case - so that the thread enters the done state before doing any incorrect multiplication with incorrectly truncated values

module coord_flagger #(parameter NARROW_WIDTH = 18, NARROW_FRACTIONAL_BITS = 16, INTEGER_BITS = 2) // currently checks if |coord| > 2
(
    input signed [2*NARROW_WIDTH-1:0] coordinate,
    input logic is_wide,
    output logic flag

);

    localparam TOP = NARROW_WIDTH*2-1;
    localparam BOTTOM = NARROW_WIDTH*2-1-INTEGER_BITS;


always_comb begin
    if (1'b0) begin
        flag = 0;
    end else begin
        if(coordinate[TOP:BOTTOM] == {(INTEGER_BITS+1){1'b0}}) flag = 0;
        else if(coordinate[TOP:BOTTOM] == {(INTEGER_BITS+1){1'b1}}) flag = 0;
        else flag = 1;
    end
end


endmodule