// Sits between the scheduler (push side) and 20 iterator cores (pop side)

module job_queue_handler #(
    parameter int NUM_ITER = 20
) (
    input  logic                  clk,
    input  logic                  rst,

    // Scheduler push interface 
    input  logic [17:0]           sched_coord, // { y[8:0], x[8:0] }
    input  logic                  sched_push,
    output logic                  sched_stall, // high when queue full

    // Flush from scheduler 
    input  logic                  flush,

    // Iterator request interface 
    input  logic [NUM_ITER-1:0]   wants_job,
    output logic [NUM_ITER-1:0]   grant,
    output logic [17:0]           coord_out
);

    // Internal FIFO signals
    logic        q_push, q_pop;
    logic [17:0] q_data_out;
    logic        q_full, q_empty;

    // Round-robin state
    logic [$clog2(NUM_ITER)-1:0] rr_ptr;

    job_queue u_job_queue (
        .clk      (clk),
        .rst      (rst),
        .flush    (flush),
        .push     (q_push),
        .data_in  (sched_coord),
        .pop      (q_pop),
        .data_out (q_data_out),
        .full     (q_full),
        .empty    (q_empty)
    );

    // Push side: stall scheduler if full
    assign sched_stall = q_full;
    assign q_push      = sched_push && !q_full;

    // Pop side: round-robin arbitration across wants_job signals
    // Uses a two-phase priority scan to wrap around correctly:
    //   phase A: rr_ptr .. NUM_ITER-1
    //   phase B: 0 .. rr_ptr-1
    // The winner is the lowest index in A; if none, lowest index in B.

    logic [NUM_ITER-1:0]          grant_next;
    logic [$clog2(NUM_ITER)-1:0]  winner;
    logic                          any_req;

    always_comb begin
        grant_next = '0;
        winner     = '0;
        any_req    = 1'b0;

        if (!q_empty) begin
            // Phase A: rr_ptr .. NUM_ITER-1 ascending - first match (lowest index) wins
            for (int i = 0; i < NUM_ITER; i++) begin
                if (i >= int'(rr_ptr) && wants_job[i] && !any_req) begin
                    winner  = $clog2(NUM_ITER)'(i);
                    any_req = 1'b1;
                end
            end
            // Phase B: 0 .. rr_ptr-1 ascending - only runs if phase A found nothing
            if (!any_req) begin
                for (int i = 0; i < NUM_ITER; i++) begin
                    if (i < int'(rr_ptr) && wants_job[i] && !any_req) begin
                        winner  = $clog2(NUM_ITER)'(i);
                        any_req = 1'b1;
                    end
                end
            end

            if (any_req) begin
                grant_next[winner] = 1'b1;
            end
        end
    end

    // Register outputs and advance round-robin pointer
    always_ff @(posedge clk) begin
        if (rst || flush) begin
            grant   <= '0;
            rr_ptr  <= '0;
        end else begin
            grant <= grant_next;
            if (any_req) begin
                // Advance past the winner for next arbitration
                rr_ptr <= (winner == $clog2(NUM_ITER)'(NUM_ITER-1))
                          ? '0
                          : winner + 1'b1;
            end
        end
    end

    // Pop the queue when a grant is being issued
    assign q_pop     = any_req;
    assign coord_out = q_data_out;

endmodule