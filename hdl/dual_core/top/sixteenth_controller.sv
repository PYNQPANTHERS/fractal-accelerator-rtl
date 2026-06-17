// Job-queue dual controller.
// A shared next_sxt counter hands out sixteenths 0-15 in order.
// Each engine claims the next job as soon as it finishes its current one —
// they never wait for each other.  Engine A has priority when both finish
// on the same clock edge.

module sixteenth_controller #(
    parameter int TILE_W = 16
)(
    input  logic clk,
    input  logic rst,

    input  logic ps_start,

    input  logic [4:0]  cfg_fractal_type,
    input  logic [34:0] cfg_centre_x,
    input  logic [34:0] cfg_centre_y,
    input  logic [15:0] cfg_zoom_level,
    input  logic [11:0] cfg_max_iter,
    input  logic [31:0] cfg_image_base_addr,

    // Independent reset + start per engine
    output logic        engine_rst_a,
    output logic        start_a,
    output logic        engine_rst_b,
    output logic        start_b,

    output logic [4:0]  fractal_type,
    output logic [34:0] centre_x,
    output logic [34:0] centre_y,
    output logic [15:0] zoom_level,
    output logic [11:0] max_iter,

    output logic [3:0]  sixteenth_id_a,
    output logic [31:0] sixteenth_base_addr_a,
    input  logic        sixteenth_complete_a,

    output logic [3:0]  sixteenth_id_b,
    output logic [31:0] sixteenth_base_addr_b,
    input  logic        sixteenth_complete_b,

    output logic        all_done,
    output logic        started
);

    typedef enum logic [1:0] { ENG_IDLE, ENG_LOAD, ENG_RENDER } eng_state_t;
    eng_state_t state_a, state_b;

    logic [4:0] next_sxt;       // next sixteenth to be claimed (0-15; 16 = all dispatched)
    logic [3:0] cur_sxt_a;      // sixteenth currently loaded/rendering by engine A
    logic [3:0] cur_sxt_b;
    logic       start_fired_a;  // one-shot: cleared each LOAD, set after start_a pulse
    logic       start_fired_b;
    logic       busy;            // high while a render is in progress

    // ── Claim logic (combinational) ───────────────────────────────────────────
    // An engine "claims" when it needs a new job.
    // Engine A has priority: if both claim simultaneously A takes next_sxt,
    // B takes next_sxt+1.

    logic       a_claiming, b_claiming;
    logic [4:0] sxt_for_a, sxt_for_b;
    logic       a_gets_job, b_gets_job;

    assign a_claiming = ((state_a == ENG_IDLE)   && ps_start) ||
                        ((state_a == ENG_RENDER)  && sixteenth_complete_a);

    assign b_claiming = ((state_b == ENG_IDLE)   && ps_start) ||
                        ((state_b == ENG_RENDER)  && sixteenth_complete_b);

    assign sxt_for_a  = next_sxt;
    assign sxt_for_b  = a_claiming ? (next_sxt + 5'd1) : next_sxt;

    assign a_gets_job = a_claiming && (sxt_for_a < 5'd16);
    assign b_gets_job = b_claiming && (sxt_for_b < 5'd16);

    always_ff @(posedge clk) begin
        if (rst) begin
            state_a               <= ENG_IDLE;
            state_b               <= ENG_IDLE;
            next_sxt              <= 5'd0;
            busy                  <= 1'b0;
            all_done              <= 1'b0;
            started               <= 1'b0;
            start_a               <= 1'b0;
            start_b               <= 1'b0;
            start_fired_a         <= 1'b0;
            start_fired_b         <= 1'b0;
            engine_rst_a          <= 1'b1;
            engine_rst_b          <= 1'b1;
            fractal_type          <= '0;
            centre_x                 <= '0;
            centre_y                 <= '0;
            zoom_level            <= '0;
            max_iter              <= '0;
            cur_sxt_a             <= '0;
            cur_sxt_b             <= '0;
            sixteenth_id_a        <= '0;
            sixteenth_id_b        <= '0;
            sixteenth_base_addr_a <= '0;
            sixteenth_base_addr_b <= '0;
        end else begin
            start_a  <= 1'b0;
            start_b  <= 1'b0;
            all_done <= 1'b0;

            // ── Advance shared counter whenever jobs are claimed ───────────────
            if (a_gets_job && b_gets_job)
                next_sxt <= next_sxt + 5'd2;
            else if (a_gets_job || b_gets_job)
                next_sxt <= next_sxt + 5'd1;

            // ── Latch config once per render (guarded so PS can't re-trigger) ──
            if (ps_start && !busy) begin
                fractal_type <= cfg_fractal_type;
                centre_x        <= cfg_centre_x;
                centre_y        <= cfg_centre_y;
                zoom_level   <= cfg_zoom_level;
                max_iter     <= cfg_max_iter;
                busy         <= 1'b1;
                started      <= 1'b1;
            end

            // ── Engine A independent FSM ──────────────────────────────────────
            case (state_a)
                ENG_IDLE: begin
                    engine_rst_a  <= 1'b1;
                    start_fired_a <= 1'b0;
                    if (a_gets_job) begin
                        cur_sxt_a <= sxt_for_a[3:0];
                        state_a   <= ENG_LOAD;
                    end
                end

                ENG_LOAD: begin
                    engine_rst_a          <= 1'b1;
                    start_fired_a         <= 1'b0;
                    sixteenth_id_a        <= cur_sxt_a;
                    sixteenth_base_addr_a <= cfg_image_base_addr +
                                            32'(cur_sxt_a) * 32'd65536;
                    state_a               <= ENG_RENDER;
                end

                ENG_RENDER: begin
                    engine_rst_a <= 1'b0;
                    if (!start_fired_a) begin
                        start_a       <= 1'b1;
                        start_fired_a <= 1'b1;
                    end
                    if (a_claiming) begin
                        if (a_gets_job) begin
                            cur_sxt_a <= sxt_for_a[3:0];
                            state_a   <= ENG_LOAD;
                        end else begin
                            state_a <= ENG_IDLE;
                        end
                    end
                end
            endcase

            // ── Engine B independent FSM ──────────────────────────────────────
            case (state_b)
                ENG_IDLE: begin
                    engine_rst_b  <= 1'b1;
                    start_fired_b <= 1'b0;
                    if (b_gets_job) begin
                        cur_sxt_b <= sxt_for_b[3:0];
                        state_b   <= ENG_LOAD;
                    end
                end

                ENG_LOAD: begin
                    engine_rst_b          <= 1'b1;
                    start_fired_b         <= 1'b0;
                    sixteenth_id_b        <= cur_sxt_b;
                    sixteenth_base_addr_b <= cfg_image_base_addr +
                                            32'(cur_sxt_b) * 32'd65536;
                    state_b               <= ENG_RENDER;
                end

                ENG_RENDER: begin
                    engine_rst_b <= 1'b0;
                    if (!start_fired_b) begin
                        start_b       <= 1'b1;
                        start_fired_b <= 1'b1;
                    end
                    if (b_claiming) begin
                        if (b_gets_job) begin
                            cur_sxt_b <= sxt_for_b[3:0];
                            state_b   <= ENG_LOAD;
                        end else begin
                            state_b <= ENG_IDLE;
                        end
                    end
                end
            endcase

            // ── All done: both engines idle after all 16 dispatched ───────────
            // Fires one cycle after the last engine transitions to ENG_IDLE.
            if (busy && state_a == ENG_IDLE && state_b == ENG_IDLE &&
                    next_sxt >= 5'd16) begin
                all_done <= 1'b1;
                started  <= 1'b0;
                busy     <= 1'b0;
                next_sxt <= 5'd0;
            end
        end
    end

endmodule
