// Dual-port colour BRAM for one 256x256 sixteenth, tile-ordered
// Write port is full-word; caller does RMW to merge a single byte

module colour_bram #(
    parameter  int TILE_W        = 16,
    localparam int TILES_PER_AXIS = 256 / TILE_W,
    localparam int TOTAL_TILES    = TILES_PER_AXIS * TILES_PER_AXIS,
    localparam int BRAM_ADDR_W    = $clog2(256 * 256 / 8)
)(
    input  logic        clk,
    input  logic        rst,   // resets tile_wr_cnt only; mem is untouched

    input  logic [7:0]  ctrl_rd_x,
    input  logic [7:0]  ctrl_rd_y,
    input  logic        ctrl_rd_en,
    output logic [7:0]  ctrl_rd_data,

    // Full-word write: caller must do RMW externally
    input  logic [BRAM_ADDR_W-1:0] ctrl_wr_waddr,
    input  logic [63:0]            ctrl_wr_word,
    input  logic                   ctrl_wr_en,

    input  logic [BRAM_ADDR_W-1:0] b2d_word_addr,
    input  logic                   b2d_rd_en,
    output logic                   b2d_rd_grant,
    output logic [63:0]            b2d_rd_data,

    // Word read for RMW — returns the 64-bit word at ctrl_rd_waddr one cycle later
    input  logic [BRAM_ADDR_W-1:0] ctrl_rmw_rd_addr,
    input  logic                   ctrl_rmw_rd_en,
    output logic [63:0]            ctrl_rmw_rd_data,

    // Per-tile pixel write counter: bit set once all PIX_PER_TILE pixels written
    output logic [TOTAL_TILES-1:0] tile_done
);

    localparam int TILE_BITS      = $clog2(TILE_W);
    localparam int PIX_PER_TILE   = TILE_W * TILE_W;
    localparam int WORDS_PER_TILE = PIX_PER_TILE / 8;
    localparam int BRAM_WORDS     = 256 * 256 / 8;
    localparam int TILE_IDX_W     = $clog2(TOTAL_TILES);
    localparam int CNT_W          = $clog2(PIX_PER_TILE) + 1;

    (* ram_style = "block" *)
    logic [63:0] mem [0:BRAM_WORDS-1];

    initial begin
        for (int i = 0; i < BRAM_WORDS; i++) mem[i] = 64'h0;
    end

    // Tile address encoding: {y[7:TILE_BITS], x[7:TILE_BITS], y[TILE_BITS-1:0], x[TILE_BITS-1:0]}
    // Total = 2*(8-TILE_BITS) + 2*TILE_BITS = 16 bits; word addr = ta[15:3]
    logic [15:0] ctrl_rd_ta;
    logic [BRAM_ADDR_W-1:0] ctrl_rd_waddr_i;
    logic [2:0]  ctrl_rd_boff;

    assign ctrl_rd_ta      = {ctrl_rd_y[7:TILE_BITS], ctrl_rd_x[7:TILE_BITS],
                               ctrl_rd_y[TILE_BITS-1:0], ctrl_rd_x[TILE_BITS-1:0]};
    assign ctrl_rd_waddr_i = ctrl_rd_ta[15:3];
    assign ctrl_rd_boff    = ctrl_rd_ta[2:0];

    // Port A: shared READ port. Serves the controller's cache-check byte read
    // (priority) and the bram_to_dram word read. b2d is read-only and the
    // cache-check is idle during the writeback drain, so moving b2d here lets it
    // read every cycle during drain instead of starving behind ctrl writes on
    // Port B. One physical read per cycle: ctrl_rd_en wins, else b2d_rd_en.
    logic [63:0] a_rd_word;
    logic [2:0]  a_byte_off_reg;

    always_ff @(posedge clk) begin
        if (ctrl_rd_en) begin
            a_rd_word      <= mem[ctrl_rd_waddr_i];
            a_byte_off_reg <= ctrl_rd_boff;
        end else if (b2d_rd_en) begin
            b2d_rd_data    <= mem[b2d_word_addr];
        end
    end

    always_comb
        ctrl_rd_data = a_rd_word[a_byte_off_reg*8 +: 8];

    // b2d gets Port A whenever the cache-check read is not using it. Grant is
    // registered to align with b2d_rd_data (both land the cycle after the read).
    always_ff @(posedge clk)
        b2d_rd_grant <= b2d_rd_en && !ctrl_rd_en;

    // Port B: controller write / RMW pre-read only. b2d no longer contends here,
    // so the control unit never has to stall for the colour BRAM.
    always_ff @(posedge clk) begin
        if (ctrl_wr_en)
            mem[ctrl_wr_waddr] <= ctrl_wr_word;
        else if (ctrl_rmw_rd_en)
            ctrl_rmw_rd_data <= mem[ctrl_rmw_rd_addr];
    end

    // Per-tile write counter, ping-pong banks. rst rising edge flips active bank and
    // starts a background TOTAL_TILES-cycle clear of the inactive bank. Saturates at bit[CNT_W-1].
    logic [CNT_W-1:0] tile_wr_cnt_a [0:TOTAL_TILES-1];
    logic [CNT_W-1:0] tile_wr_cnt_b [0:TOTAL_TILES-1];
    logic [TILE_IDX_W-1:0] tile_wr_idx;
    assign tile_wr_idx = ctrl_wr_waddr[BRAM_ADDR_W-1 : $clog2(WORDS_PER_TILE)];

    logic       active;
    logic       rst_d;
    logic       clr_active;
    logic [TILE_IDX_W-1:0] clr_addr;

    always_ff @(posedge clk) rst_d <= rst;

    always_ff @(posedge clk) begin
        if (rst && !rst_d) begin
            active     <= ~active;
            clr_active <= 1'b1;
            clr_addr   <= '0;
        end else if (clr_active) begin
            if (clr_addr == TILE_IDX_W'(TOTAL_TILES - 1))
                clr_active <= 1'b0;
            else
                clr_addr <= clr_addr + 1'b1;
        end
    end

    always_ff @(posedge clk) begin
        if (!active) begin
            if (clr_active)                                              tile_wr_cnt_b[clr_addr]   <= '0;
            if (ctrl_wr_en && !tile_wr_cnt_a[tile_wr_idx][CNT_W-1])    tile_wr_cnt_a[tile_wr_idx] <= tile_wr_cnt_a[tile_wr_idx] + 1'b1;
        end else begin
            if (clr_active)                                              tile_wr_cnt_a[clr_addr]   <= '0;
            if (ctrl_wr_en && !tile_wr_cnt_b[tile_wr_idx][CNT_W-1])    tile_wr_cnt_b[tile_wr_idx] <= tile_wr_cnt_b[tile_wr_idx] + 1'b1;
        end
    end

    genvar ti;
    generate
        for (ti = 0; ti < TOTAL_TILES; ti++) begin : tile_done_gen
            assign tile_done[ti] = active ? tile_wr_cnt_b[ti][CNT_W-1] : tile_wr_cnt_a[ti][CNT_W-1];
        end
    endgenerate

    initial begin
        active     = 1'b0;
        rst_d      = 1'b0;
        clr_active = 1'b0;
        clr_addr   = '0;
        for (int ti = 0; ti < TOTAL_TILES; ti++) begin
            tile_wr_cnt_a[ti] = '0;
            tile_wr_cnt_b[ti] = '0;
        end
    end

endmodule
