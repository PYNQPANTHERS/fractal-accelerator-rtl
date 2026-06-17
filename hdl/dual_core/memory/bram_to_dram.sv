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

    logic [WPT_W-1:0] wr_count;

    // Single word buffer: read one word from BRAM, then write it to AXI.
    // Simple sequential pipeline: BRAM_REQ -> BRAM_WAIT -> AXI_WAIT -> repeat.
    typedef enum logic [1:0] {
        BP_BRAM_REQ,   // assert b2d_rd_en
        BP_BRAM_WAIT,  // wait for b2d_rd_grant, latch data
        BP_AXI_WAIT    // present word to AXI, wait for axi_wr_ready
    } bp_state_t;

    bp_state_t bp_state;
    logic [63:0] bp_word;  // latched BRAM word

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
            BURST_PIPE: if (bp_state == BP_AXI_WAIT) begin
                axi_wr_en   = 1'b1;
                axi_wr_addr = sixteenth_base_addr + (32'(cur_tile) << $clog2(BYTES_PER_TILE)) + {wr_count, 3'b0};
                axi_wr_data = bp_word;
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
            wr_count          <= '0;
            bp_state          <= BP_BRAM_REQ;
            bp_word           <= '0;
            b2d_rd_en         <= 1'b0;
            b2d_word_addr     <= '0;
            cache_valid_wr_en <= 1'b0;
        end else begin
            b2d_rd_en         <= 1'b0;
            cache_valid_wr_en <= 1'b0;

            case (state)

                SCAN: begin
                    wr_count   <= '0;
                    fill_count <= '0;
                    bp_state   <= BP_BRAM_REQ;
                    if (any_pending) begin
                        cur_tile <= next_tile;
                        state    <= CHECK_TABLE;
                    end
                end

                CHECK_TABLE: begin
                    if (tt_is_filled)
                        state <= GENERATE_FILL;
                    else begin
                        bp_state <= BP_BRAM_REQ;
                        state    <= BURST_PIPE;
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
                    case (bp_state)
                        // Request word wr_count from BRAM
                        BP_BRAM_REQ: begin
                            b2d_rd_en     <= 1'b1;
                            b2d_word_addr <= {cur_tile, wr_count};
                            bp_state      <= BP_BRAM_WAIT;
                        end

                        // Wait for BRAM grant (re-assert each cycle until granted)
                        BP_BRAM_WAIT: begin
                            if (b2d_rd_grant) begin
                                bp_word  <= b2d_rd_data;
                                bp_state <= BP_AXI_WAIT;
                            end else begin
                                b2d_rd_en     <= 1'b1;
                                b2d_word_addr <= {cur_tile, wr_count};
                            end
                        end

                        // Present word to AXI wrapper, wait for ready
                        BP_AXI_WAIT: begin
                            if (axi_wr_ready) begin
                                if (wr_count == WPT_W'(WORDS_PER_TILE - 1)) begin
                                    transferred[cur_tile] <= 1'b1;
                                    transferred_count     <= transferred_count + 1'b1;
                                    cache_valid_wr_en     <= 1'b1;
                                    cache_valid_index     <= cur_tile;
                                    cache_valid_value     <= 1'b1;
                                    state                 <= SCAN;
                                end else begin
                                    wr_count <= wr_count + 1'b1;
                                    bp_state <= BP_BRAM_REQ;
                                end
                            end
                        end

                        default: bp_state <= BP_BRAM_REQ;
                    endcase
                end

            endcase
        end
    end

endmodule
