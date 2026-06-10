module border_pixel_generator #(
    parameter int N = 8
)(
    input  logic          clk, rst, rst_start,
    input  logic          all_left_flag, all_top_flag,
    input  logic [N-1:0]  top_left_x,    top_left_y,
    input  logic [8:0]    width_pixels_x,
    output logic [N-1:0]  x_coord, y_coord,
    output logic          valid);

    typedef enum logic [2:0] {
        IDLE, TOP, BOTTOM, LEFT, RIGHT
    } side_state_t;
    side_state_t current_state, next_state;

    logic [8:0]   width;
    logic [8:0]   midpoint;
    logic [8:0]   tmp, inverse_tmp, next_tmp_val;
    logic         first_round;
    logic         last_cycle;
    logic         both_flags;

    // ── Combinational helpers ──────────────────────────────────────────────
    assign inverse_tmp       = width - 1'b1 - tmp;
    assign next_tmp_val      = tmp + ((midpoint - 1'b1) << 1);
    assign both_flags        = all_left_flag & all_top_flag;

    // True when the next RIGHT step will execute its halving (else) branch
    logic calc_halving;
    assign calc_halving = ~((next_tmp_val < width) && ~first_round);

    // Detects whether the upcoming halving step is the last subdivision level
    // needing a skip, evaluated per-flag combination:
    //   both flags    : last when next tmp <= width-2  → route RIGHT → IDLE
    //   all_left only : last when next tmp <= width_y  → skip TOP & BOTTOM
    //   all_top only  : last when next tmp <= width_x  → skip RIGHT & LEFT
    logic last_cycle_next;
    assign last_cycle_next = (next_tmp_val == (width - 2'd2));

    // ── Sequential logic ───────────────────────────────────────────────────
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            tmp           <= '0;
            width         <= '0;
            midpoint      <= '0;
            first_round   <= 1'b1;
            last_cycle    <= 1'b0;
            valid         <= 1'b0;
            x_coord       <= '0;
            y_coord       <= '0;
            current_state <= IDLE;
        end
        else begin
            if (rst_start) begin
                tmp           <= '0;
                width         <= width_pixels_x + 1'b1;
                midpoint      <= width_pixels_x + 1'b1;
                first_round   <= 1'b1;
                last_cycle    <= 1'b0;
                // The preload below re-emits the first top pixel that the `top`
                // state produces next cycle, so mark this priming cycle invalid
                // to avoid a duplicate (top_left_x, top_left_y) push.
                valid         <= 1'b0;
                x_coord       <= top_left_x;
                y_coord       <= top_left_y;
                current_state <= TOP;
            end
            else begin
                current_state <= next_state;
                // Coordinate emitted next cycle is a real border pixel whenever
                // the generator is running (any non-IDLE state).
                valid         <= (current_state != IDLE);

                case (current_state)

                    TOP: begin
                        x_coord <= N'(top_left_x + tmp);
                        y_coord <= top_left_y;
                    end

                    BOTTOM: begin
                        x_coord <= N'(top_left_x + inverse_tmp - {8'b0, all_left_flag});
                        y_coord <= N'(top_left_y + width - {8'b0, all_top_flag} - 1'b1);
                    end

                    LEFT: begin
                        x_coord <= top_left_x;
                        y_coord <= N'(top_left_y + inverse_tmp - {8'b0, all_top_flag});
                    end

                    RIGHT: begin
                        x_coord <= N'(top_left_x + width - {8'b0, all_left_flag} - 1'b1);
                        y_coord <= N'(top_left_y + tmp);
                        
                        last_cycle <= last_cycle_next;
                        if (!calc_halving) begin
                            tmp <= tmp + ((midpoint - 1'b1) << 1);
                        end
                        else begin
                            midpoint <= (midpoint + 1'b1) >> 1;
                            tmp <= ((midpoint + 1'b1) >> 1) - 1'b1;
                            first_round <= 1'b0;
                        end
                    end

                    default: begin
                        x_coord <= '0;
                        y_coord <= '0;
                    end

                endcase
            end
        end
    end

    // ── Next-state logic ───────────────────────────────────────────────────
    always_comb begin
        next_state = current_state;

        case (current_state)

            IDLE: begin
               next_state = IDLE;
            end

            TOP:    next_state = BOTTOM;

            BOTTOM: begin
                // all_top_flag: skip right & left on last cycle
                if (all_top_flag && last_cycle) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = LEFT;
                end
            end

            LEFT:  next_state = RIGHT;

            RIGHT: begin
                if(last_cycle) begin
                    next_state = IDLE;
                end
                else begin
                    if(both_flags && last_cycle_next) begin
                        next_state = IDLE;
                    end

                    else if(all_left_flag && last_cycle_next)
                        next_state = LEFT;

                    else
                        next_state = TOP;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule
