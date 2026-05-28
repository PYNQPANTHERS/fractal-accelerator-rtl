// state_bram.sv
// Packed 2-bit state storage for one 256x256 sixteenth.
// 4 pixels per byte, tile-ordered addressing.
// State: 00=uncomputed, 01=in-progress, 11=done, 10=unused
//
// Reset: memory is initialised to 00 via initial block (BRAM init data).
// rst only gates the output register — memory contents are not cleared.
// In normal use, sixteenth_controller writes 00 to state BRAM before
// each sixteenth via the write port rather than relying on rst.

module state_bram (
    input  logic        clk,
    input  logic        rst,

    input  logic [8:0]  a_x,
    input  logic [8:0]  a_y,
    input  logic        a_rd,
    input  logic        a_we,
    input  logic [1:0]  a_wstate,
    output logic [1:0]  a_rstate
);

    (* ram_style = "block" *)
    logic [7:0] mem [0:16383];

    logic [15:0] tile_addr;
    logic [13:0] byte_addr;
    logic [1:0]  bit_slot;

    assign tile_addr = {a_y[7:4], a_x[7:4], a_y[3:0], a_x[3:0]};
    assign byte_addr = tile_addr[15:2];
    assign bit_slot  = tile_addr[1:0];

    // Registered read
    logic [7:0] rd_byte;
    logic       post_rst;

    always_ff @(posedge clk) begin
        if (rst)
            post_rst <= 1'b1;
        else if (a_rd)
            post_rst <= 1'b0;
        if (a_rd)
            rd_byte <= mem[byte_addr];
    end

    logic [7:0] rd_byte_out;
    assign rd_byte_out = post_rst ? 8'h00 : rd_byte;

    always_comb begin
        case (bit_slot)
            2'b00: a_rstate = rd_byte_out[1:0];
            2'b01: a_rstate = rd_byte_out[3:2];
            2'b10: a_rstate = rd_byte_out[5:4];
            default: a_rstate = rd_byte_out[7:6];
        endcase
    end

    // Read-modify-write
    logic [7:0] cur_byte, new_byte;
    assign cur_byte = mem[byte_addr];

    always_comb begin
        new_byte = cur_byte;
        case (bit_slot)
            2'b00: new_byte[1:0] = a_wstate;
            2'b01: new_byte[3:2] = a_wstate;
            2'b10: new_byte[5:4] = a_wstate;
            default: new_byte[7:6] = a_wstate;
        endcase
    end

    initial begin
        for (int i = 0; i < 16384; i++)
            mem[i] = 8'h00;
    end

    always_ff @(posedge clk) begin
        if (a_we && !rst)
            mem[byte_addr] <= new_byte;
    end

endmodule