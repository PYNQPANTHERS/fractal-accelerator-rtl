// job_queue_handler.sv
// Sits between the scheduler (push side) and the control unit (pop side).
// The control unit sends a single wants_job request per cycle.
// No arbitration needed — single requester only.
//
// Push side:
//   Scheduler presents sched_coord and asserts sched_push.
//   If full, sched_stall asserts and no push occurs.
//   Scheduler must hold sched_coord and sched_push until sched_stall deasserts.
//
// Pop side:
//   Control unit asserts wants_job when it needs a coordinate.
//   If queue non-empty, grant asserts and coord_out holds the coordinate.
//   If queue empty, grant stays low and control unit must wait.
//
// Flush:
//   Passed through to job_queue FIFO on quad split.

module job_queue_handler (
    input  logic        clk,
    input  logic        rst,

    // --- Scheduler push interface ---
    input  logic [17:0] sched_coord,  // { y[8:0], x[8:0] }
    input  logic        sched_push,
    output logic        sched_stall,  // asserts when queue full

    // --- Flush from scheduler ---
    input  logic        flush,

    // --- Control unit pop interface ---
    input  logic        wants_job,
    output logic        grant,
    output logic [17:0] coord_out     // { y[8:0], x[8:0] }, valid same cycle as grant
);

    logic        q_push, q_pop;
    logic [17:0] q_data_out;
    logic        q_full, q_empty;

    // ----------------------------------------------------------------
    // Job queue instance
    // ----------------------------------------------------------------
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

    // ----------------------------------------------------------------
    // Push side
    // ----------------------------------------------------------------
    assign sched_stall = q_full;
    assign q_push      = sched_push && !q_full;

    // ----------------------------------------------------------------
    // Pop side — single requester, no arbitration needed
    // ----------------------------------------------------------------
    assign q_pop = wants_job && !q_empty;

    // Register grant and coord_out so both are valid on the same cycle
    always_ff @(posedge clk) begin
        if (rst || flush) begin
            grant     <= 1'b0;
            coord_out <= '0;
        end else begin
            grant     <= wants_job && !q_empty;
            coord_out <= q_data_out;  // capture head before tail advances
        end
    end

endmodule