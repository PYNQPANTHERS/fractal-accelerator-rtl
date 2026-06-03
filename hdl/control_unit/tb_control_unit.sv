// =============================================================================
// tb_control_unit.sv
//
// End-to-end Mandelbrot render testbench for control_unit.
//
//   1 cluster · 2 cores · NARROW / Mandelbrot mode · 256×256 pixels
//
//   Coordinate mapping  pan=(-2.0, 1.0)  zoom=0  window=4 units  256 pixels:
//     real  = -2.0 + px * (4.0/512)   Q2.16: -131072 + px * 512
//     imag  =  1.0 - py * (4.0/512)   Q2.16:   65536 - py * 512
//     → real in [-2.0, -0.008],  imag in [-0.992, 1.0]
//     Shows the main cardioid, period-2 bulb, antennas and filaments.
//
//   z_real / z_imag are forced every clock cycle (1 ns after posedge) because
//   translate.sv cannot produce correct Q2.16 lower-18-bit values with the
//   current scale-factor LUT.  iverilog requires a new force call each cycle.
//
//   Render after simulation:
//     python3 hdl/worker_core/render.py \
//       --csv sim/render/frame.csv --max-iter 128 --out sim/render/frame.png
// =============================================================================
`timescale 1ns/1ps

module tb_control_unit;

    // ── testbench sizing ────────────────────────────────────────────────────
    localparam int PX_W  = 256;
    localparam int PX_H  = 256;
    localparam int TOTAL = PX_W * PX_H;

    // ── control_unit parameters ─────────────────────────────────────────────
    localparam int DATA_WIDTH    = 17;
    localparam int PIXEL_WIDTH   = 9;
    localparam int CLUSTER_COUNT = 1;
    localparam int CLUSTER_SIZE  = 4;
    localparam int PIXEL_ADDR_W  = 16;
    localparam int JOB_DATA_W    = 18;
    localparam int PIXEL_W       = 8;
    localparam int OPCODE_W      = 5;
    localparam int Z_WIDE        = (DATA_WIDTH + 1) * 2 - 1;  // 35

    // ── fractal parameters ──────────────────────────────────────────────────
    // core_top opcode: {Width[10]=0, Julia[9]=0, |x||y|-x-y[8:5]=0, MaxIter[4:0]=7}
    // MaxIter=7 + LOWEST_MAX_ITER_POW=0 → cap at iteration count bit 7 = 128
    localparam logic [10:0] CORE_OPCODE = 11'h007;
    localparam int          MAX_ITER    = 128;

    // ── coordinate mapping constants ─────────────────────────────────────────
    // pan=(-2.0, 1.0), zoom=0 (scale=512/pixel), RESOLUTION=9 (512px range)
    // Q2.16: 1.0 = 65536.  window=4 units across 512 pixels → 512/pixel step
    localparam int REAL_BASE = -131072;  // -2.0 * 65536
    localparam int IMAG_BASE =   65536;  //  1.0 * 65536
    localparam int PIX_STEP  =     512;  //  4.0/512 * 65536

    // ── DUT ports ───────────────────────────────────────────────────────────
    logic            clk, rst, opcode_reset;
    logic            start_flag, width_flag;
    logic [4:0]      fractal_type, iter_cnt_in;
    logic [DATA_WIDTH-1:0] pan_x_port, pan_y_port;
    logic [3:0]      zoom_port;

    logic                    job_valid;
    logic [PIXEL_WIDTH-1:0]  job_a, job_b;
    logic                    job_ready;

    logic                    result_valid;
    logic [PIXEL_ADDR_W-1:0] result_pixel_addr;
    logic [PIXEL_W-1:0]      result_data;
    logic                    result_ready;

    logic            bram_rd_en;
    logic [PIXEL_W-1:0] bram_pixel_a, bram_pixel_b;
    logic [7:0]      bram_rd_data;
    logic            bram_wr_en;
    logic [PIXEL_W-1:0] bram_wr_pixel_a, bram_wr_pixel_b;
    logic [7:0]      bram_wr_data;

    // ── DUT ─────────────────────────────────────────────────────────────────
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
        .iteration_count   (iter_cnt_in),
        .pan_x             (pan_x_port),
        .pan_y             (pan_y_port),
        .zoom              (zoom_port),
        .job_valid         (job_valid),
        .job_a             (job_a),
        .job_b             (job_b),
        .job_ready         (job_ready),
        .result_valid      (result_valid),
        .result_pixel_addr (result_pixel_addr),
        .result_data       (result_data),
        .result_ready      (result_ready),
        .bram_rd_en        (bram_rd_en),
        .bram_pixel_a      (bram_pixel_a),
        .bram_pixel_b      (bram_pixel_b),
        .bram_rd_data      (bram_rd_data),
        .bram_wr_en        (bram_wr_en),
        .bram_wr_pixel_a   (bram_wr_pixel_a),
        .bram_wr_pixel_b   (bram_wr_pixel_b),
        .bram_wr_data      (bram_wr_data)
    );

    // ── clock ───────────────────────────────────────────────────────────────
    initial clk = 0;
    always  #5 clk = ~clk;

    // ── static inputs ───────────────────────────────────────────────────────
    assign width_flag    = 1'b0;       // NARROW mode
    assign fractal_type  = 5'b00000;   // Mandelbrot, no transforms
    assign iter_cnt_in   = 5'd7;
    assign result_ready  = 1'b1;       // always drain result FIFO
    assign pan_x_port    = '0;         // overridden by z_real force below
    assign pan_y_port    = '0;
    assign zoom_port     = 4'd0;

    // ── opcode injection ─────────────────────────────────────────────────────
    // core_top.opcode port is not connected in cluster.sv; force it before reset.
    initial begin
        force dut.gen_clusters[0].u_cluster.gen_cores[0].u_core.opcode = CORE_OPCODE;
        force dut.gen_clusters[0].u_cluster.gen_cores[1].u_core.opcode = CORE_OPCODE;
        force dut.gen_clusters[0].u_cluster.gen_cores[2].u_core.opcode = CORE_OPCODE;
        force dut.gen_clusters[0].u_cluster.gen_cores[3].u_core.opcode = CORE_OPCODE;
    end

    // ── coordinate injection ─────────────────────────────────────────────────
    // translate cannot produce correct Q2.16 values in z_real[17:0] with the
    // current LUT, so we force z_real/z_imag at every posedge+1ns using the
    // latched pixel coordinates.  iverilog evaluates force RHS once per call,
    // so we re-call each cycle to track coord_a_q/coord_b_q changes.
    logic signed [31:0] tb_real_w, tb_imag_w;

    always @(posedge clk) begin
        #1;  // after DUT non-blocking assignments have settled
        tb_real_w = REAL_BASE + $signed({23'b0, dut.coord_a_q}) * PIX_STEP;
        tb_imag_w = IMAG_BASE - $signed({23'b0, dut.coord_b_q}) * PIX_STEP;
        force dut.z_real = { {(Z_WIDE-18){tb_real_w[17]}}, tb_real_w[17:0] };
        force dut.z_imag = { {(Z_WIDE-18){tb_imag_w[17]}}, tb_imag_w[17:0] };
    end

    // ── behavioral BRAM model ────────────────────────────────────────────────
    // Mirrors the external BRAM the DUT reads/writes.
    // Word format: {colour[5:0], done[1], started[0]}
    // TB writes back {result_data[5:0], 2'b11} on every result so Phase 2
    // repeated pixels hit the BRAM-done path instead of dispatching to a core.
    logic [7:0] bram_mem [0:PX_H-1][0:PX_W-1];  // [py][px]

    initial begin
        bram_rd_data = 8'h00;
        for (int py = 0; py < PX_H; py++)
            for (int px = 0; px < PX_W; px++)
                bram_mem[py][px] = 8'h00;
    end

    // 1-cycle registered read (matches DUT's expected read latency)
    always_ff @(posedge clk)
        if (bram_rd_en)
            bram_rd_data <= bram_mem[bram_pixel_b][bram_pixel_a];

    // DUT writes (started/done flag updates) + TB writeback on result
    always_ff @(posedge clk) begin
        if (bram_wr_en)
            bram_mem[bram_wr_pixel_b][bram_wr_pixel_a] <= bram_wr_data;
        if (result_valid && result_ready)
            bram_mem[result_pixel_addr[7:0]][result_pixel_addr[15:8]]
                <= {result_data[5:0], 2'b11};
    end

    // ── address FIFO (behavioral scheduler) ─────────────────────────────────
    localparam int SCHED_SIZE = TOTAL + 64;
    logic [PIXEL_WIDTH-1:0] sched_a [0:SCHED_SIZE-1];
    logic [PIXEL_WIDTH-1:0] sched_b [0:SCHED_SIZE-1];
    int unsigned sched_wr = 0;
    int unsigned sched_rd = 0;

    wire sched_empty = (sched_wr == sched_rd);
    assign job_valid = !sched_empty;
    assign job_a     = sched_empty ? '0 : sched_a[sched_rd];
    assign job_b     = sched_empty ? '0 : sched_b[sched_rd];

    always_ff @(posedge clk) begin
        if (job_valid && job_ready)
            sched_rd <= sched_rd + 1;
    end

    // ── result collection ────────────────────────────────────────────────────
    // result_pixel_addr = {px[7:0], py[7:0]}  (coord_a_q=px upper, coord_b_q=py lower)
    // result_data       = iteration_count[7:0]
    logic [PIXEL_W-1:0] frame_mem [0:PX_H-1][0:PX_W-1];  // [py][px]
    int unsigned pixels_done = 0;

    initial begin
        for (int py = 0; py < PX_H; py++)
            for (int px = 0; px < PX_W; px++)
                frame_mem[py][px] = 8'hFF;
    end

    always_ff @(posedge clk) begin
        if (result_valid && result_ready) begin
            // pixel_addr[15:8] = px (coord_a), pixel_addr[7:0] = py (coord_b)
            frame_mem[result_pixel_addr[7:0]][result_pixel_addr[15:8]] <= result_data;
            pixels_done <= pixels_done + 1;
        end
    end

    // ── cycle counter ────────────────────────────────────────────────────────
    longint unsigned cycle_count = 0;
    always @(posedge clk) cycle_count <= cycle_count + 1;

    // ── main sequence ────────────────────────────────────────────────────────
    integer fd;

    initial begin
        rst          = 1'b1;
        opcode_reset = 1'b0;
        start_flag   = 1'b0;

        // ① fill scheduler FIFO: row-major px=0..255, py=0..255
        for (int py = 0; py < PX_H; py++)
            for (int px = 0; px < PX_W; px++) begin
                sched_a[sched_wr] = PIXEL_WIDTH'(unsigned'(px));
                sched_b[sched_wr] = PIXEL_WIDTH'(unsigned'(py));
                sched_wr++;
            end

        // ② reset — 4 cycles
        repeat (4) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        // ③ opcode broadcast: 1-cycle pulse
        //    Cores: BOTH_IDLE → LOADING_OPCODES (latch forced opcode port) → BOTH_IDLE
        opcode_reset = 1'b1;
        @(posedge clk);
        opcode_reset = 1'b0;

        // ④ wait for opcode load + cluster_wants_job pipeline (need ≥3 cy)
        repeat (8) @(posedge clk);

        // ⑤ start frame: FSM IDLE → OPCODE_BROADCAST (1 cy) → JOB_WAIT
        start_flag = 1'b1;
        @(posedge clk);
        start_flag = 1'b0;

        // ⑥ wait for all 256×256 results
        $display("[TB] Rendering %0d pixels (1 cluster / %0d cores / NARROW Mandelbrot)...", TOTAL, CLUSTER_SIZE);
        wait (pixels_done == TOTAL);

        // ⑦ dump CSV  (directory created by Makefile)
        $display("[TB] Done in %0d cycles (%0d cycles/pixel). Writing sim/render/frame.csv...",
                 cycle_count, cycle_count / TOTAL);
        fd = $fopen("sim/render/frame.csv", "w");
        if (!fd) begin
            $display("[TB] ERROR: cannot open file (run from project root, mkdir sim/render)");
            $finish;
        end
        $fwrite(fd, "px,py,iterations\n");
        for (int py = 0; py < PX_H; py++)
            for (int px = 0; px < PX_W; px++)
                $fwrite(fd, "%0d,%0d,%0d\n", px, py, int'(frame_mem[py][px]));
        $fclose(fd);

        $display("[TB] CSV written.");
        $display("  Render: python3 hdl/worker_core/render.py --csv sim/render/frame.csv --max-iter %0d --out sim/render/frame.png", MAX_ITER);

        // ── Phase 2: BRAM cache-hit test ─────────────────────────────────────
        // Re-send the top-left 8×8 block (64 pixels).  Each pixel was already
        // computed in Phase 1, so bram_mem has {colour,2'b11} → bram_done=1.
        // The FSM should return the cached result in ~4 cycles/pixel rather
        // than ~27 cycles/pixel for a freshly computed pixel.
        begin
            longint unsigned phase2_start_cy;
            $display("[TB] Phase 2: sending 64 already-computed pixels to test BRAM cache hits...");
            for (int py2 = 0; py2 < 8; py2++)
                for (int px2 = 0; px2 < 8; px2++) begin
                    sched_a[sched_wr] = PIXEL_WIDTH'(unsigned'(px2));
                    sched_b[sched_wr] = PIXEL_WIDTH'(unsigned'(py2));
                    sched_wr++;
                end
            phase2_start_cy = cycle_count;
            wait (pixels_done == TOTAL + 64);
            $display("[TB] Phase 2 done: 64 BRAM-hit pixels in %0d cycles (%0d cycles/pixel vs ~%0d for compute)",
                     cycle_count - phase2_start_cy,
                     (cycle_count - phase2_start_cy) / 64,
                     cycle_count / TOTAL);
        end

        $finish;
    end

    // ── global timeout ───────────────────────────────────────────────────────
    // Actual rate ~857 cyc/pixel (FSM overhead dominates over compute cycles).
    // 65536 × 857 = ~56M cycles = ~560ms sim time; 2s gives comfortable margin.
    initial begin
        #2_200_000_000;
        $display("[TB] GLOBAL TIMEOUT  pixels_done=%0d / %0d", pixels_done, TOTAL + 64);
        $finish;
    end

    // ── progress ─────────────────────────────────────────────────────────────
    always @(posedge clk) begin
        if (pixels_done > 0 && (pixels_done % 4096 == 0))
            $display("[TB] %0d / %0d pixels complete", pixels_done, TOTAL);
    end

    // ── stall watchdog ────────────────────────────────────────────────────────
    // Fires if pixels_done stops advancing for 200 000 cycles (≈2ms sim time).
    // Prints FSM and cluster state so we can see where the deadlock is.
    int unsigned last_pixels_done = 0;
    int unsigned stall_cycles     = 0;

    always @(posedge clk) begin
        if (pixels_done != last_pixels_done) begin
            last_pixels_done <= pixels_done;
            stall_cycles     <= 0;
        end else begin
            stall_cycles <= stall_cycles + 1;
        end
        if (stall_cycles == 200_000) begin
            $display("[TB] STALL DETECTED after %0d idle cycles  pixels_done=%0d",
                     stall_cycles, pixels_done);
            $display("  FSM state       = %0d  job_valid=%0b  job_ready=%0b  any_cluster_free=%0b",
                     dut.u_fsm.current_state, job_valid, dut.job_ready, dut.any_cluster_free);
            $display("  cluster_wants_job=%0b  core0_ready=%0b  core1_ready=%0b  core2_ready=%0b  core3_ready=%0b",
                     dut.gen_clusters[0].u_cluster.cluster_wants_job,
                     dut.gen_clusters[0].u_cluster.gen_cores[0].u_core.ready,
                     dut.gen_clusters[0].u_cluster.gen_cores[1].u_core.ready,
                     dut.gen_clusters[0].u_cluster.gen_cores[2].u_core.ready,
                     dut.gen_clusters[0].u_cluster.gen_cores[3].u_core.ready);
            $display("  core0_state=%0d  core1_state=%0d  core2_state=%0d  core3_state=%0d",
                     dut.gen_clusters[0].u_cluster.gen_cores[0].u_core.core_state,
                     dut.gen_clusters[0].u_cluster.gen_cores[1].u_core.core_state,
                     dut.gen_clusters[0].u_cluster.gen_cores[2].u_core.core_state,
                     dut.gen_clusters[0].u_cluster.gen_cores[3].u_core.core_state);
            $display("  core0_cycles=(%0d,%0d)  core1_cycles=(%0d,%0d)  core2_cycles=(%0d,%0d)  core3_cycles=(%0d,%0d)",
                     dut.gen_clusters[0].u_cluster.gen_cores[0].u_core.m_manage.left_cycle,
                     dut.gen_clusters[0].u_cluster.gen_cores[0].u_core.m_manage.right_cycle,
                     dut.gen_clusters[0].u_cluster.gen_cores[1].u_core.m_manage.left_cycle,
                     dut.gen_clusters[0].u_cluster.gen_cores[1].u_core.m_manage.right_cycle,
                     dut.gen_clusters[0].u_cluster.gen_cores[2].u_core.m_manage.left_cycle,
                     dut.gen_clusters[0].u_cluster.gen_cores[2].u_core.m_manage.right_cycle,
                     dut.gen_clusters[0].u_cluster.gen_cores[3].u_core.m_manage.left_cycle,
                     dut.gen_clusters[0].u_cluster.gen_cores[3].u_core.m_manage.right_cycle);
            $display("  cluster_fifo_empty=%0b  cluster_fifo_full=%0b",
                     dut.gen_clusters[0].u_cluster.u_result_fifo.empty,
                     dut.gen_clusters[0].u_cluster.u_result_fifo.full);
            $display("  res_fifo_empty=%0b  res_fifo_full=%0b  sched_rd=%0d  sched_wr=%0d",
                     dut.u_res_fifo.empty, dut.u_res_fifo.full, sched_rd, sched_wr);
            $display("  core0_gen_counter=%0d  core1_gen_counter=%0d",
                     dut.gen_clusters[0].u_cluster.gen_cores[0].u_core.general_counter,
                     dut.gen_clusters[0].u_cluster.gen_cores[1].u_core.general_counter);
            // dump partial frame so we can see which pixels are missing
            begin
                integer fd2;
                fd2 = $fopen("sim/render/frame.csv", "w");
                if (fd2) begin
                    $fwrite(fd2, "px,py,iterations\n");
                    for (int py2 = 0; py2 < PX_H; py2++)
                        for (int px2 = 0; px2 < PX_W; px2++)
                            $fwrite(fd2, "%0d,%0d,%0d\n", px2, py2, int'(frame_mem[py2][px2]));
                    $fclose(fd2);
                    $display("[TB] Partial frame written to sim/render/frame.csv (0xFF = missing)");
                end
            end
            $finish;
        end
    end

endmodule
