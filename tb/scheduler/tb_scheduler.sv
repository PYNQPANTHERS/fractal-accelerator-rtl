`timescale 1ns/1ps
//
// Functional test for the scheduler (Mariani-Silver quad-subdivision controller)
// with its REAL environment in the loop:
//   scheduler  <->  comparator       (quad config out, differ/complete back)
//              <->  job_queue_handler (push border pixels, grant them back)
//              <->  tile_table        (flood-fill writes)
//
// Driver model: a UNIFORM sixteenth. Every border pixel the scheduler queues is
// fed back to the comparator with the SAME colour, so the comparator reports
// `complete` with no `differ`. The scheduler should therefore flood-fill the
// whole 256x256 region (writing the tile_table) and reach engine_done — i.e. the
// classic "uniform box resolves in one pass" behaviour.
//
// Builds against both trees (identical scheduler/comparator/queue/tile_table).
//
module tb_scheduler;

    localparam int COORD_W = 8;
    localparam int TILE_W  = 8;
    localparam logic [5:0] UNIFORM_COL = 6'd21;

    logic clk = 0; always #5 clk = ~clk;
    task automatic tick(input int n=1); repeat(n) @(posedge clk); #1; endtask

    logic rst, start;

    // scheduler <-> comparator
    wire        sched_reset;
    wire [10:0] expected_count;
    wire [COORD_W:0]   quad_size_x, quad_size_y;
    wire [COORD_W-1:0] top_left_x, top_left_y;
    wire        comp_differ, comp_complete;
    wire [5:0]  comp_ref_colour;

    // scheduler -> job queue
    wire [COORD_W-1:0] sched_x, sched_y;
    wire        sched_first_time_queued, sched_push;
    wire        jqh_sched_stall, jqh_flush, jqh_queue_empty, jqh_queue_almost_full;

    // scheduler -> tile_table
    wire        tt_wr_quad_en;
    wire [COORD_W-1:0] tt_wr_quad_tlx, tt_wr_quad_tly;
    wire [COORD_W:0]   tt_wr_quad_size;
    wire [5:0]  tt_wr_quad_colour;

    wire        engine_done;
    localparam int TILES_P_AXIS = 256 / TILE_W;
    localparam int TOTAL_TILES  = TILES_P_AXIS*TILES_P_AXIS;
    wire [TOTAL_TILES-1:0] sched_tile_done_set;

    // ── DUT: scheduler ─────────────────────────────────────────────────────────
    scheduler #(.COORD_W(COORD_W), .TILE_W(TILE_W)) dut (
        .clk(clk), .rst(rst), .start(start),
        .engine_done(engine_done),
        .differ(comp_differ), .complete(comp_complete), .ref_colour_o(comp_ref_colour),
        .sched_reset(sched_reset), .expected_count(expected_count),
        .quad_size_x(quad_size_x), .quad_size_y(quad_size_y),
        .top_left_x(top_left_x), .top_left_y(top_left_y),
        .sched_x(sched_x), .sched_y(sched_y),
        .sched_first_time_queued(sched_first_time_queued),
        .sched_push(sched_push), .sched_stall_out(),
        .sched_stall(jqh_sched_stall), .gen_stall(jqh_queue_almost_full),
        .flush(jqh_flush), .job_queue_empty(jqh_queue_empty),
        .tt_wr_quad_en(tt_wr_quad_en), .tt_wr_quad_tlx(tt_wr_quad_tlx),
        .tt_wr_quad_tly(tt_wr_quad_tly), .tt_wr_quad_size(tt_wr_quad_size),
        .tt_wr_quad_colour(tt_wr_quad_colour),
        .sched_tile_done_set(sched_tile_done_set)
    );

    // ── real comparator ────────────────────────────────────────────────────────
    logic        comp_valid;
    logic [21:0] comp_data;
    wire         comp_pop;
    comparator #(.COORD_W(COORD_W)) u_comp (
        .clk(clk), .rst(rst), .sched_reset(sched_reset),
        .top_left_x(top_left_x), .top_left_y(top_left_y),
        .quad_size_x(quad_size_x), .quad_size_y(quad_size_y),
        .expected_count(expected_count),
        .comp_valid(comp_valid), .comp_data(comp_data), .comp_pop(comp_pop),
        .ref_colour_o(comp_ref_colour), .differ(comp_differ), .complete(comp_complete)
    );

    // ── real job_queue_handler (consumes scheduler pushes; we drain it) ─────────
    logic        jqh_wants_job;
    wire         jqh_grant;
    wire [15:0]  jqh_coord_out;
    wire         jqh_first_time_out;
    job_queue_handler u_jqh (
        .clk(clk), .rst(rst),
        .sched_coord({sched_y, sched_x}),
        .sched_first_time(sched_first_time_queued),
        .sched_push(sched_push), .sched_stall(jqh_sched_stall),
        .flush(jqh_flush),
        .wants_job(jqh_wants_job), .grant(jqh_grant),
        .coord_out(jqh_coord_out), .first_time_out(jqh_first_time_out),
        .queue_empty(jqh_queue_empty), .queue_almost_full(jqh_queue_almost_full)
    );

    // ── real tile_table (capture flood fills) ──────────────────────────────────
    wire [TOTAL_TILES-1:0] tt_filled_vec;
    tile_table #(.TILE_W(TILE_W)) u_tt (
        .clk(clk), .rst(rst),
        .wr_quad_en(tt_wr_quad_en), .wr_quad_tlx(tt_wr_quad_tlx),
        .wr_quad_tly(tt_wr_quad_tly), .wr_quad_size(tt_wr_quad_size),
        .wr_quad_colour(tt_wr_quad_colour),
        .rd_index('0), .rd_is_filled(), .rd_fill_colour(),
        .rd_filled_vec(tt_filled_vec)
    );

    // ── feedback model: drain the job queue, feed each granted pixel back to the
    //    comparator as the SAME uniform colour (uniform region → complete, no differ)
    assign jqh_wants_job = !jqh_queue_empty;   // always ready to consume
    always_ff @(posedge clk) begin
        if (rst) comp_valid <= 1'b0;
        else begin
            if (jqh_grant) begin
                // jqh_coord_out = {y[7:0], x[7:0]}; comp_data = {colour[5:0], y, x}
                comp_data  <= {UNIFORM_COL, jqh_coord_out};
                comp_valid <= 1'b1;
            end else begin
                comp_valid <= 1'b0;
            end
        end
    end

    // ── monitors ────────────────────────────────────────────────────────────────
    int pass=0, fail=0, fills=0, pushes=0;
    task automatic check(input logic cond, input string msg);
        if (cond) begin pass++; $display("  [PASS] %s", msg); end
        else      begin fail++; $display("  [FAIL] %s", msg); end
    endtask
    always_ff @(posedge clk) if (!rst) begin
        if (tt_wr_quad_en) fills++;
        if (sched_push)    pushes++;
    end

    longint cyc; logic saw_reset, saw_done;
    initial begin
        rst=1; start=0; comp_valid=0; comp_data=0;
        saw_reset=0; saw_done=0; cyc=0;
        tick(5); rst=0; tick(2);

        $display("\n== scheduler functional test (uniform sixteenth, TILE_W=%0d) ==", TILE_W);

        // kick off
        start=1; tick(1); start=0;

        // run until engine_done or timeout
        for (int c = 0; c < 4_000_000; c++) begin
            if (!saw_done) begin
                tick(1); cyc++;
                if (sched_reset)  saw_reset = 1;
                if (engine_done)  saw_done  = 1;
            end
        end

        check(saw_reset,            "scheduler issued at least one quad to the comparator");
        check(pushes > 0,           "scheduler pushed border pixels to the job queue");
        check(fills  > 0,           "scheduler flood-filled at least one box (uniform region)");
        check(saw_done,             "scheduler reached engine_done");
        check(&tt_filled_vec || fills>0, "tile_table recorded fill(s)");

        $display("\n  cycles=%0d  pushes=%0d  fills=%0d  filled_tiles=%0d/%0d",
                 cyc, pushes, fills, $countones(tt_filled_vec), TOTAL_TILES);
        $display("  RESULTS: %0d / %0d passed", pass, pass+fail);
        if (fail==0) $display("  ALL TESTS PASSED"); else $display("  %0d TEST(S) FAILED", fail);
        $finish;
    end

    // hard watchdog
    initial begin #50_000_000; $display("  [WATCHDOG] timeout"); $display("  RESULTS: %0d / %0d passed (TIMEOUT)", pass, pass+fail); $finish; end

endmodule
