// Dual-port colour storage for one 256x256 sixteenth.
// Stores 6-bit colour values padded to 8 bits (top 2 bits unused).

module colour_bram (
    input  logic        clk,

    // Port A - control unit (single pixel, 8-bit)
    input  logic [8:0]  a_x,         // pixel x coordinate (0..255)
    input  logic [8:0]  a_y,         // pixel y coordinate (0..255)
    input  logic        a_rd,        // read enable
    input  logic        a_we,        // write enable
    input  logic [7:0]  a_wdata,     // write data ([5:0] = colour, [7:6] unused)
    output logic [7:0]  a_rdata,     // read data, valid one cycle after a_rd

    // Port B - BRAM-to-DRAM (8 pixels, 64-bit) 
    input  logic [12:0] b_word_addr, // word address (0..8191)
    input  logic        b_rd,        // read enable
    output logic [63:0] b_rdata      // read data, valid one cycle after b_rd
);

    // Memory - 8192 words × 64 bits
    (* ram_style = "block" *)
    logic [63:0] mem [0:8191];

    // Port A address decomposition
    logic [15:0] tile_addr;   // full tile-ordered pixel address
    logic [12:0] a_word_addr; // which 64-bit word this pixel lives in
    logic [2:0]  a_byte_off;  // which byte within that word (0..7)

    assign tile_addr   = { a_y[7:4], a_x[7:4], a_y[3:0], a_x[3:0] };
    assign a_word_addr = tile_addr[15:3];
    assign a_byte_off  = tile_addr[2:0];

    // Port A - read
    // Read the full 64-bit word, extract the target byte.
    logic [63:0] a_rd_word;

    always_ff @(posedge clk) begin
        if (a_rd)
            a_rd_word <= mem[a_word_addr];
    end

    // Extract correct byte from registered word - combinational after reg
    assign a_rdata = a_rd_word[a_byte_off * 8 +: 8];

    // Port A - write (read-modify-write)
    // Read current word, replace target byte, write back.
    logic [63:0] a_wr_word;

    always_comb begin
        a_wr_word = mem[a_word_addr]; // read current word (LUTRAM path for RMW)
        a_wr_word[a_byte_off * 8 +: 8] = a_wdata; // replace target byte
    end

    always_ff @(posedge clk) begin
        if (a_we)
            mem[a_word_addr] <= a_wr_word;
    end

    // Port B - read (64-bit, one cycle)
    always_ff @(posedge clk) begin
        if (b_rd)
            b_rdata <= mem[b_word_addr];
    end

endmodule