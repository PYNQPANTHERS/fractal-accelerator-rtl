// =============================================================================
// axi_hp_master_wrap.sv
//
// AXI4 HP Master Write Wrapper for PYNQ Z1 (Zynq-7020)
//
// Converts a simple word-at-a-time handshake interface (from bram_to_dram,
// instantiated inside per_sixteenth_engine) into AXI4 burst write
// transactions targeting S_AXI_HP0.
//
// Parameterized to match bram_to_dram's TILE_W:
//   WORDS_PER_TILE = TILE_W*TILE_W / 8   (64-bit words per tile)
//   BURST_BEATS    = WORDS_PER_TILE
//   AWLEN          = BURST_BEATS - 1
//
// For the default TILE_W=16: WORDS_PER_TILE = 32, AWLEN = 31.
//
// Fixed configuration (PYNQ Z1 specific):
//   - Data width  : 64-bit  (PYNQ HP port default)
//   - Burst type  : INCR    (AWBURST = 2'b01)
//   - Beat size   : 8 bytes (AWSIZE  = 3'b011)
//   - Cache       : 4'b0011 (Normal Non-cacheable Bufferable)
//   - Prot        : 3'b000
//   - ID          : 6'b0    (single outstanding transaction)
//   - Byte strobes: 8'hFF   (all lanes valid)
//
// Burst firing policy:
//   Burst begins as soon as the FIRST word of a tile arrives in the skid
//   buffer. bram_to_dram always produces exactly WORDS_PER_TILE words
//   consecutively (with at most short stalls handled by axi_wr_ready),
//   so the remaining beats arrive in step with the AXI W channel.
//
//   The burst base address is taken from the first word's wr_addr
//   (wr_count==0), which is BYTES_PER_TILE-aligned by construction in
//   bram_to_dram (BYTES_PER_TILE = TILE_W*TILE_W).
//
// Outstanding transaction policy:
//   One burst in-flight at a time (WAIT_B before next SEND_AW).
//
// DDR address range (PYNQ Z1): 0x0000_0000 - 0x1FFF_FFFF (512 MB)
// Clock: FCLK_CLK0 @ 100 MHz
// =============================================================================

module axi_hp_master_wrap #(
    parameter int TILE_W = 16   // must match bram_to_dram's TILE_W
)(
    input  logic        clk,
    input  logic        rst,           // synchronous active-high reset

    // -------------------------------------------------------------------------
    // Simple write interface — from bram_to_dram (axi_wr_* ports)
    // -------------------------------------------------------------------------
    input  logic [31:0] wr_addr,
    input  logic [63:0] wr_data,
    input  logic        wr_en,
    output logic        wr_ready,      // ← drives bram_to_dram.axi_wr_ready

    // -------------------------------------------------------------------------
    // AXI4 HP Master — Write Address Channel (AW) — connect to S_AXI_HP0
    // -------------------------------------------------------------------------
    output logic [5:0]  m_awid,
    output logic [31:0] m_awaddr,
    output logic [7:0]  m_awlen,
    output logic [2:0]  m_awsize,
    output logic [1:0]  m_awburst,
    output logic [3:0]  m_awcache,
    output logic [2:0]  m_awprot,
    output logic [3:0]  m_awqos,
    output logic        m_awvalid,
    input  logic        m_awready,

    // -------------------------------------------------------------------------
    // AXI4 HP Master — Write Data Channel (W)
    // -------------------------------------------------------------------------
    output logic [63:0] m_wdata,
    output logic [7:0]  m_wstrb,
    output logic        m_wlast,
    output logic        m_wvalid,
    input  logic        m_wready,

    // -------------------------------------------------------------------------
    // AXI4 HP Master — Write Response Channel (B)
    // -------------------------------------------------------------------------
    input  logic [5:0]  m_bid,
    input  logic [1:0]  m_bresp,
    input  logic        m_bvalid,
    output logic        m_bready,

    // -------------------------------------------------------------------------
    // Status outputs — to AXI-Lite status register
    // -------------------------------------------------------------------------
    output logic        err_flag,      // sticky: SLVERR/DECERR seen on B channel
    output logic        burst_done,    // 1-cycle pulse after each BVALID accepted

    // -------------------------------------------------------------------------
    // Debug taps → AXI-Lite status registers (same clock domain)
    // -------------------------------------------------------------------------
    output logic        dbg_axi_aw_hs,      // m_awvalid && m_awready
    output logic        dbg_axi_w_hs,       // m_wvalid  && m_wready
    output logic        dbg_axi_b_hs,       // m_bvalid  && m_bready
    output logic [3:0]  dbg_axi_bstate,     // burst FSM state (zero-extended)
    output logic        dbg_axi_wr_ready,   // live wr_ready (skid not full)
    output logic [1:0]  dbg_axi_bresp_last  // live BRESP value
);

    // =========================================================================
    // Parameters derived from TILE_W
    // =========================================================================
    localparam int PIX_PER_TILE   = TILE_W * TILE_W;
    localparam int WORDS_PER_TILE = PIX_PER_TILE / 8;          // 64-bit words/tile
    localparam int BURST_BEATS    = WORDS_PER_TILE;
    localparam int BEAT_W         = $clog2(BURST_BEATS);       // bits for beat_cnt
    localparam logic [7:0] AWLEN_C = 8'(BURST_BEATS - 1);

    localparam int SKID_DEPTH = 4;             // absorbs short HP port stalls
    localparam int SKID_AW    = $clog2(SKID_DEPTH);
    localparam int DATA_W     = 64;
    localparam int ADDR_W     = 32;
    localparam int ENTRY_W    = DATA_W + ADDR_W;

    // =========================================================================
    // Skid buffer — small synchronous FIFO (addr + data)
    //
    // bram_to_dram produces words back-to-back with no gaps once a tile
    // starts. The skid buffer only needs to absorb the few-cycle WREADY
    // stalls the Zynq-7020 HP AFI occasionally asserts.
    // =========================================================================
    logic [ENTRY_W-1:0] skid_mem [0:SKID_DEPTH-1];
    logic [SKID_AW:0]   skid_wr_ptr;
    logic [SKID_AW:0]   skid_rd_ptr;
    logic [SKID_AW:0]   skid_count;
    logic               skid_full;
    logic               skid_empty;
    logic               skid_rd_en;

    assign skid_count = skid_wr_ptr - skid_rd_ptr;
    assign skid_full  = (skid_count == SKID_DEPTH[SKID_AW:0]);
    assign skid_empty = (skid_count == '0);
    assign wr_ready   = ~skid_full;

    always_ff @(posedge clk) begin
        if (rst) begin
            skid_wr_ptr <= '0;
        end else if (wr_en && !skid_full) begin
            skid_mem[skid_wr_ptr[SKID_AW-1:0]] <= {wr_addr, wr_data};
            skid_wr_ptr <= skid_wr_ptr + 1;
        end
    end

    always_ff @(posedge clk) begin
        if (rst)
            skid_rd_ptr <= '0;
        else if (skid_rd_en && !skid_empty)
            skid_rd_ptr <= skid_rd_ptr + 1;
    end

    logic [ADDR_W-1:0] skid_out_addr;
    logic [DATA_W-1:0] skid_out_data;
    assign skid_out_addr = skid_mem[skid_rd_ptr[SKID_AW-1:0]][ENTRY_W-1 : DATA_W];
    assign skid_out_data = skid_mem[skid_rd_ptr[SKID_AW-1:0]][DATA_W-1  : 0];

    // =========================================================================
    // AXI fixed tie-offs
    // =========================================================================
    assign m_awid    = 6'b000000;
    assign m_awlen   = AWLEN_C;
    assign m_awsize  = 3'b011;
    assign m_awburst = 2'b01;
    assign m_awcache = 4'b0011;
    assign m_awprot  = 3'b000;
    assign m_awqos   = 4'b0000;
    assign m_wstrb   = 8'hFF;

    // =========================================================================
    // Burst state machine
    // =========================================================================
    typedef enum logic [2:0] {
        IDLE,
        SEND_AW,
        SEND_W,
        WAIT_B,
        ERROR
    } burst_state_t;

    burst_state_t bstate;

    logic [ADDR_W-1:0] burst_base_addr;
    logic [BEAT_W-1:0] beat_cnt;            // counts beats loaded (0..BURST_BEATS-1)

    localparam logic [BEAT_W-1:0] LAST_BEAT = BEAT_W'(BURST_BEATS - 1);

    always_ff @(posedge clk) begin
        if (rst) begin
            bstate          <= IDLE;
            m_awaddr        <= '0;
            m_awvalid       <= 1'b0;
            m_wdata         <= '0;
            m_wlast         <= 1'b0;
            m_wvalid        <= 1'b0;
            m_bready        <= 1'b0;
            beat_cnt        <= '0;
            burst_base_addr <= '0;
            skid_rd_en      <= 1'b0;
            err_flag        <= 1'b0;
            burst_done      <= 1'b0;
        end else begin
            skid_rd_en <= 1'b0;
            burst_done <= 1'b0;

            case (bstate)

                // -----------------------------------------------------------------
                // IDLE — wait for the first word of a new tile.
                // -----------------------------------------------------------------
                IDLE: begin
                    m_awvalid <= 1'b0;
                    m_wvalid  <= 1'b0;
                    m_bready  <= 1'b0;
                    beat_cnt  <= '0;

                    if (!skid_empty) begin
                        burst_base_addr <= skid_out_addr;
                        bstate          <= SEND_AW;
                    end
                end

                // -----------------------------------------------------------------
                // SEND_AW — assert AWVALID and hold until AWREADY.
                // W beat 0 is loaded only in the same cycle AW is accepted so
                // that WVALID is never asserted before AWREADY.  The Zynq HP AFI
                // write-data FIFO can assert WREADY independently of the write-
                // command FIFO; presenting W data early causes the AFI to consume
                // beats that have no matching AW context, misaligning the burst
                // and leaving the response channel permanently stalled (B_HS=0).
                // -----------------------------------------------------------------
                SEND_AW: begin
                    m_awaddr  <= burst_base_addr;
                    m_awvalid <= 1'b1;

                    if (m_awvalid && m_awready) begin
                        m_awvalid <= 1'b0;
                        bstate    <= SEND_W;
                        if (!skid_empty) begin
                            m_wdata    <= skid_out_data;
                            m_wlast    <= (beat_cnt == LAST_BEAT);
                            m_wvalid   <= 1'b1;
                            skid_rd_en <= 1'b1;
                            beat_cnt   <= beat_cnt + 1'b1;
                        end
                    end
                end

                // -----------------------------------------------------------------
                // SEND_W — stream beats from skid buffer onto W channel.
                // WLAST is pre-computed when loading each beat: it asserts
                // when beat_cnt reaches BURST_BEATS-1, i.e. on the final beat.
                // -----------------------------------------------------------------
                SEND_W: begin
                    if (m_wvalid && m_wready) begin
                        if (m_wlast) begin
                            m_wvalid <= 1'b0;
                            m_wlast  <= 1'b0;
                            bstate   <= WAIT_B;
                        end else if (!skid_empty) begin
                            m_wdata    <= skid_out_data;
                            m_wlast    <= (beat_cnt == LAST_BEAT);
                            skid_rd_en <= 1'b1;
                            beat_cnt   <= beat_cnt + 1'b1;
                        end else begin
                            // skid buffer momentarily empty — legal mid-burst stall
                            m_wvalid <= 1'b0;
                        end
                    end else if (!m_wvalid && !skid_empty) begin
                        m_wdata    <= skid_out_data;
                        m_wlast    <= (beat_cnt == LAST_BEAT);
                        m_wvalid   <= 1'b1;
                        skid_rd_en <= 1'b1;
                        beat_cnt   <= beat_cnt + 1'b1;
                    end
                end

                // -----------------------------------------------------------------
                // WAIT_B — consume write response immediately.
                // -----------------------------------------------------------------
                WAIT_B: begin
                    m_bready <= 1'b1;

                    if (m_bvalid) begin
                        m_bready   <= 1'b0;
                        burst_done <= 1'b1;

                        if (m_bresp != 2'b00) begin
                            err_flag <= 1'b1;
                            bstate   <= ERROR;
                        end else begin
                            bstate   <= IDLE;
                        end
                    end
                end

                // -----------------------------------------------------------------
                // ERROR — sticky, only rst clears it. Keep draining B channel.
                // -----------------------------------------------------------------
                ERROR: begin
                    m_awvalid <= 1'b0;
                    m_wvalid  <= 1'b0;
                    m_bready  <= 1'b1;
                end

                default: bstate <= IDLE;

            endcase
        end
    end

    // =========================================================================
    // Debug taps (combinational, off existing AXI signals) → AXI-Lite
    // =========================================================================
    assign dbg_axi_aw_hs      = m_awvalid && m_awready;
    assign dbg_axi_w_hs       = m_wvalid  && m_wready;
    assign dbg_axi_b_hs       = m_bvalid  && m_bready;
    assign dbg_axi_bstate     = {1'b0, bstate};   // bstate is the 3-bit burst FSM enum
    assign dbg_axi_wr_ready   = wr_ready;
    assign dbg_axi_bresp_last = m_bresp;

endmodule

// =============================================================================
// PARAMETERIZATION NOTES
//
//   TILE_W=16 → WORDS_PER_TILE=32, BEAT_W=5, AWLEN=31, burst=256 bytes
//   TILE_W=8  → WORDS_PER_TILE=8,  BEAT_W=3, AWLEN=7,  burst=64 bytes
//   TILE_W=32 → WORDS_PER_TILE=128,BEAT_W=7, AWLEN=127,burst=1024 bytes
//
//   All of these remain within a single 4KB page and the Zynq HP AWLEN
//   limit of 255, so no special-casing is required across the valid
//   range of TILE_W (must be a power of two, TILE_W*TILE_W divisible by 8
//   i.e. TILE_W >= 4, and burst size BYTES_PER_TILE = TILE_W*TILE_W must
//   not exceed 4096 → TILE_W <= 64).
//
//   Whatever TILE_W is chosen, instantiate this module with the SAME
//   TILE_W parameter as bram_to_dram (inside per_sixteenth_engine) so
//   AWLEN/WLAST timing matches the word stream exactly.
// =============================================================================
