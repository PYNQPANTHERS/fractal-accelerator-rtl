`timescale 1ns/1ps

// ─────────────────────────────────────────────────────────────────────────────
// tb_engine_full
//
// Full-system render of one 256×256 sixteenth via per_sixteenth_engine.
//
// Configuration
//   Fractal  : Mandelbrot  (fractal_type = 5'b0_0000)
//   Pan      : top-left (-1.0, +1.0) in Q2.16
//              pan_x = -1.0 * 2^16 = 0xFFFF_0000 (sign-extended)
//              pan_y = +1.0 * 2^16 = 0x0001_0000
//   Zoom     : 1  (step = 256/256 = 1 per pixel, 2-unit window)
//   Max iter : field 2 → 2^(6+2) = 256 iterations
//   Sixteenth: index 0  → x_offset=0, y_offset=0, base_addr=0
//
// Observation points
//   1. BRAM writes — tapped from dut.u_colour_bram hierarchy
//   2. DRAM writes — AXI HP write bus  (primary output)
//
// Outputs
//   sim/render/engine_full_dram.csv   — every AXI write: addr, 8 pixel bytes
//   sim/render/engine_full_bram.csv   — every BRAM write: x, y, colour
//   sim/render/engine_full_image.csv  — reconstructed 256×256 pixel grid
//   sim/waves/tb_engine_full.vcd
// ─────────────────────────────────────────────────────────────────────────────

module tb_engine_full;

    // ── Clock ────────────────────────────────────────────────────────────────
    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // ── DUT signals ──────────────────────────────────────────────────────────
    logic        rst;
    logic        start;
    logic        engine_done;
    logic        sixteenth_complete;

    // Q2.16: -1.0 = 0xFFFF_0000, +1.0 = 0x0001_0000
    localparam logic [31:0] PAN_X = 32'hFFFF_0000;
    localparam logic [31:0] PAN_Y = 32'h0001_0000;
    localparam logic [31:0] ZOOM  = 32'd1;
    localparam logic [11:0] MAX_I = 12'd2;   // max_iter field
    localparam logic [31:0] BASE  = 32'h0000_0000;

    logic [4:0]  fractal_type;
    logic [31:0] pan_x, pan_y, zoom_level;
    logic [11:0] max_iter;
    logic [9:0]  x_offset, y_offset;
    logic [3:0]  sixteenth_id;
    logic [31:0] sixteenth_base_addr;

    logic [31:0] axi_wr_addr;
    logic [63:0] axi_wr_data;
    logic        axi_wr_en;
    logic        axi_wr_ready;

    // ── DUT ──────────────────────────────────────────────────────────────────
    per_sixteenth_engine dut (
        .clk                (clk),
        .rst                (rst),
        .start              (start),
        .engine_done        (engine_done),
        .sixteenth_complete (sixteenth_complete),
        .fractal_type       (fractal_type),
        .pan_x              (pan_x),
        .pan_y              (pan_y),
        .zoom_level         (zoom_level),
        .max_iter           (max_iter),
        .x_offset           (x_offset),
        .y_offset           (y_offset),
        .sixteenth_id       (sixteenth_id),
        .sixteenth_base_addr(sixteenth_base_addr),
        .axi_wr_addr        (axi_wr_addr),
        .axi_wr_data        (axi_wr_data),
        .axi_wr_en          (axi_wr_en),
        .axi_wr_ready       (axi_wr_ready)
    );

    // ── DRAM capture ─────────────────────────────────────────────────────────
    localparam int MAX_DRAM = 8192;
    logic [31:0] dram_addr [0:MAX_DRAM-1];
    logic [63:0] dram_data [0:MAX_DRAM-1];
    int          dram_count;

    always @(posedge clk) begin
        if (axi_wr_en && axi_wr_ready && dram_count < MAX_DRAM) begin
            dram_addr[dram_count] = axi_wr_addr;
            dram_data[dram_count] = axi_wr_data;
            dram_count++;
        end
    end

    // ── BRAM write tap ───────────────────────────────────────────────────────
    localparam int MAX_BRAM = 65536;
    logic [7:0]  bram_wr_x   [0:MAX_BRAM-1];
    logic [7:0]  bram_wr_y   [0:MAX_BRAM-1];
    logic [7:0]  bram_wr_col [0:MAX_BRAM-1];
    int          bram_count;

    always @(posedge clk) begin
        if (dut.u_colour_bram.ctrl_wr_en && bram_count < MAX_BRAM) begin
            bram_wr_x  [bram_count] = dut.u_colour_bram.ctrl_wr_x;
            bram_wr_y  [bram_count] = dut.u_colour_bram.ctrl_wr_y;
            bram_wr_col[bram_count] = dut.u_colour_bram.ctrl_wr_data;
            bram_count++;
        end
    end

    // ── Cycle / heartbeat ────────────────────────────────────────────────────
    longint cycle_count;
    always @(posedge clk) cycle_count++;
    always @(posedge clk)
        if (cycle_count > 0 && (cycle_count % 100000) == 0)
            $display("  [heartbeat] cycle=%0d  bram=%0d  dram=%0d",
                     cycle_count, bram_count, dram_count);

    // ── Check helpers ────────────────────────────────────────────────────────
    int tests_passed, tests_failed;

    task automatic check(input logic cond, input string msg);
        if (cond) begin tests_passed++; $display("  [PASS] %s", msg); end
        else      begin tests_failed++; $display("  [FAIL] %s", msg); end
    endtask

    // ── Reset ────────────────────────────────────────────────────────────────
    task automatic do_reset();
        rst = 1; start = 0; tick(4); rst = 0; tick(2);
    endtask

    // ── CSV dump: DRAM ───────────────────────────────────────────────────────
    task automatic dump_dram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        if (fd == 0) begin
            $display("ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "write_index,addr_hex,b0,b1,b2,b3,b4,b5,b6,b7\n");
            for (int i = 0; i < dram_count; i++)
                $fwrite(fd, "%0d,0x%08X,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    i, dram_addr[i],
                    dram_data[i][ 7: 0], dram_data[i][15: 8],
                    dram_data[i][23:16], dram_data[i][31:24],
                    dram_data[i][39:32], dram_data[i][47:40],
                    dram_data[i][55:48], dram_data[i][63:56]);
            $fclose(fd);
            $display("  wrote %s  (%0d rows)", path, dram_count);
        end
    endtask

    // ── CSV dump: BRAM writes ─────────────────────────────────────────────────
    task automatic dump_bram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        if (fd == 0) begin
            $display("ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "write_index,x,y,colour\n");
            for (int i = 0; i < bram_count; i++)
                $fwrite(fd, "%0d,%0d,%0d,%0d\n",
                    i, bram_wr_x[i], bram_wr_y[i], bram_wr_col[i] & 8'h3F);
            $fclose(fd);
            $display("  wrote %s  (%0d rows)", path, bram_count);
        end
    endtask

    // ── CSV dump: reconstructed pixel image from DRAM ────────────────────────
    // colour_bram tile layout: tile_idx = {tile_row[3:0], tile_col[3:0]}
    // bram_to_dram address: base + tile_idx*256 + word*8
    // Each 64-bit word = 8 pixels, 2 words per tile row, 16 tile rows → 32 words/tile
    task automatic dump_pixel_csv(input string path);
        logic [7:0] image [0:255][0:255];
        integer fd;
        logic [31:0] offset;
        int tile_idx, word_in_tile;
        int tile_col16, tile_row16;
        int row_in_tile, col_start;
        int px, py;

        for (int r = 0; r < 256; r++)
            for (int c = 0; c < 256; c++)
                image[r][c] = 8'hFF;

        for (int i = 0; i < dram_count; i++) begin
            offset       = dram_addr[i] - BASE;   // offset in bytes within sixteenth
            tile_idx     = offset[15:8];            // tile_idx = offset / 256
            word_in_tile = offset[7:3];             // word within tile = (offset % 256) / 8
            // tile_table index: {tile_y[3:0], tile_x[3:0]} from colour_bram ordering
            tile_col16   = tile_idx[3:0];
            tile_row16   = tile_idx[7:4];
            row_in_tile  = word_in_tile / 2;        // 2 words per pixel row
            col_start    = (word_in_tile % 2) * 8; // first pixel column in this word
            for (int b = 0; b < 8; b++) begin
                px = tile_col16 * 16 + col_start + b;
                py = tile_row16 * 16 + row_in_tile;
                if (px < 256 && py < 256)
                    image[py][px] = dram_data[i][b*8 +: 8];
            end
        end

        fd = $fopen(path, "w");
        if (fd == 0) begin
            $display("ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "row,col,colour\n");
            for (int r = 0; r < 256; r++)
                for (int c = 0; c < 256; c++)
                    $fwrite(fd, "%0d,%0d,%0d\n", r, c, image[r][c] & 8'h3F);
            $fclose(fd);
            $display("  wrote %s  (256x256 pixel image)", path);
        end
    endtask

    // ── Main ─────────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("sim/waves/tb_engine_full.vcd");
        $dumpvars(0, tb_engine_full);

        tests_passed  = 0;
        tests_failed  = 0;
        dram_count    = 0;
        bram_count    = 0;
        cycle_count   = 0;
        axi_wr_ready  = 1'b1;
        start         = 1'b0;
        rst           = 1'b0;

        fractal_type        = 5'b0_0000;
        pan_x               = PAN_X;
        pan_y               = PAN_Y;
        zoom_level          = ZOOM;
        max_iter            = MAX_I;
        x_offset            = 10'd0;
        y_offset            = 10'd0;
        sixteenth_id        = 4'd0;
        sixteenth_base_addr = BASE;

        $display("\n%0s", {72{"="}});
        $display("  tb_engine_full  -  Mandelbrot 256x256 (sixteenth 0)");
        $display("  pan=(-1.0,+1.0)  zoom=%0d  max_iter_field=%0d", ZOOM, MAX_I);
        $display("%0s\n", {72{"="}});

        // ── Reset state checks ────────────────────────────────────────────────
        do_reset();
        check(!engine_done,        "engine_done low after reset");
        check(!sixteenth_complete, "sixteenth_complete low after reset");
        check(!axi_wr_en,          "axi_wr_en low after reset");
        check(dram_count == 0,     "no DRAM writes before start");

        // ── Start ─────────────────────────────────────────────────────────────
        $display("\n  Starting engine...");
        start = 1; tick(1); start = 0;

        // ── Wait engine_done (scheduler + compute done) ───────────────────────
        begin : wait_engine
            int t;
            t = 0;
            while (!engine_done && t < 5_000_000) begin tick(1); t++; end
            check(engine_done,
                  $sformatf("engine_done fires within 5M cycles (took %0d)", t));
            $display("  engine_done at cycle %0d  (bram_writes=%0d)", cycle_count, bram_count);
            if (!engine_done) begin
                $display("  [DIAG] scheduler state = %0d  stack_empty=%0b",
                         dut.u_scheduler.state, dut.u_scheduler.u_stack.empty);
                $display("  [DIAG] engine_done=%0b  jqh stall=%0b  flush=%0b",
                         engine_done,
                         dut.u_job_queue_handler.sched_stall,
                         dut.u_scheduler.flush);
            end
        end

        // ── BRAM mid-run checks ───────────────────────────────────────────────
        $display("\n  BRAM state at engine_done:");
        begin : bram_check
            int nonzero;
            nonzero = 0;
            for (int w = 0; w < 64; w++)
                if (dut.u_colour_bram.mem[w] !== 64'h0) nonzero++;
            check(nonzero > 0,
                  $sformatf("BRAM: at least 1 non-zero word in first 64 (found %0d)", nonzero));
        end
        check(bram_count > 0,
              $sformatf("BRAM write count > 0 (got %0d)", bram_count));

        // ── Wait sixteenth_complete (bram_to_dram stream done) ────────────────
        $display("\n  Waiting for sixteenth_complete...");
        begin : wait_complete
            int t;
            t = 0;
            while (!sixteenth_complete && t < 2_000_000) begin tick(1); t++; end
            check(sixteenth_complete,
                  $sformatf("sixteenth_complete fires within 2M extra cycles (took %0d)", t));
            $display("  sixteenth_complete at cycle %0d  (dram_writes=%0d)",
                     cycle_count, dram_count);
            if (!sixteenth_complete) begin
                $display("  [DIAG] b2d state=%0d  transferred=%0b  engine_done=%0b",
                         dut.u_bram_to_dram.state,
                         dut.u_bram_to_dram.transferred == '1,
                         engine_done);
                $display("  [DIAG] tile_done[7:0]=%0b  pending[7:0]=%0b",
                         dut.tile_done[7:0],
                         dut.u_bram_to_dram.pending[7:0]);
            end
        end

        tick(10);

        // ── DRAM output checks ────────────────────────────────────────────────
        $display("\n  DRAM output checks:");
        check(dram_count == 8192,
              $sformatf("DRAM write count == 8192 (got %0d)", dram_count));

        begin : addr_range_check
            int ok;
            ok = 1;
            for (int i = 0; i < dram_count; i++)
                if (dram_addr[i] < BASE || dram_addr[i] > BASE + 32'h0001_FFF8) ok = 0;
            check(ok, "all DRAM addresses in range [0x0, 0x1FFF8]");
        end

        begin : nonzero_check
            int nz;
            nz = 0;
            for (int i = 0; i < dram_count; i++)
                if (dram_data[i] !== 64'h0) nz++;
            check(nz > 100,
                  $sformatf("more than 100 non-zero DRAM data words (got %0d)", nz));
        end

        begin : dup_check
            int dups;
            dups = 0;
            // Check first 512 entries (full scan is O(n^2) and slow)
            for (int i = 0; i < 512 && i < dram_count; i++)
                for (int j = i+1; j < 512 && j < dram_count; j++)
                    if (dram_addr[i] == dram_addr[j]) dups++;
            check(dups == 0,
                  $sformatf("no duplicate DRAM addresses in first 512 writes (dups=%0d)", dups));
        end

        check(bram_count >= 256,
              $sformatf("BRAM write count >= 256 (got %0d)", bram_count));

        // ── Dump CSVs ─────────────────────────────────────────────────────────
        $display("\n  Writing CSVs...");
        dump_dram_csv("sim/render/engine_full_dram.csv");
        dump_bram_csv("sim/render/engine_full_bram.csv");
        dump_pixel_csv("sim/render/engine_full_image.csv");

        // ── Summary ───────────────────────────────────────────────────────────
        $display("\n%0s", {72{"="}});
        $display("  Total cycles : %0d", cycle_count);
        $display("  BRAM writes  : %0d", bram_count);
        $display("  DRAM writes  : %0d", dram_count);
        $display("  RESULTS: %0d passed, %0d failed", tests_passed, tests_failed);
        if (tests_failed == 0) $display("  ALL TESTS PASSED");
        else                   $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%0s\n", {72{"="}});

        $finish;
    end

    // ── Watchdog ─────────────────────────────────────────────────────────────
    initial begin
        #(CLK_HALF * 2 * 15_000_000);
        $display("\n[WATCHDOG] simulation timed out at cycle %0d", cycle_count);
        $finish;
    end

endmodule
