// translate
//
//   Maps pixel coordinates (a, b) to complex-plane fixed-point values
//   (z_real, z_imag) using pan offsets and a zoom scale factor.
//
//   Output format: DATA_WIDTH-bit fixed-point, Q2.(DATA_WIDTH-3).
//   Called from control_unit with DATA_WIDTH=Z_WIDE, RESOLUTION=PIXEL_WIDTH.
//
//   TODO: re-derive scale-factor LUT for the exact Q format used by the cores.
//   TODO: implement signed pan and proper centre offset.

module translate #(
    parameter int DATA_WIDTH = 35,   // output bit width (= Z_WIDE from control_unit)
    parameter int RESOLUTION = 9     // pixel coordinate bit width
) (
    input  logic [DATA_WIDTH-1:0] pan_x,
    input  logic [DATA_WIDTH-1:0] pan_y,
    input  logic [RESOLUTION-1:0] a,
    input  logic [RESOLUTION-1:0] b,
    input  logic [3:0]            zoom,
    output logic [DATA_WIDTH-1:0] z_real,
    output logic [DATA_WIDTH-1:0] z_imag
);
    // Scale factor: window_width / 2^RESOLUTION, stored in the same Q format
    // as the output.  Default zoom=0 → 4-unit wide window.
    logic [DATA_WIDTH-1:0] scale_factor;

    always_comb begin : zoom_lut
        case (zoom)
            4'd0: scale_factor = DATA_WIDTH'(32'h00400000);  // window = 4.0
            4'd1: scale_factor = DATA_WIDTH'(32'h00200000);  // window = 2.0
            4'd2: scale_factor = DATA_WIDTH'(32'h00100000);  // window = 1.0
            4'd3: scale_factor = DATA_WIDTH'(32'h00080000);  // window = 0.5
            default: scale_factor = DATA_WIDTH'(32'h00400000);
        endcase
    end

    // Zero-extend pixel coord to DATA_WIDTH, multiply by scale.
    // Keep 2*DATA_WIDTH bits to avoid overflow; use lower DATA_WIDTH bits.
    logic [2*DATA_WIDTH-1:0] a_prod, b_prod;

    always_comb begin : coordinate_map
        a_prod = DATA_WIDTH'(a) * scale_factor;
        b_prod = DATA_WIDTH'(b) * scale_factor;
        z_real = pan_x + a_prod[DATA_WIDTH-1:0];
        z_imag = pan_y - b_prod[DATA_WIDTH-1:0];
    end

endmodule
