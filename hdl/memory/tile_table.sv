// Flat register file - one entry per TILE_W x TILE_W tile in the sixteenth

module tile_table #(
    parameter int TILE_W = 16   // tile width/height in pixels (must be power of 2)
)(
    input  logic        clk,
    input  logic        rst,    // synchronous reset - clears all entries

    // Quad write port (for flood fill decisions - scheduler only)
    input  logic        wr_quad_en,
    input  logic [7:0]  wr_quad_tlx,       // top-left x pixel (0..255)
    input  logic [7:0]  wr_quad_tly,       // top-left y pixel (0..255)
    input  logic [8:0]  wr_quad_size,      // quad size in pixels; 9-bit to hold 256
    input  logic [5:0]  wr_quad_colour,    // flood fill colour

    // Combinational read port
    input  logic [TILE_IDX_W-1:0] rd_index,      // tile index to read
    output logic                  rd_is_filled,  // 1 = flood filled
    output logic [5:0]            rd_fill_colour // fill colour (valid if is_filled)
);

    localparam int TILE_BITS      = $clog2(TILE_W);
    localparam int TILES_PER_AXIS = 256 / TILE_W;
    localparam int TOTAL_TILES    = TILES_PER_AXIS * TILES_PER_AXIS;
    localparam int TILE_IDX_W     = $clog2(TOTAL_TILES);
    localparam int AXIS_BITS      = $clog2(TILES_PER_AXIS);  // bits for tile col/row index

    // bit[6] = 1 -> flood-filled by scheduler; bits[5:0] = fill colour
    logic [6:0] tile_table [0:TOTAL_TILES-1];

    assign rd_is_filled   = tile_table[rd_index][6];
    assign rd_fill_colour = tile_table[rd_index][5:0];

    logic [AXIS_BITS-1:0] tile_col_start, tile_row_start;
    logic [AXIS_BITS:0]   tile_col_end,   tile_row_end;
    logic [AXIS_BITS:0]   num_cols,       num_rows;

    assign tile_col_start = wr_quad_tlx[7:TILE_BITS];
    assign tile_row_start = wr_quad_tly[7:TILE_BITS];

    // wr_quad_size / TILE_W = wr_quad_size >> TILE_BITS; 9-bit input
    assign num_cols     = AXIS_BITS'(1) + wr_quad_size[8:TILE_BITS] - 1; // = wr_quad_size >> TILE_BITS
    assign num_rows     = num_cols;
    assign tile_col_end = {1'b0, tile_col_start} + num_cols - 1;
    assign tile_row_end = {1'b0, tile_row_start} + num_rows - 1;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < TOTAL_TILES; i++)
                tile_table[i] <= 7'b0;
        end else if (wr_quad_en) begin
            for (int row = 0; row < TILES_PER_AXIS; row++) begin
                for (int col = 0; col < TILES_PER_AXIS; col++) begin
                    if (row >= int'(tile_row_start) && (AXIS_BITS+1)'(row) <= tile_row_end &&
                        col >= int'(tile_col_start) && (AXIS_BITS+1)'(col) <= tile_col_end) begin
                        tile_table[{ AXIS_BITS'(row), AXIS_BITS'(col) }] <= { 1'b1, wr_quad_colour };
                    end
                end
            end
        end
    end

endmodule
