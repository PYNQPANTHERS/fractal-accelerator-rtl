// FSM that sequences all 16 sixteenths of a 1024x1024 render
// Sixteenth layout: row-major, 4 columns x 4 rows, each 256x256 pixels

module sixteenth_controller (
    input  logic clk,
    input  logic rst,

    // PS start trigger
    input  logic ps_start,

    // Config inputs from PS AXI registers
    input  logic [4:0]  cfg_equation_id,
    input  logic [31:0] cfg_centre_x,
    input  logic [31:0] cfg_centre_y,
    input  logic [31:0] cfg_zoom_level,
    input  logic [11:0] cfg_max_iter,
    input  logic [31:0] cfg_image_base_addr,

    // Engine reset (assert in IDLE, LOAD, NEXT; deassert in RENDER)
    output logic engine_rst,

    // Engine control
    output logic start,

    // Registered config outputs to per_sixteenth_engine
    output logic [4:0]  equation_id,
    output logic [31:0] centre_x,
    output logic [31:0] centre_y,
    output logic [31:0] zoom_level,
    output logic [11:0] max_iter,
    output logic [9:0]  x_offset,
    output logic [9:0]  y_offset,
    output logic [31:0] sixteenth_base_addr,

    // Engine done signal
    input  logic quarter_complete,

    // Interrupt to PS
    output logic all_done
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

    assign sixteenth_col = sixteenth_index[1:0];
    assign sixteenth_row = sixteenth_index[3:2];

    always_ff @(posedge clk) begin
        if (rst) begin
            state               <= IDLE;
            sixteenth_index     <= 4'd0;
            all_done            <= 1'b0;
            start               <= 1'b0;
            engine_rst          <= 1'b1;
            equation_id         <= '0;
            centre_x            <= '0;
            centre_y            <= '0;
            zoom_level          <= '0;
            max_iter            <= '0;
            x_offset            <= '0;
            y_offset            <= '0;
            sixteenth_base_addr <= '0;
        end else begin
            all_done <= 1'b0;
            start    <= 1'b0;

            case (state)

                IDLE: begin
                    engine_rst      <= 1'b1;
                    sixteenth_index <= 4'd0;
                    if (ps_start) begin
                        // TODO: connect to AXI Lite slave wrapper
                        equation_id <= cfg_equation_id;
                        centre_x    <= cfg_centre_x;
                        centre_y    <= cfg_centre_y;
                        zoom_level  <= cfg_zoom_level;
                        max_iter    <= cfg_max_iter;
                        state       <= LOAD;
                    end
                end

                LOAD: begin
                    engine_rst          <= 1'b1;
                    x_offset            <= {sixteenth_col, 8'b0};
                    y_offset            <= {sixteenth_row, 8'b0};
                    sixteenth_base_addr <= cfg_image_base_addr +
                                          32'(sixteenth_index) * 32'd66048;
                    // TODO: cache load - DMA cached tiles into colour_bram
                    state <= RENDER;
                end

                RENDER: begin
                    engine_rst <= 1'b0;
                    start      <= 1'b1;
                    if (quarter_complete) begin
                        start <= 1'b0;
                        state <= NEXT;
                    end
                end

                NEXT: begin
                    engine_rst <= 1'b1;
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
