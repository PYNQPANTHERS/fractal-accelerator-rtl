// Behavioral stub for the scheduler (quadtree FSM).

// Simplified flow:
//   1. CONFIG  - configure comparator for a 16x16 quad at the origin
//   2. PUSH    - push 4 corner pixels to the job queue
//   3. WAIT    - wait for comparator to report complete
//   4. FILL    - if uniform colour, flood-fill tile 0; either way assert engine_done
//   5. DONE    - hold engine_done until reset

`timescale 1ns/1ps

module scheduler (
    input  logic clk,
    input  logic rst,
    input  logic start,

    input  logic [4:0]  equation_id,
    input  logic [31:0] centre_x,
    input  logic [31:0] centre_y,
    input  logic [31:0] zoom_level,
    input  logic [11:0] max_iter,
    input  logic [9:0]  x_offset,
    input  logic [9:0]  y_offset,

    // Job queue push
    output logic [17:0] sched_coord,
    output logic        sched_push,
    output logic        flush,
    input  logic        sched_stall,

    // Comparator configuration
    output logic        sched_reset,
    output logic [8:0]  top_left_x,
    output logic [8:0]  top_left_y,
    output logic [8:0]  quad_size,
    output logic [10:0] expected_count,

    // Comparator results
    input  logic        differ,
    input  logic        complete,
    input  logic [5:0]  ref_colour_o,

    // tile_table quad write (flood fill path)
    output logic        tt_wr_quad_en,
    output logic [7:0]  tt_wr_quad_tlx,
    output logic [7:0]  tt_wr_quad_tly,
    output logic [7:0]  tt_wr_quad_size,
    output logic [5:0]  tt_wr_quad_colour,

    // Tile done (flood fill path)
    output logic [255:0] sched_tile_done_set,

    output logic         engine_done
);

    // 4 corner pixels of the 16x16 quad at origin: {y[8:0], x[8:0]}
    localparam logic [17:0] COORD0 = {9'd0,  9'd0};
    localparam logic [17:0] COORD1 = {9'd0,  9'd15};
    localparam logic [17:0] COORD2 = {9'd15, 9'd0};
    localparam logic [17:0] COORD3 = {9'd15, 9'd15};
    localparam int NUM_PIXELS = 4;

    typedef enum logic [2:0] { IDLE, CONFIG, PUSH, WAIT_COMP, FILL, DONE } state_t;
    state_t state;
    int     push_idx;

    // Combinational pixel select
    logic [17:0] cur_coord;
    always_comb begin
        case (push_idx)
            0:       cur_coord = COORD0;
            1:       cur_coord = COORD1;
            2:       cur_coord = COORD2;
            default: cur_coord = COORD3;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state              <= IDLE;
            push_idx           <= 0;
            sched_coord        <= '0;
            sched_push         <= 1'b0;
            flush              <= 1'b0;
            sched_reset        <= 1'b0;
            top_left_x         <= '0;
            top_left_y         <= '0;
            quad_size          <= '0;
            expected_count     <= '0;
            tt_wr_quad_en      <= 1'b0;
            tt_wr_quad_tlx     <= '0;
            tt_wr_quad_tly     <= '0;
            tt_wr_quad_size    <= '0;
            tt_wr_quad_colour  <= '0;
            sched_tile_done_set <= '0;
            engine_done        <= 1'b0;
        end else begin
            // Default: deassert all pulses
            sched_push         <= 1'b0;
            flush              <= 1'b0;
            sched_reset        <= 1'b0;
            tt_wr_quad_en      <= 1'b0;
            sched_tile_done_set <= '0;
            engine_done        <= 1'b0;

            case (state)

                IDLE: begin
                    if (start)
                        state <= CONFIG;
                end

                CONFIG: begin
                    // Pulse comparator reset with quad geometry
                    sched_reset    <= 1'b1;
                    top_left_x     <= 9'd0;
                    top_left_y     <= 9'd0;
                    quad_size      <= 9'd16;
                    expected_count <= 11'(NUM_PIXELS);
                    push_idx       <= 0;
                    state          <= PUSH;
                end

                PUSH: begin
                    if (!sched_stall) begin
                        sched_coord <= cur_coord;
                        sched_push  <= 1'b1;
                        if (push_idx == NUM_PIXELS - 1)
                            state <= WAIT_COMP;
                        else
                            push_idx <= push_idx + 1;
                    end
                end

                WAIT_COMP: begin
                    if (complete)
                        state <= FILL;
                end

                FILL: begin
                    if (!differ) begin
                        // Flood fill tile 0 (16x16 at origin)
                        tt_wr_quad_en     <= 1'b1;
                        tt_wr_quad_tlx    <= 8'd0;
                        tt_wr_quad_tly    <= 8'd0;
                        tt_wr_quad_size   <= 8'd16;   // 1 tile wide/tall
                        tt_wr_quad_colour <= ref_colour_o;
                        sched_tile_done_set[0] <= 1'b1;
                    end
                    state <= DONE;
                end

                DONE: begin
                    engine_done <= 1'b1;
                end

            endcase
        end
    end

endmodule
