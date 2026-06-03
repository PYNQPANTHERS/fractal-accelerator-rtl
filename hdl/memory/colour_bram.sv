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

    function [12:0] word_addr(input logic [8:0] x, input logic [8:0] y);
        logic [15:0] ta;
        ta = {y[7:4], x[7:4], y[3:0], x[3:0]};
        return ta[15:3];
    endfunction

    function [2:0] byte_off(input logic [8:0] x, input logic [8:0] y);
        logic [15:0] ta;
        ta = {y[7:4], x[7:4], y[3:0], x[3:0]};
        return ta[2:0];
    endfunction

    // Port A — controller dedicated read
    logic [63:0] a_rd_word;
    logic [2:0]  a_byte_off_reg;

    always_ff @(posedge clk) begin
        if (ctrl_rd_en) begin
            a_rd_word      <= mem[word_addr(ctrl_rd_x, ctrl_rd_y)];
            a_byte_off_reg <= byte_off(ctrl_rd_x, ctrl_rd_y);
        end
    end

    always_comb begin
        case (a_byte_off_reg)
            3'd0: ctrl_rd_data = a_rd_word[7:0];
            3'd1: ctrl_rd_data = a_rd_word[15:8];
            3'd2: ctrl_rd_data = a_rd_word[23:16];
            3'd3: ctrl_rd_data = a_rd_word[31:24];
            3'd4: ctrl_rd_data = a_rd_word[39:32];
            3'd5: ctrl_rd_data = a_rd_word[47:40];
            3'd6: ctrl_rd_data = a_rd_word[55:48];
            default: ctrl_rd_data = a_rd_word[63:56];
        endcase
    end

    // Port B arbitration
    assign b2d_rd_grant = b2d_rd_en && !ctrl_wr_en;

    // Read-modify-write for controller write
    logic [63:0] b_wr_word;
    logic [2:0]  wr_byte_off;
    assign wr_byte_off = byte_off(ctrl_wr_x, ctrl_wr_y);

    always_comb begin
        b_wr_word = mem[word_addr(ctrl_wr_x, ctrl_wr_y)];
        case (wr_byte_off)
            3'd0: b_wr_word[7:0]   = ctrl_wr_data;
            3'd1: b_wr_word[15:8]  = ctrl_wr_data;
            3'd2: b_wr_word[23:16] = ctrl_wr_data;
            3'd3: b_wr_word[31:24] = ctrl_wr_data;
            3'd4: b_wr_word[39:32] = ctrl_wr_data;
            3'd5: b_wr_word[47:40] = ctrl_wr_data;
            3'd6: b_wr_word[55:48] = ctrl_wr_data;
            default: b_wr_word[63:56] = ctrl_wr_data;
        endcase
    end

    always_ff @(posedge clk) begin
        if (ctrl_wr_en)
            mem[word_addr(ctrl_wr_x, ctrl_wr_y)] <= b_wr_word;
        else if (b2d_rd_en)
            b2d_rd_data <= mem[b2d_word_addr];
    end

endmodule