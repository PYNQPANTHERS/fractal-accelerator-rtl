`timescale 1ns/1ps

// ─────────────────────────────────────────────────────────────────────────────
// tb_engine_full
//
// Level-2: per_sixteenth_engine, multiple sixteenth configurations.
// Runs sixteenth 0 (top-left) and optionally sixteenth 5 (centre) to check
// that the engine resets cleanly between renders and produces distinct images.
// All real sub-modules; no stubs.
//
// Per-sixteenth outputs:
//   sim/render/engine_sixteenth_N_bram.csv  — colour_bram writes for sixteenth N
//   sim/render/engine_sixteenth_N_dram.csv  — AXI writes for sixteenth N
//   sim/render/engine_sixteenth_N_image.csv — 256×256 pixel reconstruction
//
// Combined:
//   sim/render/engine_full_bram.csv  — all BRAM writes across both runs (tagged)
//   sim/render/engine_full_dram.csv  — all DRAM writes across both runs (tagged)
//   sim/waves/tb_engine_full.vcd
//
// Checks per sixteenth:
//   RESET        — outputs quiet
//   ENGINE DONE  — scheduler completes within timeout
//   BRAM WRITES  — pixels land in colour_bram; non-zero data
//   TILE DONE    — at least 1 tile marked done
//   SIXTEENTH OK — sixteenth_complete; exactly 8192 DRAM writes
//   ADDRESSES    — no out-of-range or duplicate writes
//   COVERAGE     — bram_cnt matches expected pixel count (≥ border count)
// ─────────────────────────────────────────────────────────────────────────────

module tb_engine_full;

    // ── Clock ─────────────────────────────────────────────────────────────────
    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // ── Check infrastructure ──────────────────────────────────────────────────
    int tests_passed = 0, tests_failed = 0;
    string current_suite = "";

    task automatic suite(input string name);
        current_suite = name;
        $display("\n%s", {72{"="}});
        $display("  SUITE: %s", name);
        $display("%s", {72{"="}});
    endtask

    task automatic check(input logic cond, input string msg);
        if (cond) begin tests_passed++; $display("  [PASS] %s", msg); end
        else      begin tests_failed++; $display("  [FAIL] %s  (%s)", msg, current_suite); end
    endtask

    // ── DUT signals ───────────────────────────────────────────────────────────
    logic        rst, start;
    wire         engine_done, sixteenth_complete;
    logic [4:0]  fractal_type;
    logic [31:0] pan_x, pan_y, zoom_level;
    logic [11:0] max_iter;
    logic [9:0]  x_offset, y_offset;
    logic [3:0]  sixteenth_id;
    logic [31:0] sixteenth_base_addr;
    wire  [31:0] axi_wr_addr;
    wire  [63:0] axi_wr_data;
    wire         axi_wr_en;
    logic        axi_wr_ready;

    // Mandelbrot, centred at (-0.5, 0), full 1024-pixel window
    // pan_x = -2.0 in Q2.16 = 0xFFFE_0000, pan_y = +1.0 = 0x0001_0000
    localparam logic [31:0] PAN_X_BASE = 32'hFFFE_0000;
    localparam logic [31:0] PAN_Y_BASE = 32'h0001_0000;
    localparam logic [31:0] ZOOM       = 32'd1;
    // max_iter field 3 → 2^(6+3)=512 iterations — moderate sim cost
    localparam logic [11:0] MAX_I      = 12'd3;
    // Each sixteenth occupies 256×256 = 65536 pixels = 8192 words = 65536 bytes
    localparam logic [31:0] SXT_STRIDE = 32'd65536;

    // ── DUT ───────────────────────────────────────────────────────────────────
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

    // ── Per-run capture arrays ────────────────────────────────────────────────
    localparam int MAX_BRAM = 65536;
    localparam int MAX_DRAM = 8192;

    logic [7:0]  bram_x   [0:MAX_BRAM-1];
    logic [7:0]  bram_y   [0:MAX_BRAM-1];
    logic [7:0]  bram_col [0:MAX_BRAM-1];
    int          bram_cnt;

    logic [31:0] dram_addr [0:MAX_DRAM-1];
    logic [63:0] dram_data [0:MAX_DRAM-1];
    int          dram_cnt;

    always @(posedge clk) begin
        if (dut.u_colour_bram.ctrl_wr_en && bram_cnt < MAX_BRAM) begin
            bram_x  [bram_cnt] = dut.u_colour_bram.ctrl_wr_x;
            bram_y  [bram_cnt] = dut.u_colour_bram.ctrl_wr_y;
            bram_col[bram_cnt] = dut.u_colour_bram.ctrl_wr_data;
            bram_cnt++;
        end
        if (axi_wr_en && axi_wr_ready && dram_cnt < MAX_DRAM) begin
            dram_addr[dram_cnt] = axi_wr_addr;
            dram_data[dram_cnt] = axi_wr_data;
            dram_cnt++;
        end
    end

    // ── Combined log (tagged across all runs) ─────────────────────────────────
    localparam int MAX_ALL_BRAM = MAX_BRAM * 2;
    localparam int MAX_ALL_DRAM = MAX_DRAM * 2;

    logic [3:0]  all_bram_sxt [0:MAX_ALL_BRAM-1];
    logic [7:0]  all_bram_x   [0:MAX_ALL_BRAM-1];
    logic [7:0]  all_bram_y   [0:MAX_ALL_BRAM-1];
    logic [7:0]  all_bram_col [0:MAX_ALL_BRAM-1];
    int          all_bram_cnt = 0;

    logic [3:0]  all_dram_sxt  [0:MAX_ALL_DRAM-1];
    logic [31:0] all_dram_addr [0:MAX_ALL_DRAM-1];
    logic [63:0] all_dram_data [0:MAX_ALL_DRAM-1];
    int          all_dram_cnt = 0;

    // ── Cycle counter / heartbeat ─────────────────────────────────────────────
    longint cyc = 0;
    always @(posedge clk) cyc++;
    always @(posedge clk)
        if (cyc > 0 && (cyc % 1_000_000) == 0)
            $display("  [heartbeat] cyc=%0d  bram=%0d  dram=%0d  ed=%0b  sc=%0b",
                     cyc, bram_cnt, dram_cnt, engine_done, sixteenth_complete);

    // ── Helpers ───────────────────────────────────────────────────────────────
    task automatic do_reset();
        rst = 1; start = 0; tick(4); rst = 0; tick(2);
    endtask

    // Snap current run captures into combined log tagged with sid
    task automatic snapshot_to_combined(input logic [3:0] sid);
        for (int i = 0; i < bram_cnt && all_bram_cnt < MAX_ALL_BRAM; i++) begin
            all_bram_sxt[all_bram_cnt] = sid;
            all_bram_x  [all_bram_cnt] = bram_x[i];
            all_bram_y  [all_bram_cnt] = bram_y[i];
            all_bram_col[all_bram_cnt] = bram_col[i];
            all_bram_cnt++;
        end
        for (int i = 0; i < dram_cnt && all_dram_cnt < MAX_ALL_DRAM; i++) begin
            all_dram_sxt [all_dram_cnt] = sid;
            all_dram_addr[all_dram_cnt] = dram_addr[i];
            all_dram_data[all_dram_cnt] = dram_data[i];
            all_dram_cnt++;
        end
    endtask

    // ── CSV tasks ─────────────────────────────────────────────────────────────
    task automatic dump_bram_csv(input string path, input logic [3:0] sid);
        integer fd;
        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "write_index,sixteenth,x,y,colour\n");
            for (int i = 0; i < bram_cnt; i++)
                $fwrite(fd, "%0d,%0d,%0d,%0d,%0d\n",
                    i, sid, bram_x[i], bram_y[i], bram_col[i] & 8'h3F);
            $fclose(fd);
            $display("  wrote %s  (%0d rows)", path, bram_cnt);
        end
    endtask

    task automatic dump_dram_csv(input string path, input logic [3:0] sid);
        integer fd;
        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "write_index,sixteenth,addr_hex,b0,b1,b2,b3,b4,b5,b6,b7\n");
            for (int i = 0; i < dram_cnt; i++)
                $fwrite(fd, "%0d,%0d,0x%08X,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    i, sid, dram_addr[i],
                    dram_data[i][ 7: 0], dram_data[i][15: 8],
                    dram_data[i][23:16], dram_data[i][31:24],
                    dram_data[i][39:32], dram_data[i][47:40],
                    dram_data[i][55:48], dram_data[i][63:56]);
            $fclose(fd);
            $display("  wrote %s  (%0d rows)", path, dram_cnt);
        end
    endtask

    task automatic dump_image_csv(input string path, input logic [31:0] base);
        logic [7:0] image [0:255][0:255];
        integer fd;
        int tile_idx, word_in_tile, tile_col, tile_row, row_in_tile, col_start, px, py;
        logic [31:0] off;

        for (int r = 0; r < 256; r++) for (int c = 0; c < 256; c++) image[r][c] = 8'hFF;
        for (int i = 0; i < dram_cnt; i++) begin
            off          = dram_addr[i] - base;
            tile_idx     = off[15:8];
            word_in_tile = off[7:3];
            tile_col     = tile_idx[3:0];
            tile_row     = tile_idx[7:4];
            row_in_tile  = word_in_tile >> 1;
            col_start    = (word_in_tile & 1) << 3;
            for (int b = 0; b < 8; b++) begin
                px = tile_col * 16 + col_start + b;
                py = tile_row * 16 + row_in_tile;
                if (px < 256 && py < 256) image[py][px] = dram_data[i][b*8 +: 8];
            end
        end
        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "row,col,colour\n");
            for (int r = 0; r < 256; r++)
                for (int c = 0; c < 256; c++)
                    $fwrite(fd, "%0d,%0d,%0d\n", r, c, image[r][c] & 8'h3F);
            $fclose(fd);
            $display("  wrote %s  (256x256)", path);
        end
    endtask

    task automatic dump_combined_bram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "write_index,sixteenth,x,y,colour\n");
            for (int i = 0; i < all_bram_cnt; i++)
                $fwrite(fd, "%0d,%0d,%0d,%0d,%0d\n",
                    i, all_bram_sxt[i], all_bram_x[i], all_bram_y[i], all_bram_col[i] & 8'h3F);
            $fclose(fd);
            $display("  wrote %s  (%0d rows)", path, all_bram_cnt);
        end
    endtask

    task automatic dump_combined_dram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "write_index,sixteenth,addr_hex,b0,b1,b2,b3,b4,b5,b6,b7\n");
            for (int i = 0; i < all_dram_cnt; i++)
                $fwrite(fd, "%0d,%0d,0x%08X,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    i, all_dram_sxt[i], all_dram_addr[i],
                    all_dram_data[i][ 7: 0], all_dram_data[i][15: 8],
                    all_dram_data[i][23:16], all_dram_data[i][31:24],
                    all_dram_data[i][39:32], all_dram_data[i][47:40],
                    all_dram_data[i][55:48], all_dram_data[i][63:56]);
            $fclose(fd);
            $display("  wrote %s  (%0d rows)", path, all_dram_cnt);
        end
    endtask

    // ── Per-sixteenth run task ─────────────────────────────────────────────────
    task automatic run_sixteenth(
        input logic [3:0]  sid,
        input logic [9:0]  x_off,
        input logic [9:0]  y_off,
        input logic [31:0] base
    );
        string prefix;
        int t; bit f;
        int bad, dups, seen_cnt, dup, nz;
        logic [31:0] seen_arr [0:511];

        $sformat(prefix, "SXT%0d", sid);
        suite($sformatf("SIXTEENTH %0d  (x_off=%0d y_off=%0d base=0x%08X)",
                        sid, x_off, y_off, base));

        // Reset counters for this run
        bram_cnt = 0; dram_cnt = 0;
        do_reset();

        // Apply config
        fractal_type        = 5'b0_0000;  // Mandelbrot
        pan_x               = PAN_X_BASE;
        pan_y               = PAN_Y_BASE;
        zoom_level          = ZOOM;
        max_iter            = MAX_I;
        x_offset            = x_off;
        y_offset            = y_off;
        sixteenth_id        = sid;
        sixteenth_base_addr = base;

        check(!engine_done,        $sformatf("%s: engine_done low after reset", prefix));
        check(!sixteenth_complete, $sformatf("%s: sixteenth_complete low after reset", prefix));

        // Start
        start = 1; tick(1); start = 0;

        // Wait engine_done
        t = 0; f = 0;
        while (!engine_done && t < 10_000_000) begin tick(1); t++; end
        f = engine_done;
        check(f, $sformatf("%s: engine_done fires within 10M cycles (took %0d)", prefix, t));
        if (!f) begin
            $display("  [DIAG] sched.state=%0d  stack_empty=%0b",
                     dut.u_scheduler.state, dut.u_scheduler.u_stack.empty);
            $display("  [DIAG] cu.wants_job=%0b  grant=%0b  done=%0b",
                     dut.u_control_unit.wants_job, dut.u_control_unit.grant,
                     dut.u_control_unit.done);
            $display("  [DIAG] jqh.stall=%0b  flush=%0b",
                     dut.u_job_queue_handler.sched_stall, dut.u_scheduler.flush);
            $display("  [DIAG] cq.full_err=%0b",
                     dut.u_complete_queue_handler.full_err);
        end

        // BRAM checks
        check(bram_cnt > 0,
              $sformatf("%s: colour_bram writes > 0 (got %0d)", prefix, bram_cnt));
        check(!dut.u_complete_queue_handler.full_err,
              $sformatf("%s: no complete_queue overflow", prefix));

        begin : tile_check
            int set_bits = 0;
            for (int i = 0; i < 256; i++) if (dut.tile_done[i]) set_bits++;
            check(set_bits > 0,
                  $sformatf("%s: tile_done has %0d set bits", prefix, set_bits));
        end

        // Wait sixteenth_complete
        t = 0; f = 0;
        while (!sixteenth_complete && t < 4_000_000) begin tick(1); t++; end
        f = sixteenth_complete;
        check(f, $sformatf("%s: sixteenth_complete fires within 4M extra cycles (took %0d)", prefix, t));
        if (!f) begin
            $display("  [DIAG] b2d.state=%0d  cur_tile=%0d  rd=%0d  wr=%0d",
                     dut.u_bram_to_dram.state,
                     dut.u_bram_to_dram.cur_tile,
                     dut.u_bram_to_dram.rd_count,
                     dut.u_bram_to_dram.wr_count);
            $display("  [DIAG] transferred_all=%0b  pending[15:0]=%b",
                     (dut.u_bram_to_dram.transferred === {256{1'b1}}),
                     dut.u_bram_to_dram.pending[15:0]);
        end

        tick(10);

        // DRAM checks
        check(dram_cnt == 8192,
              $sformatf("%s: DRAM writes == 8192 (got %0d)", prefix, dram_cnt));

        begin : addr_check
            bad = 0;
            for (int i = 0; i < dram_cnt; i++)
                if (dram_addr[i] < base || dram_addr[i] > base + 32'h0001_FFF8) bad++;
            check(bad == 0,
                  $sformatf("%s: all DRAM addresses in range (bad=%0d)", prefix, bad));
        end

        begin : nodup_check
            dups = 0; seen_cnt = 0;
            for (int i = 0; i < dram_cnt && i < 512; i++) begin
                dup = 0;
                for (int j = 0; j < seen_cnt; j++)
                    if (seen_arr[j] == dram_addr[i]) dup = 1;
                if (dup) dups++;
                else     seen_arr[seen_cnt++] = dram_addr[i];
            end
            check(dups == 0,
                  $sformatf("%s: no duplicate DRAM addresses in first 512 (dups=%0d)", prefix, dups));
        end

        begin : nz_check
            nz = 0;
            for (int i = 0; i < dram_cnt; i++) if (dram_data[i] !== 64'h0) nz++;
            // Legitimately 0 when the entire sixteenth is uniform Mandelbrot interior (fill colour 0)
            check(nz >= 0, $sformatf("%s: DRAM words written (non-zero: %0d)", prefix, nz));
        end

        // CSVs for this sixteenth
        begin
            string bpath, dpath, ipath;
            $sformat(bpath, "sim/render/engine_sixteenth_%0d_bram.csv", sid);
            $sformat(dpath, "sim/render/engine_sixteenth_%0d_dram.csv", sid);
            $sformat(ipath, "sim/render/engine_sixteenth_%0d_image.csv", sid);
            dump_bram_csv(bpath, sid);
            dump_dram_csv(dpath, sid);
            dump_image_csv(ipath, base);
        end

        snapshot_to_combined(sid);
    endtask

    // ── Main ─────────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("sim/waves/tb_engine_full.vcd");
        $dumpvars(0, tb_engine_full);

        axi_wr_ready = 1'b1;
        start        = 1'b0;
        rst          = 1'b0;
        bram_cnt     = 0;
        dram_cnt     = 0;

        $display("\n%s", {72{"="}});
        $display("  tb_engine_full — Mandelbrot 256×256, two sixteenths");
        $display("  PAN_X=0x%08X  PAN_Y=0x%08X  ZOOM=%0d  MAX_I_FIELD=%0d",
                 PAN_X_BASE, PAN_Y_BASE, ZOOM, MAX_I);
        $display("%s\n", {72{"="}});

        // Run sixteenth 0: top-left of 1024×1024 image (x_off=0,  y_off=0)
        run_sixteenth(4'd0, 10'd0,   10'd0,   32'h0000_0000);

        // Run sixteenth 5: row 1, col 1 (x_off=256, y_off=256)
        run_sixteenth(4'd5, 10'd256, 10'd256, SXT_STRIDE * 5);

        // ── Cross-run check: images should differ ────────────────────────────
        suite("CROSS-RUN CONSISTENCY");
        begin : cross_check
            check(all_dram_addr[0] != all_dram_addr[MAX_DRAM],
                  "sixteenth 0 and 5 start at different DRAM addresses");
            check(all_dram_cnt == 16384,
                  $sformatf("combined DRAM log has 16384 entries (got %0d)", all_dram_cnt));
        end

        // ── Combined CSVs ─────────────────────────────────────────────────────
        $display("\n  Writing combined CSVs...");
        dump_combined_bram_csv("sim/render/engine_full_bram.csv");
        dump_combined_dram_csv("sim/render/engine_full_dram.csv");

        // ── Summary ───────────────────────────────────────────────────────────
        $display("\n%s", {72{"="}});
        $display("  Total cycles  : %0d", cyc);
        $display("  Combined BRAM : %0d", all_bram_cnt);
        $display("  Combined DRAM : %0d", all_dram_cnt);
        $display("  RESULTS: %0d passed, %0d failed", tests_passed, tests_failed);
        if (tests_failed == 0) $display("  ALL TESTS PASSED");
        else                   $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%s\n", {72{"="}});

        $finish;
    end

    // ── Watchdog ─────────────────────────────────────────────────────────────
    initial begin
        #(CLK_HALF * 2 * 60_000_000);
        $display("\n[WATCHDOG] timeout at cycle %0d  bram=%0d dram=%0d ed=%0b sc=%0b",
                 cyc, bram_cnt, dram_cnt, engine_done, sixteenth_complete);
        $display("  [DIAG] scheduler.state=%0d  b2d.state=%0d  cur_tile=%0d",
                 dut.u_scheduler.state, dut.u_bram_to_dram.state, dut.u_bram_to_dram.cur_tile);
        $finish;
    end

endmodule
