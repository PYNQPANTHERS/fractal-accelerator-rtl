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

    typedef enum logic [2:0] {
        SCAN,
        CHECK_TABLE,
        GENERATE_FILL,
        BURST_PIPE,
        PIPE_DRAIN
    } state_t;

    state_t state;

    logic [255:0] transferred;
    logic [7:0]   cur_tile;
    logic [4:0]   rd_count;      // BRAM words received into pipeline (0..31)
    logic [4:0]   wr_count;      // AXI writes committed (0..31)
    logic [4:0]   fill_count;    // words generated in fill path (0..31)

    // one-deep pipeline register
    logic [63:0]  pipe_data;
    logic         pipe_valid;

    logic [255:0] pending;
    assign pending = tile_done & ~transferred;

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

    assign tt_rd_index    = cur_tile;
    assign sixteenth_complete = (transferred == '1) && engine_done;

    // fill word — 8 pixels of same colour packed into 64 bits
    logic [63:0] fill_word;
    always_comb begin
        fill_word = '0;
        for (int i = 0; i < 8; i++)
            fill_word[i*8 +: 8] = {2'b00, tt_fill_colour};
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
            axi_wr_en         <= 1'b0;
            axi_wr_addr       <= '0;
            axi_wr_data       <= '0;
            cache_valid_wr_en <= 1'b0;
        end else begin
            // default deasserts
            b2d_rd_en         <= 1'b0;
            axi_wr_en         <= 1'b0;
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
                    // no BRAM read — generate solid colour words and write to AXI
                    if (axi_wr_ready) begin
                        // register address with pre-increment wr_count
                        axi_wr_addr <= sixteenth_base_addr + {cur_tile, 8'b0} + {wr_count, 3'b0};
                        axi_wr_en   <= 1'b1;
                        axi_wr_data <= fill_word;
                        fill_count  <= fill_count + 1;
                        wr_count    <= wr_count + 1;
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
                    if (b2d_rd_grant) begin
                        if (!pipe_valid) begin
                            // priming — fill the pipeline, no AXI write yet
                            pipe_data  <= b2d_rd_data;
                            pipe_valid <= 1'b1;
                            rd_count   <= rd_count + 1;
                            if (rd_count < 5'd31) begin
                                b2d_rd_en     <= 1'b1;
                                b2d_word_addr <= {cur_tile, 5'(rd_count + 1)};
                            end else begin
                                state <= PIPE_DRAIN;
                            end
                        end else if (axi_wr_ready) begin
                            // pipeline flowing — write current word, latch new BRAM data
                            // register address with pre-increment wr_count
                            axi_wr_addr <= sixteenth_base_addr + {cur_tile, 8'b0} + {wr_count, 3'b0};
                            axi_wr_en   <= 1'b1;
                            axi_wr_data <= pipe_data;
                            wr_count    <= wr_count + 1;
                            pipe_data   <= b2d_rd_data;
                            rd_count    <= rd_count + 1;
                            if (rd_count == 5'd31) begin
                                state <= PIPE_DRAIN;
                            end else begin
                                b2d_rd_en     <= 1'b1;
                                b2d_word_addr <= {cur_tile, 5'(rd_count + 1)};
                            end
                        end else begin
                            // AXI stall — cannot latch new data, re-request same BRAM word
                            b2d_rd_en     <= 1'b1;
                            b2d_word_addr <= {cur_tile, rd_count};
                        end
                    end else begin
                        // BRAM grant denied — controller write took priority; retry same address
                        b2d_rd_en     <= 1'b1;
                        b2d_word_addr <= {cur_tile, rd_count};
                    end
                end

                PIPE_DRAIN: begin
                    // send the last word sitting in pipe_data to AXI
                    if (pipe_valid && axi_wr_ready) begin
                        axi_wr_addr           <= sixteenth_base_addr + {cur_tile, 8'b0} + {wr_count, 3'b0};
                        axi_wr_en             <= 1'b1;
                        axi_wr_data           <= pipe_data;
                        pipe_valid            <= 1'b0;
                        transferred[cur_tile] <= 1'b1;
                        cache_valid_wr_en     <= 1'b1;
                        cache_valid_index     <= cur_tile;
                        cache_valid_value     <= 1'b1;
                        state                 <= SCAN;
                    end
                end

            endcase
        end
    end

endmodule
