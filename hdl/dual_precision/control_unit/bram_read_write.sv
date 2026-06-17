
module bram_read_write #(
    parameter  int PIXEL_W    = 8,
    parameter  int TILE_W     = 16,  // tile width/height in pixels (must be power of 2)
    localparam int BRAM_ADDR_W = 13
) (
    input  logic                clk,
    input  logic                rst,

    // read request from frame_fsm - held until decoded
    input  logic                check_bram,
    input  logic [PIXEL_W-1:0]  a,
    input  logic [PIXEL_W-1:0]  b,

    // colour BRAM byte-read interface (frame_fsm check path)
    output logic                bram_rd_en,
    input  logic [7:0]          bram_rd_data,

    // colour BRAM full-word write interface (RMW result path)
    output logic [BRAM_ADDR_W-1:0] bram_wr_waddr,
    output logic [63:0]            bram_wr_word,
    output logic                   bram_wr_en,

    // colour BRAM word-read for RMW pre-read
    output logic [BRAM_ADDR_W-1:0] bram_rmw_rd_addr,
    output logic                   bram_rmw_rd_en,
    input  logic [63:0]            bram_rmw_rd_data,

    // state BRAM interface - 2-bit: {done, start}
    output logic                sb_rd,
    output logic                sb_we,
    output logic [PIXEL_W-1:0]  sb_x,
    output logic [PIXEL_W-1:0]  sb_y,
    output logic [1:0]          sb_wstate,
    input  logic [1:0]          sb_rstate,

    // result write from cluster result FIFO (show-ahead)
    input  logic                res_valid,
    input  logic                res_reinject,  // re-injected done pixel: skip colour_bram write
    input  logic [PIXEL_W-1:0]  res_a,
    input  logic [PIXEL_W-1:0]  res_b,
    input  logic [7:0]          res_colour,
    output logic                res_rd_en,

    // decoded outputs - registered, hold until next READ
    output logic                miss,
    output logic                started,
    output logic                done,
    output logic [7:0]          colour,

    // one-cycle pulse: fresh miss/done/started values are now valid for the
    // pixel whose check_bram triggered the READ that just completed
    output logic                read_done_pulse
);

    localparam int TILE_BITS      = $clog2(TILE_W);
    localparam int PIX_PER_TILE   = TILE_W * TILE_W;
    localparam int WORDS_PER_TILE = PIX_PER_TILE / 8;
    localparam int TILES_PER_AXIS = 256 / TILE_W;
    localparam int TOTAL_TILES    = TILES_PER_AXIS * TILES_PER_AXIS;
    localparam int BRAM_WORDS     = TOTAL_TILES * WORDS_PER_TILE;

    typedef enum logic [2:0] {
        IDLE,
        READ,
        PREREAD,   // issue word-read for RMW
        WRITE      // merge byte and write full word back
    } state_t;

    state_t current_state, next_state;

    logic started_write_pending;
    logic [PIXEL_W-1:0] a_latch, b_latch;

    // Reinject entries skip colour_bram write entirely - pop them immediately in IDLE.
    logic res_valid_new;
    assign res_valid_new = res_valid && !res_reinject;

    // Mask check_bram for one cycle after READ completes to prevent a spurious
    // second READ while job_prefetch is still combinatorially in CHECKING state.
    logic check_bram_gated;
    assign check_bram_gated = check_bram && !read_done_pulse;

    // "started" state is written immediately in IDLE (not via PREREAD→WRITE), so
    // go_read is blocked while that write is pending to keep state BRAM address clean.
    // PREREAD→WRITE is now used only for cluster results (colour BRAM RMW + "done" state).
    logic go_read, go_write;
    assign go_read  = check_bram_gated && !started_write_pending;
    assign go_write = res_valid_new    && !check_bram_gated;

    // Tile address encoding: {y[7:TILE_BITS], x[7:TILE_BITS], y[TILE_BITS-1:0], x[TILE_BITS-1:0]}
    logic [15:0]          res_ta;
    logic [BRAM_ADDR_W-1:0] res_waddr;
    logic [2:0]           res_boff;
    assign res_ta    = {res_b[7:TILE_BITS], res_a[7:TILE_BITS],
                        res_b[TILE_BITS-1:0], res_a[TILE_BITS-1:0]};
    assign res_waddr = res_ta[15:3];
    assign res_boff  = res_ta[2:0];

    // Latch write target across PREREAD → WRITE
    logic [BRAM_ADDR_W-1:0] wr_waddr_q;
    logic [2:0]  wr_boff_q;
    logic [7:0]  wr_data_q;

    always_ff @(posedge clk) begin
        if (rst) current_state <= IDLE;
        else     current_state <= next_state;
    end

    always_comb begin
        next_state = current_state;
        unique case (current_state)
            IDLE:    if      (go_read)  next_state = READ;
                     else if (go_write) next_state = PREREAD;
            READ:                       next_state = IDLE;
            PREREAD:                    next_state = WRITE;
            WRITE:                      next_state = IDLE;
            default:                    next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            started_write_pending <= 1'b0;
            a_latch               <= '0;
            b_latch               <= '0;
            miss                  <= 1'b0;
            started               <= 1'b0;
            done                  <= 1'b0;
            colour                <= 8'b0;
            wr_waddr_q            <= '0;
            wr_boff_q             <= '0;
            wr_data_q             <= '0;
        end else begin
            if ((current_state == IDLE) && go_read) begin
                a_latch <= a;
                b_latch <= b;
            end

            if (current_state == READ) begin
                started <= sb_rstate[0] & ~sb_rstate[1];
                done    <= sb_rstate[1];
                miss    <= ~sb_rstate[0] & ~sb_rstate[1];
                colour  <= bram_rd_data;
                if (~sb_rstate[0] & ~sb_rstate[1])
                    started_write_pending <= 1'b1;
            end

            // "started" write fires in the very next IDLE cycle after READ detects a miss.
            // This keeps the state BRAM accurate with minimum latency, preventing the
            // scheduler from seeing a stale "miss" on the next check of the same pixel.
            if ((current_state == IDLE) && started_write_pending)
                started_write_pending <= 1'b0;

            if (current_state == PREREAD) begin
                wr_waddr_q <= res_waddr;
                wr_boff_q  <= res_boff;
                wr_data_q  <= res_colour;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (rst) read_done_pulse <= 1'b0;
        else     read_done_pulse <= (current_state == READ);
    end

    // Merged write word: take the pre-read word and insert the new byte
    logic [63:0] merged_word;
    always_comb begin
        merged_word = bram_rmw_rd_data;
        merged_word[wr_boff_q*8 +: 8] = wr_data_q;
    end

    // colour BRAM byte-read (check path)
    assign bram_rd_en = (current_state == IDLE) && go_read;

    // colour BRAM RMW pre-read
    assign bram_rmw_rd_en   = (current_state == PREREAD);
    assign bram_rmw_rd_addr = res_waddr;

    // colour BRAM full-word write — skip if pixel already done (sb_rstate[1]=1).
    // sb_rstate during WRITE holds the state read in the preceding PREREAD cycle
    // (sb_x/y = res_a/b), reflecting the pixel's state before this WRITE.
    // Guards against any residual duplicate results inflating tile_wr_cnt.
    assign bram_wr_en    = (current_state == WRITE) && !sb_rstate[1];
    assign bram_wr_waddr = wr_waddr_q;
    assign bram_wr_word  = merged_word;

    // Pop reinject entries immediately in IDLE; pop normal results in WRITE.
    assign res_rd_en = ((current_state == IDLE)  && res_valid && res_reinject)
                     || (current_state == WRITE);

    // state BRAM
    // "started" (01) written immediately in IDLE when started_write_pending.
    // "done"    (11) written in WRITE when cluster result is processed.
    // Both are separate from colour BRAM and need no PREREAD.
    assign sb_rd     = (current_state == IDLE) && go_read;
    assign sb_we     = ((current_state == IDLE)  && started_write_pending)
                     || (current_state == WRITE);
    // Priority: check-READ uses current a/b; "started" write uses latched coords; "done" write uses res_a/b
    assign sb_x      = sb_rd                                             ? a       :
                       (current_state == IDLE && started_write_pending)  ? a_latch : res_a;
    assign sb_y      = sb_rd                                             ? b       :
                       (current_state == IDLE && started_write_pending)  ? b_latch : res_b;
    assign sb_wstate = (started_write_pending && current_state == IDLE) ? 2'b01 : 2'b11;

endmodule
