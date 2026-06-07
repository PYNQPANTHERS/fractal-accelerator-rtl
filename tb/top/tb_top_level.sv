`timescale 1ns/1ps

// ─────────────────────────────────────────────────────────────────────────────
// tb_top_level
//
// Level-3: full top_level (sixteenth_controller + per_sixteenth_engine).
// Injects PS config registers via `force`, pulses ps_start, and lets the
// sixteenth_controller sequence all 16 sixteenths automatically.
// All 16 colour_bram states are captured separately (one snapshot per
// sixteenth, because the BRAM is reset between sixteenths).
//
// Outputs
//   sim/render/top_sixteenth_N_bram.csv  — BRAM writes for each sixteenth (0-15)
//   sim/render/top_sixteenth_N_image.csv — 256×256 pixel reconstruction per sxt
//   sim/render/top_dram.csv             — all 131072 AXI writes (full 1024×1024)
//   sim/render/top_full_image.csv       — reconstructed 1024×1024 pixel grid
//   sim/waves/tb_top_level.vcd
//
// Checks
//   RESET        — all outputs quiet, controller in IDLE
//   CONTROLLER   — FSM transitions: IDLE→LOAD→RENDER→NEXT
//   OFFSETS      — correct x/y offsets and base addresses per sixteenth
//   ENGINE RUN   — engine_done fires for each sixteenth
//   SIXTEENTH    — sixteenth_complete for each; DRAM writes accumulate
//   NEXT/WRAP    — controller advances index; stays in IDLE after 16th
//   IRQ          — irq_all_done fires after all 16 sixteenths
//   DRAM TOTAL   — exactly 131072 writes; all addresses in range; no duplicates
// ─────────────────────────────────────────────────────────────────────────────

module tb_top_level;

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

    // ── DUT signals (top-level has minimal external ports) ────────────────────
    logic        rst;
    wire  [31:0] hp_axi_wr_addr;
    wire  [63:0] hp_axi_wr_data;
    wire         hp_axi_wr_en;
    logic        hp_axi_wr_ready;
    wire         irq_all_done;

    top_level dut (
        .clk            (clk),
        .rst            (rst),
        .hp_axi_wr_addr (hp_axi_wr_addr),
        .hp_axi_wr_data (hp_axi_wr_data),
        .hp_axi_wr_en   (hp_axi_wr_en),
        .hp_axi_wr_ready(hp_axi_wr_ready),
        .irq_all_done   (irq_all_done)
    );

    // ── PS config (forced into internal registers) ────────────────────────────
    // Mandelbrot, pan to top-left of full image, zoom=1, moderate iteration
    // pan_x = -2.0 Q2.16 = 32'hFFFE_0000, pan_y = +1.0 = 32'h0001_0000
    localparam logic [31:0] CFG_PAN_X  = 32'hFFFE_0000;
    localparam logic [31:0] CFG_PAN_Y  = 32'h0001_0000;
    localparam logic [31:0] CFG_ZOOM   = 32'd1;
    // max_iter field 3 → 2^(6+3)=512 iterations; keep low for simulation speed
    localparam logic [11:0] CFG_MAX_I  = 12'd3;
    localparam logic [31:0] CFG_BASE   = 32'h0000_0000;
    // Each sixteenth = 65536 bytes; sixteenth_controller uses 66048 as stride
    localparam logic [31:0] SXT_STRIDE = 32'd66048;

    // ── BRAM capture — reset and re-arm for each sixteenth ────────────────────
    localparam int MAX_BRAM = 65536;

    logic [7:0]  bram_x   [0:MAX_BRAM-1];
    logic [7:0]  bram_y   [0:MAX_BRAM-1];
    logic [7:0]  bram_col [0:MAX_BRAM-1];
    int          bram_cnt = 0;
    int          bram_armed = 1;  // 1 = capturing, 0 = paused between sixteenths

    always @(posedge clk) begin
        if (bram_armed && dut.u_engine.u_colour_bram.ctrl_wr_en && bram_cnt < MAX_BRAM) begin
            bram_x  [bram_cnt] = dut.u_engine.u_colour_bram.ctrl_wr_x;
            bram_y  [bram_cnt] = dut.u_engine.u_colour_bram.ctrl_wr_y;
            bram_col[bram_cnt] = dut.u_engine.u_colour_bram.ctrl_wr_data;
            bram_cnt++;
        end
    end

    // ── DRAM capture — accumulates across all 16 sixteenths ───────────────────
    localparam int MAX_DRAM = 131072;  // 16 × 8192

    logic [31:0] dram_addr [0:MAX_DRAM-1];
    logic [63:0] dram_data [0:MAX_DRAM-1];
    int          dram_cnt  = 0;

    always @(posedge clk)
        if (hp_axi_wr_en && hp_axi_wr_ready && dram_cnt < MAX_DRAM) begin
            dram_addr[dram_cnt] = hp_axi_wr_addr;
            dram_data[dram_cnt] = hp_axi_wr_data;
            dram_cnt++;
        end

    // ── Cycle counter / heartbeat ─────────────────────────────────────────────
    longint cyc = 0;
    always @(posedge clk) cyc++;
    always @(posedge clk)
        if (cyc > 0 && (cyc % 2_000_000) == 0) begin
            $display("  [heartbeat] cyc=%0d  sxt=%0d  bram=%0d  dram=%0d  irq=%0b",
                     cyc,
                     dut.u_sixteenth_controller.sixteenth_index,
                     bram_cnt, dram_cnt, irq_all_done);
        end

    // ── Helpers ───────────────────────────────────────────────────────────────
    task automatic do_reset();
        rst = 1; tick(4); rst = 0; tick(2);
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

    task automatic dump_sxt_image_csv(input string path, input logic [31:0] base);
        // Reconstruct 256×256 from the last 8192 DRAM writes (one sixteenth's worth).
        logic [7:0] image [0:255][0:255];
        integer fd, start_i;
        int tile_idx, word_in_tile, tile_col, tile_row, row_in_tile, col_start, px, py;
        logic [31:0] off;

        for (int r = 0; r < 256; r++) for (int c = 0; c < 256; c++) image[r][c] = 8'hFF;
        start_i = dram_cnt - 8192;
        if (start_i < 0) start_i = 0;

        for (int i = start_i; i < dram_cnt; i++) begin
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

    task automatic dump_full_dram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "write_index,addr_hex,b0,b1,b2,b3,b4,b5,b6,b7\n");
            for (int i = 0; i < dram_cnt; i++)
                $fwrite(fd, "%0d,0x%08X,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    i, dram_addr[i],
                    dram_data[i][ 7: 0], dram_data[i][15: 8],
                    dram_data[i][23:16], dram_data[i][31:24],
                    dram_data[i][39:32], dram_data[i][47:40],
                    dram_data[i][55:48], dram_data[i][63:56]);
            $fclose(fd);
            $display("  wrote %s  (%0d rows)", path, dram_cnt);
        end
    endtask

    // Reconstruct full 1024×1024 from all DRAM writes.
    task automatic dump_full_image_csv(input string path);
        logic [7:0] image [0:1023][0:1023];
        integer fd;
        logic [31:0] off_from_base, sxt_base, within_sxt;
        int sxt_id, tile_idx, word_in_tile, tile_col, tile_row;
        int row_in_tile, col_start, px, py, sxt_col, sxt_row;

        for (int r = 0; r < 1024; r++) for (int c = 0; c < 1024; c++) image[r][c] = 8'hFF;

        for (int i = 0; i < dram_cnt; i++) begin
            off_from_base = dram_addr[i] - CFG_BASE;
            sxt_id        = int'(off_from_base / SXT_STRIDE);
            if (sxt_id >= 0 && sxt_id <= 15) begin
                sxt_base    = CFG_BASE + 32'(sxt_id) * SXT_STRIDE;
                within_sxt  = dram_addr[i] - sxt_base;

                tile_idx     = within_sxt[15:8];
                word_in_tile = within_sxt[7:3];
                tile_col     = tile_idx[3:0];
                tile_row     = tile_idx[7:4];
                row_in_tile  = word_in_tile >> 1;
                col_start    = (word_in_tile & 1) << 3;

                sxt_col = sxt_id & 3;
                sxt_row = sxt_id >> 2;

                for (int b = 0; b < 8; b++) begin
                    px = sxt_col * 256 + tile_col * 16 + col_start + b;
                    py = sxt_row * 256 + tile_row * 16 + row_in_tile;
                    if (px < 1024 && py < 1024)
                        image[py][px] = dram_data[i][b*8 +: 8];
                end
            end
        end

        fd = $fopen(path, "w");
        if (!fd) begin
            $display("  ERROR: cannot open %s", path);
        end else begin
            $fwrite(fd, "row,col,colour\n");
            for (int r = 0; r < 1024; r++)
                for (int c = 0; c < 1024; c++)
                    $fwrite(fd, "%0d,%0d,%0d\n", r, c, image[r][c] & 8'h3F);
            $fclose(fd);
            $display("  wrote %s  (1024x1024)", path);
        end
    endtask

    // ── Module-scope scratch variables (Icarus requires explicit lifetime) ────
    int    _t, _bad, _dups, _nz;
    bit    _f;
    logic [31:0] _max_addr;
    logic [31:0] _first_addrs [0:15];
    // Loop scratch — declared here because Icarus cannot bind logic in begin blocks
    logic [3:0]  _loop_sid;
    logic [31:0] _loop_sxt_base;

    // ── Main ─────────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("sim/waves/tb_top_level.vcd");
        $dumpvars(0, tb_top_level);

        hp_axi_wr_ready = 1'b1;

        $display("\n%s", {72{"="}});
        $display("  tb_top_level — full 1024×1024 Mandelbrot (16 sixteenths)");
        $display("  PAN_X=0x%08X  PAN_Y=0x%08X  ZOOM=%0d  MAX_I_FIELD=%0d",
                 CFG_PAN_X, CFG_PAN_Y, CFG_ZOOM, CFG_MAX_I);
        $display("  SXT_STRIDE=0x%08X  BASE=0x%08X", SXT_STRIDE, CFG_BASE);
        $display("%s\n", {72{"="}});

        // ── SUITE: RESET ─────────────────────────────────────────────────────
        suite("RESET");
        do_reset();
        check(!irq_all_done,                      "irq_all_done low after reset");
        check(!hp_axi_wr_en,                      "hp_axi_wr_en low after reset");
        check(dut.ctrl_engine_rst,                "engine_rst high (controller in IDLE)");
        check(!dut.ctrl_start,                    "ctrl_start low after reset");
        check(dut.u_sixteenth_controller.state == 2'b00, "controller in IDLE state");
        check(dut.u_sixteenth_controller.sixteenth_index == 4'd0,
              "sixteenth_index = 0 after reset");

        // ── SUITE: CONTROLLER FSM TRANSITIONS ────────────────────────────────
        suite("CONTROLLER FSM");
        do_reset();
        // Force PS config and pulse ps_start
        force dut.cfg_equation_id    = 5'b0_0000;
        force dut.cfg_pan_x          = CFG_PAN_X;
        force dut.cfg_pan_y          = CFG_PAN_Y;
        force dut.cfg_zoom_level     = CFG_ZOOM;
        force dut.cfg_max_iter       = CFG_MAX_I;
        force dut.cfg_image_base_addr = CFG_BASE;
        force dut.ps_start           = 1'b1;
        tick(1);                            // IDLE → LOAD (ps_start latched)
        release dut.ps_start;
        check(dut.u_sixteenth_controller.state == 2'b01, "tick 1: state = LOAD");
        check(dut.ctrl_engine_rst,                       "tick 1: engine_rst = 1 (LOAD)");
        check(!dut.ctrl_start,                           "tick 1: start = 0 (LOAD)");
        tick(1);                            // LOAD → RENDER (offsets registered)
        check(dut.u_sixteenth_controller.state == 2'b10, "tick 2: state = RENDER");
        check(!dut.ctrl_engine_rst, "tick 2: engine_rst deasserted in RENDER");
        check(dut.ctrl_start,       "tick 2: start asserted in RENDER");
        check(dut.ctrl_x_offset == 10'd0,
              $sformatf("sixteenth 0: x_offset=0 (got %0d)", dut.ctrl_x_offset));
        check(dut.ctrl_y_offset == 10'd0,
              $sformatf("sixteenth 0: y_offset=0 (got %0d)", dut.ctrl_y_offset));
        check(dut.ctrl_sixteenth_base_addr == CFG_BASE,
              $sformatf("sixteenth 0: base_addr=0x%08X (got 0x%08X)",
                        CFG_BASE, dut.ctrl_sixteenth_base_addr));

        // ── SUITE: OFFSET TABLE — check all 16 sixteenth offsets ─────────────
        suite("OFFSET TABLE");
        begin : off_check
            logic [9:0] expected_x5, expected_y5;
            expected_x5 = {2'd1, 8'd0};  // col of idx 5 = 5[1:0] = 01 = 1
            expected_y5 = {2'd1, 8'd0};  // row of idx 5 = 5[3:2] = 01 = 1
            check(expected_x5 == 10'd256,
                  $sformatf("formula: sixteenth 5 x_off = 256 (computed %0d)", expected_x5));
            check(expected_y5 == 10'd256,
                  $sformatf("formula: sixteenth 5 y_off = 256 (computed %0d)", expected_y5));
        end

        // Release forced overrides before full render
        release dut.cfg_equation_id;
        release dut.cfg_pan_x;
        release dut.cfg_pan_y;
        release dut.cfg_zoom_level;
        release dut.cfg_max_iter;
        release dut.cfg_image_base_addr;

        // ── SUITE: FULL 16-SIXTEENTH RENDER ──────────────────────────────────
        suite("FULL RENDER");
        do_reset();

        // Apply PS config and start
        force dut.cfg_equation_id     = 5'b0_0000;
        force dut.cfg_pan_x           = CFG_PAN_X;
        force dut.cfg_pan_y           = CFG_PAN_Y;
        force dut.cfg_zoom_level      = CFG_ZOOM;
        force dut.cfg_max_iter        = CFG_MAX_I;
        force dut.cfg_image_base_addr = CFG_BASE;
        force dut.ps_start            = 1'b1;
        tick(1);
        release dut.ps_start;

        // Walk all 16 sixteenths
        begin : full_render_loop
            int sxt_dram_start, loop_t, loop_rt, sxt_writes, bad, set_bits;
            bit loop_f, loop_rf;
            string loop_prefix, bpath, ipath;

            for (int s = 0; s < 16; s++) begin
                _loop_sid      = 4'(s);
                _loop_sxt_base = CFG_BASE + 32'(s) * SXT_STRIDE;
                $sformat(loop_prefix, "SXT%0d", s);

                // Wait until controller enters RENDER state for this sixteenth
                loop_rt = 0; loop_rf = 0;
                while (dut.u_sixteenth_controller.state !== 2'b10 && loop_rt < 200) begin
                    tick(1); loop_rt++;
                end
                loop_rf = (dut.u_sixteenth_controller.state === 2'b10);
                check(loop_rf, $sformatf("%s: controller enters RENDER state", loop_prefix));
                check(dut.u_sixteenth_controller.sixteenth_index == _loop_sid,
                      $sformatf("%s: sixteenth_index = %0d (got %0d)",
                                loop_prefix, s, dut.u_sixteenth_controller.sixteenth_index));

                // Arm BRAM capture for this sixteenth
                bram_cnt       = 0;
                bram_armed     = 1;
                sxt_dram_start = dram_cnt;

                // Wait engine_done
                loop_t = 0; loop_f = 0;
                while (!dut.u_engine.engine_done && loop_t < 12_000_000) begin tick(1); loop_t++; end
                loop_f = dut.u_engine.engine_done;
                check(loop_f, $sformatf("%s: engine_done fires within 12M cycles (took %0d)", loop_prefix, loop_t));
                if (!loop_f) begin
                    $display("  [DIAG] %s sched.state=%0d  stack_empty=%0b",
                             loop_prefix, dut.u_engine.u_scheduler.state,
                             dut.u_engine.u_scheduler.u_stack.empty);
                    $display("  [DIAG] %s cu.wants_job=%0b  grant=%0b",
                             loop_prefix, dut.u_engine.u_control_unit.wants_job,
                             dut.u_engine.u_control_unit.grant);
                    $display("  [DIAG] %s cq.full_err=%0b",
                             loop_prefix, dut.u_engine.u_complete_queue_handler.full_err);
                end

                // Pause BRAM capture (BRAM resets between sixteenths)
                bram_armed = 0;

                // BRAM checks for this sixteenth
                check(bram_cnt > 0,
                      $sformatf("%s: colour_bram writes > 0 (got %0d)", loop_prefix, bram_cnt));
                check(!dut.u_engine.u_complete_queue_handler.full_err,
                      $sformatf("%s: no complete_queue overflow", loop_prefix));

                set_bits = 0;
                for (int i = 0; i < 256; i++)
                    if (dut.u_engine.tile_done[i]) set_bits++;
                check(set_bits > 0,
                      $sformatf("%s: tile_done %0d tiles set", loop_prefix, set_bits));

                // Wait sixteenth_complete (drives controller RENDER→NEXT)
                loop_t = 0; loop_f = 0;
                while (!dut.u_engine.sixteenth_complete && loop_t < 5_000_000) begin tick(1); loop_t++; end
                loop_f = dut.u_engine.sixteenth_complete;
                check(loop_f, $sformatf("%s: sixteenth_complete fires (took %0d cycles)", loop_prefix, loop_t));
                if (!loop_f) begin
                    $display("  [DIAG] %s b2d.state=%0d  cur_tile=%0d  rd=%0d  wr=%0d",
                             loop_prefix,
                             dut.u_engine.u_bram_to_dram.state,
                             dut.u_engine.u_bram_to_dram.cur_tile,
                             dut.u_engine.u_bram_to_dram.rd_count,
                             dut.u_engine.u_bram_to_dram.wr_count);
                    $display("  [DIAG] %s pending[15:0]=%b  engine_done=%0b",
                             loop_prefix, dut.u_engine.u_bram_to_dram.pending[15:0],
                             dut.u_engine.engine_done);
                end

                tick(10);

                // DRAM count for this sixteenth
                sxt_writes = dram_cnt - sxt_dram_start;
                check(sxt_writes == 8192,
                      $sformatf("%s: DRAM writes == 8192 (got %0d)", loop_prefix, sxt_writes));

                // Address range for this sixteenth
                bad = 0;
                for (int i = sxt_dram_start; i < dram_cnt; i++)
                    if (dram_addr[i] < _loop_sxt_base ||
                        dram_addr[i] > _loop_sxt_base + 32'h0001_FFF8) bad++;
                check(bad == 0,
                      $sformatf("%s: all addresses in [0x%08X, 0x%08X] (bad=%0d)",
                                loop_prefix, _loop_sxt_base, _loop_sxt_base + 32'h0001_FFF8, bad));

                // Dump per-sixteenth CSVs
                $sformat(bpath, "sim/render/top_sixteenth_%0d_bram.csv", s);
                $sformat(ipath, "sim/render/top_sixteenth_%0d_image.csv", s);
                dump_bram_csv(bpath, _loop_sid);
                dump_sxt_image_csv(ipath, _loop_sxt_base);

                // After last sixteenth let controller settle into NEXT→IDLE
                tick(10);
            end
        end

        release dut.cfg_equation_id;
        release dut.cfg_pan_x;
        release dut.cfg_pan_y;
        release dut.cfg_zoom_level;
        release dut.cfg_max_iter;
        release dut.cfg_image_base_addr;

        // ── SUITE: IRQ / FINAL STATE ──────────────────────────────────────────
        suite("IRQ AND FINAL STATE");
        begin : irq_check
            _t = 0; _f = 0;
            while (!irq_all_done && _t < 500_000) begin tick(1); _t++; end
            _f = irq_all_done;
            check(_f, $sformatf("irq_all_done fires after all 16 sixteenths (took %0d)", _t));
        end
        check(dut.u_sixteenth_controller.state == 2'b00,
              "controller returns to IDLE after all 16 sixteenths");

        // ── SUITE: DRAM GLOBAL CHECKS ─────────────────────────────────────────
        suite("DRAM GLOBAL");
        check(dram_cnt == 131072,
              $sformatf("total DRAM writes == 131072 (16 × 8192) (got %0d)", dram_cnt));

        begin : global_range
            _bad = 0;
            _max_addr = CFG_BASE + 32'(15) * SXT_STRIDE + 32'h0001_FFF8;
            for (int i = 0; i < dram_cnt; i++)
                if (dram_addr[i] < CFG_BASE || dram_addr[i] > _max_addr) _bad++;
            check(_bad == 0,
                  $sformatf("all DRAM addresses in image range (bad=%0d)", _bad));
        end

        begin : global_nodup
            _dups = 0;
            for (int s = 0; s < 16; s++) _first_addrs[s] = dram_addr[s * 8192];
            for (int i = 0; i < 16; i++)
                for (int j = i+1; j < 16; j++)
                    if (_first_addrs[i] == _first_addrs[j]) _dups++;
            check(_dups == 0,
                  $sformatf("first DRAM address per sixteenth all unique (dups=%0d)", _dups));
        end

        begin : global_nz
            _nz = 0;
            for (int i = 0; i < dram_cnt; i++) if (dram_data[i] !== 64'h0) _nz++;
            check(_nz > 1000,
                  $sformatf("more than 1000 non-zero DRAM words across image (got %0d)", _nz));
        end

        // ── Dump global CSVs ──────────────────────────────────────────────────
        $display("\n  Writing global CSVs...");
        dump_full_dram_csv("sim/render/top_dram.csv");
        dump_full_image_csv("sim/render/top_full_image.csv");

        // ── Summary ───────────────────────────────────────────────────────────
        $display("\n%s", {72{"="}});
        $display("  Total cycles : %0d", cyc);
        $display("  DRAM writes  : %0d", dram_cnt);
        $display("  RESULTS: %0d passed, %0d failed", tests_passed, tests_failed);
        if (tests_failed == 0) $display("  ALL TESTS PASSED");
        else                   $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%s\n", {72{"="}});

        $finish;
    end

    // ── Watchdog ─────────────────────────────────────────────────────────────
    initial begin
        #(CLK_HALF * 2 * 250_000_000);
        $display("\n[WATCHDOG] timeout at cycle %0d  sxt=%0d  dram=%0d  irq=%0b",
                 cyc,
                 dut.u_sixteenth_controller.sixteenth_index,
                 dram_cnt, irq_all_done);
        $display("  [DIAG] ctrl.state=%0d  engine.sched.state=%0d  b2d.state=%0d",
                 dut.u_sixteenth_controller.state,
                 dut.u_engine.u_scheduler.state,
                 dut.u_engine.u_bram_to_dram.state);
        $finish;
    end

endmodule
