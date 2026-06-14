module translate #(
    parameter int DATA_WIDTH = 35,
    parameter int RESOLUTION = 8
) (
    input  logic                  clk,
    input  logic [DATA_WIDTH-1:0] pan_x,
    input  logic [DATA_WIDTH-1:0] pan_y,
    input  logic [RESOLUTION-1:0] a,
    input  logic [RESOLUTION-1:0] b,
    input  logic [15:0]            zoom,
    input  logic [3:0]            sixteenth,
    output logic [DATA_WIDTH-1:0] z_real,
    output logic [DATA_WIDTH-1:0] z_imag
);

    logic [DATA_WIDTH-1:0] scale_factor;     // combinational LUT output
    logic [DATA_WIDTH-1:0] scale_factor_q;   // registered: removes the 80-way LUT
                                             // mux from the multiply's critical
                                             // path. zoom is per-frame config so
                                             // the 1-cycle delay is harmless.

    always_ff @(posedge clk) scale_factor_q <= scale_factor;

// Each raw step value is multiplied by 2^17 so that x_prod = px * scale_factor
// places the Q2.16 coordinate in z_real[34:17] (the top 18 bits), matching the
// narrow-mode bit-select in job_datapath.
always_comb begin : zoom_lut
    case (zoom[6:0])  // 7 bits, 0-79
        // Band 0: 256 -> 128, step 8 (levels 0-16)
        7'd0:  scale_factor = DATA_WIDTH'(32'd33554432);
        7'd1:  scale_factor = DATA_WIDTH'(32'd32505856);
        7'd2:  scale_factor = DATA_WIDTH'(32'd31457280);
        7'd3:  scale_factor = DATA_WIDTH'(32'd30408704);
        7'd4:  scale_factor = DATA_WIDTH'(32'd29360128);
        7'd5:  scale_factor = DATA_WIDTH'(32'd28311552);
        7'd6:  scale_factor = DATA_WIDTH'(32'd27262976);
        7'd7:  scale_factor = DATA_WIDTH'(32'd26214400);
        7'd8:  scale_factor = DATA_WIDTH'(32'd25165824);
        7'd9:  scale_factor = DATA_WIDTH'(32'd24117248);
        7'd10: scale_factor = DATA_WIDTH'(32'd23068672);
        7'd11: scale_factor = DATA_WIDTH'(32'd22020096);
        7'd12: scale_factor = DATA_WIDTH'(32'd20971520);
        7'd13: scale_factor = DATA_WIDTH'(32'd19922944);
        7'd14: scale_factor = DATA_WIDTH'(32'd18874368);
        7'd15: scale_factor = DATA_WIDTH'(32'd17825792);
        7'd16: scale_factor = DATA_WIDTH'(32'd16777216);

        // Band 1: 128 -> 64, step 4 (levels 17-32)
        7'd17: scale_factor = DATA_WIDTH'(32'd16252928);
        7'd18: scale_factor = DATA_WIDTH'(32'd15728640);
        7'd19: scale_factor = DATA_WIDTH'(32'd15204352);
        7'd20: scale_factor = DATA_WIDTH'(32'd14680064);
        7'd21: scale_factor = DATA_WIDTH'(32'd14155776);
        7'd22: scale_factor = DATA_WIDTH'(32'd13631488);
        7'd23: scale_factor = DATA_WIDTH'(32'd13107200);
        7'd24: scale_factor = DATA_WIDTH'(32'd12582912);
        7'd25: scale_factor = DATA_WIDTH'(32'd12058624);
        7'd26: scale_factor = DATA_WIDTH'(32'd11534336);
        7'd27: scale_factor = DATA_WIDTH'(32'd11010048);
        7'd28: scale_factor = DATA_WIDTH'(32'd10485760);
        7'd29: scale_factor = DATA_WIDTH'(32'd9961472);
        7'd30: scale_factor = DATA_WIDTH'(32'd9437184);
        7'd31: scale_factor = DATA_WIDTH'(32'd8912896);
        7'd32: scale_factor = DATA_WIDTH'(32'd8388608);

        // Band 2: 64 -> 32, step 2 (levels 33-48)
        7'd33: scale_factor = DATA_WIDTH'(32'd8126464);
        7'd34: scale_factor = DATA_WIDTH'(32'd7864320);
        7'd35: scale_factor = DATA_WIDTH'(32'd7602176);
        7'd36: scale_factor = DATA_WIDTH'(32'd7340032);
        7'd37: scale_factor = DATA_WIDTH'(32'd7077888);
        7'd38: scale_factor = DATA_WIDTH'(32'd6815744);
        7'd39: scale_factor = DATA_WIDTH'(32'd6553600);
        7'd40: scale_factor = DATA_WIDTH'(32'd6291456);
        7'd41: scale_factor = DATA_WIDTH'(32'd6029312);
        7'd42: scale_factor = DATA_WIDTH'(32'd5767168);
        7'd43: scale_factor = DATA_WIDTH'(32'd5505024);
        7'd44: scale_factor = DATA_WIDTH'(32'd5242880);
        7'd45: scale_factor = DATA_WIDTH'(32'd4980736);
        7'd46: scale_factor = DATA_WIDTH'(32'd4718592);
        7'd47: scale_factor = DATA_WIDTH'(32'd4456448);
        7'd48: scale_factor = DATA_WIDTH'(32'd4194304);

        // Band 3: 32 -> 1, step 1 (levels 49-79)
        7'd49: scale_factor = DATA_WIDTH'(32'd4063232);
        7'd50: scale_factor = DATA_WIDTH'(32'd3932160);
        7'd51: scale_factor = DATA_WIDTH'(32'd3801088);
        7'd52: scale_factor = DATA_WIDTH'(32'd3670016);
        7'd53: scale_factor = DATA_WIDTH'(32'd3538944);
        7'd54: scale_factor = DATA_WIDTH'(32'd3407872);
        7'd55: scale_factor = DATA_WIDTH'(32'd3276800);
        7'd56: scale_factor = DATA_WIDTH'(32'd3145728);
        7'd57: scale_factor = DATA_WIDTH'(32'd3014656);
        7'd58: scale_factor = DATA_WIDTH'(32'd2883584);
        7'd59: scale_factor = DATA_WIDTH'(32'd2752512);
        7'd60: scale_factor = DATA_WIDTH'(32'd2621440);
        7'd61: scale_factor = DATA_WIDTH'(32'd2490368);
        7'd62: scale_factor = DATA_WIDTH'(32'd2359296);
        7'd63: scale_factor = DATA_WIDTH'(32'd2228224);
        7'd64: scale_factor = DATA_WIDTH'(32'd2097152);
        7'd65: scale_factor = DATA_WIDTH'(32'd1966080);
        7'd66: scale_factor = DATA_WIDTH'(32'd1835008);
        7'd67: scale_factor = DATA_WIDTH'(32'd1703936);
        7'd68: scale_factor = DATA_WIDTH'(32'd1572864);
        7'd69: scale_factor = DATA_WIDTH'(32'd1441792);
        7'd70: scale_factor = DATA_WIDTH'(32'd1310720);
        7'd71: scale_factor = DATA_WIDTH'(32'd1179648);
        7'd72: scale_factor = DATA_WIDTH'(32'd1048576);
        7'd73: scale_factor = DATA_WIDTH'(32'd917504);
        7'd74: scale_factor = DATA_WIDTH'(32'd786432);
        7'd75: scale_factor = DATA_WIDTH'(32'd655360);
        7'd76: scale_factor = DATA_WIDTH'(32'd524288);
        7'd77: scale_factor = DATA_WIDTH'(32'd393216);
        7'd78: scale_factor = DATA_WIDTH'(32'd262144);
        7'd79: scale_factor = DATA_WIDTH'(32'd131072);

        default: scale_factor = DATA_WIDTH'(32'd131072); // clamp anything > 79 to min
    endcase
end
    // Tile select within a 4x4 grid, book-reading order.
    logic [1:0] tile_col, tile_row;
    assign tile_col = sixteenth[1:0];   // X column
    assign tile_row = sixteenth[3:2];   // Y row = floor(sixteenth/4)

    // Global pixel coord = tile offset (256 px per tile) + within-tile pixel.
    logic [DATA_WIDTH-1:0]   px, py;
    logic [2*DATA_WIDTH-1:0] x_prod, y_prod;

    always_comb begin : coordinate_map
        px = (DATA_WIDTH'(tile_col) << RESOLUTION) + DATA_WIDTH'(a);   // 0..1023
        py = (DATA_WIDTH'(tile_row) << RESOLUTION) + DATA_WIDTH'(b);

        x_prod = px * scale_factor_q;   // uniform step everywhere
        y_prod = py * scale_factor_q;

        z_real = $signed(pan_x) + $signed(DATA_WIDTH'(x_prod));
        z_imag = $signed(pan_y) - $signed(DATA_WIDTH'(y_prod));
    end
endmodule