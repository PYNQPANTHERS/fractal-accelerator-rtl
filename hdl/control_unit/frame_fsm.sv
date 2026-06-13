module frame_fsm (
    input  logic clk,
    input  logic rst,

    input  logic start_flag,
    input  logic julia,
    input  logic wide,

    input  logic load_last,  // load_sequencer done signal (used for C loading)

    output logic opcode_broadcast_en,
    output logic load_c_en,
    output logic start_load_pulse
);

    // SETTLE_1 and SETTLE_2 give cores 2 cycles to exit LOADING_OPCODES and
    // for cluster_wants_job to propagate before the prefetch loop opens.
    typedef enum logic [2:0] {
        IDLE,
        OPCODE_BROADCAST,
        LOAD_C_NARROW,
        LOAD_C_WIDE,
        SETTLE_1,
        SETTLE_2,
        RUNNING
    } my_state;

    my_state current_state, next_state;

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
                    next_state = SETTLE_1;
                end
            end
            LOAD_C_NARROW,
            LOAD_C_WIDE: begin
                if (load_last) next_state = SETTLE_1;
            end
            SETTLE_1: next_state = SETTLE_2;
            SETTLE_2: next_state = RUNNING;
            RUNNING:  next_state = RUNNING;
            default:  next_state = IDLE;
        endcase
    end

    assign opcode_broadcast_en = (current_state == OPCODE_BROADCAST);
    assign load_c_en           = (current_state == LOAD_C_NARROW) ||
                                 (current_state == LOAD_C_WIDE);

    assign start_load_pulse = ((next_state == LOAD_C_NARROW) && (current_state != LOAD_C_NARROW)) ||
                              ((next_state == LOAD_C_WIDE)   && (current_state != LOAD_C_WIDE));

endmodule
