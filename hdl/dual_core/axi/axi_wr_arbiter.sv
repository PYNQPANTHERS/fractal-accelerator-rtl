// 2-input write arbiter for the bram_to_dram -> axi_hp_master_wrap interface.
//
// Grant switches only when the current holder signals sixteenth_complete — i.e.
// its bram_to_dram has transferred every tile of that sixteenth to DRAM. This is
// the only safe boundary: mid-sixteenth tile gaps look identical to end-of-
// sixteenth from the wr_en signal alone, so wr_en idleness cannot be used.

module axi_wr_arbiter (
    input  logic        clk,
    input  logic        rst,

    // Engine A
    input  logic [31:0] a_wr_addr,
    input  logic [63:0] a_wr_data,
    input  logic        a_wr_en,
    output logic        a_wr_ready,
    input  logic        a_complete,   // bram_to_dram sixteenth_complete (level)

    // Engine B
    input  logic [31:0] b_wr_addr,
    input  logic [63:0] b_wr_data,
    input  logic        b_wr_en,
    output logic        b_wr_ready,
    input  logic        b_complete,   // bram_to_dram sixteenth_complete (level)

    // Shared downstream (-> axi_hp_master_wrap)
    output logic [31:0] wr_addr,
    output logic [63:0] wr_data,
    output logic        wr_en,
    input  logic        wr_ready
);

    // grant: 0 = engine A holds the bus, 1 = engine B
    logic grant;

    // Grant switches on the *_complete LEVEL signals, NOT on the peer's per-word
    // wr_en pulse. The old condition (a_complete && b_wr_en) deadlocked at end of
    // frame: when the holder (A) finished its LAST sixteenth (a_complete held high)
    // while the peer (B) still had its final sixteenth to drain, the switch needed
    // a_complete and b_wr_en to coincide — but b_wr_en is a gapped per-word pulse
    // and A's complete could clear (engine reset) before they lined up, stranding
    // B's whole sixteenth (the 7680 = 15x512 hang: the 16th sixteenth issues ZERO
    // bursts). Releasing the bus the moment the holder is complete fixes it: a
    // holder only reaches *_complete after draining all its tiles, so no data is
    // lost. The !peer_complete guard prevents the grant oscillating between two
    // idle engines once BOTH have finished at end of frame.
    always_ff @(posedge clk) begin
        if (rst) begin
            grant <= 1'b0;
        end else begin
            case (grant)
                1'b0: if (a_complete && !b_complete) grant <= 1'b1;  // A done, hand bus to B
                1'b1: if (b_complete && !a_complete) grant <= 1'b0;  // B done, hand bus to A
            endcase
        end
    end

    // Fully combinational mux — zero latency in both directions
    always_comb begin
        if (grant == 1'b0) begin
            wr_addr    = a_wr_addr;
            wr_data    = a_wr_data;
            wr_en      = a_wr_en;
            a_wr_ready = wr_ready;
            b_wr_ready = 1'b0;
        end else begin
            wr_addr    = b_wr_addr;
            wr_data    = b_wr_data;
            wr_en      = b_wr_en;
            a_wr_ready = 1'b0;
            b_wr_ready = wr_ready;
        end
    end

endmodule
