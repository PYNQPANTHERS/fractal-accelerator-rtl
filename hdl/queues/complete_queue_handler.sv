// Sits between the control unit (push side) and the comparator (pop side)
// The control unit sends a single done signal with payload per cycle


module complete_queue_handler (
    input  logic        clk,
    input  logic        rst,

    // Control unit push interface 
    input  logic        done,
    input  logic [8:0]  iter_x,
    input  logic [8:0]  iter_y,
    input  logic [3:0]  iter_colour,

    // Comparator pop interface
    input  logic        comp_pop,     // comparator consumes one entry
    output logic        comp_valid,   // queue non-empty
    output logic [21:0] comp_data,    // { colour[3:0], y[8:0], x[8:0] }

    // Debug 
    output logic        full_err      // pulses if push attempted when full
);

    logic        q_push;
    logic [21:0] q_data_in;
    logic        q_full, q_empty;

    complete_queue u_complete_queue (
        .clk      (clk),
        .rst      (rst),
        .push     (q_push),
        .data_in  (q_data_in),
        .pop      (comp_pop),
        .data_out (comp_data),
        .full     (q_full),
        .empty    (q_empty)
    );

    // Push side
    assign q_data_in = { iter_colour, iter_y, iter_x };
    assign q_push    = done && !q_full;
    assign full_err  = done &&  q_full;

    // Pop side - purely combinational, comparator drives comp_pop
    assign comp_valid = !q_empty;

endmodule