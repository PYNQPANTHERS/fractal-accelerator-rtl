//      Inputs : pixel coord (a,b) - zoom value (arbritrary) - pan (x,y)
//      Outputs: The Z for iterator to calculate with
//
//  To Do.
//      - Need to consider the pan width
//      - Need to define zoomeness
//

module translate #(
    parameter int DATA_WIDTH = 32,
    parameter int RESOLUTION = 10  // 2^10 = 1024 pixels
)(
    input  logic [DATA_WIDTH-1:0] pan_x,
    input  logic [DATA_WIDTH-1:0] pan_y,
    input  logic [RESOLUTION-1:0] a,
    input  logic [RESOLUTION-1:0] b,
    input  logic [3:0]            zoom,
    output logic [DATA_WIDTH-1:0] z_real,
    output logic [DATA_WIDTH-1:0] z_imag
);
localparam FRAC_BITS = DATA_WIDTH - 2; // Q2.30
logic [DATA_WIDTH-1:0] scale_factor;

typedef enum logic [1:0] {  
    ONE,
    TWO,
    FOUR
} name;


//  Zoom -> scale_factor = window_width / 1024 in Q2.30
//      - window_width * 2^20 
//      - ^ limits our zoom can increase probably just have this match 128 case or have dynamic with FSM

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
    pan_x_ext  = {{RESOLUTION{pan[DATA_WIDTH-1]}}, pan_x};  // sign-extend pan to scaled width
    real_sum = pan_ext + a_scaled;    
    z_real   = real_sum[DATA_WIDTH-1:0];
end

always_comb begin : imaginary_calc
    b_scaled = b * scale_factor;
    pan_y_ext  = {{RESOLUTION{pan[DATA_WIDTH-1]}}, pan_y};  // sign-extend pan to scaled width
    imag_sum = pan_ext - b_scaled;
    z_imag   = imag_sum[DATA_WIDTH-1:0];
end
endmodule