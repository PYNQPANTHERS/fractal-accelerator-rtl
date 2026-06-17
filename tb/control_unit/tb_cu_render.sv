// ─────────────────────────────────────────────────────────────────────────────
// tb_cu_render
//   Renders three 128x128 fractal frames through control_unit with
//   CLUSTER_COUNT clusters running in parallel.
//
//   Frame 0: Mandelbrot    fractal_type = 5'b00000
//   Frame 1: Burning Ship  fractal_type = 5'b01100  (abs_x, abs_y)
//   Frame 2: Julia         fractal_type = 5'b11100  c = -0.7 + 0.27i
//
//   View window: 2x2
//     zoom=0 (scale=512), pan_x=-1.0, pan_y≈+1.0, 256 pixels each axis.
//
//   Output: frame0_mandelbrot.csv, frame1_burningship.csv, frame2_julia.csv
//     format: col,row,iters  (matches render_frames.py)
//   Run: python3 hdl/worker_core/render_frames.py --max-iter 128
//
//   Results collected via cu_wr_en/cu_wr_x/cu_wr_y/cu_wr_data (colour BRAM
//   write path), which fires exactly once per computed pixel.
// ─────────────────────────────────────────────────────────────────────────────
`timescale 1ns/1ps

module tb_cu_render;

    // ── sizing ────────────────────────────────────────────────────────────────
    localparam int IMAGE_SIZE    = 256;
    localparam int CLUSTER_COUNT = 2;
    localparam int CLUSTER_SIZE  = 4;
    localparam int DATA_WIDTH    = 17;
    localparam int PIXEL_ADDR_W  = 16;
    localparam int JOB_DATA_W    = 18;
    localparam int PIXEL_W       = 8;
    localparam int OPCODE_W      = 5;

    localparam time CLK_PERIOD = 10ns;

    // ── view ──────────────────────────────────────────────────────────────────
    // zoom=0 → scale=512/pixel. 256 pixels × 512 = 131072 ≈ 2.0 span.
    // pan_x = -1.0 = -65536, pan_y ≈ +1.0 = 65024
    localparam logic signed [DATA_WIDTH-1:0] PAN_X = 17'($signed(-65536));
    localparam logic signed [DATA_WIDTH-1:0] PAN_Y = 17'(65024);
    localparam logic [3:0] ZOOM = 4'd0;

    // max_iter field 5'd1 → 2^(6+1) = 128 iterations
    localparam logic [4:0] MAX_ITER_FIELD = 5'd1;
    localparam int          MAX_ITER       = 128;

    // Julia c = -0.7 + 0.27i
    localparam logic signed [DATA_WIDTH-1:0] JULIA_CX = 17'($signed(-45875));
    localparam logic signed [DATA_WIDTH-1:0] JULIA_CY = 17'(17695);

    // ── DUT signals ───────────────────────────────────────────────────────────
    logic                    clk, rst;
    logic                    opcode_reset;
    logic                    start_flag;
    logic                    width_flag;
    logic [4:0]              fractal_type;
    logic [4:0]              max_iter;
    logic [DATA_WIDTH-1:0]   pan_x, pan_y;
    logic [3:0]              zoom_level;
    logic [DATA_WIDTH-1:0]   c_x, c_y;

    // scheduler handshake — coord_out packs {y[7:0], x[7:0]}
    logic                    wants_job;
    logic                    grant;
    logic [PIXEL_ADDR_W-1:0] coord_out;

    // result path
    logic                    done;
    logic [PIXEL_W:0]        iter_x;
    logic [PIXEL_W:0]        iter_y;
    logic [7:0]              iter_colour;

    // colour BRAM read (driven by control_unit)
    logic [PIXEL_W-1:0]      cu_rd_x, cu_rd_y;
    logic                    cu_rd_en;
    logic [7:0]              cu_rd_data;

    // colour BRAM write (driven by control_unit — one pulse per computed pixel)
    logic                    cu_wr_en;
    logic [PIXEL_W-1:0]      cu_wr_x, cu_wr_y;
    logic [7:0]              cu_wr_data;

    // state BRAM (driven by control_unit)
    logic [PIXEL_W-1:0]      sb_x, sb_y;
    logic                    sb_rd, sb_we;
    logic [1:0]              sb_wstate;
    logic [1:0]              sb_rstate;

    logic                    cu_tile_done_set;

    // ── DUT ──────────────────────────────────────────────────────────────────
    control_unit #(
        .DATA_WIDTH    (DATA_WIDTH),
        .CLUSTER_COUNT (CLUSTER_COUNT),
        .CLUSTER_SIZE  (CLUSTER_SIZE),
        .PIXEL_ADDR_W  (PIXEL_ADDR_W),
        .JOB_DATA_W    (JOB_DATA_W),
        .PIXEL_W       (PIXEL_W),
        .OPCODE_W      (OPCODE_W)
    ) dut (
        .clk              (clk),
        .rst              (rst),
        .opcode_reset     (opcode_reset),
        .start_flag       (start_flag),
        .width_flag       (width_flag),
        .fractal_type     (fractal_type),
        .max_iter         (max_iter),
        .pan_x            (pan_x),
        .pan_y            (pan_y),
        .zoom_level       (zoom_level),
        .c_x              (c_x),
        .c_y              (c_y),
        .sixteenth        ('0),
        .wants_job        (wants_job),
        .grant            (grant),
        .coord_out        (coord_out),
        .done             (done),
        .iter_x           (iter_x),
        .iter_y           (iter_y),
        .iter_colour      (iter_colour),
        .cu_rd_x          (cu_rd_x),
        .cu_rd_y          (cu_rd_y),
        .cu_rd_en         (cu_rd_en),
        .cu_rd_data       (cu_rd_data),
        .cu_wr_en         (cu_wr_en),
        .cu_wr_x          (cu_wr_x),
        .cu_wr_y          (cu_wr_y),
        .cu_wr_data       (cu_wr_data),
        .sb_x             (sb_x),
        .sb_y             (sb_y),
        .sb_rd            (sb_rd),
        .sb_we            (sb_we),
        .sb_wstate        (sb_wstate),
        .sb_rstate        (sb_rstate),
        .cu_tile_done_set (cu_tile_done_set)
    );

    // ── clock ─────────────────────────────────────────────────────────────────
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // ── colour BRAM model ─────────────────────────────────────────────────────
    logic [7:0] cbram [0:IMAGE_SIZE-1][0:IMAGE_SIZE-1];
    logic [7:0] cbram_rd_q;

    always_ff @(posedge clk) begin
        if (cu_rd_en)
            cbram_rd_q <= cbram[cu_rd_x][cu_rd_y];
        if (cu_wr_en)
            cbram[cu_wr_x][cu_wr_y] <= cu_wr_data;
    end
    assign cu_rd_data = cbram_rd_q;

    // ── state BRAM model (1-cycle read latency) ───────────────────────────────
    logic [1:0] sbram [0:IMAGE_SIZE-1][0:IMAGE_SIZE-1];
    logic [1:0] sbram_rd_q;

    always_ff @(posedge clk) begin
        if (sb_rd)
            sbram_rd_q <= sbram[sb_x][sb_y];
        if (sb_we)
            sbram[sb_x][sb_y] <= sb_wstate;
    end
    assign sb_rstate = sbram_rd_q;

    // ── frame buffers ─────────────────────────────────────────────────────────
    // Results collected via colour BRAM writes (cu_wr_en), which fire exactly
    // once per computed pixel and carry the full pixel address.
    logic [PIXEL_W-1:0] frame_buf [0:2][0:IMAGE_SIZE*IMAGE_SIZE-1];
    int                 collected [3];
    int                 active_frame;
    longint             frame_cycles [3];

    initial begin
        for (int i = 0; i < IMAGE_SIZE*IMAGE_SIZE; i++) begin
            frame_buf[0][i] = '0;
            frame_buf[1][i] = '0;
            frame_buf[2][i] = '0;
        end
    end

    initial begin : collector
        forever begin
            @(posedge clk);
            if (cu_wr_en) begin
                frame_buf[active_frame][cu_wr_y * IMAGE_SIZE + cu_wr_x] = cu_wr_data;
                collected[active_frame]++;
            end
        end
    end

    // ── tile tracking ─────────────────────────────────────────────────────────
    // tile_done_addr: {col[7:4], row[7:4]} — stable while cu_tile_done_set high
    localparam int TILE_SZ    = 16;
    localparam int TILE_COLS  = IMAGE_SIZE / TILE_SZ;   // 16
    localparam int TILE_COUNT = TILE_COLS * TILE_COLS;  // 256

    wire [7:0] tile_done_addr = {cu_wr_x[7:4], cu_wr_y[7:4]};

    int tile_done_count;
    int tile_fired   [256];

    always_ff @(posedge clk) begin
        if (cu_tile_done_set) begin
            tile_fired[tile_done_addr] <= tile_fired[tile_done_addr] + 1;
            tile_done_count            <= tile_done_count + 1;
        end
    end

    task automatic reset_tile_tracking();
        tile_done_count = 0;
        for (int i = 0; i < 256; i++) tile_fired[i] = 0;
    endtask

    task automatic verify_tiles(input int fid, input string name);
        int fails;
        fails = 0;
        for (int tc = 0; tc < TILE_COLS; tc++) begin
            for (int tr = 0; tr < TILE_COLS; tr++) begin
                automatic int ta = (tc << 4) | tr;
                if (tile_fired[ta] != 1) begin
                    $display("  FAIL frame%0d tile %02h (col=%0d row=%0d): fired %0d times",
                             fid, ta, tc, tr, tile_fired[ta]);
                    fails++;
                end
            end
        end
        if (tile_done_count != TILE_COUNT) begin
            $display("  FAIL frame%0d tile_done_count=%0d (expected %0d)",
                     fid, tile_done_count, TILE_COUNT);
            fails++;
        end
        if (fails == 0)
            $display("  tile check PASS: %0d/%0d tiles done for %s", TILE_COUNT, TILE_COUNT, name);
        else
            $display("  tile check FAIL: %0d error(s) for %s", fails, name);
    endtask

    // ── scheduler model ───────────────────────────────────────────────────────
    // Holds pixel coords {y[7:0], x[7:0]}.
    // Responds on the RISING EDGE of wants_job: grant fires 1 cycle later.
    // Level-based pop would double-consume on the accept cycle because
    // frame_fsm.job_ready (= wants_job) is still high from the registered
    // current_state on the same edge that accept fires.
    logic [PIXEL_ADDR_W-1:0] sched_queue [$];
    logic wants_job_q;

    always_ff @(posedge clk) begin
        wants_job_q <= wants_job;
        grant       <= 0;
        coord_out   <= '0;
        if (wants_job && !wants_job_q && sched_queue.size() > 0) begin
            coord_out <= sched_queue.pop_front();
            grant     <= 1;
        end
    end

    // ── helpers ───────────────────────────────────────────────────────────────
    task automatic do_reset();
        rst          = 1;
        start_flag   = 0;
        opcode_reset = 0;
        width_flag   = 0;
        fractal_type = '0;
        max_iter     = '0;
        pan_x        = PAN_X;
        pan_y        = PAN_Y;
        zoom_level   = ZOOM;
        c_x          = '0;
        c_y          = '0;
        sched_queue.delete();
        for (int i = 0; i < IMAGE_SIZE; i++)
            for (int j = 0; j < IMAGE_SIZE; j++) begin
                cbram[i][j] = 8'h00;
                sbram[i][j] = 2'b00;
            end
        repeat (4) @(posedge clk);
        rst = 0;
        @(posedge clk);
    endtask

    task automatic drain(input int fid);
        int timeout, quiet;
        timeout = 0;
        quiet   = 0;
        while ((collected[fid] < IMAGE_SIZE * IMAGE_SIZE || quiet < 20)
               && timeout < 10_000_000) begin
            @(posedge clk);
            timeout++;
            if (cu_wr_en) quiet = 0;
            else          quiet = quiet + 1;
        end
        if (collected[fid] < IMAGE_SIZE * IMAGE_SIZE)
            $error("[%0t] drain timeout: got %0d / %0d",
                   $time, collected[fid], IMAGE_SIZE * IMAGE_SIZE);
    endtask

    task automatic render_frame(
        input int                    fid,
        input logic [4:0]            ftype,
        input logic [DATA_WIDTH-1:0] cx,
        input logic [DATA_WIDTH-1:0] cy,
        input string                 name
    );
        longint t_start, t_end;
        $display("\n══ Frame %0d: %s  %0dx%0d ══", fid, name, IMAGE_SIZE, IMAGE_SIZE);
        collected[fid] = 0;
        active_frame   = fid;
        reset_tile_tracking();

        do_reset();

        fractal_type = ftype;
        max_iter     = MAX_ITER_FIELD;
        c_x          = cx;
        c_y          = cy;

        opcode_reset = 1;
        @(posedge clk);
        opcode_reset = 0;

        // queue all pixel coords packed as {y[7:0], x[7:0]}
        for (int row = 0; row < IMAGE_SIZE; row++)
            for (int col = 0; col < IMAGE_SIZE; col++)
                sched_queue.push_back({PIXEL_W'(row), PIXEL_W'(col)});

        t_start    = $time;
        start_flag = 1;
        @(posedge clk);
        start_flag = 0;

        $display("  queued %0d pixels, draining...", IMAGE_SIZE * IMAGE_SIZE);
        drain(fid);
        t_end = $time;

        frame_cycles[fid] = (t_end - t_start) / CLK_PERIOD;
        $display("  collected  %0d / %0d  (%0d cycles)",
                 collected[fid], IMAGE_SIZE * IMAGE_SIZE, frame_cycles[fid]);
        verify_tiles(fid, name);
    endtask

    task automatic dump_csv(input string fname, input int fid);
        int fd;
        fd = $fopen(fname, "w");
        if (fd == 0) begin
            $display("ERROR: could not open %s", fname);
            return;
        end
        $fwrite(fd, "col,row,iters\n");
        for (int row = 0; row < IMAGE_SIZE; row++)
            for (int col = 0; col < IMAGE_SIZE; col++)
                $fwrite(fd, "%0d,%0d,%0d\n", col, row,
                        frame_buf[fid][row * IMAGE_SIZE + col]);
        $fclose(fd);
        $display("  wrote %s", fname);
    endtask

    // ── main ─────────────────────────────────────────────────────────────────
    initial begin
        collected[0]    = 0;
        collected[1]    = 0;
        collected[2]    = 0;
        active_frame    = 0;
        frame_cycles[0] = 0;
        frame_cycles[1] = 0;
        frame_cycles[2] = 0;
        tile_done_count = 0;
        for (int i = 0; i < 256; i++) tile_fired[i] = 0;

        render_frame(0, 5'b00000, '0,       '0,       "Mandelbrot");
        render_frame(1, 5'b01100, '0,       '0,       "Burning Ship");
        render_frame(2, 5'b11100, JULIA_CX, JULIA_CY, "Julia c=-0.7+0.27i");

        $display("\n══ Writing CSVs ══");
        dump_csv("frame0_mandelbrot.csv",  0);
        dump_csv("frame1_burningship.csv", 1);
        dump_csv("frame2_julia.csv",       2);

        $display("\n══ Render timing summary ══");
        $display("  %-22s  %8s  %10s", "Frame", "Pixels", "Cycles");
        $display("  ──────────────────────────────────────────");
        $display("  %-22s  %8d  %10d", "Mandelbrot",   IMAGE_SIZE*IMAGE_SIZE, frame_cycles[0]);
        $display("  %-22s  %8d  %10d", "Burning Ship", IMAGE_SIZE*IMAGE_SIZE, frame_cycles[1]);
        $display("  %-22s  %8d  %10d", "Julia",        IMAGE_SIZE*IMAGE_SIZE, frame_cycles[2]);
        $display("  ──────────────────────────────────────────");
        $display("  %-22s  %8d  %10d", "Total",
                 3*IMAGE_SIZE*IMAGE_SIZE,
                 frame_cycles[0]+frame_cycles[1]+frame_cycles[2]);

        $display("\nRun: python3 hdl/worker_core/render_frames.py --max-iter %0d\n", MAX_ITER);
        $finish;
    end

    initial begin
        #(CLK_PERIOD * 50_000_000);
        $display("WATCHDOG TIMEOUT");
        $finish;
    end

endmodule
