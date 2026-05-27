module framebuffer (
    input  logic        clk,
    input  logic        we,
    input  logic [7:0]  row,
    input  logic [7:0]  col,
    input  logic [7:0]  din,
    output logic [7:0]  dout
);
    logic [7:0] mem [65536];
    logic [15:0] addr;

    assign addr = {row, col};

    always_ff @(posedge clk) begin
        if (we) mem[addr] <= din;
        dout <= mem[addr];
    end
endmodule