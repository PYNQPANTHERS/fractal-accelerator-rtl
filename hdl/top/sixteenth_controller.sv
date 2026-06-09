// FSM that sequences all 16 sixteenths of a 1024x1024 render
// Sixteenth layout: row-major, 4 columns x 4 rows, each 256x256 pixels

module sixteenth_controller (
    input  logic clk,
    input  logic rst,

    // PS start trigger
    input  logic ps_start,

    // Config inputs from PS AXI registers
    input  logic [4:0]  cfg_fractal_type,
    input  logic [31:0] cfg_pan_x,
    input  logic [31:0] cfg_pan_y,
    input  logic [31:0] cfg_zoom_level,
    input  logic [11:0] cfg_max_iter,
    input  logic [31:0] cfg_image_base_addr,

    // Engine reset (assert in IDLE, LOAD, NEXT; deassert in RENDER)
    output logic engine_rst,

    // Engine control
    output logic start,

    // Registered config outputs to per_sixteenth_engine
    output logic [4:0]  fractal_type,
    output logic [31:0] pan_x,
    output logic [31:0] pan_y,
    output logic [31:0] zoom_level,
    output logic [11:0] max_iter,
    output logic [9:0]  x_offset,
    output logic [9:0]  y_offset,
    output logic [3:0]  sixteenth_id,
    output logic [31:0] sixteenth_base_addr,

    // Engine done signal
    input  logic sixteenth_complete,

    // Interrupt to PS
    output logic all_done,

    // PS handshake: high from first RENDER cycle until IDLE (PS should not re-assert ps_start while high)
    output logic started
);

    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        RENDER,
        NEXT
    } state_t;

    state_t      state;
    logic [3:0]  sixteenth_index;
    logic [1:0]  sixteenth_col;
    logic [1:0]  sixteenth_row;
    logic        start_fired;  // one-shot arm: cleared by engine_rst, set when start pulse is sent

    assign sixteenth_col = sixteenth_index[1:0];
    assign sixteenth_row = sixteenth_index[3:2];

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
            pan_x               <= '0;
            pan_y               <= '0;
            zoom_level          <= '0;
            max_iter            <= '0;
            x_offset            <= '0;
            y_offset            <= '0;
            sixteenth_id        <= '0;
            sixteenth_base_addr <= '0;
        end else begin
            all_done <= 1'b0;
            start    <= 1'b0;  // default: pulse low every cycle

            // Clear one-shot arm whenever engine_rst is asserted (IDLE/LOAD/NEXT)
            if (engine_rst) start_fired <= 1'b0;

            case (state)

                IDLE: begin
                    engine_rst      <= 1'b1;
                    started         <= 1'b0;
                    sixteenth_index <= 4'd0;
                    if (ps_start) begin
                        fractal_type <= cfg_fractal_type;
                        pan_x       <= cfg_pan_x;
                        pan_y       <= cfg_pan_y;
                        zoom_level  <= cfg_zoom_level;
                        max_iter    <= cfg_max_iter;
                        state       <= LOAD;
                    end
                end

                LOAD: begin
                    engine_rst          <= 1'b1;
                    // started stays high — PS should not send another request mid-render
                    x_offset            <= {sixteenth_col, 8'b0};
                    y_offset            <= {sixteenth_row, 8'b0};
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
                    started    <= 1'b1;  // still busy between sixteenths
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
