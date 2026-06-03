// ─────────────────────────────────────────────────────────────────────────────
// frame_fsm
// ─────────────────────────────────────────────────────────────────────────────
module frame_fsm (
    input  logic clk,
    input  logic rst,

    input  logic start_flag,
    input  logic julia,
    input  logic wide,

    // scheduler handshake
    input  logic job_valid,
    output logic job_ready,

    // sequencer status
    input  logic load_last,
    input  logic any_cluster_free,

    // bram read results (valid for one cycle in bram_read's DECODE state)
    input  logic bram_miss,       // pixel not started, not done    -> dispatch
    input  logic bram_started,    // pixel in flight elsewhere      -> skip
    input  logic bram_done,       // pixel already compute          -> skip

    // strobes
    output logic check_bram,         // held high while in CHECK_BRAM state
    output logic opcode_broadcast_en,
    output logic load_c_en,
    output logic load_z_en,
    output logic start_load_pulse,
    output logic accept_pulse,
    output logic capture_winner
);

    typedef enum logic [2:0] {
        IDLE,
        OPCODE_BROADCAST,
        LOAD_C_NARROW,
        LOAD_C_WIDE,
        JOB_WAIT,
        CHECK_BRAM,
        LOAD_Z_NARROW,
        LOAD_Z_WIDE
    } my_state;

    my_state current_state, next_state;

    // accept: in JOB_WAIT, job offered, and a cluster is free
    logic accept;
    assign accept    = (current_state == JOB_WAIT) && job_valid && any_cluster_free;
    assign job_ready = (current_state == JOB_WAIT) && any_cluster_free;

    always_ff @(posedge clk) begin : state_reg
        if (rst) current_state <= IDLE;
        else     current_state <= next_state;
    end

    always_comb begin : next_state_logic
        next_state = current_state;
        unique case (current_state)
            IDLE: begin
                if (start_flag) next_state = OPCODE_BROADCAST;
            end
            OPCODE_BROADCAST: begin
                if (julia) begin
                    if (wide) next_state = LOAD_C_WIDE;
                    else      next_state = LOAD_C_NARROW;
                end else begin
                    next_state = JOB_WAIT;
                end
            end
            LOAD_C_NARROW,
            LOAD_C_WIDE: begin
                if (load_last) next_state = JOB_WAIT;
            end
            JOB_WAIT: begin
                if (accept) next_state = CHECK_BRAM;
            end
            CHECK_BRAM: begin
                // bram_read takes 2 cycles (READ_DS + DECODE) after check_bram
                // asserted; outputs are only valid in the DECODE cycle.
                if (bram_done || bram_started) begin
                    next_state = JOB_WAIT;   // pixel handled elsewhere, skip
                end else if (bram_miss) begin
                    if (wide) next_state = LOAD_Z_WIDE;
                    else      next_state = LOAD_Z_NARROW;
                end
            end
            LOAD_Z_NARROW,
            LOAD_Z_WIDE: begin
                if (load_last) next_state = JOB_WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // held high for all cycles in CHECK_BRAM; bram_read's own FSM handles
    // the 2-cycle latency and only asserts outputs in its DECODE cycle.
    assign check_bram = (current_state == CHECK_BRAM);

    assign opcode_broadcast_en = (current_state == OPCODE_BROADCAST);
    assign load_c_en           = (current_state == LOAD_C_NARROW) ||
                                 (current_state == LOAD_C_WIDE);
    assign load_z_en           = (current_state == LOAD_Z_NARROW) ||
                                 (current_state == LOAD_Z_WIDE);

    assign accept_pulse   = accept;
    assign capture_winner = accept;

    assign start_load_pulse = ((next_state == LOAD_C_NARROW)  && (current_state != LOAD_C_NARROW)) ||
                              ((next_state == LOAD_C_WIDE)    && (current_state != LOAD_C_WIDE))    ||
                              ((next_state == LOAD_Z_NARROW)  && (current_state != LOAD_Z_NARROW))  ||
                              ((next_state == LOAD_Z_WIDE)    && (current_state != LOAD_Z_WIDE));

endmodule
