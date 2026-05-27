// Generic synchronous circular FIFO


module fifo #(
    parameter int DATA_WIDTH = 18,
    parameter int DEPTH      = 2048
) (
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  flush, // resets all pointers and count in one cycle

    input  logic                  push,
    input  logic [DATA_WIDTH-1:0] data_in,

    input  logic                  pop,
    output logic [DATA_WIDTH-1:0] data_out,

    output logic                  full, // asserts when count == DEPTH (writer must stall and retry)
    output logic                  empty // asserts when count == 0
);

    localparam int PTR_W = $clog2(DEPTH);
 
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [PTR_W-1:0]      head;
    logic [PTR_W-1:0]      tail;
    logic [PTR_W:0]        count;  // one extra bit to hold value DEPTH
 
    // full/empty are combinational from count
    assign full  = (count == (PTR_W+1)'(DEPTH));
    assign empty = (count == '0);
 
    // data_out is combinational from tail — always shows current head of queue
    assign data_out = mem[tail];
 
    always_ff @(posedge clk) begin
        if (rst || flush) begin
            head  <= '0;
            tail  <= '0;
            count <= '0;
        end else begin
            if (push && !full) begin
                mem[head] <= data_in;
                head      <= head + 1'b1;
            end
            if (pop && !empty) begin
                tail <= tail + 1'b1;
            end
            case ({(push && !full), (pop && !empty)})
                2'b10:   count <= count + 1'b1;
                2'b01:   count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end
 
endmodule