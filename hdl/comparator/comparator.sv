// Consumes entries from the complete_queue_handler, performs bounds checking,
// colour comparison, and raises differ/complete flags to the scheduler.

module comparator (
    input  logic        clk,
    input  logic        rst,

    // Scheduler configuration (loaded on reset) 
    input  logic        sched_reset,      // pulse to reset and load new quad config
    input  logic [8:0]  top_left_x,
    input  logic [8:0]  top_left_y,
    input  logic [8:0]  quad_size,        // in pixels, border is quad_size wide
    input  logic [10:0] expected_count,   // total border pixels expected (max 2046)

    // Complete queue handler interface 
    input  logic        comp_valid,
    input  logic [21:0] comp_data,        // { colour[3:0], y[8:0], x[8:0] }
    output logic        comp_pop,

    // Flags to scheduler 
    output logic        differ,           // latches high if any colour mismatch seen
    output logic        complete          // latches high when seen_count == expected_count
);

    logic [8:0]  entry_x, entry_y;
    logic [3:0]  entry_colour;

    assign entry_x      = comp_data[8:0];
    assign entry_y      = comp_data[17:9];
    assign entry_colour = comp_data[21:18];

    // Bounds check
    logic in_bounds;
    assign in_bounds = (entry_x >= top_left_x) &&
                       (entry_x <  top_left_x + quad_size) &&
                       (entry_y >= top_left_y) &&
                       (entry_y <  top_left_y + quad_size);

    logic [3:0]  ref_colour;
    logic        ref_valid;
    logic [10:0] seen_count;

    // Pop whenever there is a valid entry
    assign comp_pop = comp_valid;

    // Main logic
    always_ff @(posedge clk) begin
        if (rst) begin
            differ      <= 1'b0;
            complete    <= 1'b0;
            ref_colour  <= 4'b0;
            ref_valid   <= 1'b0;
            seen_count  <= 11'b0;
        end else if (sched_reset) begin
            differ      <= 1'b0;
            complete    <= 1'b0;
            ref_colour  <= 4'b0;
            ref_valid   <= 1'b0;
            seen_count  <= 11'b0;
        end else if (comp_valid && in_bounds) begin
            // First valid entry after reset — store as reference colour
            if (!ref_valid) begin
                ref_colour <= entry_colour;
                ref_valid  <= 1'b1;
            end else begin
                // Compare against reference — latch differ if mismatch
                if (entry_colour != ref_colour)
                    differ <= 1'b1;
            end

            // Increment seen counter
            seen_count <= seen_count + 1'b1;

            // Latch complete when we have seen all expected border pixels
            if (seen_count + 1'b1 == expected_count)
                complete <= 1'b1;
        end
        // Out-of-bounds entries: comp_pop still fires (entry consumed) but no state changes 
        // Stale results from previous quads are discarded
    end

endmodule