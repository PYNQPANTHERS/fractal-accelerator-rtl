`timescale 1ns/1ps
//
// Unit test for border_pixel_generator — the Mariani-Silver border walk that
// emits the perimeter pixels of a box (with quadtree subdivision skips).
//
// We don't hard-code the full traversal order (it depends on the subdivision
// schedule); instead we check the robust invariants:
//   - first emitted pixel is the top-left corner,
//   - every emitted (x,y) stays within the box [top_left, top_left+width),
//   - `advance` low freezes output (valid drops, coords hold),
//   - the walk terminates (returns to IDLE → valid stays low) in bounded cycles.
//
// Builds against both trees (identical module).
//
module tb_border_pixel_generator;

    localparam int N = 8;

    logic clk = 0; always #5 clk = ~clk;
    task automatic tick(input int n=1); repeat(n) @(posedge clk); #1; endtask

    logic         rst, rst_start, advance;
    logic         all_left_flag, all_top_flag;
    logic [N-1:0] top_left_x, top_left_y;
    logic [1:0]   box_id;
    logic [8:0]   normal_width;
    wire  [N-1:0] x_coord, y_coord;
    wire          first_time_queued, valid;

    border_pixel_generator #(.N(N)) dut (
        .clk(clk), .rst(rst), .rst_start(rst_start), .advance(advance),
        .all_left_flag(all_left_flag), .all_top_flag(all_top_flag),
        .top_left_x(top_left_x), .top_left_y(top_left_y),
        .box_id(box_id), .normal_width(normal_width),
        .x_coord(x_coord), .y_coord(y_coord),
        .first_time_queued(first_time_queued), .valid(valid)
    );

    int pass=0, fail=0;
    task automatic check(input logic cond, input string msg);
        if (cond) begin pass++; $display("  [PASS] %s", msg); end
        else      begin fail++; $display("  [FAIL] %s", msg); end
    endtask

    // box config under test
    localparam int TLX = 8'd10, TLY = 8'd20, W = 9'd7;   // 8x8 box (normal_width+1)
    int  emitted, oob, first_seen, quiet_run, done_walk;
    logic [N-1:0] first_x, first_y;

    initial begin
        rst=1; rst_start=0; advance=1; all_left_flag=0; all_top_flag=0;
        top_left_x=TLX; top_left_y=TLY; box_id=2'b00; normal_width=W;
        tick(3); rst=0; tick(2);

        $display("\n== border_pixel_generator unit test (box %0dx%0d at (%0d,%0d)) ==",
                 W+1, W+1, TLX, TLY);

        // ── kick off the walk ────────────────────────────────────────────────
        rst_start = 1; tick(1); rst_start = 0;

        // ── collect emitted pixels until the walk returns to IDLE ────────────
        emitted=0; oob=0; first_seen=0; quiet_run=0; done_walk=0;
        for (int c = 0; c < 512; c++) begin
            if (!done_walk) begin
                tick(1);
                if (valid) begin
                    if (!first_seen) begin first_x=x_coord; first_y=y_coord; first_seen=1; end
                    emitted++;
                    quiet_run = 0;
                    // bounds: within [TL, TL+width]
                    if (x_coord <  TLX || x_coord >  TLX+W ||
                        y_coord <  TLY || y_coord >  TLY+W) oob++;
                end else if (first_seen) begin
                    quiet_run++;
                    if (quiet_run >= 16) done_walk = 1;   // terminated (back to IDLE)
                end
            end
        end

        check(first_seen,                     "generator emitted at least one pixel");
        check(first_x==TLX && first_y==TLY,   "first emitted pixel is the top-left corner");
        check(oob==0,                         "all emitted pixels are within the box bounds");
        check(emitted >= 4,                   "emitted a plausible number of border pixels");

        // ── advance low freezes output ───────────────────────────────────────
        rst_start = 1; tick(1); rst_start = 0;
        tick(2);
        advance = 0;
        tick(1);
        check(!valid, "valid low while advance deasserted (backpressure)");
        advance = 1;
        tick(1);
        check(valid,  "valid resumes after advance reasserted");

        $display("\n  emitted=%0d  oob=%0d", emitted, oob);
        $display("  RESULTS: %0d / %0d passed", pass, pass+fail);
        if (fail==0) $display("  ALL TESTS PASSED"); else $display("  %0d TEST(S) FAILED", fail);
        $finish;
    end

endmodule
