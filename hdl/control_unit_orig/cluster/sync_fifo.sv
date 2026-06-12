// ─────────────────────────────────────────────────────────────────────────────
// sync_fifo
//   Synchronous FIFO.
//   - DEPTH must be a power of 2 for the wrap-around counter to work simply might need higher incase of jobs finishing before emptying 
//   - Standard "show-ahead"
// ─────────────────────────────────────────────────────────────────────────────
module sync_fifo #(
    parameter  int DW    = 32,
    parameter  int DEPTH = 8,
    localparam int AW    = $clog2(DEPTH)
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

    logic [DW-1:0]   mem [DEPTH];
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