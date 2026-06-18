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

    // ── Per-tile pixel counter: count in BRAM, done-flag in fabric ────────────
    // Previously this was 1024 (x2 ping-pong) saturating counters in LUT fabric,
    // each with a CE gated by a 1024-way write-address decode. That decode + wide
    // fanout dominated timing (354 failing paths). Here the COUNT lives in a small
    // BRAM (touched one tile per cycle via RMW) and only the 1-bit-per-tile DONE
    // flag stays in fabric, so bram_to_dram's lowest_set_tree still reads all 1024
    // done bits in parallel — its interface (the tile_done bus) is unchanged.
    //
    // ctrl_wr_en (= bram_read_write WRITE state) fires at most once every 3 cycles
    // (FSM: IDLE->PREREAD->WRITE->IDLE), so consecutive writes are never adjacent.
    // The 2-stage RMW (read S0, write-back S1) always completes before the next
    // write arrives — no same-tile hazard, no forwarding needed.
    localparam logic [CNT_W-1:0] CNT_FULL = CNT_W'(PIX_PER_TILE);  // done at full count

    logic [TILE_IDX_W-1:0] tile_wr_idx;
    assign tile_wr_idx = ctrl_wr_waddr[BRAM_ADDR_W-1 : $clog2(WORDS_PER_TILE)];

    // Count BRAM: 2 banks (ping-pong) x TOTAL_TILES x CNT_W. One write port each.
    (* ram_style = "block" *)
    logic [CNT_W-1:0] cnt_bram_a [0:TOTAL_TILES-1];
    (* ram_style = "block" *)
    logic [CNT_W-1:0] cnt_bram_b [0:TOTAL_TILES-1];

    // Done flags: 1 bit per tile, in fabric — read in parallel by the priority tree.
    logic [TOTAL_TILES-1:0] done_flag_a;
    logic [TOTAL_TILES-1:0] done_flag_b;

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

    // ── RMW stage 0: read the active bank's count for the tile being written ───
    logic                  rmw_v_s1;       // a write is in flight (stage 1)
    logic [TILE_IDX_W-1:0] rmw_idx_s1;
    logic [CNT_W-1:0]      cnt_rd_s1;       // registered count read in S0

    always_ff @(posedge clk) begin
        rmw_v_s1   <= ctrl_wr_en;
        rmw_idx_s1 <= tile_wr_idx;
        cnt_rd_s1  <= active ? cnt_bram_b[tile_wr_idx] : cnt_bram_a[tile_wr_idx];
    end

    // ── RMW stage 1: increment (saturating) + write back; set done flag at full ─
    logic [CNT_W-1:0] cnt_next;
    logic             cnt_hits_full;
    always_comb begin
        cnt_next      = (cnt_rd_s1 == CNT_FULL) ? cnt_rd_s1 : cnt_rd_s1 + 1'b1;
        cnt_hits_full = (cnt_next == CNT_FULL);
    end

    always_ff @(posedge clk) begin
        // Active bank: RMW write-back (stage 1). Inactive bank: background clear.
        if (!active) begin
            if (rmw_v_s1)  cnt_bram_a[rmw_idx_s1] <= cnt_next;
            if (clr_active) cnt_bram_b[clr_addr]   <= '0;
        end else begin
            if (rmw_v_s1)  cnt_bram_b[rmw_idx_s1] <= cnt_next;
            if (clr_active) cnt_bram_a[clr_addr]   <= '0;
        end
    end

    // Done flags: set when the active bank's RMW reaches full; clear walks inactive.
    always_ff @(posedge clk) begin
        if (!active) begin
            if (rmw_v_s1 && cnt_hits_full) done_flag_a[rmw_idx_s1] <= 1'b1;
            if (clr_active)                done_flag_b[clr_addr]   <= 1'b0;
        end else begin
            if (rmw_v_s1 && cnt_hits_full) done_flag_b[rmw_idx_s1] <= 1'b1;
            if (clr_active)                done_flag_a[clr_addr]   <= 1'b0;
        end
    end

    assign tile_done = active ? done_flag_b : done_flag_a;

    initial begin
        active      = 1'b0;
        rst_d       = 1'b0;
        clr_active  = 1'b0;
        clr_addr    = '0;
        rmw_v_s1    = 1'b0;
        rmw_idx_s1  = '0;
        cnt_rd_s1   = '0;
        done_flag_a = '0;
        done_flag_b = '0;
        for (int ti = 0; ti < TOTAL_TILES; ti++) begin
            cnt_bram_a[ti] = '0;
            cnt_bram_b[ti] = '0;
        end
    end

endmodule
