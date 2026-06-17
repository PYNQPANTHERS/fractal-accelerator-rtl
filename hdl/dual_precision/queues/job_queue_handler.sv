// Sits between the scheduler (push side) and the control unit (pop side)
// The control unit sends a single wants_job request per cycle 

module job_queue_handler (
    input  logic        clk,
    input  logic        rst,  

    // Scheduler push interface
    input  logic [15:0] sched_coord,       // { y[7:0], x[7:0] }
    input  logic        sched_first_time,  // first_time_queued flag from scheduler
    input  logic        sched_push,
    output logic        sched_stall,       // asserts when queue full

    // Flush from scheduler
    input  logic        flush,

    // Control unit pop interface
    input  logic        wants_job,
    output logic        grant,
    output logic [15:0] coord_out,      // { y[7:0], x[7:0] }, valid same cycle as grant
    output logic        first_time_out, // first_time_queued flag, valid same cycle as grant

    output logic        queue_empty,
    output logic        queue_almost_full  // 1-cycle lookahead for generator backpressure
);

    logic        q_push, q_pop;
    logic [16:0] q_data_out;
    logic        q_full, q_almost_full, q_empty;

    // Job queue instance
    job_queue u_job_queue (
        .clk        (clk),
        .rst        (rst),
        .flush      (flush),
        .push       (q_push),
        .data_in    ({sched_first_time, sched_coord}),
        .pop        (q_pop),
        .data_out   (q_data_out),
        .full       (q_full),
        .almost_full(q_almost_full),
        .empty      (q_empty)
    );

    assign queue_almost_full = q_almost_full;

    // Push side
    assign sched_stall = q_full;
    assign q_push      = sched_push && !q_full;

    assign queue_empty = q_empty;

    // Pop side - single requester, no arbitration needed
    assign q_pop = wants_job && !q_empty && !grant;

    // Register grant and coord_out so both are valid on the same cycle
    always_ff @(posedge clk) begin
        if (rst || flush) begin
            grant          <= 1'b0;
            coord_out      <= '0;
            first_time_out <= 1'b0;
        end else begin
            grant          <= wants_job && !q_empty;
            coord_out      <= q_data_out[15:0];   // capture head before tail advances
            first_time_out <= q_data_out[16];
        end
    end

endmodule