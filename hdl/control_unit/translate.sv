// translate
//
//   Maps pixel coordinates (a, b) to complex-plane Q2.16 fixed-point values
//   in z_real[17:0] and z_imag[17:0].  Upper bits are sign-extended to DATA_WIDTH.
//

module translate #(
    parameter int DATA_WIDTH = 35,
    parameter int RESOLUTION = 9
) (
    input  logic [DATA_WIDTH-1:0] pan_x,
    input  logic [DATA_WIDTH-1:0] pan_y,
    input  logic [RESOLUTION-1:0] a,
    input  logic [RESOLUTION-1:0] b,
    input  logic [3:0]            zoom,
    input  logic [3:0]            sixteenth,
    output logic [DATA_WIDTH-1:0] z_real,
    output logic [DATA_WIDTH-1:0] z_imag
);
    // Scale factor in Q2.16: step size per pixel for each zoom level.
    // Assumes 2^RESOLUTION pixels span the full window.
    logic [DATA_WIDTH-1:0] scale_factor;

    always_comb begin : zoom_lut
        case (zoom)
            4'd0:    scale_factor = DATA_WIDTH'(32'd512);   // window 4.0
            4'd1:    scale_factor = DATA_WIDTH'(32'd256);   // window 2.0
            4'd2:    scale_factor = DATA_WIDTH'(32'd128);   // window 1.0
            4'd3:    scale_factor = DATA_WIDTH'(32'd64);    // window 0.5
            default: scale_factor = DATA_WIDTH'(32'd512);
        endcase
    end

    // Multiply pixel coord (unsigned) by scale and add/subtract pan.
    // Use a wider intermediate to avoid overflow before truncation.
    logic [2*DATA_WIDTH-1:0] a_prod, b_prod;

    always_comb begin : coordinate_map
        a_prod = DATA_WIDTH'(a) * scale_factor;
        b_prod = DATA_WIDTH'(b) * scale_factor;
        z_real = $signed(pan_x) + $signed(DATA_WIDTH'(a_prod));
        z_imag = $signed(pan_y) - $signed(DATA_WIDTH'(b_prod));
    end

endmodule
