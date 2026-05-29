module border_pixel_chooser #(
    parameter int N = 10
)(
    input  logic          clk, rst, rst_start,
    input  logic          all_left_flag, all_top_flag,
    input  logic [N-1:0]  top_left_x,    top_left_y,
    input  logic [N-1:0]  width_pixels_x, width_pixels_y,
    output logic [N-1:0]  x_coord, y_coord
);

    typedef enum logic [2:0] {
        IDLE, calculate, top, bottom, right, left
    } side_state_t;
    side_state_t current_state, next_state;

    logic [N-1:0] width;
    logic [N-1:0] midpoint;
    logic [N-1:0] tmp, used_tmp, inverse_tmp, next_tmp_val;
    logic         first_round;
    logic         last_cycle;
    logic         both_flags;

    // ── Combinational helpers ──────────────────────────────────────────────
    assign used_tmp          = tmp - 1'b1;
    assign inverse_tmp       = width - used_tmp;
    assign next_tmp_val      = tmp <= tmp + (midpoint << 1) + 1'b1;
    assign both_flags        = all_left_flag & all_top_flag;

    // True when the calculate state will execute its halving (else) branch
    logic calc_halving;
    assign calc_halving = ~(((tmp << 1) < (top_left_x + width)) && ~first_round);

    // Detects whether the upcoming halving step is the last subdivision level
    // needing a skip, evaluated per-flag combination:
    //   both flags    : last when next tmp <= width-2  → route calculate → IDLE
    //   all_left only : last when next tmp <= width_y  → skip top & bottom
    //   all_top only  : last when next tmp <= width_x  → skip right & left
    logic last_cycle_next;
    assign last_cycle_next = calc_halving && (
        ( both_flags                    && (next_tmp_val = (width - 2'd2))) ||
        (~both_flags & all_left_flag    && (next_tmp_val = width_pixels_x)) ||
        (~both_flags & all_top_flag     && (next_tmp_val = width_pixels_y))
    );

    // ── Sequential logic ───────────────────────────────────────────────────
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            tmp           <= '0;
            width         <= '0;
            midpoint      <= '0;
            first_round   <= 1'b1;
            last_cycle    <= 1'b0;
            x_coord       <= '0;
            y_coord       <= '0;
            current_state <= IDLE;
        end
        else begin
            if (rst_start) begin
                tmp           <= '0;
                width         <= (width_pixels_x >= width_pixels_y)
                                    ? width_pixels_x : width_pixels_y;
                midpoint      <= (width_pixels_x >= width_pixels_y)
                                    ? width_pixels_x : width_pixels_y;
                first_round   <= 1'b1;
                last_cycle    <= 1'b0;
                x_coord       <= top_left_x;
                y_coord       <= top_left_y;
                current_state <= top;
            end
            else begin
                current_state <= next_state;

                case (current_state)

                    calculate: begin
                        last_cycle <= last_cycle_next;
                        if (!calc_halving) begin
                            tmp <= tmp + (midpoint << 1) + 1'b1;
                        end
                        else begin
                            midpoint <= (midpoint + 1) >> 1;
                            tmp <= (midpoint + 1) >> 1;
                            first_round <= 1'b0;
                        end
                    end

                    top: begin
                        x_coord <= top_left_x + used_tmp;
                        y_coord <= top_left_y;
                    end

                    bottom: begin
                        x_coord <= top_left_x + inverse_tmp;
                        y_coord <= top_left_y + width - 1'b1;
                    end

                    right: begin
                        x_coord <= top_left_x + width - 1'b1;
                        y_coord <= top_left_y + used_tmp;
                    end

                    left: begin
                        if(tmp == width - 2'd2) begin
                            midpoint <= (midpoint + 1) >> 1;
                            tmp <= (midpoint + 1) >> 1;
                        end
                        x_coord <= top_left_x;
                        y_coord <= top_left_y + inverse_tmp + 1'b1;
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

            IDLE: next_state = IDLE;

            calculate: begin
                if      (both_flags       && last_cycle_next) next_state = IDLE;
                // all_left_flag: skip top & bottom on last cycle
                else if (all_left_flag    && last_cycle_next) next_state = left;
                else                                          next_state = top;
            end

            top:    next_state = bottom;

            bottom: begin
                // all_top_flag: skip right & left on last cycle
                if (all_top_flag && last_cycle) next_state = IDLE;
                else                            next_state = left;
            end

            left:  next_state = left;

            right: begin
                next_state = (used_tmp == width - 1'b1) ? IDLE : calculate;
            end

            default: next_state = IDLE;

        endcase
    end
endmodule
