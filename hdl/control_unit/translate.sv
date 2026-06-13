module translate #(
    parameter int DATA_WIDTH = 35,
    parameter int RESOLUTION = 8
) (
    input  logic [DATA_WIDTH-1:0] pan_x,
    input  logic [DATA_WIDTH-1:0] pan_y,
    input  logic [RESOLUTION-1:0] a,
    input  logic [RESOLUTION-1:0] b,
    input  logic [15:0]            zoom,
    input  logic [3:0]            sixteenth,
    output logic [DATA_WIDTH-1:0] z_real,
    output logic [DATA_WIDTH-1:0] z_imag
);

    logic [DATA_WIDTH-1:0] scale_factor;

    always_comb begin : zoom_lut
    case (zoom[6:0])  // 7 bits, 0-99
        // Band 0: 512 -> 256, step 16 (levels 0-16)
        7'd0:  scale_factor = DATA_WIDTH'(32'd512);
        7'd1:  scale_factor = DATA_WIDTH'(32'd496);
        7'd2:  scale_factor = DATA_WIDTH'(32'd480);
        7'd3:  scale_factor = DATA_WIDTH'(32'd464);
        7'd4:  scale_factor = DATA_WIDTH'(32'd448);
        7'd5:  scale_factor = DATA_WIDTH'(32'd432);
        7'd6:  scale_factor = DATA_WIDTH'(32'd416);
        7'd7:  scale_factor = DATA_WIDTH'(32'd400);
        7'd8:  scale_factor = DATA_WIDTH'(32'd384);
        7'd9:  scale_factor = DATA_WIDTH'(32'd368);
        7'd10: scale_factor = DATA_WIDTH'(32'd352);
        7'd11: scale_factor = DATA_WIDTH'(32'd336);
        7'd12: scale_factor = DATA_WIDTH'(32'd320);
        7'd13: scale_factor = DATA_WIDTH'(32'd304);
        7'd14: scale_factor = DATA_WIDTH'(32'd288);
        7'd15: scale_factor = DATA_WIDTH'(32'd272);
        7'd16: scale_factor = DATA_WIDTH'(32'd256);

        // Band 1: 256 -> 128, step 8 (levels 17-33)
        7'd17: scale_factor = DATA_WIDTH'(32'd248);
        7'd18: scale_factor = DATA_WIDTH'(32'd240);
        7'd19: scale_factor = DATA_WIDTH'(32'd232);
        7'd20: scale_factor = DATA_WIDTH'(32'd224);
        7'd21: scale_factor = DATA_WIDTH'(32'd216);
        7'd22: scale_factor = DATA_WIDTH'(32'd208);
        7'd23: scale_factor = DATA_WIDTH'(32'd200);
        7'd24: scale_factor = DATA_WIDTH'(32'd192);
        7'd25: scale_factor = DATA_WIDTH'(32'd184);
        7'd26: scale_factor = DATA_WIDTH'(32'd176);
        7'd27: scale_factor = DATA_WIDTH'(32'd168);
        7'd28: scale_factor = DATA_WIDTH'(32'd160);
        7'd29: scale_factor = DATA_WIDTH'(32'd152);
        7'd30: scale_factor = DATA_WIDTH'(32'd144);
        7'd31: scale_factor = DATA_WIDTH'(32'd136);
        7'd32: scale_factor = DATA_WIDTH'(32'd128);  // Note: 7'd33 skipped, 128 shared with band end

        // Band 2: 128 -> 64, step 4 (levels 33-49)
        7'd33: scale_factor = DATA_WIDTH'(32'd124);
        7'd34: scale_factor = DATA_WIDTH'(32'd120);
        7'd35: scale_factor = DATA_WIDTH'(32'd116);
        7'd36: scale_factor = DATA_WIDTH'(32'd112);
        7'd37: scale_factor = DATA_WIDTH'(32'd108);
        7'd38: scale_factor = DATA_WIDTH'(32'd104);
        7'd39: scale_factor = DATA_WIDTH'(32'd100);
        7'd40: scale_factor = DATA_WIDTH'(32'd96);
        7'd41: scale_factor = DATA_WIDTH'(32'd92);
        7'd42: scale_factor = DATA_WIDTH'(32'd88);
        7'd43: scale_factor = DATA_WIDTH'(32'd84);
        7'd44: scale_factor = DATA_WIDTH'(32'd80);
        7'd45: scale_factor = DATA_WIDTH'(32'd76);
        7'd46: scale_factor = DATA_WIDTH'(32'd72);
        7'd47: scale_factor = DATA_WIDTH'(32'd68);
        7'd48: scale_factor = DATA_WIDTH'(32'd64);

        // Band 3: 64 -> 32, step 2 (levels 49-65)
        7'd49: scale_factor = DATA_WIDTH'(32'd62);
        7'd50: scale_factor = DATA_WIDTH'(32'd60);
        7'd51: scale_factor = DATA_WIDTH'(32'd58);
        7'd52: scale_factor = DATA_WIDTH'(32'd56);
        7'd53: scale_factor = DATA_WIDTH'(32'd54);
        7'd54: scale_factor = DATA_WIDTH'(32'd52);
        7'd55: scale_factor = DATA_WIDTH'(32'd50);
        7'd56: scale_factor = DATA_WIDTH'(32'd48);
        7'd57: scale_factor = DATA_WIDTH'(32'd46);
        7'd58: scale_factor = DATA_WIDTH'(32'd44);
        7'd59: scale_factor = DATA_WIDTH'(32'd42);
        7'd60: scale_factor = DATA_WIDTH'(32'd40);
        7'd61: scale_factor = DATA_WIDTH'(32'd38);
        7'd62: scale_factor = DATA_WIDTH'(32'd36);
        7'd63: scale_factor = DATA_WIDTH'(32'd34);
        7'd64: scale_factor = DATA_WIDTH'(32'd32);

        // Band 4: 32 -> 1, step 1 (levels 65-96)
        7'd65: scale_factor = DATA_WIDTH'(32'd31);
        7'd66: scale_factor = DATA_WIDTH'(32'd30);
        7'd67: scale_factor = DATA_WIDTH'(32'd29);
        7'd68: scale_factor = DATA_WIDTH'(32'd28);
        7'd69: scale_factor = DATA_WIDTH'(32'd27);
        7'd70: scale_factor = DATA_WIDTH'(32'd26);
        7'd71: scale_factor = DATA_WIDTH'(32'd25);
        7'd72: scale_factor = DATA_WIDTH'(32'd24);
        7'd73: scale_factor = DATA_WIDTH'(32'd23);
        7'd74: scale_factor = DATA_WIDTH'(32'd22);
        7'd75: scale_factor = DATA_WIDTH'(32'd21);
        7'd76: scale_factor = DATA_WIDTH'(32'd20);
        7'd77: scale_factor = DATA_WIDTH'(32'd19);
        7'd78: scale_factor = DATA_WIDTH'(32'd18);
        7'd79: scale_factor = DATA_WIDTH'(32'd17);
        7'd80: scale_factor = DATA_WIDTH'(32'd16);
        7'd81: scale_factor = DATA_WIDTH'(32'd15);
        7'd82: scale_factor = DATA_WIDTH'(32'd14);
        7'd83: scale_factor = DATA_WIDTH'(32'd13);
        7'd84: scale_factor = DATA_WIDTH'(32'd12);
        7'd85: scale_factor = DATA_WIDTH'(32'd11);
        7'd86: scale_factor = DATA_WIDTH'(32'd10);
        7'd87: scale_factor = DATA_WIDTH'(32'd9);
        7'd88: scale_factor = DATA_WIDTH'(32'd8);
        7'd89: scale_factor = DATA_WIDTH'(32'd7);
        7'd90: scale_factor = DATA_WIDTH'(32'd6);
        7'd91: scale_factor = DATA_WIDTH'(32'd5);
        7'd92: scale_factor = DATA_WIDTH'(32'd4);
        7'd93: scale_factor = DATA_WIDTH'(32'd3);
        7'd94: scale_factor = DATA_WIDTH'(32'd2);
        7'd95: scale_factor = DATA_WIDTH'(32'd1);

        default: scale_factor = DATA_WIDTH'(32'd1); // clamp anything > 95 to min
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

        x_prod = px * scale_factor;     // uniform step everywhere
        y_prod = py * scale_factor;

        z_real = $signed(pan_x) + $signed(DATA_WIDTH'(x_prod));
        z_imag = $signed(pan_y) - $signed(DATA_WIDTH'(y_prod));
    end
endmodule