// Streams completed tiles from colour_bram to DDR3 via AXI HP

module bram_to_dram #(
    parameter  int TILE_W        = 16,
    localparam int TILES_PER_AXIS = 256 / TILE_W,
    localparam int TOTAL_TILES    = TILES_PER_AXIS * TILES_PER_AXIS,
    localparam int TILE_IDX_W     = $clog2(TOTAL_TILES),
    localparam int BRAM_ADDR_W    = $clog2(256 * 256 / 8)
)(
    input  logic         clk,
    input  logic         rst,

    input  logic [TOTAL_TILES-1:0] tile_done,
    input  logic                   engine_done,

    // tile_table read (combinational)
    output logic [TILE_IDX_W-1:0] tt_rd_index,
    input  logic                  tt_is_filled,
    input  logic [5:0]            tt_fill_colour,

    // colour_bram Port B
    output logic [BRAM_ADDR_W-1:0] b2d_word_addr,
    output logic                   b2d_rd_en,
    input  logic                   b2d_rd_grant,
    input  logic [63:0]            b2d_rd_data,

    // AXI HP write interface
    output logic [31:0]  axi_wr_addr,
    output logic [63:0]  axi_wr_data,
    output logic         axi_wr_en,
    input  logic         axi_wr_ready,

    // cache valid metadata write
    output logic                  cache_valid_wr_en,
    output logic [TILE_IDX_W-1:0] cache_valid_index,
    output logic                  cache_valid_value,

    input  logic [31:0]  sixteenth_base_addr,

    output logic         sixteenth_complete
);

    localparam int TILE_BITS      = $clog2(TILE_W);
    localparam int PIX_PER_TILE   = TILE_W * TILE_W;
    localparam int WORDS_PER_TILE = PIX_PER_TILE / 8;
    localparam int BRAM_WORDS     = 256 * 256 / 8;
    localparam int WPT_W          = $clog2(WORDS_PER_TILE);     // bits to index word within tile
    localparam int BYTES_PER_TILE = PIX_PER_TILE;               // 1 byte per pixel

    typedef enum logic [1:0] {
        SCAN,
        CHECK_TABLE,
        GENERATE_FILL,
        BURST_PIPE
    } state_t;

    state_t state;

    logic [TOTAL_TILES-1:0] transferred;
    logic [TILE_IDX_W-1:0]  cur_tile;
    logic [WPT_W-1:0]       fill_count;

    logic [WPT_W:0]  rd_count;    // next word index to request (0..WORDS_PER_TILE)
    logic [WPT_W-1:0] rd_addr;    // address of in-flight read
    logic             rd_inflight;
    logic             rd_suppress; // suppress re-assert for 1 cycle after issuing new address

    logic [WPT_W-1:0] wr_count;

    // 2-slot FIFO; slot 0 is the AXI head
    logic [63:0] fifo0, fifo1;
    logic        fifo0_v, fifo1_v;

    logic [TOTAL_TILES-1:0] pending;
    assign pending = tile_done & ~transferred;

    // lowest pending tile via balanced tree (log-depth, Fmax-friendly) instead
    // of a TOTAL_TILES-deep priority chain
    logic [TILE_IDX_W-1:0] next_tile;
    logic                  any_pending;
    lowest_set_tree #(.WIDTH(TOTAL_TILES)) u_next_tile (
        .bits  (pending),
        .any   (any_pending),
        .index (next_tile)
    );

    // count of transferred tiles; replaces the wide (transferred == '1) reduction
    logic [TILE_IDX_W:0] transferred_count;

    assign tt_rd_index        = cur_tile;
    assign sixteenth_complete = (transferred_count == (TILE_IDX_W+1)'(TOTAL_TILES))
                                && engine_done;

    logic [63:0] fill_word;
    always_comb begin
        fill_word = '0;
        for (int i = 0; i < 8; i++)
            fill_word[i*8 +: 8] = {2'b00, tt_fill_colour};
    end

    always_comb begin
        axi_wr_en   = 1'b0;
        axi_wr_addr = '0;
        axi_wr_data = '0;
        case (state)
            GENERATE_FILL: begin
                axi_wr_en   = 1'b1;
                axi_wr_addr = sixteenth_base_addr + (32'(cur_tile) << $clog2(BYTES_PER_TILE)) + {wr_count, 3'b0};
                axi_wr_data = fill_word;
            end
            BURST_PIPE: if (fifo0_v) begin
                axi_wr_en   = 1'b1;
                axi_wr_addr = sixteenth_base_addr + (32'(cur_tile) << $clog2(BYTES_PER_TILE)) + {wr_count, 3'b0};
                axi_wr_data = fifo0;
            end
            default: ;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state             <= SCAN;
            transferred       <= '0;
            transferred_count <= '0;
            cur_tile          <= '0;
            fill_count        <= '0;
            rd_count          <= '0;
            rd_addr           <= '0;
            rd_inflight       <= 1'b0;
            rd_suppress       <= 1'b0;
            wr_count          <= '0;
            fifo0_v           <= 1'b0;
            fifo1_v           <= 1'b0;
            fifo0             <= '0;
            fifo1             <= '0;
            b2d_rd_en         <= 1'b0;
            b2d_word_addr     <= '0;
            cache_valid_wr_en <= 1'b0;
        end else begin
            b2d_rd_en         <= 1'b0;
            cache_valid_wr_en <= 1'b0;

            case (state)

                SCAN: begin
                    fifo0_v     <= 1'b0;
                    fifo1_v     <= 1'b0;
                    rd_inflight <= 1'b0;
                    rd_suppress <= 1'b0;
                    rd_count    <= '0;
                    wr_count    <= '0;
                    fill_count  <= '0;
                    if (any_pending) begin
                        cur_tile <= next_tile;
                        state    <= CHECK_TABLE;
                    end
                end

                CHECK_TABLE: begin
                    if (tt_is_filled)
                        state <= GENERATE_FILL;
                    else begin
                        b2d_rd_en     <= 1'b1;
                        b2d_word_addr <= {cur_tile, {WPT_W{1'b0}}};
                        rd_addr       <= '0;
                        rd_count      <= (WPT_W+1)'(1);
                        rd_inflight   <= 1'b1;
                        rd_suppress   <= 1'b1;
                        state         <= BURST_PIPE;
                    end
                end

                GENERATE_FILL: begin
                    if (axi_wr_ready) begin
                        fill_count <= fill_count + 1'b1;
                        wr_count   <= wr_count + 1'b1;
                        if (fill_count == WPT_W'(WORDS_PER_TILE - 1)) begin
                            transferred[cur_tile] <= 1'b1;
                            transferred_count     <= transferred_count + 1'b1;
                            cache_valid_wr_en     <= 1'b1;
                            cache_valid_index     <= cur_tile;
                            cache_valid_value     <= 1'b0;
                            state                 <= SCAN;
                        end
                    end
                end

                BURST_PIPE: begin
                    if (fifo0_v && axi_wr_ready) begin
                        fifo0   <= fifo1;
                        fifo0_v <= fifo1_v;
                        fifo1   <= '0;
                        fifo1_v <= 1'b0;
                        if (wr_count == WPT_W'(WORDS_PER_TILE - 1)) begin
                            transferred[cur_tile] <= 1'b1;
                            transferred_count     <= transferred_count + 1'b1;
                            cache_valid_wr_en     <= 1'b1;
                            cache_valid_index     <= cur_tile;
                            cache_valid_value     <= 1'b1;
                            state                 <= SCAN;
                        end else
                            wr_count <= wr_count + 1'b1;
                    end

                    if (rd_inflight) begin
                        if (rd_suppress) begin
                            b2d_rd_en     <= 1'b1;
                            b2d_word_addr <= {cur_tile, rd_addr};
                            rd_suppress   <= 1'b0;
                        end else if (b2d_rd_grant) begin
                            if (fifo0_v && axi_wr_ready) begin
                                if (!fifo1_v) begin
                                    fifo0   <= b2d_rd_data;
                                    fifo0_v <= 1'b1;
                                end else begin
                                    fifo1   <= b2d_rd_data;
                                    fifo1_v <= 1'b1;
                                end
                            end else begin
                                if (!fifo0_v) begin
                                    fifo0   <= b2d_rd_data;
                                    fifo0_v <= 1'b1;
                                end else begin
                                    fifo1   <= b2d_rd_data;
                                    fifo1_v <= 1'b1;
                                end
                            end
                            rd_inflight <= 1'b0;

                            if ((rd_count < (WPT_W+1)'(WORDS_PER_TILE))
                                    && !(wr_count == WPT_W'(WORDS_PER_TILE-1) && fifo0_v && axi_wr_ready)
                                    && ((fifo0_v && axi_wr_ready) || !fifo1_v)) begin
                                b2d_rd_en     <= 1'b1;
                                b2d_word_addr <= {cur_tile, rd_count[WPT_W-1:0]};
                                rd_addr       <= rd_count[WPT_W-1:0];
                                rd_count      <= rd_count + 1'b1;
                                rd_inflight   <= 1'b1;
                                rd_suppress   <= 1'b1;
                            end
                        end else begin
                            b2d_rd_en     <= 1'b1;
                            b2d_word_addr <= {cur_tile, rd_addr};
                        end
                    end else if ((rd_count < (WPT_W+1)'(WORDS_PER_TILE))
                            && !fifo1_v
                            && !(wr_count == WPT_W'(WORDS_PER_TILE-1) && fifo0_v && axi_wr_ready)) begin
                        b2d_rd_en     <= 1'b1;
                        b2d_word_addr <= {cur_tile, rd_count[WPT_W-1:0]};
                        rd_addr       <= rd_count[WPT_W-1:0];
                        rd_count      <= rd_count + 1'b1;
                        rd_inflight   <= 1'b1;
                        rd_suppress   <= 1'b1;
                    end

                end

            endcase
        end
    end

endmodule
