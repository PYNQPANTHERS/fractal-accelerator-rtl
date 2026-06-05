// Dual-port colour storage for one 256x256 sixteenth.
// 6-bit colour padded to 8 bits, tile-ordered addressing.

module colour_bram (
    input  logic        clk,

    input  logic [8:0]  ctrl_rd_x,
    input  logic [8:0]  ctrl_rd_y,
    input  logic        ctrl_rd_en,
    output logic [7:0]  ctrl_rd_data,

    input  logic [8:0]  ctrl_wr_x,
    input  logic [8:0]  ctrl_wr_y,
    input  logic        ctrl_wr_en,
    input  logic [7:0]  ctrl_wr_data,

    input  logic [12:0] b2d_word_addr,
    input  logic        b2d_rd_en,
    output logic        b2d_rd_grant,
    output logic [63:0] b2d_rd_data
);

    (* ram_style = "block" *)
    logic [63:0] mem [0:8191];

    // Tile address: {y[7:4], x[7:4], y[3:0], x[3:0]} → 16 bits; [15:3]=word, [2:0]=byte
    logic [15:0] ctrl_rd_ta, ctrl_wr_ta;
    logic [12:0] ctrl_rd_waddr, ctrl_wr_waddr;
    logic [2:0]  ctrl_rd_boff,  ctrl_wr_boff;

    assign ctrl_rd_ta    = {ctrl_rd_y[7:4], ctrl_rd_x[7:4], ctrl_rd_y[3:0], ctrl_rd_x[3:0]};
    assign ctrl_wr_ta    = {ctrl_wr_y[7:4], ctrl_wr_x[7:4], ctrl_wr_y[3:0], ctrl_wr_x[3:0]};
    assign ctrl_rd_waddr = ctrl_rd_ta[15:3];
    assign ctrl_wr_waddr = ctrl_wr_ta[15:3];
    assign ctrl_rd_boff  = ctrl_rd_ta[2:0];
    assign ctrl_wr_boff  = ctrl_wr_ta[2:0];

    // Port A — controller dedicated read
    logic [63:0] a_rd_word;
    logic [2:0]  a_byte_off_reg;

    always_ff @(posedge clk) begin
        if (ctrl_rd_en) begin
            a_rd_word      <= mem[ctrl_rd_waddr];
            a_byte_off_reg <= ctrl_rd_boff;
        end
    end

    always_comb
        ctrl_rd_data = a_rd_word[a_byte_off_reg*8 +: 8];

    // Port B arbitration
    assign b2d_rd_grant = b2d_rd_en && !ctrl_wr_en;

    // Read-modify-write for controller write
    logic [63:0] b_wr_word;

    always_comb begin
        b_wr_word = mem[ctrl_wr_waddr];
        b_wr_word[ctrl_wr_boff*8 +: 8] = ctrl_wr_data;
    end

    always_ff @(posedge clk) begin
        if (ctrl_wr_en)
            mem[ctrl_wr_waddr] <= b_wr_word;
        else if (b2d_rd_en)
            b2d_rd_data <= mem[b2d_word_addr];
    end

endmodule
