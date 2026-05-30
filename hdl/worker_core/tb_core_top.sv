`timescale 1ns/1ps

module core_top_tb;

// ──────────────────────────────────────────────
// Parameters
// ──────────────────────────────────────────────
localparam NARROW_WIDTH               = 18;
localparam ITERATION_COUNT_WIDTH      = 16;
localparam INTEGER_BITS               = 2;
localparam LOWEST_MAX_ITERATION_POWER = 6;
localparam FRAC_BITS                  = NARROW_WIDTH - INTEGER_BITS; // 16
localparam CLK_PERIOD                 = 10;
localparam BATCH_SIZE                 = 20;

// ──────────────────────────────────────────────
// DUT signals
// ──────────────────────────────────────────────
logic clk, rst;
logic opcode_reset;
logic live_data;
logic [10:0] opcode;
logic [NARROW_WIDTH-1:0] data_in;

logic done;
logic done_side;
logic will_load_into;
logic received;
logic ready;
logic [ITERATION_COUNT_WIDTH-1:0] iteration_count;

// ──────────────────────────────────────────────
// DUT
// ──────────────────────────────────────────────
core_top #(
    .NARROW_WIDTH              (NARROW_WIDTH),
    .ITERATION_COUNT_WIDTH     (ITERATION_COUNT_WIDTH),
    .INTEGER_BITS              (INTEGER_BITS),
    .LOWEST_MAX_ITERATION_POWER(LOWEST_MAX_ITERATION_POWER)
) dut (
    .clk            (clk),
    .rst            (rst),
    .opcode_reset   (opcode_reset),
    .live_data      (live_data),
    .opcode         (opcode),
    .data_in        (data_in),
    .done           (done),
    .done_side      (done_side),
    .will_load_into (will_load_into),
    .received       (received),
    .ready          (ready),
    .iteration_count(iteration_count)
);

// ──────────────────────────────────────────────
// Clock
// ──────────────────────────────────────────────
initial clk = 0;
always #(CLK_PERIOD/2) clk = ~clk;

// ──────────────────────────────────────────────
// Fixed-point encode
// ──────────────────────────────────────────────
function automatic logic [NARROW_WIDTH-1:0] fp(input real val);
    return NARROW_WIDTH'(int'(val * (1 << FRAC_BITS)));
endfunction

function automatic logic [10:0] build_opcode(
    input logic is_wide, is_julia,
    input logic abs_x, abs_y, neg_x, neg_y,
    input logic [4:0] max_iter_field
);
    return {is_wide, is_julia, abs_x, abs_y, neg_x, neg_y, max_iter_field};
endfunction

// ──────────────────────────────────────────────
// Per-dispatch tracking
// ──────────────────────────────────────────────
logic [NARROW_WIDTH-1:0] coord_x    [0:BATCH_SIZE-1];
logic [NARROW_WIDTH-1:0] coord_y    [0:BATCH_SIZE-1];
logic                    coord_side [0:BATCH_SIZE-1];
logic                    coord_done [0:BATCH_SIZE-1];

int dispatched_count     [0:1];
int result_count_per_side[0:1];
int total_dispatched;
int total_collected;

// ──────────────────────────────────────────────
// Tasks
// ──────────────────────────────────────────────
task automatic send_opcode(input logic [10:0] opc);
    @(posedge clk); #1;
    opcode_reset = 1;
    opcode       = opc;
    @(posedge clk); #1;
    opcode_reset = 0;
    opcode       = '0;
    @(posedge clk); #1;
endtask

task automatic dispatch_coord(input int idx, input real x, input real y);
    logic side;
    wait(ready === 1'b1);
    @(posedge clk); #1;

    side = will_load_into;              // latch before live_data
    coord_x[idx]    = fp(x);
    coord_y[idx]    = fp(y);
    coord_side[idx] = side;
    coord_done[idx] = 0;
    dispatched_count[side]++;
    total_dispatched++;

    $display("  [dispatch #%02d] x=%6.3f y=%6.3f → side %0d  (side0=%0d side1=%0d)",
             idx, x, y, side, dispatched_count[0], dispatched_count[1]);

    live_data = 1;
    data_in   = fp(x);
    @(posedge clk); #1;
    data_in   = fp(y);
    @(posedge clk); #1;
    live_data = 0;
    data_in   = '0;
endtask

task automatic collect_one;
    logic [ITERATION_COUNT_WIDTH-1:0] icount;
    logic side;
    logic found;

    wait(done === 1'b1);
    @(posedge clk); #1;

    icount = iteration_count;
    side   = done_side;

    received = 1;
    @(posedge clk); #1;
    received = 0;

    result_count_per_side[side]++;
    total_collected++;

    // Match to most-recent unfinished dispatch on this side
    found = 0;
    for (int i = total_dispatched-1; i >= 0; i--) begin
        if (!coord_done[i] && coord_side[i] === side && !found) begin
            coord_done[i] = 1;
            found = 1;
            $display("  [result  #%02d] side=%0d  iters=%0d  (side0_results=%0d side1_results=%0d)",
                     i, side, icount,
                     result_count_per_side[0], result_count_per_side[1]);
        end
    end

    if (!found)
        $display("  WARNING: result from side %0d with no pending dispatch", side);
endtask

// ──────────────────────────────────────────────
// Pass/fail
// ──────────────────────────────────────────────
int pass_count = 0;
int fail_count = 0;

task automatic check(input string name, input logic cond);
    if (cond) begin $display("  PASS  %s", name); pass_count++; end
    else      begin $display("  FAIL  %s", name); fail_count++; end
endtask

// ──────────────────────────────────────────────
// Test coordinates
// Alternating fast (outside) and slow (inside)
// so threads are genuinely at different stages
// ──────────────────────────────────────────────
real test_x [0:BATCH_SIZE-1];
real test_y [0:BATCH_SIZE-1];

initial begin
    test_x[0]  =  2.0;  test_y[0]  =  0.0;  // outside - fast
    test_x[1]  =  0.0;  test_y[1]  =  0.0;  // inside  - slow
    test_x[2]  = -2.0;  test_y[2]  =  0.0;  // outside - fast
    test_x[3]  = -0.5;  test_y[3]  =  0.0;  // inside  - slow
    test_x[4]  =  0.0;  test_y[4]  =  2.0;  // outside - fast
    test_x[5]  =  0.1;  test_y[5]  =  0.1;  // inside  - slow
    test_x[6]  =  1.5;  test_y[6]  =  0.5;  // outside - fast
    test_x[7]  = -0.2;  test_y[7]  =  0.2;  // inside  - slow
    test_x[8]  = -1.5;  test_y[8]  =  0.5;  // outside - fast
    test_x[9]  =  0.0;  test_y[9]  = -0.3;  // inside  - slow
    test_x[10] =  2.0;  test_y[10] =  1.0;  // outside - fast
    test_x[11] = -0.1;  test_y[11] =  0.0;  // inside  - slow
    test_x[12] = -2.0;  test_y[12] = -1.0;  // outside - fast
    test_x[13] =  0.0;  test_y[13] =  0.1;  // inside  - slow
    test_x[14] =  1.8;  test_y[14] =  0.0;  // outside - fast
    test_x[15] = -0.3;  test_y[15] =  0.1;  // inside  - slow
    test_x[16] = -1.8;  test_y[16] =  0.5;  // outside - fast
    test_x[17] =  0.2;  test_y[17] = -0.2;  // inside  - slow
    test_x[18] =  0.5;  test_y[18] =  1.8;  // outside - fast
    test_x[19] =  0.0;  test_y[19] =  0.0;  // inside  - slow
end

// ──────────────────────────────────────────────
// Main
// ──────────────────────────────────────────────
initial begin
    rst          = 1;
    opcode_reset = 0;
    live_data    = 0;
    received     = 0;
    opcode       = '0;
    data_in      = '0;
    dispatched_count[0]      = 0;
    dispatched_count[1]      = 0;
    result_count_per_side[0] = 0;
    result_count_per_side[1] = 0;
    total_dispatched         = 0;
    total_collected          = 0;
    for (int i = 0; i < BATCH_SIZE; i++) coord_done[i] = 0;

    repeat(4) @(posedge clk);
    rst = 0;
    @(posedge clk); #1;

    $display("\n── Config: narrow Mandelbrot, 256 max iterations ──");
    send_opcode(build_opcode(0, 0, 0, 0, 0, 0, 5'd2));

    $display("\n── Batch: %0d coords, alternating fast/slow ──", BATCH_SIZE);

    // Producer and consumer run concurrently —
    // this is what the real upstream module would do
    fork
        begin : producer
            for (int i = 0; i < BATCH_SIZE; i++)
                dispatch_coord(i, test_x[i], test_y[i]);
            $display("\n  [producer done] all %0d dispatched", BATCH_SIZE);
        end

        begin : consumer
            for (int i = 0; i < BATCH_SIZE; i++)
                collect_one();
            $display("  [consumer done] all %0d collected", BATCH_SIZE);
        end
    join

    // ── Summary ──
    $display("\n── Thread utilisation ──");
    $display("  Side 0 : dispatched=%0d  results=%0d",
             dispatched_count[0], result_count_per_side[0]);
    $display("  Side 1 : dispatched=%0d  results=%0d",
             dispatched_count[1], result_count_per_side[1]);
    $display("  Total  : dispatched=%0d  results=%0d",
             total_dispatched, total_collected);

    $display("\n── Checks ──");
    check("Side 0 received work",
          dispatched_count[0] > 0);
    check("Side 1 received work",
          dispatched_count[1] > 0);
    check("Total dispatched == BATCH_SIZE",
          total_dispatched == BATCH_SIZE);
    check("Total collected  == BATCH_SIZE",
          total_collected  == BATCH_SIZE);
    check("Side 0 results match dispatches",
          result_count_per_side[0] == dispatched_count[0]);
    check("Side 1 results match dispatches",
          result_count_per_side[1] == dispatched_count[1]);
    check("Neither side did everything (side 0)",
          dispatched_count[0] < BATCH_SIZE);
    check("Neither side did everything (side 1)",
          dispatched_count[1] < BATCH_SIZE);

    begin
        logic all_matched;
        all_matched = 1;
        for (int i = 0; i < BATCH_SIZE; i++)
            if (!coord_done[i]) all_matched = 0;
        check("Every dispatch matched a result", all_matched);
    end

    $display("\n══════════════════════════════════════");
    $display("  %0d passed  %0d failed", pass_count, fail_count);
    $display("══════════════════════════════════════\n");

    $finish;
end

initial begin
    #(CLK_PERIOD * 2000000);
    $display("WATCHDOG TIMEOUT");
    $finish;
end

initial begin
    $dumpfile("core_top_tb.vcd");
    $dumpvars(0, core_top_tb);
end

endmodule