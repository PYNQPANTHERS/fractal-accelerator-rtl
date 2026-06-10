// Thin wrapper around fifo.sv for iterator -> comparator result passing

module complete_queue (
    input  logic        clk,
    input  logic        rst,

    // Write port (from complete_queue_handler, one entry per cycle max)
    input  logic        push,
    input  logic [19:0] data_in,   // { colour[3:0], y[7:0], x[7:0] }

    // Read port (to comparator)
    input  logic        pop,
    output logic [19:0] data_out,

    output logic        full,
    output logic        empty
);

    fifo #(
        .DATA_WIDTH(20),
        .DEPTH(32)
    ) u_fifo (
        .clk      (clk),
        .rst      (rst),
        .flush    (1'b0),   // never flushed
        .push     (push),
        .data_in  (data_in),
        .pop      (pop),
        .data_out (data_out),
        .full     (full),
        .empty    (empty)
    );

endmodule