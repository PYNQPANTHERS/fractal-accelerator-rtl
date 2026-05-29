// Behavioral stub for the control_unit (iterator pool manager).
// On each job from the job queue the stub:
//   1. Issues simultaneous reads of state_bram and colour_bram (READ state).
//   2. Waits one cycle for the registered BRAM outputs to settle (WAIT state).
//   3. If state_bram returned 2'b11 (done), forwards the cached colour from
//      colour_bram to the complete queue without recomputing.
//   4. Otherwise computes the pixel (stub: fixed STUB_COLOUR), writes the
//      result to colour_bram, marks the pixel done in state_bram, and pushes
//      to the complete queue (OUTPUT state).
//
// All control outputs are driven combinationally from the FSM state so that
// the BRAMs see the correct enables exactly on the relevant clock edge.

`timescale 1ns/1ps

module control_unit (
    input  logic clk,
    input  logic rst,

    input  logic [4:0]  equation_id,
    input  logic [31:0] centre_x,
    input  logic [31:0] centre_y,
    input  logic [31:0] zoom_level,
    input  logic [11:0] max_iter,
    input  logic [9:0]  x_offset,
    input  logic [9:0]  y_offset,

    // Job queue pop
    output logic        wants_job,
    input  logic        grant,
    input  logic [17:0] coord_out,

    // Complete queue push
    output logic        done,
    output logic [8:0]  iter_x,
    output logic [8:0]  iter_y,
    output logic [3:0]  iter_colour,

    // colour_bram read (check cached colour if pixel already computed)
    output logic [8:0]  cu_rd_x,
    output logic [8:0]  cu_rd_y,
    output logic        cu_rd_en,
    input  logic [7:0]  cu_rd_data,

    // colour_bram write (store computed colour)
    output logic [8:0]  cu_wr_x,
    output logic [8:0]  cu_wr_y,
    output logic        cu_wr_en,
    output logic [7:0]  cu_wr_data,

    // state_bram (Port A) - read and write
    output logic [8:0]  sb_x,
    output logic [8:0]  sb_y,
    output logic        sb_rd,
    output logic        sb_we,
    output logic [1:0]  sb_wstate,
    input  logic [1:0]  sb_rstate,

    // tile_table single write (tiled path - unused in stub)
    output logic        tt_wr_single_en,
    output logic [7:0]  tt_wr_single_index,
    output logic        tt_wr_single_filled,
    output logic [5:0]  tt_wr_single_colour,

    // Tile done (tiled path - unused in stub)
    output logic [255:0] cu_tile_done_set
);

    localparam logic [3:0] STUB_COLOUR = 4'd5;

    typedef enum logic [1:0] { S_IDLE, S_READ, S_WAIT, S_OUTPUT } state_t;
    state_t state;

    logic [8:0]  px, py;           // latched pixel coordinate
    logic        already_done;     // 1 when state_bram returned 2'b11
    logic [3:0]  cached_colour;    // colour_bram result when already_done

    // Tiled-path outputs - unused in stub
    assign tt_wr_single_en     = 1'b0;
    assign tt_wr_single_index  = 8'b0;
    assign tt_wr_single_filled = 1'b0;
    assign tt_wr_single_colour = 6'b0;
    assign cu_tile_done_set    = '0;

    // Combinational output mux - driven by FSM state

    // Request a job when idle and no grant is already in-flight.
    // Gating with !grant prevents job_queue_handler from popping a second entry
    // (and issuing a wasted grant) at the same rising edge the FSM accepts the
    // current grant and transitions to S_READ.
    assign wants_job = (state == S_IDLE) && !grant;

    // Read both BRAMs together in S_READ; address held stable throughout
    assign sb_rd   = (state == S_READ);
    assign sb_x    = px;
    assign sb_y    = py;
    assign cu_rd_en = (state == S_READ);
    assign cu_rd_x  = px;
    assign cu_rd_y  = py;

    // Write to both BRAMs in S_OUTPUT (only when pixel was not already done)
    assign cu_wr_en   = (state == S_OUTPUT) && !already_done;
    assign cu_wr_x    = px;
    assign cu_wr_y    = py;
    assign cu_wr_data = {4'b0, STUB_COLOUR};

    assign sb_we     = (state == S_OUTPUT) && !already_done;
    assign sb_wstate = 2'b11;  // done (state encoding: 00=uncomputed, 11=done)

    // Push result in S_OUTPUT
    assign done        = (state == S_OUTPUT);
    assign iter_x      = px;
    assign iter_y      = py;
    assign iter_colour = (state == S_OUTPUT) ?
                         (already_done ? cached_colour : STUB_COLOUR) : '0;

    // FSM
    always_ff @(posedge clk) begin
        if (rst) begin
            state        <= S_IDLE;
            px           <= '0;
            py           <= '0;
            already_done  <= 1'b0;
            cached_colour <= '0;
        end else begin
            case (state)

                S_IDLE: begin
                    if (grant) begin
                        px    <= coord_out[8:0];
                        py    <= coord_out[17:9];
                        state <= S_READ;
                    end
                end

                S_READ: begin
                    // BRAMs sample sb_rd/cu_rd_en=1 (combinational) at this rising edge.
                    // Their registered outputs (sb_rstate, cu_rd_data) will be valid
                    // after this edge.  Wait one more cycle to read them safely.
                    state <= S_WAIT;
                end

                S_WAIT: begin
                    // BRAM results settled; capture them.
                    already_done  <= (sb_rstate == 2'b11);
                    cached_colour <= cu_rd_data[3:0];
                    state <= S_OUTPUT;
                end

                S_OUTPUT: begin
                    // done=1, writes asserted (combinational above).
                    // Return to idle to fetch next job.
                    state <= S_IDLE;
                end

            endcase
        end
    end

endmodule
