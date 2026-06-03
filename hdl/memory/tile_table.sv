// Flat 256-entry register file — one entry per 16x16 tile in the sixteenth.
// Stored in flip-flops (not BRAM) — fully combinational read, zero latency.

module tile_table (
    input  logic        clk,
    input  logic        rst,    // synchronous reset — clears all entries

    // Single write port (for tiled leaf nodes)
    input  logic        wr_single_en,
    input  logic [7:0]  wr_single_index,   // tile index 0..255
    input  logic        wr_single_filled,
    input  logic [5:0]  wr_single_colour,

    // Quad write port (for flood fill decisions)
    input  logic        wr_quad_en,
    input  logic [7:0]  wr_quad_tlx,       // top-left x pixel (0..255)
    input  logic [7:0]  wr_quad_tly,       // top-left y pixel (0..255)
    input  logic [7:0]  wr_quad_size,      // quad size in pixels (16/32/64/128/256)
    input  logic [5:0]  wr_quad_colour,    // flood fill colour

    // Combinational read port
    input  logic [7:0]  rd_index,          // tile index to read
    output logic        rd_is_filled,      // 1 = flood filled
    output logic [5:0]  rd_fill_colour     // fill colour (valid if is_filled)
);

    logic [6:0] tile_table [0:255]; // [6] = is_filled, [5:0] = fill_colour

    assign rd_is_filled   = tile_table[rd_index][6];
    assign rd_fill_colour = tile_table[rd_index][5:0];

    logic [3:0] tile_col_start, tile_col_end;
    logic [3:0] tile_row_start, tile_row_end;
    logic [3:0] num_cols, num_rows;

    assign tile_col_start = wr_quad_tlx[7:4];
    assign tile_row_start = wr_quad_tly[7:4];

    assign num_cols       = wr_quad_size[7:4]; // quad_size / 16
    assign num_rows       = wr_quad_size[7:4];
    assign tile_col_end   = tile_col_start + num_cols - 1;
    assign tile_row_end   = tile_row_start + num_rows - 1;

    // Write logic
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 256; i++)
                tile_table[i] <= 7'b0;

        end else if (wr_quad_en) begin
            // Write all tiles within the quad bounds
            for (int row = 0; row < 16; row++) begin
                for (int col = 0; col < 16; col++) begin
                    if (row >= int'(tile_row_start) && row <= int'(tile_row_end) &&
                        col >= int'(tile_col_start) && col <= int'(tile_col_end)) begin
                        tile_table[{ 4'(row), 4'(col) }] <= { 1'b1, wr_quad_colour };
                    end
                end
            end

        end else if (wr_single_en) begin
            tile_table[wr_single_index] <= { wr_single_filled, wr_single_colour };
        end
    end

endmodule