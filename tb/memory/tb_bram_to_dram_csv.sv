// tb_bram_to_dram_csv.sv
// End-to-end render validation for bram_to_dram.
//
// Loads frame0_mandelbrot.csv into a BRAM stub using colour_bram's tile-address
// mapping, then drives bram_to_dram and checks that DRAM write data reconstructs
// the original pixel values exactly.
//
// Two scenarios:
//   PARTIAL — 4 spread tiles (tile 0, 17, 119, 255)
//   FULL    — all 256 tiles, complete 256×256 frame round-trip
//
// Outputs (written to sim/render/):
//   b2d_bram_source.csv   — 256×256 source pixels loaded from CSV
//   b2d_partial_dram.csv  — AXI write log for the 4 partial tiles
//   b2d_full_dram.csv     — AXI write log for all 256 tiles
//
// Pixel → BRAM address (mirrors colour_bram.sv):
//   tile_addr = {y[7:4], x[7:4], y[3:0], x[3:0]}
//   word_addr = tile_addr[15:3]    (b2d_word_addr = {tile[7:0], word[4:0]})
//   byte_off  = tile_addr[2:0]
//
// DRAM address from bram_to_dram:
//   addr = base + tile*256 + word_in_tile*8
//   Each 8-byte DRAM word holds 8 pixels in {inner_y[3:0], inner_x[3:0]} order

`timescale 1ns/1ps

module tb_bram_to_dram_csv;

    int tests_run = 0, tests_passed = 0, tests_failed = 0;

    task automatic check(input logic cond, input string desc);
        tests_run++;
        if (cond) begin tests_passed++; $display("  [PASS] %s", desc); end
        else       begin tests_failed++; $display("  [FAIL] %s", desc); end
    endtask

    logic clk = 0;
    always #5 clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // ── DUT ports ────────────────────────────────────────────────────────────
    logic [255:0] tile_done;
    logic         engine_done;
    logic [7:0]   tt_rd_index;
    logic         tt_is_filled;
    logic [5:0]   tt_fill_colour;
    logic [12:0]  b2d_word_addr;
    logic         b2d_rd_en;
    logic         b2d_rd_grant;
    logic [63:0]  b2d_rd_data;
    logic [31:0]  axi_wr_addr;
    logic [63:0]  axi_wr_data;
    logic         axi_wr_en;
    logic         axi_wr_ready;
    logic         cache_valid_wr_en;
    logic [7:0]   cache_valid_index;
    logic         cache_valid_value;
    logic [31:0]  sixteenth_base_addr;
    logic         sixteenth_complete;
    logic         rst;

    bram_to_dram dut (
        .clk                (clk),
        .rst                (rst),
        .tile_done          (tile_done),
        .engine_done        (engine_done),
        .tt_rd_index        (tt_rd_index),
        .tt_is_filled       (tt_is_filled),
        .tt_fill_colour     (tt_fill_colour),
        .b2d_word_addr      (b2d_word_addr),
        .b2d_rd_en          (b2d_rd_en),
        .b2d_rd_grant       (b2d_rd_grant),
        .b2d_rd_data        (b2d_rd_data),
        .axi_wr_addr        (axi_wr_addr),
        .axi_wr_data        (axi_wr_data),
        .axi_wr_en          (axi_wr_en),
        .axi_wr_ready       (axi_wr_ready),
        .cache_valid_wr_en  (cache_valid_wr_en),
        .cache_valid_index  (cache_valid_index),
        .cache_valid_value  (cache_valid_value),
        .sixteenth_base_addr(sixteenth_base_addr),
        .sixteenth_complete (sixteenth_complete)
    );

    // ── BRAM stub ────────────────────────────────────────────────────────────
    // Mirrors colour_bram's tile-address layout.
    // Populated from csv_pixels before each test.
    logic [63:0] bram_mem [0:8191];

    always_comb begin
        b2d_rd_grant = b2d_rd_en;
        b2d_rd_data  = bram_mem[b2d_word_addr];
    end

    // ── Address conversion functions ─────────────────────────────────────────
    // colour_bram tile mapping: tile_addr = {y[7:4], x[7:4], y[3:0], x[3:0]}
    function automatic logic [12:0] px_to_word(input int px, input int py);
        logic [15:0] ta;
        ta = {py[7:4], px[7:4], py[3:0], px[3:0]};
        return ta[15:3];
    endfunction

    function automatic logic [2:0] px_to_byte(input int px, input int py);
        logic [15:0] ta;
        ta = {py[7:4], px[7:4], py[3:0], px[3:0]};
        return ta[2:0];
    endfunction

    // DRAM → pixel: addr = base + tile*256 + word*8; byte b within that word
    // tile = {ty[3:0], tx[3:0]},  inner = {iy[3:0], ix[3:0]} = word*8 + b
    function automatic int dram_to_px(
        input logic [31:0] base, input logic [31:0] addr, input int b
    );
        int tile, wrd, inner, tx, ix;
        tile  = int'((addr - base) / 256);
        wrd   = int'(((addr - base) % 256) / 8);
        inner = (wrd << 3) | b;
        tx    = tile & 32'hF;
        ix    = inner & 32'hF;
        return tx * 16 + ix;
    endfunction

    function automatic int dram_to_py(
        input logic [31:0] base, input logic [31:0] addr, input int b
    );
        int tile, wrd, inner, ty, iy;
        tile  = int'((addr - base) / 256);
        wrd   = int'(((addr - base) % 256) / 8);
        inner = (wrd << 3) | b;
        ty    = (tile >> 4) & 32'hF;
        iy    = (inner >> 4) & 32'hF;
        return ty * 16 + iy;
    endfunction

    // ── AXI write capture ────────────────────────────────────────────────────
    localparam int MAX_CAP = 8192;
    logic [63:0] cap_data [0:MAX_CAP-1];
    logic [31:0] cap_addr [0:MAX_CAP-1];
    int          cap_count;

    task automatic reset_dut();
        rst                 = 1;
        tile_done           = '0;
        engine_done         = 0;
        tt_is_filled        = 0;
        tt_fill_colour      = 0;
        axi_wr_ready        = 1;
        sixteenth_base_addr = 32'h0;
        tick(3);
        rst = 0;
        tick(1);
    endtask

    // Collect n AXI writes silently (no per-write display — output goes to CSV)
    task automatic collect_writes_silent(input int n_writes, input int max_cycles);
        int collected, cyc;
        collected = 0; cyc = 0; cap_count = 0;
        while (collected < n_writes && cyc < max_cycles) begin
            @(posedge clk); #1; cyc++;
            if (axi_wr_en && axi_wr_ready) begin
                cap_data[collected] = axi_wr_data;
                cap_addr[collected] = axi_wr_addr;
                collected++;
                cap_count = collected;
            end
        end
        if (cyc >= max_cycles)
            $display("  WARNING: collect_writes_silent timed out (%0d/%0d collected)",
                      collected, n_writes);
    endtask

    // ── CSV source image ─────────────────────────────────────────────────────
    logic [5:0] csv_pixels [0:255][0:255];  // [row][col] = 6-bit colour
    int         csv_fd, csv_ret, csv_col, csv_row, csv_iters;
    string      csv_hdr;

    // ── Module-level temporaries (Icarus: no automatic vars inside begin/end) ─
    int      pixel_errors, tile_val, word_val;
    int      px_out, py_out;
    int      i, b, wcount, cyc;
    integer  out_fd;

    task automatic load_bram_from_pixels();
        for (int a = 0; a < 8192; a++) bram_mem[a] = '0;
        for (int r = 0; r < 256; r++)
            for (int c = 0; c < 256; c++)
                bram_mem[px_to_word(c, r)][px_to_byte(c, r)*8 +: 8] =
                    {2'b00, csv_pixels[r][c]};
    endtask

    task automatic verify_and_report(
        input logic [31:0] base,
        input int          n_writes,
        input int          max_errors_shown
    );
        int shown;
        pixel_errors = 0; shown = 0;
        for (i = 0; i < n_writes; i++) begin
            for (b = 0; b < 8; b++) begin
                px_out = dram_to_px(base, cap_addr[i], b);
                py_out = dram_to_py(base, cap_addr[i], b);
                if (cap_data[i][b*8 +: 8] !== {2'b00, csv_pixels[py_out][px_out]}) begin
                    if (shown < max_errors_shown) begin
                        $display("  MISMATCH write=%0d byte=%0d px=(%0d,%0d) got=0x%02X expect=0x%02X",
                            i, b, px_out, py_out,
                            cap_data[i][b*8 +: 8],
                            {2'b00, csv_pixels[py_out][px_out]});
                        shown++;
                    end
                    pixel_errors++;
                end
            end
        end
        $display("  Pixel errors: %0d / %0d pixels checked", pixel_errors, n_writes * 8);
    endtask

    task automatic dump_dram_csv(input string path, input int n_writes, input logic [31:0] base);
        out_fd = $fopen(path, "w");
        if (out_fd == 0) begin
            $display("  WARNING: could not open %s for writing", path);
        end else begin
            $fwrite(out_fd, "write_index,addr_hex,tile,word_in_tile,px0,py0,b0,b1,b2,b3,b4,b5,b6,b7\n");
            for (i = 0; i < n_writes; i++) begin
                tile_val = int'((cap_addr[i] - base) / 256);
                word_val = int'(((cap_addr[i] - base) % 256) / 8);
                px_out   = dram_to_px(base, cap_addr[i], 0);
                py_out   = dram_to_py(base, cap_addr[i], 0);
                $fwrite(out_fd,
                    "%0d,0x%08X,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    i, cap_addr[i], tile_val, word_val, px_out, py_out,
                    cap_data[i][ 7: 0], cap_data[i][15: 8],
                    cap_data[i][23:16], cap_data[i][31:24],
                    cap_data[i][39:32], cap_data[i][47:40],
                    cap_data[i][55:48], cap_data[i][63:56]);
            end
            $fclose(out_fd);
            $display("  Wrote %s  (%0d rows)", path, n_writes);
        end
    endtask

    // ── Main ─────────────────────────────────────────────────────────────────
    initial begin
        $display("\n%0s", {72{"="}});
        $display("  tb_bram_to_dram_csv — fractal BRAM→DRAM round-trip validation");
        $display("%0s", {72{"="}});

        // ── Load fractal CSV ──────────────────────────────────────────────────
        for (int r = 0; r < 256; r++)
            for (int c = 0; c < 256; c++)
                csv_pixels[r][c] = '0;

        csv_fd = $fopen("frame0_mandelbrot.csv", "r");
        if (csv_fd == 0) begin
            $display("  ERROR: frame0_mandelbrot.csv not found. Run from repo root.");
            $finish;
        end
        csv_ret = $fscanf(csv_fd, "%s\n", csv_hdr);  // skip header line
        while (!$feof(csv_fd)) begin
            csv_ret = $fscanf(csv_fd, "%d,%d,%d\n", csv_col, csv_row, csv_iters);
            if (csv_ret == 3 && csv_row < 256 && csv_col < 256)
                csv_pixels[csv_row][csv_col] = csv_iters[5:0];
        end
        $fclose(csv_fd);
        $display("  Loaded frame0_mandelbrot.csv — 256×256 pixels");

        // Dump the source as a reference CSV so it can be diffed against DRAM output
        out_fd = $fopen("sim/render/b2d_bram_source.csv", "w");
        if (out_fd != 0) begin
            $fwrite(out_fd, "row,col,colour\n");
            for (int r = 0; r < 256; r++)
                for (int c = 0; c < 256; c++)
                    $fwrite(out_fd, "%0d,%0d,%0d\n", r, c, csv_pixels[r][c]);
            $fclose(out_fd);
            $display("  Wrote sim/render/b2d_bram_source.csv");
        end

        // Pre-populate BRAM stub with fractal data
        load_bram_from_pixels();
        $display("  BRAM stub loaded from fractal pixels");

        // ── PARTIAL TEST: tiles 0, 17, 119, 255 ──────────────────────────────
        //
        // Tile layout (16×16 tile grid across 256×256 frame):
        //   tile 0   = top-left     (pixel region x=0..15,   y=0..15)
        //   tile 17  = row 1 col 1  (pixel region x=16..31,  y=16..31)
        //   tile 119 = row 7 col 7  (pixel region x=112..127,y=112..127)
        //   tile 255 = bottom-right (pixel region x=240..255, y=240..255)
        //
        // Expected: 4 × 32 = 128 DRAM writes, only covering those tile regions.
        $display("\n%0s", {72{"-"}});
        $display("  PARTIAL: tiles 0, 17, 119, 255  (4 × 32 = 128 writes expected)");
        $display("%0s", {72{"-"}});

        reset_dut();
        tile_done[0]   = 1;
        tile_done[17]  = 1;
        tile_done[119] = 1;
        tile_done[255] = 1;
        collect_writes_silent(128, 50000);
        tile_done = '0;

        $display("  Collected: %0d writes", cap_count);
        check(cap_count == 128,
              $sformatf("partial: exactly 128 writes produced (got %0d)", cap_count));

        // Verify only the expected tile indices appear in addresses
        begin
            int bad_tile;
            bad_tile = 0;
            for (i = 0; i < cap_count; i++) begin
                tile_val = int'(cap_addr[i] / 256);
                if (tile_val != 0 && tile_val != 17 && tile_val != 119 && tile_val != 255) begin
                    $display("  UNEXPECTED tile %0d at addr=0x%08X", tile_val, cap_addr[i]);
                    bad_tile++;
                end
            end
            check(bad_tile == 0,
                  $sformatf("partial: all writes belong to tiles 0/17/119/255 (bad=%0d)", bad_tile));
        end

        // Check each tile produced exactly 32 writes
        begin
            int cnt0, cnt17, cnt119, cnt255;
            cnt0 = 0; cnt17 = 0; cnt119 = 0; cnt255 = 0;
            for (i = 0; i < cap_count; i++) begin
                tile_val = int'(cap_addr[i] / 256);
                if (tile_val == 0)   cnt0++;
                if (tile_val == 17)  cnt17++;
                if (tile_val == 119) cnt119++;
                if (tile_val == 255) cnt255++;
            end
            $display("  Writes per tile: 0→%0d  17→%0d  119→%0d  255→%0d  (32 each expected)",
                      cnt0, cnt17, cnt119, cnt255);
            check(cnt0   == 32, $sformatf("partial: tile 0 has 32 writes (got %0d)",   cnt0));
            check(cnt17  == 32, $sformatf("partial: tile 17 has 32 writes (got %0d)",  cnt17));
            check(cnt119 == 32, $sformatf("partial: tile 119 has 32 writes (got %0d)", cnt119));
            check(cnt255 == 32, $sformatf("partial: tile 255 has 32 writes (got %0d)", cnt255));
        end

        // Pixel-accurate data check
        verify_and_report(32'h0, cap_count, 10);
        check(pixel_errors == 0,
              $sformatf("partial: all %0d pixels match fractal source (errors=%0d)",
                         cap_count * 8, pixel_errors));

        dump_dram_csv("sim/render/b2d_partial_dram.csv", cap_count, 32'h0);

        // ── FULL TEST: all 256 tiles ──────────────────────────────────────────
        //
        // All tile_done bits set simultaneously, engine_done=1.
        // Expected: 256 × 32 = 8192 DRAM writes covering the entire 256×256 frame.
        // Every pixel in the frame should appear exactly once with the correct colour.
        $display("\n%0s", {72{"-"}});
        $display("  FULL: all 256 tiles  (256 × 32 = 8192 writes expected)");
        $display("%0s", {72{"-"}});

        load_bram_from_pixels();  // reload in case partial test perturbed state
        reset_dut();
        tile_done   = '1;
        engine_done = 1;

        wcount = 0; cyc = 0; cap_count = 0;
        while (wcount < 8192 && cyc < 5000000) begin
            @(posedge clk); #1; cyc++;
            if (axi_wr_en && axi_wr_ready) begin
                cap_data[wcount] = axi_wr_data;
                cap_addr[wcount] = axi_wr_addr;
                wcount++;
                cap_count = wcount;
            end
        end
        tile_done = '0;

        $display("  Collected: %0d writes in %0d cycles", cap_count, cyc);
        check(cap_count == 8192,
              $sformatf("full: exactly 8192 writes produced (got %0d)", cap_count));

        // sixteenth_complete must assert (engine_done=1, all transferred)
        tick(5);
        $display("  sixteenth_complete = %b  (expect 1)", sixteenth_complete);
        check(sixteenth_complete, "full: sixteenth_complete asserts after all tiles");

        // No duplicate addresses
        begin
            int dups;
            dups = 0;
            // Only scan a window — O(n^2) over 8192 is too slow; compare each entry
            // against the next 256 (covers all words of any single tile)
            for (i = 0; i < cap_count; i++)
                for (int j = i+1; j < i+256 && j < cap_count; j++)
                    if (cap_addr[i] == cap_addr[j]) dups++;
            check(dups == 0, $sformatf("full: no duplicate DRAM addresses (dups=%0d)", dups));
        end

        // Address range: all writes must be within [0, 255*256 + 31*8] = [0, 0xFFF8]
        begin
            int out_of_range;
            out_of_range = 0;
            for (i = 0; i < cap_count; i++)
                if (cap_addr[i] > 32'hFFF8) out_of_range++;
            check(out_of_range == 0,
                  $sformatf("full: all addresses in [0x0, 0xFFF8] (violations=%0d)", out_of_range));
        end

        // Pixel-accurate full round-trip
        verify_and_report(32'h0, cap_count, 10);
        check(pixel_errors == 0,
              $sformatf("full: all 65536 pixels match fractal source (errors=%0d)", pixel_errors));

        dump_dram_csv("sim/render/b2d_full_dram.csv", cap_count, 32'h0);

        // ── Summary ───────────────────────────────────────────────────────────
        $display("\n%0s", {72{"="}});
        $display("  RESULTS: %0d / %0d passed", tests_passed, tests_run);
        if (tests_failed == 0) $display("  ALL TESTS PASSED");
        else                   $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%0s\n", {72{"="}});
        $display("  Output files:");
        $display("    sim/render/b2d_bram_source.csv  — source fractal pixels (row,col,colour)");
        $display("    sim/render/b2d_partial_dram.csv — DRAM writes for 4 tiles");
        $display("    sim/render/b2d_full_dram.csv    — DRAM writes for all 256 tiles");
        $display("  Columns: write_index,addr_hex,tile,word_in_tile,px0,py0,b0..b7");

        $finish;
    end

    initial begin #500000000; $display("[TIMEOUT]"); $finish; end

endmodule
