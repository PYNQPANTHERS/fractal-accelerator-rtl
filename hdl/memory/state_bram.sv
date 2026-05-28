// Packed 2-bit state storage for one 256x256 sixteenth.

module state_bram (
    input  logic        clk,
    input  logic        rst,

    // Port A - control unit
    input  logic [8:0]  a_x,          // pixel x coordinate (0..255)
    input  logic [8:0]  a_y,          // pixel y coordinate (0..255)
    input  logic        a_rd,         // read enable
    input  logic        a_we,         // write enable
    input  logic [1:0]  a_wstate,     // state to write
    output logic [1:0]  a_rstate      // state read out, valid one cycle after a_rd
);

    // Memory - 16,384 bytes, each holding 4 pixel states
    (* ram_style = "block" *)
    logic [7:0] mem [0:16383];

    // Address computation
    // Tile-ordered pixel address = { y[7:4], x[7:4], y[3:0], x[3:0] }
    // Byte address = tile_ordered_addr[15:2]  (upper 14 bits)
    // Bit slot     = tile_ordered_addr[1:0]   (lower 2 bits → which pair)
    logic [15:0] tile_addr;
    logic [13:0] byte_addr;
    logic [1:0]  bit_slot;

    assign tile_addr = { a_y[7:4], a_x[7:4], a_y[3:0], a_x[3:0] };
    assign byte_addr = tile_addr[15:2];
    assign bit_slot  = tile_addr[1:0];

    // Read - registered, extract correct 2-bit slot
    logic [7:0] rd_byte;

    always_ff @(posedge clk) begin
        if (a_rd)
            rd_byte <= mem[byte_addr];
    end

    always_comb begin
        case (bit_slot)
            2'b00: a_rstate = rd_byte[1:0];
            2'b01: a_rstate = rd_byte[3:2];
            2'b10: a_rstate = rd_byte[5:4];
            2'b11: a_rstate = rd_byte[7:6];
        endcase
    end

    // Write - read-modify-write to update the correct 2-bit slot
    logic [7:0] cur_byte;
    logic [7:0] new_byte;

    always_comb begin
        cur_byte = mem[byte_addr]; // combinational read for RMW
        new_byte = cur_byte;
        case (bit_slot)
            2'b00: new_byte[1:0] = a_wstate;
            2'b01: new_byte[3:2] = a_wstate;
            2'b10: new_byte[5:4] = a_wstate;
            2'b11: new_byte[7:6] = a_wstate;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            // Clear all state to 00 (uncomputed) on reset
            for (int i = 0; i < 16384; i++) // COULD CAUSE CRITICAL PATH ISSUES
                mem[i] <= 8'h00;
        end else if (a_we) begin
            mem[byte_addr] <= new_byte;
        end
    end

endmodule