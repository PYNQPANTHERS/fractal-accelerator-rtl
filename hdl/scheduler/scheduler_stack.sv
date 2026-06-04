module scheduler_stack #(
    parameter WIDTH = 32,      // Number of bits to save per level
    parameter DEPTH = 3       // Max zoom depth (determines pointer width)
)(
    input  logic              clk,
    input  logic              rst,
    input  logic              push,
    input  logic              pop,
    input  logic [WIDTH-1:0]  data_in,
    output logic [WIDTH-1:0]  data_out,
    output logic              full,
    output logic              empty
);

    // Local pointer tracking stack depth
    localparam PTR_WIDTH = $clog2(DEPTH);
    logic [PTR_WIDTH-1:0] stack_ptr;

    // Memory array (will infer BRAM if large enough)
    logic [WIDTH-1:0] stack_mem [0:DEPTH-1];

    // Status Flags
    assign empty = (stack_ptr == 0);
    assign full  = (stack_ptr == DEPTH - 1);

    // Sequential Read/Write and Pointer Management
    // (Upwards growing stack)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            stack_ptr <= '0;
            data_out  <= '0;
        end
        else begin
            if (push && !full) begin
                stack_mem[stack_ptr] <= data_in;
                stack_ptr            <= stack_ptr + 1;
            end
            else if (pop && !empty) begin
                stack_ptr            <= stack_ptr - 1;
                // Read the data that was at the top of the stack
                data_out             <= stack_mem[stack_ptr - 1]; 
            end
        end
    end

endmodule