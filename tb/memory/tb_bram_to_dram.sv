// tb_bram_to_dram.sv
// Heavy testbench for bram_to_dram.
//
// Key concerns:
//   1. Tiled path: 32 AXI writes per tile, correct addresses, correct data from BRAM stub
//   2. Flood-fill path: 32 solid-colour writes, no BRAM reads
//   3. AXI backpressure: writes retry correctly when axi_wr_ready=0
//   4. BRAM grant denied: module retries correctly
//   5. Reset: all state clears, no spurious writes
//   6. sixteenth_complete: only asserts when engine_done AND all 256 tiles transferred
//   7. Base address: all AXI addresses offset by sixteenth_base_addr
//   8. Multiple tiles: sequential tile processing, correct per-tile addresses
//   9. cache_valid_wr_en: pulsed with correct index and value for each tile type

`timescale 1ns/1ps

module tb_bram_to_dram;

    int tests_run = 0, tests_passed = 0, tests_failed = 0;
    string current_suite = "";

    task automatic suite(input string name);
        current_suite = name;
        $display("\n%0s", {72{"="}});
        $display("  SUITE: %s", name);
        $display("%0s", {72{"="}});
    endtask

    task automatic check(input logic cond, input string desc);
        tests_run++;
        if (cond) begin tests_passed++; $display("  [PASS] %s", desc); end
        else       begin tests_failed++; $display("  [FAIL] %s  (suite: %s)", desc, current_suite); end
    endtask

    task automatic summary();
        $display("\n%0s", {72{"="}});
        $display("  RESULTS: %0d / %0d passed", tests_passed, tests_run);
        if (tests_failed == 0) $display("  ALL TESTS PASSED");
        else $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%0s\n", {72{"="}});
    endtask

    logic clk = 0;
    always #5 clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // DUT ports
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

    // ── BRAM model ───────────────────────────────────────────────────────────
    // 256 tiles × 32 words = 8192 words. Each word is 64 bits.
    // b2d_word_addr format: { tile[7:0], word[4:0] } = 13 bits.
    // Pattern: byte[i] of word A = (A*8 + i) & 0xFF — deterministic, non-trivial.
    logic [63:0] bram_model [0:8191];

    // Default BRAM response: registered grant + data, matching real colour_bram
    // timing (grant and data both arrive 1 cycle after request).
    // Overridden in BRAM-deny test via force/release on b2d_rd_grant.
    always_ff @(posedge clk) begin
        b2d_rd_grant <= b2d_rd_en;
        if (b2d_rd_en) b2d_rd_data <= bram_model[b2d_word_addr];
    end

    initial begin
        for (int a = 0; a < 8192; a++) begin
            bram_model[a] = {
                8'((a*8 + 7) & 8'hFF),
                8'((a*8 + 6) & 8'hFF),
                8'((a*8 + 5) & 8'hFF),
                8'((a*8 + 4) & 8'hFF),
                8'((a*8 + 3) & 8'hFF),
                8'((a*8 + 2) & 8'hFF),
                8'((a*8 + 1) & 8'hFF),
                8'((a*8 + 0) & 8'hFF)
            };
        end
    end

    // ── AXI write capture ────────────────────────────────────────────────────
    localparam int MAX_CAP = 8192;   // large enough for all-256-tiles test
    logic [63:0] cap_data [0:MAX_CAP-1];
    logic [31:0] cap_addr [0:MAX_CAP-1];
    int          cap_count;

    task automatic clear_cap();
        cap_count = 0;
    endtask

    // Collect exactly n handshaked writes (axi_wr_en && axi_wr_ready)
    task automatic collect_writes(input int n_writes, input int max_cycles = 10000);
        int collected, cyc;
        collected = 0; cyc = 0;
        clear_cap();
        while (collected < n_writes && cyc < max_cycles) begin
            @(posedge clk); #1; cyc++;
            if (axi_wr_en && axi_wr_ready) begin
                cap_data[collected] = axi_wr_data;
                cap_addr[collected] = axi_wr_addr;
                $display("    AXI write #%0d: addr=0x%08X data=0x%016X",
                          collected, axi_wr_addr, axi_wr_data);
                collected++;
                cap_count = collected;
            end
        end
        if (cyc >= max_cycles)
            $display("    WARNING: collect_writes timed out after %0d cycles", max_cycles);
    endtask

    // ── Reset helper ─────────────────────────────────────────────────────────
    task automatic do_reset();
        rst                = 1;
        tile_done          = '0;
        engine_done        = 0;
        tt_is_filled       = 0;
        tt_fill_colour     = 0;
        axi_wr_ready       = 1;
        sixteenth_base_addr = 32'h0;
        tick(3);
        rst = 0;
        tick(1);
        $display("    Reset complete: sixteenth_complete=%b axi_wr_en=%b",
                  sixteenth_complete, axi_wr_en);
    endtask

    // ── Tile address formula ─────────────────────────────────────────────────
    // AXI address for tile T, word W = base + T*256 + W*8
    function automatic logic [31:0] tile_word_addr(
        input logic [31:0] base, input int tile, input int word
    );
        return base + 32'(tile) * 32'd256 + 32'(word) * 32'd8;
    endfunction

    // ── Module-level working variables (Icarus: no automatic inside begin/end) ──
    int          addr_errors, data_errors, writes_seen, wcount;
    int          i, n, cyc, rdy_timer, bp_count, deny_count, post_writes;
    logic [31:0] exp_addr;
    logic [63:0] exp_fill;
    logic        got_cache_pulse, got_cache_val, bram_read_seen;
    logic [7:0]  got_cache_idx;

    // ── Tests ────────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("sim/waves/tb_bram_to_dram.vcd");
        $dumpvars(0, tb_bram_to_dram);
        rst=1; tile_done='0; engine_done=0;
        tt_is_filled=0; tt_fill_colour=0;
        axi_wr_ready=1; sixteenth_base_addr=0;
        tick(3);

        // ── RESET BEHAVIOUR ──────────────────────────────────────────────────
        suite("RESET - no spurious outputs immediately after reset");
        do_reset();
        tick(5);
        $display("    5 idle cycles after reset: axi_wr_en=%b b2d_rd_en=%b sixteenth_complete=%b cache_valid_wr_en=%b",
                  axi_wr_en, b2d_rd_en, sixteenth_complete, cache_valid_wr_en);
        check(!axi_wr_en,          "no AXI write_en immediately after reset");
        check(!b2d_rd_en,          "no BRAM read request immediately after reset");
        check(!sixteenth_complete, "sixteenth_complete low after reset");
        check(!cache_valid_wr_en,  "cache_valid_wr_en low after reset");

        suite("RESET - module starts processing tile_done after rst deasserts");
        rst = 1; tick(2);
        tile_done[0] = 1;
        tt_is_filled  = 0;
        tick(1);
        rst = 0;
        tick(1);
        $display("    First cycle after rst: axi_wr_en=%b (should not write yet)", axi_wr_en);
        collect_writes(1, 200);
        $display("    Eventually started writing: cap_count=%0d", cap_count);
        check(cap_count == 1, "module begins processing tile_done after rst deasserts");
        tile_done = '0;

        // ── TILED TILE (colour_bram path) ────────────────────────────────────
        suite("TILED TILE - tile 0: 32 writes, sequential addresses, correct BRAM data");
        do_reset();
        tt_is_filled = 0;
        $display("    tile_done[0]=1, base=0, tt_is_filled=0 (BRAM path)");
        tile_done[0] = 1;
        collect_writes(32);
        tile_done = '0;
        $display("    Collected %0d writes", cap_count);
        check(cap_count == 32, $sformatf("32 AXI writes for tile 0 (got %0d)", cap_count));
        addr_errors = 0; data_errors = 0;
        for (i = 0; i < 32; i++) begin
            exp_addr = tile_word_addr(32'h0, 0, i);
            if (cap_addr[i] !== exp_addr) begin
                $display("    word %0d: addr got=0x%08X expect=0x%08X", i, cap_addr[i], exp_addr);
                addr_errors++;
            end
            if (cap_data[i] !== bram_model[{8'h00, 5'(i)}]) begin
                $display("    word %0d: data got=0x%016X expect=0x%016X",
                          i, cap_data[i], bram_model[{8'h00, 5'(i)}]);
                data_errors++;
            end
        end
        $display("    Tile 0: addr_errors=%0d data_errors=%0d", addr_errors, data_errors);
        check(addr_errors == 0, "tile 0: all 32 addresses sequential from base");
        check(data_errors == 0, "tile 0: all 32 words match BRAM model");

        suite("TILED TILE - tile 5: addresses start at tile*256");
        do_reset();
        tt_is_filled = 0;
        $display("    tile_done[5]=1, expect first addr=0x%08X", tile_word_addr(32'h0, 5, 0));
        tile_done[5] = 1;
        collect_writes(32);
        tile_done = '0;
        addr_errors = 0;
        for (i = 0; i < 32; i++) begin
            exp_addr = tile_word_addr(32'h0, 5, i);
            if (cap_addr[i] !== exp_addr) begin
                $display("    tile5 word %0d: addr got=0x%08X expect=0x%08X", i, cap_addr[i], exp_addr);
                addr_errors++;
            end
        end
        $display("    Tile 5 addr_errors=%0d", addr_errors);
        check(addr_errors == 0, "tile 5: all addresses at offset tile*256");

        suite("TILED TILE - AXI backpressure: 32 correct writes under 2-ready/1-stall pattern");
        do_reset();
        tt_is_filled = 0;
        tile_done[2] = 1;
        bp_count = 0; rdy_timer = 0; cyc = 0;
        axi_wr_ready = 1;
        clear_cap();
        while (bp_count < 32 && cyc < 5000) begin
            @(posedge clk); #1; cyc++;
            rdy_timer++;
            // Pattern: 2 cycles ready, 1 cycle not-ready
            if      (rdy_timer == 2) axi_wr_ready = 0;
            else if (rdy_timer == 3) begin axi_wr_ready = 1; rdy_timer = 0; end
            if (axi_wr_en && axi_wr_ready) begin
                cap_data[bp_count] = axi_wr_data;
                cap_addr[bp_count] = axi_wr_addr;
                $display("    BP write #%0d: addr=0x%08X data=0x%016X (cyc=%0d)",
                          bp_count, axi_wr_addr, axi_wr_data, cyc);
                bp_count++;
                cap_count = bp_count;
            end
        end
        axi_wr_ready = 1;
        tile_done = '0;
        $display("    Backpressure done: %0d writes collected in %0d cycles", cap_count, cyc);
        check(cap_count == 32, $sformatf("backpressure: all 32 writes produced (got %0d)", cap_count));
        addr_errors = 0; data_errors = 0;
        for (i = 0; i < 32; i++) begin
            exp_addr = tile_word_addr(32'h0, 2, i);
            if (cap_addr[i] !== exp_addr) begin
                $display("    BP addr[%0d]: got=0x%08X expect=0x%08X", i, cap_addr[i], exp_addr);
                addr_errors++;
            end
            if (cap_data[i] !== bram_model[{8'h02, 5'(i)}]) begin
                $display("    BP data[%0d]: got=0x%016X expect=0x%016X",
                          i, cap_data[i], bram_model[{8'h02, 5'(i)}]);
                data_errors++;
            end
        end
        $display("    Backpressure: addr_errors=%0d data_errors=%0d", addr_errors, data_errors);
        check(addr_errors == 0, "backpressure: all 32 addresses sequential (stride 8, no gaps)");
        check(data_errors == 0, "backpressure: all 32 data words match BRAM model (no skipped words)");

        suite("TILED TILE - cache_valid_wr_en=1 with correct index after transfer");
        do_reset();
        tt_is_filled = 0;
        tile_done[3] = 1;
        got_cache_pulse = 0; got_cache_val = 0; got_cache_idx = 0;
        n = 0;
        while (!got_cache_pulse && n < 300) begin
            @(posedge clk); #1; n++;
            if (cache_valid_wr_en) begin
                got_cache_pulse = 1;
                got_cache_val   = cache_valid_value;
                got_cache_idx   = cache_valid_index;
                $display("    cache pulse at cycle %0d: idx=%0d val=%b",
                          n, got_cache_idx, got_cache_val);
            end
        end
        tile_done = '0;
        if (!got_cache_pulse) $display("    WARNING: no cache_valid pulse seen in 300 cycles");
        check(got_cache_pulse,        "cache_valid_wr_en pulsed after tiled tile done");
        check(got_cache_val == 1'b1,  "cache_valid_value=1 for tiled tile (data in BRAM)");
        check(got_cache_idx == 8'd3,  "cache_valid_index=3 matches tile");

        // ── FLOOD-FILL TILE ──────────────────────────────────────────────────
        suite("FLOOD FILL - tile 0: 32 writes, all bytes = fill colour");
        do_reset();
        tt_is_filled   = 1;
        tt_fill_colour = 6'h2A;
        $display("    tile_done[0]=1, fill colour=0x2A; expect all bytes=0x2A");
        tile_done[0] = 1;
        collect_writes(32);
        tile_done = '0;
        $display("    Got %0d writes", cap_count);
        check(cap_count == 32, $sformatf("flood fill: 32 AXI writes (got %0d)", cap_count));
        exp_fill = {8{8'h2A}};   // {2'b00, 6'h2A} = 8'h2A
        data_errors = 0;
        for (i = 0; i < 32; i++) begin
            if (cap_data[i] !== exp_fill) begin
                $display("    fill word %0d: got=0x%016X expect=0x%016X",
                          i, cap_data[i], exp_fill);
                data_errors++;
            end
        end
        $display("    Fill data errors=%0d", data_errors);
        check(data_errors == 0, "flood fill: all 32 words are solid fill colour 0x2A");

        suite("FLOOD FILL - tile 7 addresses correct at tile*256");
        do_reset();
        tt_is_filled   = 1;
        tt_fill_colour = 6'h0F;
        tile_done[7] = 1;
        collect_writes(32);
        tile_done = '0;
        addr_errors = 0;
        for (i = 0; i < 32; i++) begin
            exp_addr = tile_word_addr(32'h0, 7, i);
            if (cap_addr[i] !== exp_addr) begin
                $display("    fill tile7 word %0d: addr got=0x%08X expect=0x%08X",
                          i, cap_addr[i], exp_addr);
                addr_errors++;
            end
        end
        $display("    Fill tile 7 addr_errors=%0d", addr_errors);
        check(addr_errors == 0, "flood fill tile 7: addresses at tile*256 + word*8");

        suite("FLOOD FILL - b2d_rd_en never asserted during fill path");
        do_reset();
        tt_is_filled   = 1;
        tt_fill_colour = 6'h1F;
        tile_done[10]  = 1;
        bram_read_seen = 0;
        for (i = 0; i < 300; i++) begin
            @(posedge clk); #1;
            if (b2d_rd_en) begin
                $display("    UNEXPECTED b2d_rd_en at cycle %0d", i);
                bram_read_seen = 1;
            end
        end
        tile_done = '0;
        $display("    BRAM read seen during fill=%b (expect 0)", bram_read_seen);
        check(!bram_read_seen, "b2d_rd_en never asserted during flood fill");

        suite("FLOOD FILL - cache_valid_wr_en=0 with correct index");
        do_reset();
        tt_is_filled   = 1;
        tt_fill_colour = 6'h0F;
        tile_done[5] = 1;
        got_cache_pulse = 0; got_cache_val = 0; got_cache_idx = 0;
        n = 0;
        while (!got_cache_pulse && n < 300) begin
            @(posedge clk); #1; n++;
            if (cache_valid_wr_en) begin
                got_cache_pulse = 1;
                got_cache_val   = cache_valid_value;
                got_cache_idx   = cache_valid_index;
                $display("    Fill cache pulse at cycle %0d: idx=%0d val=%b",
                          n, got_cache_idx, got_cache_val);
            end
        end
        tile_done = '0;
        if (!got_cache_pulse) $display("    WARNING: no cache_valid pulse in 300 cycles");
        check(got_cache_pulse,        "cache_valid_wr_en pulsed for fill tile");
        check(got_cache_val == 1'b0,  "cache_valid_value=0 for flood fill (not from BRAM)");
        check(got_cache_idx == 8'd5,  "cache_valid_index=5 matches tile");

        // ── BASE ADDRESS ─────────────────────────────────────────────────────
        suite("BASE ADDRESS - tiled tile respects sixteenth_base_addr");
        do_reset();
        sixteenth_base_addr = 32'h00100000;
        tt_is_filled = 0;
        tile_done[0] = 1;
        collect_writes(32);
        tile_done = '0;
        $display("    First:  got=0x%08X  expect=0x%08X", cap_addr[0],  32'h00100000);
        $display("    Second: got=0x%08X  expect=0x%08X", cap_addr[1],  32'h00100008);
        $display("    Last:   got=0x%08X  expect=0x%08X", cap_addr[31], 32'h001000F8);
        check(cap_addr[0]  == 32'h00100000, $sformatf("first write at base (got 0x%08X)", cap_addr[0]));
        check(cap_addr[1]  == 32'h00100008, $sformatf("second write at base+8 (got 0x%08X)", cap_addr[1]));
        check(cap_addr[31] == 32'h001000F8, $sformatf("last write at base+248 (got 0x%08X)", cap_addr[31]));

        suite("BASE ADDRESS - flood fill tile respects sixteenth_base_addr");
        do_reset();
        sixteenth_base_addr = 32'hDEAD0000;
        tt_is_filled   = 1;
        tt_fill_colour = 6'h3F;
        tile_done[1] = 1;   // tile 1 → offset = 1*256 = 0x100
        collect_writes(32);
        tile_done = '0;
        exp_addr = 32'hDEAD0000 + 32'h100;
        $display("    Tile 1 first: got=0x%08X  expect=0x%08X", cap_addr[0], exp_addr);
        $display("    Tile 1 last:  got=0x%08X  expect=0x%08X", cap_addr[31], exp_addr + 32'd248);
        check(cap_addr[0]  == exp_addr,
            $sformatf("fill tile 1 first at base+256 (got 0x%08X)", cap_addr[0]));
        check(cap_addr[31] == exp_addr + 32'd248,
            $sformatf("fill tile 1 last at base+256+248 (got 0x%08X)", cap_addr[31]));

        // ── MULTIPLE TILES ───────────────────────────────────────────────────
        suite("MULTIPLE TILES - 3 tiled tiles simultaneously produce 96 writes");
        do_reset();
        tt_is_filled = 0;
        $display("    tile_done[0,1,2]=1 simultaneously");
        tile_done[0] = 1; tile_done[1] = 1; tile_done[2] = 1;
        writes_seen = 0;
        for (i = 0; i < 1000; i++) begin
            @(posedge clk); #1;
            if (axi_wr_en && axi_wr_ready) writes_seen++;
        end
        tile_done = '0;
        $display("    Total writes: %0d (expect 96)", writes_seen);
        check(writes_seen == 96, $sformatf("3 tiles × 32 = 96 writes (got %0d)", writes_seen));

        suite("MULTIPLE TILES - mixed fill and tiled tiles, 4 tiles = 128 writes");
        do_reset();
        // tiles 0,2 = fill; tiles 1,3 = tiled
        $display("    tiles 0,2=fill(col=0x15) tiles 1,3=tiled(BRAM)");
        tile_done[0] = 1; tile_done[1] = 1;
        tile_done[2] = 1; tile_done[3] = 1;
        wcount = 0;
        for (i = 0; i < 2000; i++) begin
            @(posedge clk); #1;
            // Respond to tt_rd_index to select path per tile
            if (tt_rd_index == 0 || tt_rd_index == 2)
                { tt_is_filled, tt_fill_colour } = { 1'b1, 6'h15 };
            else
                { tt_is_filled, tt_fill_colour } = { 1'b0, 6'h00 };
            if (axi_wr_en && axi_wr_ready) wcount++;
        end
        tile_done = '0;
        $display("    Mixed batch total writes: %0d (expect 128)", wcount);
        check(wcount == 128, $sformatf("4 tiles (mixed) × 32 = 128 writes (got %0d)", wcount));

        suite("MULTIPLE TILES - tiles set one by one, 2 tiles = 64 writes");
        do_reset();
        tt_is_filled = 0;
        writes_seen = 0;
        $display("    Set tile_done[0]; after 50 cycles set tile_done[1]");
        tile_done[0] = 1;
        for (i = 0; i < 50; i++) begin
            @(posedge clk); #1;
            if (axi_wr_en && axi_wr_ready) writes_seen++;
        end
        tile_done[1] = 1;
        for (i = 0; i < 200; i++) begin
            @(posedge clk); #1;
            if (axi_wr_en && axi_wr_ready) writes_seen++;
        end
        tile_done = '0;
        $display("    Sequential tiles total writes: %0d (expect 64)", writes_seen);
        check(writes_seen == 64, $sformatf("2 sequential tiles = 64 writes (got %0d)", writes_seen));

        // ── sixteenth_complete ───────────────────────────────────────────────
        suite("sixteenth_complete - stays low with all tiles done but engine_done=0");
        do_reset();
        tt_is_filled = 1; tt_fill_colour = 6'h01;
        tile_done    = '1;
        engine_done  = 0;
        $display("    All 256 tile_done bits set, engine_done=0; running 10000 cycles...");
        repeat(10000) @(posedge clk); #1;
        $display("    sixteenth_complete=%b (expect 0)", sixteenth_complete);
        check(!sixteenth_complete, "sixteenth_complete low without engine_done");

        suite("sixteenth_complete - asserts after engine_done (all tiles already done)");
        engine_done = 1; tick(5);
        $display("    engine_done=1: sixteenth_complete=%b (expect 1)", sixteenth_complete);
        check(sixteenth_complete, "sixteenth_complete asserts after engine_done");

        suite("sixteenth_complete - stays low before tiles done even if engine_done=1");
        do_reset();
        tt_is_filled = 1; tt_fill_colour = 6'h01;
        engine_done  = 1;
        tick(2);
        $display("    engine_done=1, no tiles done yet: sixteenth_complete=%b (expect 0)",
                  sixteenth_complete);
        check(!sixteenth_complete, "sixteenth_complete low before any tiles transferred");
        tile_done = '1;
        repeat(10000) @(posedge clk); #1;
        $display("    After all tiles transferred: sixteenth_complete=%b (expect 1)",
                  sixteenth_complete);
        check(sixteenth_complete, "sixteenth_complete asserts after all tiles transferred");

        suite("sixteenth_complete - stays low if only 128 of 256 tiles done");
        do_reset();
        tt_is_filled = 1; tt_fill_colour = 6'h05;
        engine_done  = 1;
        tile_done    = {{128{1'b0}}, {128{1'b1}}};   // lower 128 bits set
        $display("    128/256 tiles set, engine_done=1; running 5000 cycles...");
        repeat(5000) @(posedge clk); #1;
        $display("    sixteenth_complete=%b (expect 0)", sixteenth_complete);
        check(!sixteenth_complete, "sixteenth_complete low with only 128/256 tiles done");
        tile_done = '0;

        // ── BRAM GRANT DENIED ────────────────────────────────────────────────
        suite("BRAM GRANT DENIED - module retries and still produces 32 correct writes");
        do_reset();
        tt_is_filled = 0;
        tile_done[4] = 1;
        deny_count = 0; wcount = 0; cyc = 0;
        clear_cap();
        // Override the always_comb model by driving from procedural block
        // Note: this is a forcing approach — both will try to drive, Icarus last-assign wins
        // We use a flag + always_comb below, but here drive directly each cycle
        while (wcount < 32 && cyc < 5000) begin
            @(posedge clk); #1; cyc++;
            // Deny every 3rd BRAM request
            if (b2d_rd_en) begin
                if (deny_count % 3 == 0) begin
                    $display("    BRAM deny #%0d at cyc=%0d addr=0x%04X",
                              deny_count, cyc, b2d_word_addr);
                end
                deny_count++;
            end
            if (axi_wr_en && axi_wr_ready) begin
                cap_data[wcount] = axi_wr_data;
                cap_addr[wcount] = axi_wr_addr;
                wcount++;
                cap_count = wcount;
            end
        end
        tile_done = '0;
        // (For this test the always_comb always grants — denial is modelled in a separate
        //  test mode below that overrides with a flag)
        $display("    BRAM-deny test: %0d writes collected (denial tracking only — grant still asserted)",
                  cap_count);
        // Separate denial test with actual grant suppression:
        do_reset();
        tt_is_filled = 0;
        tile_done[6] = 1;
        deny_count = 0; wcount = 0; cyc = 0;
        clear_cap();
        while (wcount < 32 && cyc < 5000) begin
            @(posedge clk); #1; cyc++;
            // Suppress grant on every 3rd rd_en
            if (b2d_rd_en && (deny_count % 3 == 0)) begin
                force b2d_rd_grant = 1'b0;
                $display("    Suppressing grant #%0d at cyc=%0d addr=0x%04X",
                          deny_count, cyc, b2d_word_addr);
            end else begin
                release b2d_rd_grant;
            end
            if (b2d_rd_en) deny_count++;
            if (axi_wr_en && axi_wr_ready) begin
                cap_data[wcount] = axi_wr_data;
                cap_addr[wcount] = axi_wr_addr;
                wcount++;
                cap_count = wcount;
            end
        end
        release b2d_rd_grant;
        tile_done = '0;
        $display("    BRAM-deny tile 6: %0d writes collected", cap_count);
        check(cap_count == 32, $sformatf("retry on BRAM deny: still 32 writes (got %0d)", cap_count));
        addr_errors = 0;
        for (i = 0; i < 32; i++) begin
            exp_addr = tile_word_addr(32'h0, 6, i);
            if (cap_addr[i] !== exp_addr) begin
                $display("    retry word %0d: addr got=0x%08X expect=0x%08X",
                          i, cap_addr[i], exp_addr);
                addr_errors++;
            end
        end
        check(addr_errors == 0, "retry on BRAM deny: all 32 addresses correct");

        // ── AXI BACKPRESSURE DURING FLOOD FILL ──────────────────────────────
        // The fill path now also uses combinational AXI outputs, so wr_count only
        // advances when axi_wr_ready=1. Test that stalls during fill produce all
        // 32 correct words rather than repeating or skipping words.
        suite("FLOOD FILL - AXI backpressure: 32 correct writes under 2-ready/1-stall pattern");
        do_reset();
        tt_is_filled   = 1;
        tt_fill_colour = 6'h17;
        tile_done[9]   = 1;
        bp_count = 0; rdy_timer = 0; cyc = 0;
        axi_wr_ready = 1;
        clear_cap();
        while (bp_count < 32 && cyc < 5000) begin
            @(posedge clk); #1; cyc++;
            rdy_timer++;
            if      (rdy_timer == 2) axi_wr_ready = 0;
            else if (rdy_timer == 3) begin axi_wr_ready = 1; rdy_timer = 0; end
            if (axi_wr_en && axi_wr_ready) begin
                cap_data[bp_count] = axi_wr_data;
                cap_addr[bp_count] = axi_wr_addr;
                $display("    Fill BP write #%0d: addr=0x%08X data=0x%016X (cyc=%0d)",
                          bp_count, axi_wr_addr, axi_wr_data, cyc);
                bp_count++;
                cap_count = bp_count;
            end
        end
        axi_wr_ready = 1;
        tile_done = '0;
        $display("    Fill backpressure: %0d writes collected in %0d cycles", cap_count, cyc);
        check(cap_count == 32, $sformatf("fill backpressure: all 32 writes produced (got %0d)", cap_count));
        exp_fill = {8{8'h17}};
        addr_errors = 0; data_errors = 0;
        for (i = 0; i < 32; i++) begin
            exp_addr = tile_word_addr(32'h0, 9, i);
            if (cap_addr[i] !== exp_addr) begin
                $display("    Fill BP addr[%0d]: got=0x%08X expect=0x%08X", i, cap_addr[i], exp_addr);
                addr_errors++;
            end
            if (cap_data[i] !== exp_fill) begin
                $display("    Fill BP data[%0d]: got=0x%016X expect=0x%016X",
                          i, cap_data[i], exp_fill);
                data_errors++;
            end
        end
        $display("    Fill backpressure: addr_errors=%0d data_errors=%0d", addr_errors, data_errors);
        check(addr_errors == 0, "fill backpressure: all 32 addresses sequential (stride 8, no gaps)");
        check(data_errors == 0, "fill backpressure: all 32 data words are correct fill colour");

        // ── BRAM DENY COINCIDING WITH AXI-READY ─────────────────────────────
        // This tests the new re-prime path in BURST_PIPE: when axi_wr_ready=1 (write
        // accepted) but b2d_rd_grant=0 simultaneously, pipe_valid is cleared and the
        // module must re-prime the pipeline from rd_count without losing a word.
        // We force this by suppressing BRAM grant specifically on cycles where axi_wr_en
        // and axi_wr_ready are both high — the hardest case for the pipeline.
        suite("BRAM DENY + AXI-READY coincide: re-prime path produces all 32 correct writes");
        do_reset();
        tt_is_filled = 0;
        tile_done[11] = 1;
        deny_count = 0; wcount = 0; cyc = 0;
        clear_cap();
        // Suppress BRAM grant on every 4th accepted AXI write — forces the simultaneous case
        while (wcount < 32 && cyc < 10000) begin
            @(posedge clk); #1; cyc++;
            // If this cycle would be a simultaneous AXI-accept + grant, deny every 4th
            if (axi_wr_en && axi_wr_ready && b2d_rd_en) begin
                deny_count++;
                if (deny_count % 4 == 0) begin
                    force b2d_rd_grant = 1'b0;
                    $display("    Coincident deny #%0d at cyc=%0d (axi+bram same cycle)",
                              deny_count, cyc);
                end else begin
                    release b2d_rd_grant;
                end
            end else begin
                release b2d_rd_grant;
            end
            if (axi_wr_en && axi_wr_ready) begin
                cap_data[wcount] = axi_wr_data;
                cap_addr[wcount] = axi_wr_addr;
                $display("    Coincide write #%0d: addr=0x%08X data=0x%016X (cyc=%0d)",
                          wcount, axi_wr_addr, axi_wr_data, cyc);
                wcount++;
                cap_count = wcount;
            end
        end
        release b2d_rd_grant;
        tile_done = '0;
        $display("    Coincident deny: %0d writes collected, %0d denials injected", cap_count, deny_count);
        check(cap_count == 32, $sformatf("coincident deny: all 32 writes produced (got %0d)", cap_count));
        addr_errors = 0; data_errors = 0;
        for (i = 0; i < 32; i++) begin
            exp_addr = tile_word_addr(32'h0, 11, i);
            if (cap_addr[i] !== exp_addr) begin
                $display("    Coincide addr[%0d]: got=0x%08X expect=0x%08X", i, cap_addr[i], exp_addr);
                addr_errors++;
            end
            if (cap_data[i] !== bram_model[{8'h0B, 5'(i)}]) begin
                $display("    Coincide data[%0d]: got=0x%016X expect=0x%016X",
                          i, cap_data[i], bram_model[{8'h0B, 5'(i)}]);
                data_errors++;
            end
        end
        $display("    Coincident deny: addr_errors=%0d data_errors=%0d", addr_errors, data_errors);
        check(addr_errors == 0, "coincident deny: all 32 addresses correct");
        check(data_errors == 0, "coincident deny: all 32 data words correct, no word lost on re-prime");

        // ── RESET MID-TRANSFER ───────────────────────────────────────────────
        suite("RESET MID-TRANSFER - rst clears state, no writes after tile_done cleared");
        do_reset();
        tt_is_filled = 0;
        tile_done[0] = 1;
        writes_seen = 0;
        for (i = 0; i < 10; i++) begin
            @(posedge clk); #1;
            if (axi_wr_en && axi_wr_ready) writes_seen++;
        end
        $display("    Writes before mid-reset: %0d", writes_seen);
        rst = 1; tick(3); rst = 0;
        tile_done = '0;
        post_writes = 0;
        for (i = 0; i < 20; i++) begin
            @(posedge clk); #1;
            if (axi_wr_en) begin
                $display("    Unexpected write at cycle %0d post-reset", i);
                post_writes++;
            end
        end
        $display("    Post-reset: axi_wr_en writes=%0d sixteenth_complete=%b",
                  post_writes, sixteenth_complete);
        check(!sixteenth_complete, "sixteenth_complete cleared by reset");
        check(post_writes == 0,    "no AXI writes after reset when no tile_done active");

        summary();
        $finish;
    end

    initial begin #100000000; $display("[TIMEOUT]"); $finish; end

endmodule
