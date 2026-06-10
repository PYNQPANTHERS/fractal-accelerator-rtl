`timescale 1ns/1ps

// ──────────────────────────────────────────────────────────────────────────
// frame_render_tb
//
// Renders three frames through a single core_top instantiation:
//   Frame 0 : Mandelbrot   is_julia=0 abs_x=0 abs_y=0
//   Frame 1 : Burning Ship is_julia=0 abs_x=1 abs_y=1
//   Frame 2 : Julia        is_julia=1 abs_x=0 abs_y=0  c = -0.7 + 0.27i
//
// All frames use the same view window: real ∈ [-1.5, 1.5], imag ∈ [-1.5, 1.5]
//
// After simulation, three CSV files are written:
//   frame0_mandelbrot.csv
//   frame1_burningship.csv
//   frame2_julia.csv
// Each CSV row: col,row,iteration_count
// Run render.py to convert to images.
// ──────────────────────────────────────────────────────────────────────────

module frame_render_tb;

// ──────────────────────────────────────────────
// ▸ Customise here
// ──────────────────────────────────────────────
localparam int    WIDTH      = 512;          // horizontal pixels
localparam int    HEIGHT     = 512;          // vertical pixels
localparam real   RE_MIN     = -0.8;
localparam real   RE_MAX     = -0.7;
localparam real   IM_MIN     = 0.1;
localparam real   IM_MAX     =  0.2;
localparam real   JULIA_CX   = -0.700;      // Julia constant real
localparam real   JULIA_CY   =  0.270;      // Julia constant imag
localparam logic [4:0] MAX_ITER_FIELD = 5'd3; // 2^(6+field) iterations

// ──────────────────────────────────────────────
// DUT parameters
// ──────────────────────────────────────────────
localparam NARROW_WIDTH               = 18;
localparam ITERATION_COUNT_WIDTH      = 16;
localparam INTEGER_BITS               = 2;
localparam LOWEST_MAX_ITERATION_POWER = 6;
localparam FRAC_BITS                  = NARROW_WIDTH - INTEGER_BITS;
localparam CLK_PERIOD                 = 10;
localparam int PIXELS                 = WIDTH * HEIGHT;

// ──────────────────────────────────────────────
// DUT signals
// ──────────────────────────────────────────────
logic clk, rst;
logic opcode_reset;
logic live_data;
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
// Fixed-point helpers
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
// Pixel coordinate → complex plane mapping
// ──────────────────────────────────────────────
function automatic real pixel_re(input int col);
    return RE_MIN + (RE_MAX - RE_MIN) * col / (WIDTH - 1);
endfunction

function automatic real pixel_im(input int row);
    // row 0 = top → IM_MAX, row HEIGHT-1 = bottom → IM_MIN
    return IM_MAX - (IM_MAX - IM_MIN) * row / (HEIGHT - 1);
endfunction

// ──────────────────────────────────────────────
// Frame storage: [frame][pixel_index] = iters
// pixel_index = row*WIDTH + col
// ──────────────────────────────────────────────
logic [ITERATION_COUNT_WIDTH-1:0] frame_buf [0:2][0:PIXELS-1];

// Per-dispatch side tracking (need to know which pixel each side holds)
// We use a 2-deep FIFO per side — at most one pixel in flight per side
logic [ITERATION_COUNT_WIDTH-1:0] side_iter_result[0:1];
int                                side_pixel_idx  [0:1];  // which pixel index
logic                              side_occupied   [0:1];

// Cycle counter and per-frame timestamps
longint cycle_count;
longint frame_start_cycle[0:2];
longint frame_end_cycle  [0:2];

always @(posedge clk) cycle_count++;

// ──────────────────────────────────────────────
// Opcode tasks
// ──────────────────────────────────────────────
task automatic send_opcode(input logic [10:0] opc);
    @(posedge clk); #1;
    opcode_reset = 1;
    @(posedge clk); #1;
    data_in      = {{(NARROW_WIDTH-11){1'b0}}, opc};
    opcode_reset = 0;
    @(posedge clk); #1;
endtask

task automatic send_julia_opcode(input logic [10:0] opc, input real cx, input real cy);
    @(posedge clk); #1;
    opcode_reset = 1;
    @(posedge clk); #1;       // DUT latches opcode on this edge
    data_in = {{(NARROW_WIDTH-11){1'b0}}, opc};
    opcode_reset = 0;
    @(posedge clk); #1;
    data_in      = fp(cx);    // cx on cycle immediately after reset
    @(posedge clk); #1;
    data_in      = fp(cy);    // cy on the cycle after that
    @(posedge clk); #1;
    data_in      = '0;
endtask

// ──────────────────────────────────────────────
// render_frame
//
// Streams all PIXELS coordinates into the DUT using both sides
// concurrently, collecting results as they arrive.
// Records frame_start_cycle / frame_end_cycle.
// Results written into frame_buf[frame_id][].
// ──────────────────────────────────────────────
task automatic render_frame(input int frame_id);
    int dispatched;   // pixels sent so far
    int collected;    // pixels received so far
    int pixel_idx;
    int col, row;
    real re, im;
    logic side;

    dispatched = 0;
    collected  = 0;
    side_occupied[0] = 0;
    side_occupied[1] = 0;

    frame_start_cycle[frame_id] = cycle_count;
    $display("  [frame %0d] start cycle %0d", frame_id, cycle_count);

    fork
        // ── Producer ──────────────────────────────
        begin : producer
            for (int p = 0; p < PIXELS; p++) begin
                col = p % WIDTH;
                row = p / WIDTH;
                re  = pixel_re(col);
                im  = pixel_im(row);

                wait(ready === 1'b1);
                @(posedge clk); #1;

                side = will_load_into;
                side_pixel_idx[side] = p;
                side_occupied[side]  = 1;
                dispatched++;

                live_data = 1;
                data_in   = fp(re);
                @(posedge clk); #1;
                data_in   = fp(im);
                @(posedge clk); #1;
                live_data = 0;
                data_in   = '0;
            end
        end

        // ── Consumer ──────────────────────────────
        begin : consumer
            for (int p = 0; p < PIXELS; p++) begin
                wait(done === 1'b1);
                @(posedge clk); #1;

                begin
                    logic s;
                    int   px;
                    s  = done_side;
                    px = side_pixel_idx[s];
                    frame_buf[frame_id][px] = iteration_count;
                    side_occupied[s] = 0;

                    received = 1;
                    @(posedge clk); #1;
                    received = 0;
                    collected++;
                end
            end
        end
    join

    frame_end_cycle[frame_id] = cycle_count;
    $display("  [frame %0d] end   cycle %0d  (elapsed %0d cycles, %0d pixels)",
             frame_id,
             frame_end_cycle[frame_id],
             frame_end_cycle[frame_id] - frame_start_cycle[frame_id],
             PIXELS);
endtask

// ──────────────────────────────────────────────
// CSV dump
// ──────────────────────────────────────────────
task automatic dump_csv(input string filename, input int frame_id);
    int fd;
    fd = $fopen(filename, "w");
    if (fd == 0) begin
        $display("ERROR: could not open %s", filename);
    end else begin
        $fwrite(fd, "col,row,iters\n");
        for (int row = 0; row < HEIGHT; row++)
            for (int col = 0; col < WIDTH; col++)
                $fwrite(fd, "%0d,%0d,%0d\n",
                        col, row,
                        frame_buf[frame_id][row * WIDTH + col]);
        $fclose(fd);
        $display("  wrote %s", filename);
    end
endtask

// ──────────────────────────────────────────────
// Main
// ──────────────────────────────────────────────
initial begin
    rst          = 1;
    opcode_reset = 0;
    live_data    = 0;
    received     = 0;
    data_in      = '0;
    cycle_count  = 0;
    side_occupied[0] = 0;
    side_occupied[1] = 0;

    repeat(4) @(posedge clk);
    rst = 0;
    @(posedge clk); #1;

    // ── Frame 0 : Mandelbrot ──────────────────
    $display("\n══ Frame 0: Mandelbrot  %0dx%0d ══", WIDTH, HEIGHT);
    send_opcode(build_opcode(0, 0, 0, 0, 0, 0, MAX_ITER_FIELD));
    render_frame(0);

    // // ── Frame 1 : Burning Ship ────────────────
    // $display("\n══ Frame 1: Burning Ship  %0dx%0d ══", WIDTH, HEIGHT);
    // send_opcode(build_opcode(0, 0, 1, 1, 0, 0, MAX_ITER_FIELD));
    // render_frame(1);

    // // ── Frame 2 : Julia ───────────────────────
    // $display("\n══ Frame 2: Julia (c=%.3f+%.3fi)  %0dx%0d ══",
    //          JULIA_CX, JULIA_CY, WIDTH, HEIGHT);
    // send_julia_opcode(build_opcode(0, 1, 0, 0, 0, 0, MAX_ITER_FIELD),
    //                   JULIA_CX, JULIA_CY);
    // render_frame(2);

    // ── Timing summary ────────────────────────
    $display("\n══ Frame timing summary ══");
    $display("  Frame 0 (Mandelbrot)  : %0d cycles",
             frame_end_cycle[0] - frame_start_cycle[0]);
    // $display("  Frame 1 (Burning Ship): %0d cycles",
    //          frame_end_cycle[1] - frame_start_cycle[1]);
    // $display("  Frame 2 (Julia)       : %0d cycles",
    //          frame_end_cycle[2] - frame_start_cycle[2]);
    // $display("  Total                 : %0d cycles",
    //          frame_end_cycle[2] - frame_start_cycle[0]);

    // ── Dump CSVs ─────────────────────────────
    $display("\n══ Writing CSVs ══");
    dump_csv("frame0_mandelbrot.csv",   0);
    // dump_csv("frame1_burningship.csv",  1);
    // dump_csv("frame2_julia.csv",        2);

    $display("\nDone.\n");
    $finish;
end

// ──────────────────────────────────────────────
// Watchdog: 3 frames × PIXELS × ~300 cycles/pixel worst case
// ──────────────────────────────────────────────
initial begin
    #(CLK_PERIOD * 3 * PIXELS * 400);
    $display("WATCHDOG TIMEOUT");
    $finish;
end

initial begin
    $dumpfile("frame_render_tb.vcd");
    $dumpvars(0, frame_render_tb);
end

endmodule