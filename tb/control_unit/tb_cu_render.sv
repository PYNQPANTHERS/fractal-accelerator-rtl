// ─────────────────────────────────────────────────────────────────────────────
// tb_cu_render
//   Renders three 128x128 fractal frames through control_unit with
//   CLUSTER_COUNT clusters running in parallel.
//
//   Frame 0: Mandelbrot    fractal_type = 5'b00000
//   Frame 1: Burning Ship  fractal_type = 5'b01100  (abs_x, abs_y)
//   Frame 2: Julia         fractal_type = 5'b10000  c = -0.7 + 0.27i
//
//   View window: 2*2
//     zoom=0 (scale=512), pan_x=-1.0, pan_y≈+1.0, 128 pixels each axis.
//
//   Output: frame0_mandelbrot.csv, frame1_burningship.csv, frame2_julia.csv
//     format: col,row,iters  (matches render_frames.py)
//   Run: python3 hdl/worker_core/render_frames.py --max-iter 128
// ─────────────────────────────────────────────────────────────────────────────
`timescale 1ns/1ps

module tb_cu_render;

    // ── sizing ────────────────────────────────────────────────────────────────
    localparam int IMAGE_SIZE    = 256;
    localparam int CLUSTER_COUNT = 2;
    localparam int CLUSTER_SIZE  = 4;
    localparam int DATA_WIDTH    = 17;
    localparam int PIXEL_WIDTH   = 9;
    localparam int PIXEL_ADDR_W  = 16;   // 2 × PIXEL_W
    localparam int JOB_DATA_W    = 18;
    localparam int PIXEL_W       = 8;
    localparam int OPCODE_W      = 5;

    localparam time CLK_PERIOD = 10ns;

    // ── view ──────────────────────────────────────────────────────────────────
    // zoom=0 → scale=512 per pixel.  128 pixels × 512 = 65536 ≈ 1.0 span.
    // pan_x = -1.0 = -65536,  pan_y ≈ +1.0 = 65024
    // → z_real/imag in [-1.0, +1.0] for pixel indices 0..127
    localparam logic signed [DATA_WIDTH-1:0] PAN_X = 17'($signed(-65536));
    localparam logic signed [DATA_WIDTH-1:0] PAN_Y = 17'(65024);
    localparam logic [3:0] ZOOM = 4'd0;

    // iteration_count field 5'd1 → 2^(6+1) = 128 iterations (fits in PIXEL_W=8 bits)
    localparam logic [OPCODE_W-1:0] MAX_ITER_FIELD = 5'd1;
    localparam int                   MAX_ITER       = 128;

    // Julia c = -0.7 + 0.27i in Q2.16
    localparam logic signed [DATA_WIDTH-1:0] JULIA_CX = 17'($signed(-45875));
    localparam logic signed [DATA_WIDTH-1:0] JULIA_CY = 17'(17695);

    // ── DUT signals ───────────────────────────────────────────────────────────
    logic                    clk, rst;
    logic                    opcode_reset;
    logic                    start_flag;
    logic                    width_flag;
    logic [OPCODE_W-1:0]     fractal_type;
    logic [OPCODE_W-1:0]     iteration_count;
    logic [DATA_WIDTH-1:0]   pan_x, pan_y;
    logic [3:0]              zoom;
    logic [DATA_WIDTH-1:0]   c_x, c_y;

    logic                    job_valid;
    logic [PIXEL_WIDTH-1:0]  job_a, job_b;
    logic                    job_ready;

    logic                    result_valid;
    logic [PIXEL_ADDR_W-1:0] result_pixel_addr;
    logic [PIXEL_W-1:0]      result_data;
    logic                    result_ready;

    // ── DUT ──────────────────────────────────────────────────────────────────
    control_unit #(
        .DATA_WIDTH    (DATA_WIDTH),
        .PIXEL_WIDTH   (PIXEL_WIDTH),
        .CLUSTER_COUNT (CLUSTER_COUNT),
        .CLUSTER_SIZE  (CLUSTER_SIZE),
        .PIXEL_ADDR_W  (PIXEL_ADDR_W),
        .JOB_DATA_W    (JOB_DATA_W),
        .PIXEL_W       (PIXEL_W),
        .OPCODE_W      (OPCODE_W)
    ) dut (
        .clk               (clk),
        .rst               (rst),
        .opcode_reset      (opcode_reset),
        .start_flag        (start_flag),
        .width_flag        (width_flag),
        .fractal_type      (fractal_type),
        .iteration_count   (iteration_count),
        .pan_x             (pan_x),
        .pan_y             (pan_y),
        .zoom              (zoom),
        .c_x               (c_x),
        .c_y               (c_y),
        .job_valid         (job_valid),
        .job_a             (job_a),
        .job_b             (job_b),
        .job_ready         (job_ready),
        .result_valid      (result_valid),
        .result_pixel_addr (result_pixel_addr),
        .result_data       (result_data),
        .result_ready      (result_ready),
        .bram_rd_data      (8'h00)
    );

    // ── clock ─────────────────────────────────────────────────────────────────
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // ── frame buffers ─────────────────────────────────────────────────────────
    // frame_buf[frame_id][row * IMAGE_SIZE + col]
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

    // always accept results, store by pixel address
    assign result_ready = 1'b1;

    initial begin : collector
        int row, col;
        forever begin
            @(posedge clk);
            if (result_valid) begin
                col = result_pixel_addr[PIXEL_ADDR_W-1:PIXEL_W];
                row = result_pixel_addr[PIXEL_W-1:0];
                frame_buf[active_frame][row * IMAGE_SIZE + col] = result_data;
                collected[active_frame]++;
            end
        end
    end

    // ── helpers ───────────────────────────────────────────────────────────────
    task automatic do_reset();
        rst             = 1;
        start_flag      = 0;
        opcode_reset    = 0;
        job_valid       = 0;
        job_a           = '0;
        job_b           = '0;
        width_flag      = 0;
        fractal_type    = '0;
        iteration_count = '0;
        pan_x           = PAN_X;
        pan_y           = PAN_Y;
        zoom            = ZOOM;
        c_x             = '0;
        c_y             = '0;
        repeat (4) @(posedge clk);
        rst = 0;
        @(posedge clk);
    endtask

    task automatic start_frame(
        input logic [OPCODE_W-1:0]   ftype,
        input logic [OPCODE_W-1:0]   icount,
        input logic [DATA_WIDTH-1:0] cx,
        input logic [DATA_WIDTH-1:0] cy
    );
        int c;
        fractal_type    = ftype;
        iteration_count = icount;
        c_x             = cx;
        c_y             = cy;
        opcode_reset    = 1;
        @(posedge clk);
        opcode_reset    = 0;
        start_flag      = 1;
        @(posedge clk);
        start_flag      = 0;
        c = 0;
        do begin
            @(negedge clk);
            if (c++ >= 10_000) begin
                $error("[%0t] start_frame timed out", $time);
                return;
            end
        end while (!job_ready);
    endtask

    task automatic send_job(
        input logic [PIXEL_WIDTH-1:0] a,
        input logic [PIXEL_WIDTH-1:0] b
    );
        int c;
        c         = 0;
        job_a     = a;
        job_b     = b;
        job_valid = 1;
        do begin
            @(negedge clk);
            if (c++ >= 100_000) begin
                $error("[%0t] send_job TIMEOUT (a=%0d b=%0d)", $time, a, b);
                job_valid = 0;
                return;
            end
        end while (!job_ready);
        @(posedge clk);
        @(negedge clk);
        job_valid = 0;
        job_a     = '0;
        job_b     = '0;
    endtask

    task automatic drain(input int fid);
        int timeout, quiet;
        timeout = 0;
        quiet   = 0;
        // exit when all results are collected AND result pipe is quiet for 10 cycles
        while ((collected[fid] < IMAGE_SIZE * IMAGE_SIZE || quiet < 10)
               && timeout < 10_000_000) begin
            @(posedge clk);
            timeout++;
            if (result_valid) quiet = 0;
            else              quiet = quiet + 1;
        end
        if (collected[fid] < IMAGE_SIZE * IMAGE_SIZE)
            $error("[%0t] drain timeout: got %0d / %0d",
                   $time, collected[fid], IMAGE_SIZE * IMAGE_SIZE);
    endtask

    task automatic render_frame(
        input int                    fid,
        input logic [OPCODE_W-1:0]   ftype,
        input logic [DATA_WIDTH-1:0] cx,
        input logic [DATA_WIDTH-1:0] cy,
        input string                 name
    );
        longint t_start, t_end;
        $display("\n══ Frame %0d: %s  %0dx%0d ══", fid, name, IMAGE_SIZE, IMAGE_SIZE);
        collected[fid] = 0;
        active_frame   = fid;

        do_reset();
        start_frame(ftype, MAX_ITER_FIELD, cx, cy);

        t_start = $time;
        for (int row = 0; row < IMAGE_SIZE; row++)
            for (int col = 0; col < IMAGE_SIZE; col++)
                send_job(PIXEL_WIDTH'(col), PIXEL_WIDTH'(row));

        $display("  dispatched %0d pixels, draining...", IMAGE_SIZE * IMAGE_SIZE);
        drain(fid);
        t_end = $time;

        frame_cycles[fid] = (t_end - t_start) / CLK_PERIOD;
        $display("  collected  %0d / %0d  (%0d cycles)",
                 collected[fid], IMAGE_SIZE * IMAGE_SIZE, frame_cycles[fid]);
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
