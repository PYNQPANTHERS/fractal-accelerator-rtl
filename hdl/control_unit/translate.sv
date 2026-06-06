module translate #(
    parameter int DATA_WIDTH = 35,
    parameter int RESOLUTION = 8
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

    logic [DATA_WIDTH-1:0] scale_factor;

    always_comb begin : zoom_lut
        case (zoom)
            4'd0:    scale_factor = DATA_WIDTH'(32'd512);
            4'd1:    scale_factor = DATA_WIDTH'(32'd256);
            4'd2:    scale_factor = DATA_WIDTH'(32'd128);
            4'd3:    scale_factor = DATA_WIDTH'(32'd64);
            default: scale_factor = DATA_WIDTH'(32'd512);
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