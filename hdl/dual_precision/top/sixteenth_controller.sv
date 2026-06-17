// Sequences all 16 sixteenths of a 1024x1024 render, row-major

module sixteenth_controller #(
    parameter int TILE_W = 16   // tile width/height in pixels (must be power of 2)
)(
    input  logic clk,
    input  logic rst,

    input  logic ps_start,

    // Config from PS AXI registers
    input  logic [4:0]  cfg_fractal_type,
    input  logic [34:0] cfg_centre_x,
    input  logic [34:0] cfg_centre_y,
    input  logic [15:0] cfg_zoom_level,
    input  logic [11:0] cfg_max_iter,
    input  logic [31:0] cfg_image_base_addr,

    output logic engine_rst,
    output logic start,

    // Registered outputs to per_sixteenth_engine
    output logic [4:0]  fractal_type,
    output logic [34:0] centre_x,
    output logic [34:0] centre_y,
    output logic [15:0] zoom_level,
    output logic [11:0] max_iter,
    output logic [3:0]  sixteenth_id,
    output logic [31:0] sixteenth_base_addr,

    input  logic sixteenth_complete,
    output logic all_done,
    output logic started  // high from first RENDER until IDLE; PS must not re-trigger while high
);

    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        RENDER,
        NEXT
    } state_t;

    state_t      state;
    logic [3:0]  sixteenth_index;
    logic        start_fired;  // one-shot arm: cleared by engine_rst, set when start pulse is sent

    always_ff @(posedge clk) begin
        if (rst) begin
            state               <= IDLE;
            sixteenth_index     <= 4'd0;
            all_done            <= 1'b0;
            start               <= 1'b0;
            start_fired         <= 1'b0;
            started             <= 1'b0;
            engine_rst          <= 1'b1;
            fractal_type        <= '0;
            centre_x               <= '0;
            centre_y               <= '0;
            zoom_level          <= '0;
            max_iter            <= '0;
            sixteenth_id        <= '0;
            sixteenth_base_addr <= '0;
        end else begin
            all_done <= 1'b0;
            start    <= 1'b0;

            if (engine_rst) start_fired <= 1'b0;

            case (state)

                IDLE: begin
                    engine_rst      <= 1'b1;
                    started         <= 1'b0;
                    sixteenth_index <= 4'd0;
                    if (ps_start) begin
                        fractal_type <= cfg_fractal_type;
                        centre_x       <= cfg_centre_x;
                        centre_y       <= cfg_centre_y;
                        zoom_level  <= cfg_zoom_level;
                        max_iter    <= cfg_max_iter;
                        state       <= LOAD;
                    end
                end

                LOAD: begin
                    engine_rst          <= 1'b1;
                    sixteenth_id        <= sixteenth_index;
                    sixteenth_base_addr <= cfg_image_base_addr +
                                          32'(sixteenth_index) * 32'd65536;
                    state <= RENDER;
                end

                RENDER: begin
                    engine_rst <= 1'b0;
                    started    <= 1'b1;
                    if (!start_fired) begin
                        start       <= 1'b1;
                        start_fired <= 1'b1;
                    end
                    if (sixteenth_complete) begin
                        state <= NEXT;
                    end
                end

                NEXT: begin
                    engine_rst <= 1'b1;
                    started    <= 1'b1;
                    if (sixteenth_index == 4'd15) begin
                        all_done <= 1'b1;
                        state    <= IDLE;
                    end else begin
                        sixteenth_index <= sixteenth_index + 4'd1;
                        state           <= LOAD;
                    end
                end

            endcase
        end
    end

endmodule
