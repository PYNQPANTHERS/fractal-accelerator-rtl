// =============================================================================
// axi_hp_master_wrap.sv
//
// AXI HP master write wrapper for PYNQ-Z1 / Zynq-7020.
//
// Converts the simple bram_to_dram word stream into AXI writes targeting
// S_AXI_HP0. The Zynq PS HP ports are AXI3 on the PS side, so bursts must be
// limited to 16 beats even though the Vivado interconnect presents an AXI4-like
// 8-bit AWLEN on this module's side.
//
// Default TILE_W=16:
//   - bram_to_dram produces 32 x 64-bit words per 16x16 tile.
//   - this wrapper buffers the tile words.
//   - it writes them as two AXI3-safe 16-beat bursts with AWLEN=15.
//
// The W channel is started only after the AW handshake. This avoids the HP
// port/interconnect seeing write data before it has accepted the write address.
// =============================================================================

module axi_hp_master_wrap #(
    parameter int TILE_W = 16   // must match bram_to_dram's TILE_W
)(
    input  logic        clk,
    input  logic        rst,           // synchronous active-high reset

    // -------------------------------------------------------------------------
    // Simple write interface - from bram_to_dram
    // -------------------------------------------------------------------------
    input  logic [31:0] wr_addr,
    input  logic [63:0] wr_data,
    input  logic        wr_en,
    output logic        wr_ready,

    // -------------------------------------------------------------------------
    // AXI HP write address channel
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
    // AXI HP write data channel
    // -------------------------------------------------------------------------
    output logic [63:0] m_wdata,
    output logic [7:0]  m_wstrb,
    output logic        m_wlast,
    output logic        m_wvalid,
    input  logic        m_wready,

    // -------------------------------------------------------------------------
    // AXI HP write response channel
    // -------------------------------------------------------------------------
    input  logic [5:0]  m_bid,
    input  logic [1:0]  m_bresp,
    input  logic        m_bvalid,
    output logic        m_bready,

    // -------------------------------------------------------------------------
    // Status outputs - to AXI-Lite status register
    // -------------------------------------------------------------------------
    output logic        err_flag,      // sticky: SLVERR/DECERR seen on B channel
    output logic        burst_done     // 1-cycle pulse after each BVALID accepted
);

    // =========================================================================
    // Geometry and AXI burst sizing
    // =========================================================================
    localparam int PIX_PER_TILE    = TILE_W * TILE_W;
    localparam int WORDS_PER_TILE  = PIX_PER_TILE / 8;    // 64-bit words/tile
    localparam int AXI3_MAX_BEATS  = 16;                  // Zynq HP AXI3 limit
    localparam int BURST_BEATS     = (WORDS_PER_TILE < AXI3_MAX_BEATS)
                                   ? WORDS_PER_TILE : AXI3_MAX_BEATS;
    localparam int BEAT_W          = (BURST_BEATS <= 1) ? 1 : $clog2(BURST_BEATS);
    localparam logic [7:0] AWLEN_C = 8'(BURST_BEATS - 1);
    localparam logic [BEAT_W-1:0] LAST_BEAT = BEAT_W'(BURST_BEATS - 1);

    // Buffer one whole tile. For TILE_W=16 this is 32 entries, enough to absorb
    // the full bram_to_dram tile while the AXI side emits two 16-beat bursts.
    localparam int FIFO_DEPTH   = WORDS_PER_TILE;
    localparam int FIFO_AW      = (FIFO_DEPTH <= 1) ? 1 : $clog2(FIFO_DEPTH);
    localparam int FIFO_COUNT_W = FIFO_AW + 1;
    localparam int DATA_W       = 64;
    localparam int ADDR_W       = 32;
    localparam int ENTRY_W      = DATA_W + ADDR_W;

    localparam logic [FIFO_COUNT_W-1:0] FIFO_DEPTH_C =
        FIFO_COUNT_W'(FIFO_DEPTH);
    localparam logic [FIFO_COUNT_W-1:0] BURST_BEATS_C =
        FIFO_COUNT_W'(BURST_BEATS);

    // =========================================================================
    // Tile FIFO
    // =========================================================================
    logic [ENTRY_W-1:0] fifo_mem [0:FIFO_DEPTH-1];
    logic [FIFO_AW-1:0] fifo_wr_ptr;
    logic [FIFO_AW-1:0] fifo_rd_ptr;
    logic [FIFO_COUNT_W-1:0] fifo_count;

    logic fifo_wr_fire;
    logic fifo_rd_fire;
    logic load_w_beat;
    logic fifo_full;
    logic fifo_empty;
    logic fifo_has_burst;

    assign fifo_full      = (fifo_count == FIFO_DEPTH_C);
    assign fifo_empty     = (fifo_count == '0);
    assign fifo_has_burst = (fifo_count >= BURST_BEATS_C);
    assign wr_ready       = !fifo_full;
    assign fifo_wr_fire   = wr_en && wr_ready;

    logic [ADDR_W-1:0] fifo_out_addr;
    logic [DATA_W-1:0] fifo_out_data;
    assign fifo_out_addr = fifo_mem[fifo_rd_ptr][ENTRY_W-1 : DATA_W];
    assign fifo_out_data = fifo_mem[fifo_rd_ptr][DATA_W-1  : 0];

    always_ff @(posedge clk) begin
        if (rst) begin
            fifo_wr_ptr <= '0;
            fifo_rd_ptr <= '0;
            fifo_count  <= '0;
        end else begin
            if (fifo_wr_fire) begin
                fifo_mem[fifo_wr_ptr] <= {wr_addr, wr_data};
                fifo_wr_ptr <= fifo_wr_ptr + 1'b1;
            end

            if (fifo_rd_fire)
                fifo_rd_ptr <= fifo_rd_ptr + 1'b1;

            case ({fifo_wr_fire, fifo_rd_fire})
                2'b10: fifo_count <= fifo_count + 1'b1;
                2'b01: fifo_count <= fifo_count - 1'b1;
                default: fifo_count <= fifo_count;
            endcase
        end
    end

    // =========================================================================
    // AXI fixed tie-offs
    // =========================================================================
    assign m_awid    = 6'b000000;
    assign m_awlen   = AWLEN_C;     // AXI3-safe: <= 15
    assign m_awsize  = 3'b011;      // 8 bytes / beat
    assign m_awburst = 2'b01;       // INCR
    assign m_awcache = 4'b0011;     // normal non-cacheable bufferable
    assign m_awprot  = 3'b000;
    assign m_awqos   = 4'b0000;
    assign m_wstrb   = 8'hFF;

    // =========================================================================
    // AXI burst state machine
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
    logic [BEAT_W-1:0] beat_cnt;  // beats ACCEPTED so far in the current burst

    // -------------------------------------------------------------------------
    // W channel, driven combinationally off the FIFO head.
    //
    // The burst is only started (AW issued) once a full BURST_BEATS worth of
    // words is buffered (fifo_has_burst), so once we are in SEND_W the head
    // always has a valid word to present. WVALID is therefore held continuously
    // for the whole burst, WDATA comes straight from the FIFO head, and a beat
    // is counted ONLY when it is actually accepted (WVALID && WREADY). This is
    // the invariant that keeps WLAST aligned to AWLEN: WLAST asserts on the beat
    // whose accept makes beat_cnt reach LAST_BEAT, so exactly AWLEN+1 beats are
    // terminated by WLAST regardless of any WREADY bubbles.
    // -------------------------------------------------------------------------
    logic w_beat_accept;
    assign w_beat_accept = (bstate == SEND_W) && m_wvalid && m_wready;

    assign m_wvalid = (bstate == SEND_W);
    assign m_wdata  = fifo_out_data;
    assign m_wlast  = (bstate == SEND_W) && (beat_cnt == LAST_BEAT);

    // FIFO is popped exactly when a W beat is accepted.
    assign fifo_rd_fire = w_beat_accept;
    assign load_w_beat  = w_beat_accept;  // retained for any external reference

    always_ff @(posedge clk) begin
        if (rst) begin
            bstate          <= IDLE;
            m_awaddr        <= '0;
            m_awvalid       <= 1'b0;
            m_bready        <= 1'b0;
            beat_cnt        <= '0;
            burst_base_addr <= '0;
            err_flag        <= 1'b0;
            burst_done      <= 1'b0;
        end else begin
            burst_done <= 1'b0;

            case (bstate)

                // Wait until a complete AXI3-sized burst is buffered.
                IDLE: begin
                    m_awvalid <= 1'b0;
                    m_bready  <= 1'b0;
                    beat_cnt  <= '0;

                    if (fifo_has_burst) begin
                        burst_base_addr <= fifo_out_addr;
                        m_awaddr        <= fifo_out_addr;
                        m_awvalid       <= 1'b1;
                        bstate          <= SEND_AW;
                    end
                end

                // Address first. WVALID (combinational) is suppressed until
                // SEND_W, so the slave never sees write data before AW completes.
                SEND_AW: begin
                    m_awaddr  <= burst_base_addr;
                    m_awvalid <= 1'b1;
                    beat_cnt  <= '0;

                    if (m_awvalid && m_awready) begin
                        m_awvalid <= 1'b0;
                        bstate    <= SEND_W;
                    end
                end

                // Emit exactly BURST_BEATS accepted W handshakes. WVALID/WDATA/
                // WLAST are combinational; here we only count accepted beats and
                // advance to WAIT_B once the WLAST beat is accepted.
                SEND_W: begin
                    if (w_beat_accept) begin
                        if (beat_cnt == LAST_BEAT)
                            bstate <= WAIT_B;
                        else
                            beat_cnt <= beat_cnt + 1'b1;
                    end
                end

                // Single outstanding burst, so any accepted B completes this burst.
                WAIT_B: begin
                    m_bready <= 1'b1;

                    if (m_bvalid && m_bready) begin
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

                ERROR: begin
                    m_awvalid <= 1'b0;
                    m_bready  <= 1'b1;
                end

                default: bstate <= IDLE;

            endcase
        end
    end

endmodule

// =============================================================================
// Parameterization notes
//
//   TILE_W=16 -> WORDS_PER_TILE=32, BURST_BEATS=16, AWLEN=15.
//                Each tile becomes two 128-byte AXI bursts.
//   TILE_W=8  -> WORDS_PER_TILE=8,  BURST_BEATS=8,  AWLEN=7.
//   TILE_W=32 -> WORDS_PER_TILE=128,BURST_BEATS=16, AWLEN=15.
//
// The key invariant for Zynq-7000 HP is BURST_BEATS <= 16. The module port
// keeps an 8-bit AWLEN so the existing Vivado block design does not need to be
// repackaged, but the driven value is always AXI3-safe.
// =============================================================================
