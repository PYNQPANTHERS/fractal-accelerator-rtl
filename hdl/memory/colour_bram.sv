// Dual-port colour storage for one 256x256 sixteenth.
// 6-bit colour padded to 8 bits, tile-ordered addressing.
//
// Write port takes a full 64-bit word — caller (bram_read_write) is responsible
// for doing a read-modify-write to merge a single byte into the existing word.

module colour_bram (
    input  logic        clk,

    input  logic [7:0]  ctrl_rd_x,
    input  logic [7:0]  ctrl_rd_y,
    input  logic        ctrl_rd_en,
    output logic [7:0]  ctrl_rd_data,

    // Full-word write: caller must do RMW externally
    input  logic [12:0] ctrl_wr_waddr,
    input  logic [63:0] ctrl_wr_word,
    input  logic        ctrl_wr_en,

    input  logic [12:0] b2d_word_addr,
    input  logic        b2d_rd_en,
    output logic        b2d_rd_grant,
    output logic [63:0] b2d_rd_data,

    // Word read for RMW — returns the 64-bit word at ctrl_rd_waddr one cycle later
    input  logic [12:0] ctrl_rmw_rd_addr,
    input  logic        ctrl_rmw_rd_en,
    output logic [63:0] ctrl_rmw_rd_data
);

    (* ram_style = "block" *)
    logic [63:0] mem [0:8191];

    initial begin
        for (int i = 0; i < 8192; i++) mem[i] = 64'h0;
    end

    // Tile address for byte read: {y[7:4], x[7:4], y[3:0], x[3:0]} → 16 bits
    logic [15:0] ctrl_rd_ta;
    logic [12:0] ctrl_rd_waddr_i;
    logic [2:0]  ctrl_rd_boff;

    assign ctrl_rd_ta      = {ctrl_rd_y[7:4], ctrl_rd_x[7:4], ctrl_rd_y[3:0], ctrl_rd_x[3:0]};
    assign ctrl_rd_waddr_i = ctrl_rd_ta[15:3];
    assign ctrl_rd_boff    = ctrl_rd_ta[2:0];

    // Port A — controller byte read (for frame_fsm bram check)
    logic [63:0] a_rd_word;
    logic [2:0]  a_byte_off_reg;

    always_ff @(posedge clk) begin
        if (ctrl_rd_en) begin
            a_rd_word      <= mem[ctrl_rd_waddr_i];
            a_byte_off_reg <= ctrl_rd_boff;
        end
    end

    always_comb
        ctrl_rd_data = a_rd_word[a_byte_off_reg*8 +: 8];

    // Port B — RMW pre-read and b2d read (arbitrated: wr beats b2d)
    // Grant is registered so it arrives on the same cycle as the data (both
    // are one cycle after the request), letting bram_to_dram capture b2d_rd_data
    // the moment grant fires rather than one cycle too early.
    always_ff @(posedge clk)
        b2d_rd_grant <= b2d_rd_en && !ctrl_wr_en && !ctrl_rmw_rd_en;

    always_ff @(posedge clk) begin
        if (ctrl_wr_en)
            mem[ctrl_wr_waddr] <= ctrl_wr_word;
        else if (ctrl_rmw_rd_en)
            ctrl_rmw_rd_data <= mem[ctrl_rmw_rd_addr];
        else if (b2d_rd_en)
            b2d_rd_data <= mem[b2d_word_addr];
    end

endmodule
