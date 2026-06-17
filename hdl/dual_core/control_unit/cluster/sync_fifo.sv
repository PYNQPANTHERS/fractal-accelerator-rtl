module sync_fifo #(
    parameter  int DW    = 32,
    parameter  int DEPTH = 8,
    // The circular pointers rely on natural wrap at a power-of-2 boundary, so the
    // physical ring is rounded up to the next power of 2 (PDEPTH). The requested
    // DEPTH need NOT be a power of 2 — extra slots are simply unused capacity.
    // This lets callers size FIFOs as CLUSTER_COUNT*2 etc. with any CLUSTER_COUNT.
    localparam int AW     = (DEPTH <= 1) ? 1 : $clog2(DEPTH),
    localparam int PDEPTH = 1 << AW
) (
    input  logic            clk,
    input  logic            rst,
    // write side
    input  logic            wr_en,
    input  logic [DW-1:0]   wr_data,
    output logic            full,
    // read side
    input  logic            rd_en,
    output logic [DW-1:0]   rd_data,
    output logic            empty
);

    logic [DW-1:0]   mem [PDEPTH];
    logic [AW:0]     wr_ptr;     // extra bit for full/empty disambiguation
    logic [AW:0]     rd_ptr;

    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[AW]     != rd_ptr[AW]) &&
                   (wr_ptr[AW-1:0] == rd_ptr[AW-1:0]);

    assign rd_data = mem[rd_ptr[AW-1:0]];

    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            if (wr_en && !full)  begin
                mem[wr_ptr[AW-1:0]] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
            end
            if (rd_en && !empty) begin
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

endmodule