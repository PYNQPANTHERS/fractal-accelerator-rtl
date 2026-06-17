`timescale 1ns/1ps
//
// Functional test for control_unit — the per-sixteenth compute pipeline
// (dispatch FIFO -> clusters of worker cores -> iterate -> result FIFO -> RMW
// writeback). The CU instantiates its clusters/dispatch/bram_read_write
// internally; here we provide its REAL memory environment and a pixel feeder:
//
//   control_unit  <->  colour_bram   (cache byte read, RMW pre-read, full-word write)
//                 <->  state_bram    (per-pixel started/done state)
//   feeder:  wants_job/grant/coord_out  (hand the CU pixels to compute)
//
// We dispatch a handful of pixels into a uniform Mandelbrot config and check the
// pipeline produces results (done pulses with iter coords) and writes the colour
// BRAM — i.e. the whole compute path runs end-to-end.
//
// Builds against both trees (identical control_unit + memories).
//
module tb_control_unit;

    localparam int TILE_W       = 8;
    localparam int PIXEL_W      = 8;
    localparam int PIXEL_ADDR_W = 16;
    localparam int BRAM_ADDR_W  = $clog2(256*256/8);

    logic clk = 0; always #5 clk = ~clk;
    task automatic tick(input int n=1); repeat(n) @(posedge clk); #1; endtask

    logic rst;

    // config
    logic [4:0]  fractal_type;
    logic [34:0] centre_x, centre_y, c_x, c_y;
    logic [15:0] zoom_level;
    logic [4:0]  max_iter;
    logic        start_flag;
    logic [3:0]  sixteenth;

    // scheduler handshake (pixel feeder)
    wire         wants_job;
    logic        grant;
    logic        coord_skip;
    logic [PIXEL_ADDR_W-1:0] coord_out;
    logic        flush;

    // results
    wire         done;
    wire [PIXEL_W-1:0] iter_x, iter_y;
    wire [7:0]   iter_colour;

    // colour bram interface
    wire [PIXEL_W-1:0] cu_rd_x, cu_rd_y;
    wire         cu_rd_en;
    wire [7:0]   cu_rd_data;
    wire         cu_wr_en;
    wire [BRAM_ADDR_W-1:0] cu_wr_waddr;
    wire [63:0]  cu_wr_word;
    wire [BRAM_ADDR_W-1:0] cu_rmw_rd_addr;
    wire         cu_rmw_rd_en;
    wire [63:0]  cu_rmw_rd_data;

    // state bram interface
    wire [PIXEL_W-1:0] sb_x, sb_y;
    wire         sb_rd, sb_we;
    wire [1:0]   sb_wstate;
    wire [1:0]   sb_rstate;

    // ── DUT ────────────────────────────────────────────────────────────────────
    control_unit #(.TILE_W(TILE_W)) dut (
        .clk(clk), .rst(rst), .opcode_reset(1'b0),
        .fractal_type(fractal_type), .centre_x(centre_x), .centre_y(centre_y),
        .zoom_level(zoom_level), .max_iter(max_iter),
        .start_flag(start_flag), .sixteenth(sixteenth),
        .c_x(c_x), .c_y(c_y),
        .wants_job(wants_job), .grant(grant), .coord_skip(coord_skip),
        .coord_out(coord_out), .flush(flush),
        .done(done), .iter_x(iter_x), .iter_y(iter_y), .iter_colour(iter_colour),
        .cu_rd_x(cu_rd_x), .cu_rd_y(cu_rd_y), .cu_rd_en(cu_rd_en), .cu_rd_data(cu_rd_data),
        .cu_wr_en(cu_wr_en), .cu_wr_waddr(cu_wr_waddr), .cu_wr_word(cu_wr_word),
        .cu_rmw_rd_addr(cu_rmw_rd_addr), .cu_rmw_rd_en(cu_rmw_rd_en), .cu_rmw_rd_data(cu_rmw_rd_data),
        .sb_x(sb_x), .sb_y(sb_y), .sb_rd(sb_rd), .sb_we(sb_we),
        .sb_wstate(sb_wstate), .sb_rstate(sb_rstate)
    );

    // ── real colour_bram ───────────────────────────────────────────────────────
    wire [(256/TILE_W)*(256/TILE_W)-1:0] cb_tile_done;
    colour_bram #(.TILE_W(TILE_W)) u_cbram (
        .clk(clk), .rst(rst),
        .ctrl_rd_x(cu_rd_x), .ctrl_rd_y(cu_rd_y), .ctrl_rd_en(cu_rd_en),
        .ctrl_rd_data(cu_rd_data),
        .ctrl_wr_waddr(cu_wr_waddr), .ctrl_wr_word(cu_wr_word), .ctrl_wr_en(cu_wr_en),
        .b2d_word_addr('0), .b2d_rd_en(1'b0), .b2d_rd_grant(), .b2d_rd_data(),
        .ctrl_rmw_rd_addr(cu_rmw_rd_addr), .ctrl_rmw_rd_en(cu_rmw_rd_en),
        .ctrl_rmw_rd_data(cu_rmw_rd_data),
        .tile_done(cb_tile_done)
    );

    // ── real state_bram ────────────────────────────────────────────────────────
    state_bram u_sbram (
        .clk(clk), .rst(rst),
        .x(sb_x), .y(sb_y), .rd(sb_rd), .we(sb_we),
        .wstate(sb_wstate), .rstate(sb_rstate),
        .rd_valid(), .wr_done(), .clear_done()
    );

    // ── pixel feeder: grant a fixed set of coords when the CU wants a job ───────
    localparam int NPIX = 8;
    logic [PIXEL_ADDR_W-1:0] coords [0:NPIX-1];
    int feed_idx;
    always_ff @(posedge clk) begin
        if (rst) begin grant <= 0; feed_idx <= 0; coord_out <= 0; end
        else begin
            grant <= 1'b0;
            if (wants_job && feed_idx < NPIX) begin
                coord_out <= coords[feed_idx];
                grant     <= 1'b1;
                feed_idx  <= feed_idx + 1;
            end
        end
    end

    // ── result capture ─────────────────────────────────────────────────────────
    int results, writes;
    always_ff @(posedge clk) if (!rst) begin
        if (done)     results++;
        if (cu_wr_en) writes++;
    end

    int pass=0, fail=0;
    task automatic check(input logic cond, input string msg);
        if (cond) begin pass++; $display("  [PASS] %s", msg); end
        else      begin fail++; $display("  [FAIL] %s", msg); end
    endtask

    initial begin
        rst=1; grant=0; coord_skip=1; flush=0; coord_out=0;
        fractal_type=5'b0;                  // mandelbrot
        centre_x=35'h0; centre_y=35'h0; c_x=0; c_y=0;
        zoom_level=16'd20; max_iter=5'd3; sixteenth=4'd0; start_flag=0;
        results=0; writes=0; feed_idx=0;
        for (int i=0;i<NPIX;i++) coords[i] = {8'(i), 8'(i)};   // {y,x} = (i,i)
        tick(6); rst=0; tick(2);

        $display("\n== control_unit functional test (mandelbrot, %0d pixels) ==", NPIX);

        // start the frame (opcode broadcast + config load happen off start_flag)
        start_flag=1; tick(1); start_flag=0;

        // run the pipeline; coords feed in as the CU requests jobs
        for (int c = 0; c < 200_000; c++) tick(1);

        check(feed_idx == NPIX,      "all dispatched pixels were accepted by the CU");
        check(results  > 0,          "CU produced compute results (done pulses)");
        check(writes   > 0,          "CU wrote results back to the colour BRAM");

        $display("\n  dispatched=%0d  results=%0d  cbram_writes=%0d", feed_idx, results, writes);
        $display("  RESULTS: %0d / %0d passed", pass, pass+fail);
        if (fail==0) $display("  ALL TESTS PASSED"); else $display("  %0d TEST(S) FAILED", fail);
        $finish;
    end

    initial begin #20_000_000; $display("  [WATCHDOG] timeout"); $finish; end

endmodule
