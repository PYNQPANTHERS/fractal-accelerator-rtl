// 64-bit wide dual-port BRAM for 256x256 sixteenth colour storage.
// 6-bit colour padded to 8 bits, tile-ordered addressing throughout.
module colour_bram (
    input  logic        clk,

    // controller read port - dedicated, always served
    input  logic [8:0]  ctrl_rd_x,
    input  logic [8:0]  ctrl_rd_y,
    input  logic        ctrl_rd_en,
    output logic [7:0]  ctrl_rd_data,   // valid one cycle after ctrl_rd_en

    // controller write port - priority on port B
    input  logic [8:0]  ctrl_wr_x,
    input  logic [8:0]  ctrl_wr_y,
    input  logic        ctrl_wr_en,
    input  logic [7:0]  ctrl_wr_data,

    // bram-to-dram read port - port B, granted only when no controller write
    input  logic [12:0] b2d_word_addr,
    input  logic        b2d_rd_en,
    output logic        b2d_rd_grant,   // high when b2d read is being served
    output logic [63:0] b2d_rd_data     // valid one cycle after b2d_rd_grant
);

    (* ram_style = "block" *)
    logic [63:0] mem [0:8191];

    function automatic [12:0] word_addr(input logic [8:0] x, input logic [8:0] y);
        logic [15:0] ta;
        ta = {y[7:4], x[7:4], y[3:0], x[3:0]};
        return ta[15:3];
    endfunction

    function automatic [2:0] byte_off(input logic [8:0] x, input logic [8:0] y);
        logic [15:0] ta;
        ta = {y[7:4], x[7:4], y[3:0], x[3:0]};
        return ta[2:0];
    endfunction

    // port A - controller dedicated read
    logic [63:0] a_rd_word;
    logic [2:0]  a_byte_off_reg;

    always_ff @(posedge clk) begin
        if (ctrl_rd_en) begin
            a_rd_word     <= mem[word_addr(ctrl_rd_x, ctrl_rd_y)];
            a_byte_off_reg <= byte_off(ctrl_rd_x, ctrl_rd_y);
        end
    end

    assign ctrl_rd_data = a_rd_word[a_byte_off_reg * 8 +: 8];

    // port B arbitration - controller write beats b2d read
    assign b2d_rd_grant = b2d_rd_en && !ctrl_wr_en;

    logic [63:0] b_wr_word;

    always_comb begin
        b_wr_word = mem[word_addr(ctrl_wr_x, ctrl_wr_y)];
        b_wr_word[byte_off(ctrl_wr_x, ctrl_wr_y) * 8 +: 8] = ctrl_wr_data;
    end

    always_ff @(posedge clk) begin
        if (ctrl_wr_en)
            mem[word_addr(ctrl_wr_x, ctrl_wr_y)] <= b_wr_word;
        else if (b2d_rd_en)
            b2d_rd_data <= mem[b2d_word_addr];
    end

endmodule