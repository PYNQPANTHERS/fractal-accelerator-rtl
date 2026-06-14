// Consumes entries from the complete_queue_handler, performs bounds checking,
// colour comparison, and raises differ/complete flags to the scheduler

module comparator #(
    parameter int COORD_W = 8   // coordinate bit width; must match scheduler
) (
    input  logic        clk,
    input  logic        rst,

    // Scheduler configuration (loaded on reset)
    input  logic        sched_reset,      // pulse to reset and load new quad config
    input  logic [COORD_W-1:0] top_left_x,
    input  logic [COORD_W-1:0] top_left_y,
    input  logic [COORD_W:0]   quad_size_x,
    input  logic [COORD_W:0]   quad_size_y,
    input  logic [10:0] expected_count,   // total border pixels expected (max 2046)

    // Complete queue handler interface
    input  logic        comp_valid,
    input  logic [21:0] comp_data,        // { colour[5:0], y[7:0], x[7:0] }
    output logic        comp_pop,

    // Flags to scheduler
    output logic [5:0]  ref_colour_o,     // reference colour latched from first border pixel
    output logic        differ,           // latches high if any colour mismatch seen
    output logic        complete          // latches high when seen_count == expected_count
);

    logic [COORD_W-1:0] entry_x, entry_y;
    logic [5:0]  entry_colour;

    assign entry_x      = comp_data[COORD_W-1:0];
    assign entry_y      = comp_data[COORD_W*2-1:COORD_W];
    assign entry_colour = comp_data[21:16];

    // Bounds check
    logic in_bounds;
    assign in_bounds = ({1'b0, entry_x} >= {1'b0, top_left_x}) &&
                       ({1'b0, entry_x} <  {1'b0, top_left_x} + quad_size_x) &&
                       ({1'b0, entry_y} >= {1'b0, top_left_y}) &&
                       ({1'b0, entry_y} <  {1'b0, top_left_y} + quad_size_y);

    logic [5:0]  ref_colour;
    logic        ref_valid;
    logic [10:0] seen_count;

    assign ref_colour_o = ref_colour;

    // Pop whenever there is a valid entry
    assign comp_pop = comp_valid;

    // Main logic
    always_ff @(posedge clk) begin
        if (rst) begin
            differ      <= 1'b0;
            complete    <= 1'b0;
            ref_colour  <= 6'b0;
            ref_valid   <= 1'b0;
            seen_count  <= 11'b0;
        end else if (sched_reset) begin
            differ      <= 1'b0;
            complete    <= 1'b0;
            ref_colour  <= 6'b0;
            ref_valid   <= 1'b0;
            seen_count  <= 11'b0;
        end else if (comp_valid && in_bounds) begin
            // this_differs: the current pixel mismatches the reference. Computed
            // here (not just the registered `differ`) so the final border pixel
            // can suppress `complete` in the same cycle it sets `differ`.
            logic this_differs;
            this_differs = ref_valid && (entry_colour != ref_colour);

            // First valid entry after reset - store as reference colour
            if (!ref_valid) begin
                ref_colour <= entry_colour;
                ref_valid  <= 1'b1;
            end else begin
                // Compare against reference - latch differ if mismatch
                if (this_differs)
                    differ <= 1'b1;
            end

            // Increment seen counter
            seen_count <= seen_count + 1'b1;

            // Latch complete only when all expected border pixels have been seen
            // AND neither a previous pixel nor this one differed. Without the
            // !differ && !this_differs guard, a border whose LAST pixel is the one
            // that differs would set `differ` and `complete` on the same cycle;
            // the scheduler checks `complete` first and would wrongly flood-fill a
            // non-uniform box with the reference colour.
            if (ref_valid && !differ && !this_differs &&
                (seen_count + 1'b1 >= expected_count))
                complete <= 1'b1;
        end
        // Out-of-bounds entries: comp_pop still fires (entry consumed) but no state changes 
    end

endmodule