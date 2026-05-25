// Accepts: pixel coord of form (a,b) - zoom value - pan
// Outputs: The Z for iterator to calculate with

module translate #(
    parameter int DATA_WIDTH = 32,
    parameter int RESOLUTION = 10  // 2^10 = 1024 pixels
)(
    input  logic [DATA_WIDTH-1:0] pan,
    input  logic [RESOLUTION-1:0] a,
    input  logic [RESOLUTION-1:0] b,
    input  logic [3:0]            zoom,
    output logic [DATA_WIDTH-1:0] z_real,
    output logic [DATA_WIDTH-1:0] z_imag
);

localparam FRAC_BITS = DATA_WIDTH - 2; // Q2.30
logic [DATA_WIDTH-1:0] scale_factor;

// scale_factor = window_width / 1024 in Q2.30
// bits = window_width * 2^FRAC_BITS / 1024 = window_width * 2^20
// this lut can be extended to facilitate higher zoom resolution
always_comb begin : zoom_lut
    case (zoom)
        4'd0: scale_factor = 32'h00400000; // window = 4.0  (2^22)
        4'd1: scale_factor = 32'h00200000; // window = 2.0  (2^21)
        4'd2: scale_factor = 32'h00100000; // window = 1.0  (2^20)
        4'd3: scale_factor = 32'h00080000; // window = 0.5  (2^19)
        default: scale_factor = 32'h00400000;
    endcase
end

logic [DATA_WIDTH+RESOLUTION-1:0]        a_scaled, b_scaled;;
logic signed [DATA_WIDTH+RESOLUTION-1:0] pan_ext, real_sum, imag_sum;

always_comb begin : real_calc
    a_scaled = a * scale_factor;
    pan_ext  = {{RESOLUTION{pan[DATA_WIDTH-1]}}, pan};  // sign-extend pan to scaled width
    real_sum = pan_ext + a_scaled;    
    z_real   = real_sum[DATA_WIDTH-1:0];
end

always_comb begin : imaginary_calc
    b_scaled = b * scale_factor;
    imag_sum = pan_ext - b_scaled;
    z_imag   = imag_sum[DATA_WIDTH-1:0];
end

endmodule