// Flat 256-entry register file - one entry per 16x16 tile in the sixteenth

module tile_table (
    input  logic        clk,
    input  logic        rst,    // synchronous reset - clears all entries

    // Quad write port (for flood fill decisions - scheduler only)
    input  logic        wr_quad_en,
    input  logic [7:0]  wr_quad_tlx,       // top-left x pixel (0..255)
    input  logic [7:0]  wr_quad_tly,       // top-left y pixel (0..255)
    input  logic [8:0]  wr_quad_size,      // quad size in pixels (16/32/64/128/256); 9-bit to hold 256
    input  logic [5:0]  wr_quad_colour,    // flood fill colour

    // Combinational read port
    input  logic [7:0]  rd_index,          // tile index to read
    output logic        rd_is_filled,      // 1 = flood filled
    output logic [5:0]  rd_fill_colour     // fill colour (valid if is_filled)
);

    // bit[6] = 1 -> flood-filled by scheduler; bits[5:0] = fill colour
    // bit[6] = 0 -> tiled (pixels written individually by control_unit via colour_bram)
    logic [6:0] tile_table [0:255];

    assign rd_is_filled   = tile_table[rd_index][6];
    assign rd_fill_colour = tile_table[rd_index][5:0];

    logic [3:0] tile_col_start, tile_row_start;
    logic [4:0] tile_col_end, tile_row_end;
    logic [4:0] num_cols, num_rows;  

    assign tile_col_start = wr_quad_tlx[7:4];
    assign tile_row_start = wr_quad_tly[7:4];

    assign num_cols       = wr_quad_size[8:4];  // quad_size / 16; 9-bit>>4 gives 1..16
    assign num_rows       = wr_quad_size[8:4];
    assign tile_col_end   = {1'b0, tile_col_start} + num_cols - 1;
    assign tile_row_end   = {1'b0, tile_row_start} + num_rows - 1;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 256; i++)
                tile_table[i] <= 7'b0;
        end else if (wr_quad_en) begin
            for (int row = 0; row < 16; row++) begin
                for (int col = 0; col < 16; col++) begin
                    if (row >= int'(tile_row_start) && 5'(row) <= tile_row_end &&
                        col >= int'(tile_col_start) && 5'(col) <= tile_col_end) begin
                        tile_table[{ 4'(row), 4'(col) }] <= { 1'b1, wr_quad_colour };
                    end
                end
            end
        end
    end

endmodule