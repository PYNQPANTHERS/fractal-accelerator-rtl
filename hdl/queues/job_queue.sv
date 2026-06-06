// Thin wrapper around fifo.sv for scheduler -> iterator work distribution.

module job_queue (
    input  logic        clk,
    input  logic        rst,
    input  logic        flush,

    // Write port (from job_queue_handler on behalf of scheduler)
    input  logic        push,
    input  logic [15:0] data_in,   // { y[7:0], x[7:0] }

    // Read port (to job_queue_handler for iterator dispatch)
    input  logic        pop,
    output logic [15:0] data_out,

    output logic        full,
    output logic        empty
);

    fifo #(
        .DATA_WIDTH(16),
        .DEPTH(2048)
    ) u_fifo (
        .clk      (clk),
        .rst      (rst),
        .flush    (flush),
        .push     (push),
        .data_in  (data_in),
        .pop      (pop),
        .data_out (data_out),
        .full     (full),
        .empty    (empty)
    );

endmodule