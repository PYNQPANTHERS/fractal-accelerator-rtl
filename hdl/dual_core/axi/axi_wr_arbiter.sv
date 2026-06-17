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

    always_ff @(posedge clk) begin
        if (rst) begin
            grant <= 1'b0;
        end else begin
            case (grant)
                // A holds grant: switch to B only after A's sixteenth is complete
                // and B is actually requesting (avoid pointless switch to idle B)
                1'b0: if (a_complete && b_wr_en) grant <= 1'b1;
                // B holds grant: switch back to A after B's sixteenth is complete
                1'b1: if (b_complete && a_wr_en) grant <= 1'b0;
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
