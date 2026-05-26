module core_ram #(
    parameter int CORE_COUNT = 200,
    parameter int PIXEL_WIDTH    = 40,
    localparam int ADDR_WIDTH   = $clog2(CORE_COUNT)   // = 8 bits, addresses 0..255
) (
    input  logic                    clk,
    input  logic                    we,
    input  logic [ADDR_WIDTH-1:0]   addr,
    input  logic [PIXEL_WIDTH-1:0]  din,
    output logic [PIXEL_WIDTH-1:0]  dout
);
    logic [PIXEL_WIDTH-1:0] mem [CORE_COUNT];

    always_ff @(posedge clk) begin
        if (we) mem[addr] <= din;
        dout <= mem[addr];
    end
endmodule