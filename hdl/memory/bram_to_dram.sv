// Streams completed tiles from colour_bram to DDR3 via AXI HP.
// Runs concurrently with per_sixteenth_engine.

module bram_to_dram (
    input  logic         clk,
    input  logic         rst,

    input  logic [255:0] tile_done,
    input  logic         engine_done,

    // tile_table read (combinational)
    output logic [7:0]   tt_rd_index,
    input  logic         tt_is_filled,
    input  logic [5:0]   tt_fill_colour,

    // colour_bram Port B
    output logic [12:0]  b2d_word_addr,
    output logic         b2d_rd_en,
    input  logic         b2d_rd_grant,
    input  logic [63:0]  b2d_rd_data,

    // AXI HP write interface
    output logic [31:0]  axi_wr_addr,
    output logic [63:0]  axi_wr_data,
    output logic         axi_wr_en,
    input  logic         axi_wr_ready,

    // cache valid metadata write
    output logic         cache_valid_wr_en,
    output logic [7:0]   cache_valid_index,
    output logic         cache_valid_value,

    input  logic [31:0]  sixteenth_base_addr,

    output logic         sixteenth_complete
);

    typedef enum logic [1:0] {
        SCAN,
        CHECK_TABLE,
        GENERATE_FILL,
        BURST_PIPE
    } state_t;

    state_t state;

    logic [255:0] transferred;
    logic [7:0]   cur_tile;
    logic [4:0]   rd_count;      // next BRAM word index to request (0..31)
    logic [4:0]   wr_count;      // AXI writes accepted (0..31)
    logic [4:0]   fill_count;    // words accepted in fill path (0..31)

    // pipeline register — holds the word currently being presented to AXI
    logic [63:0]  pipe_data;
    logic         pipe_valid;

    logic [255:0] pending;
    assign pending = (tile_done == '1) ? (tile_done & ~transferred) : '0;

    // priority encoder — lowest set bit of pending
    logic [7:0] next_tile;
    logic       any_pending;

    always_comb begin
        next_tile   = '0;
        any_pending = 1'b0;
        for (int i = 255; i >= 0; i--) begin
            if (pending[i]) begin
                next_tile   = 8'(i);
                any_pending = 1'b1;
            end
        end
    end

    assign tt_rd_index       = cur_tile;
    assign sixteenth_complete = (transferred == '1) && engine_done;

    // fill word — 8 pixels of same colour packed into 64 bits
    logic [63:0] fill_word;
    always_comb begin
        fill_word = '0;
        for (int i = 0; i < 8; i++)
            fill_word[i*8 +: 8] = {2'b00, tt_fill_colour};
    end

    // ── AXI write outputs: combinational so handshake is glitch-free ────────
    always_comb begin
        axi_wr_en   = 1'b0;
        axi_wr_addr = '0;
        axi_wr_data = '0;
        case (state)
            GENERATE_FILL: begin
                axi_wr_en   = 1'b1;
                axi_wr_addr = sixteenth_base_addr + {cur_tile, 8'b0} + {wr_count, 3'b0};
                axi_wr_data = fill_word;
            end
            BURST_PIPE: begin
                if (pipe_valid) begin
                    axi_wr_en   = 1'b1;
                    axi_wr_addr = sixteenth_base_addr + {cur_tile, 8'b0} + {wr_count, 3'b0};
                    axi_wr_data = pipe_data;
                end
            end
            default: ;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state             <= SCAN;
            transferred       <= '0;
            cur_tile          <= '0;
            rd_count          <= '0;
            wr_count          <= '0;
            fill_count        <= '0;
            pipe_valid        <= 1'b0;
            pipe_data         <= '0;
            b2d_rd_en         <= 1'b0;
            b2d_word_addr     <= '0;
            cache_valid_wr_en <= 1'b0;
        end else begin
            // default deasserts
            b2d_rd_en         <= 1'b0;
            cache_valid_wr_en <= 1'b0;

            case (state)

                SCAN: begin
                    pipe_valid <= 1'b0;
                    rd_count   <= '0;
                    wr_count   <= '0;
                    fill_count <= '0;
                    if (any_pending) begin
                        cur_tile <= next_tile;
                        state    <= CHECK_TABLE;
                    end
                end

                CHECK_TABLE: begin
                    // tt_is_filled combinational from cur_tile via tt_rd_index
                    if (tt_is_filled)
                        state <= GENERATE_FILL;
                    else begin
                        // issue first BRAM read immediately
                        b2d_rd_en     <= 1'b1;
                        b2d_word_addr <= {cur_tile, 5'b0}; // tile*32 + 0
                        state         <= BURST_PIPE;
                    end
                end

                GENERATE_FILL: begin
                    // AXI write is presented combinationally above.
                    // Only advance counters when AXI accepts (axi_wr_ready=1).
                    if (axi_wr_ready) begin
                        fill_count <= fill_count + 1;
                        wr_count   <= wr_count + 1;
                        if (fill_count == 5'd31) begin
                            transferred[cur_tile] <= 1'b1;
                            cache_valid_wr_en     <= 1'b1;
                            cache_valid_index     <= cur_tile;
                            cache_valid_value     <= 1'b0;
                            state                 <= SCAN;
                        end
                    end
                end

                BURST_PIPE: begin
                    if (pipe_valid) begin
                        // Word is ready — present to AXI and wait for acceptance.
                        // No BRAM activity here: avoids latching the stale grant that
                        // always trails a BRAM priming cycle by one clock (2-cycle latency).
                        if (axi_wr_ready) begin
                            pipe_valid <= 1'b0;
                            if (wr_count == 5'd31) begin
                                // Last word accepted — tile complete
                                transferred[cur_tile] <= 1'b1;
                                cache_valid_wr_en     <= 1'b1;
                                cache_valid_index     <= cur_tile;
                                cache_valid_value     <= 1'b1;
                                state                 <= SCAN;
                            end else begin
                                wr_count      <= wr_count + 1;
                                // Issue BRAM read for the next word now that AXI consumed this one
                                b2d_rd_en     <= 1'b1;
                                b2d_word_addr <= {cur_tile, rd_count};
                            end
                        end
                    end else begin
                        // Waiting for BRAM grant — retry until granted
                        if (b2d_rd_grant) begin
                            pipe_data  <= b2d_rd_data;
                            pipe_valid <= 1'b1;
                            rd_count   <= rd_count + 1;
                        end else begin
                            b2d_rd_en     <= 1'b1;
                            b2d_word_addr <= {cur_tile, rd_count};
                        end
                    end
                end

            endcase
        end
    end

endmodule
