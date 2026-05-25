// Sits between 20 iterator cores (push side) and the comparator (pop side)

module complete_queue_handler #(
    parameter int NUM_ITER = 20
) (
    input  logic                  clk,
    input  logic                  rst,

    // Iterator result interface
    input  logic [NUM_ITER-1:0]       done,
    input  logic [NUM_ITER-1:0][8:0]  iter_x,
    input  logic [NUM_ITER-1:0][8:0]  iter_y,
    input  logic [NUM_ITER-1:0][3:0]  iter_colour,

    // Comparator interface 
    input  logic        comp_pop,    // comparator consumes one entry
    output logic        comp_valid,  // queue non-empty
    output logic [21:0] comp_data,   // { colour[3:0], y[8:0], x[8:0] }

    // Debug 
    output logic        full_err     // pulsed if a push is dropped due to full
);

    // Internal FIFO signals
    logic        q_push;
    logic [21:0] q_data_in;
    logic [21:0] q_data_out;
    logic        q_full, q_empty;

    // Round-robin state
    logic [$clog2(NUM_ITER)-1:0] rr_ptr;

    complete_queue u_complete_queue (
        .clk      (clk),
        .rst      (rst),
        .push     (q_push),
        .data_in  (q_data_in),
        .pop      (comp_pop),
        .data_out (q_data_out),
        .full     (q_full),
        .empty    (q_empty)
    );

    // Comparator pop side (purely combinational)
    assign comp_valid = !q_empty;
    assign comp_data  = q_data_out;

    // Push side: round-robin arbitration across done signals

    logic [$clog2(NUM_ITER)-1:0] winner;
    logic                         any_done;

     always_comb begin
        winner   = '0;
        any_done = 1'b0;
 
        // Phase A: rr_ptr .. NUM_ITER-1 ascending - first match (lowest index) wins
        for (int i = 0; i < NUM_ITER; i++) begin
            if (i >= int'(rr_ptr) && done[i] && !any_done) begin
                winner   = $clog2(NUM_ITER)'(i);
                any_done = 1'b1;
            end
        end
        // Phase B: 0 .. rr_ptr-1 ascending - only runs if phase A found nothing
        if (!any_done) begin
            for (int i = 0; i < NUM_ITER; i++) begin
                if (i < int'(rr_ptr) && done[i] && !any_done) begin
                    winner   = $clog2(NUM_ITER)'(i);
                    any_done = 1'b1;
                end
            end
        end
    end

    // Pack winning iterator's payload into FIFO entry format
    assign q_data_in = { iter_colour[winner], iter_y[winner], iter_x[winner] };
    assign q_push    = any_done && !q_full;
    assign full_err  = any_done &&  q_full; // should never fire

    // Advance round-robin pointer on each successful push
    always_ff @(posedge clk) begin
        if (rst) begin
            rr_ptr <= '0;
        end else if (any_done) begin
            rr_ptr <= (winner == $clog2(NUM_ITER)'(NUM_ITER-1))
                      ? '0
                      : winner + 1'b1;
        end
    end

endmodule