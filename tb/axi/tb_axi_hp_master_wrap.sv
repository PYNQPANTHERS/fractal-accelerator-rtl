`timescale 1ns/1ps

// Exercises axi_hp_master_wrap in isolation: drives the simple wr_* interface
// like bram_to_dram does (WORDS_PER_TILE words back-to-back per tile), models a
// minimal AXI4 write slave (AW/W/B with configurable backpressure), and checks
// that every tile produces one correct burst (right addr, right data, WLAST on
// the final beat, OKAY response). This is the module never exercised by the
// engine sim, so it isolates "wrapper RTL vs real HP slave" for the DDR-writeback
// bug.

module tb_axi_hp_master_wrap;

    localparam int TILE_W         = 8;                 // 8 words/tile (fast); try 16 too
    localparam int WORDS_PER_TILE = TILE_W*TILE_W/8;
    localparam int BYTES_PER_TILE = TILE_W*TILE_W;

    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    int tests = 0, passes = 0, fails = 0;
    task automatic chk(input logic cond, input string msg);
        tests++;
        if (cond) begin passes++; $display("  [PASS] %s", msg); end
        else      begin fails++;  $display("  [FAIL] %s", msg); end
    endtask

    // ── DUT signals ───────────────────────────────────────────────────────────
    logic        rst;
    logic [31:0] wr_addr;
    logic [63:0] wr_data;
    logic        wr_en;
    wire         wr_ready;

    wire [5:0]  m_awid;
    wire [31:0] m_awaddr;
    wire [7:0]  m_awlen;
    wire [2:0]  m_awsize;
    wire [1:0]  m_awburst;
    wire [3:0]  m_awcache;
    wire [2:0]  m_awprot;
    wire [3:0]  m_awqos;
    wire        m_awvalid;
    logic       m_awready;

    wire [63:0] m_wdata;
    wire [7:0]  m_wstrb;
    wire        m_wlast;
    wire        m_wvalid;
    logic       m_wready;

    logic [5:0] m_bid;
    logic [1:0] m_bresp;
    logic       m_bvalid;
    wire        m_bready;

    wire        err_flag;
    wire        burst_done;

    axi_hp_master_wrap #(.TILE_W(TILE_W)) dut (
        .clk(clk), .rst(rst),
        .wr_addr(wr_addr), .wr_data(wr_data), .wr_en(wr_en), .wr_ready(wr_ready),
        .m_awid(m_awid), .m_awaddr(m_awaddr), .m_awlen(m_awlen), .m_awsize(m_awsize),
        .m_awburst(m_awburst), .m_awcache(m_awcache), .m_awprot(m_awprot),
        .m_awqos(m_awqos), .m_awvalid(m_awvalid), .m_awready(m_awready),
        .m_wdata(m_wdata), .m_wstrb(m_wstrb), .m_wlast(m_wlast),
        .m_wvalid(m_wvalid), .m_wready(m_wready),
        .m_bid(m_bid), .m_bresp(m_bresp), .m_bvalid(m_bvalid), .m_bready(m_bready),
        .err_flag(err_flag), .burst_done(burst_done)
    );

    // ── Minimal AXI4 write slave model ────────────────────────────────────────
    // Configurable: aw_stall_cyc (cycles AWREADY is withheld), w_backpressure
    // (deassert WREADY every other beat), bresp_val.
    int          aw_stall_cyc   = 0;
    logic        w_backpressure = 0;
    logic [1:0]  bresp_val      = 2'b00;

    // captured transaction
    logic [31:0] cap_awaddr;
    logic [7:0]  cap_awlen;
    int          cap_beats;
    logic [63:0] cap_wdata [0:255];
    logic        cap_wlast_ok;       // wlast asserted exactly on final beat
    logic        cap_done;

    // AW: accept after aw_stall_cyc cycles of awvalid
    int aw_wait;
    always @(posedge clk) begin
        if (rst) begin
            m_awready <= 1'b0;
            aw_wait   <= 0;
        end else begin
            m_awready <= 1'b0;
            if (m_awvalid && !m_awready) begin
                if (aw_wait >= aw_stall_cyc) begin
                    m_awready  <= 1'b1;
                    cap_awaddr <= m_awaddr;
                    cap_awlen  <= m_awlen;
                    aw_wait    <= 0;
                end else aw_wait <= aw_wait + 1;
            end
        end
    end

    // W: accept beats, capture data, verify WLAST timing
    logic w_tog;
    always @(posedge clk) begin
        if (rst) begin
            m_wready     <= 1'b0;
            cap_beats    <= 0;
            cap_wlast_ok <= 1'b1;
            w_tog        <= 1'b0;
        end else begin
            // WREADY policy
            if (w_backpressure) begin w_tog <= ~w_tog; m_wready <= w_tog; end
            else                       m_wready <= 1'b1;

            if (m_wvalid && m_wready) begin
                cap_wdata[cap_beats] <= m_wdata;
                // wlast must assert exactly when this is the last expected beat
                if (m_wlast && (cap_beats != WORDS_PER_TILE-1)) cap_wlast_ok <= 1'b0;
                if (!m_wlast && (cap_beats == WORDS_PER_TILE-1)) cap_wlast_ok <= 1'b0;
                cap_beats <= cap_beats + 1;
            end
        end
    end

    // B: after WLAST accepted, return response
    logic wlast_seen;
    always @(posedge clk) begin
        if (rst) begin
            m_bvalid   <= 1'b0;
            m_bresp    <= 2'b00;
            m_bid      <= '0;
            wlast_seen <= 1'b0;
            cap_done   <= 1'b0;
        end else begin
            cap_done <= 1'b0;
            if (m_wvalid && m_wready && m_wlast) wlast_seen <= 1'b1;
            if (wlast_seen && !m_bvalid) begin
                m_bvalid <= 1'b1;
                m_bresp  <= bresp_val;
            end
            if (m_bvalid && m_bready) begin
                m_bvalid   <= 1'b0;
                wlast_seen <= 1'b0;
                cap_done   <= 1'b1;
            end
        end
    end

    // ── Drive one tile: WORDS_PER_TILE words, base address `base` ─────────────
    task automatic send_tile(input logic [31:0] base);
        cap_beats    = 0;
        cap_wlast_ok = 1'b1;
        for (int w = 0; w < WORDS_PER_TILE; w++) begin
            // wait for wr_ready
            while (!wr_ready) tick(1);
            wr_addr = base + w*8;
            wr_data = {32'hD0D0_0000 + w, base + w};   // unique recognizable data
            wr_en   = 1'b1;
            tick(1);
            wr_en   = 1'b0;
        end
    endtask

    task automatic wait_burst(input int max_cyc = 2000);
        int t; t = 0;
        while (!cap_done && t < max_cyc) begin tick(1); t++; end
    endtask

    task automatic check_tile(input logic [31:0] base, input string nm);
        chk(cap_done, {nm, ": burst completed (BVALID/burst_done seen)"});
        chk(cap_awaddr == base, {nm, ": AWADDR == tile base"});
        chk(int'(cap_awlen) == WORDS_PER_TILE-1, {nm, ": AWLEN == WORDS_PER_TILE-1"});
        chk(cap_beats == WORDS_PER_TILE, {nm, ": exactly WORDS_PER_TILE beats"});
        chk(cap_wlast_ok, {nm, ": WLAST asserted on final beat only"});
        begin
            logic data_ok; data_ok = 1'b1;
            for (int w = 0; w < WORDS_PER_TILE; w++)
                if (cap_wdata[w] !== {32'hD0D0_0000 + w, base + w}) data_ok = 1'b0;
            chk(data_ok, {nm, ": all beat data correct & in order"});
        end
        chk(m_awsize == 3'b011, {nm, ": AWSIZE == 8 bytes"});
        chk(m_awburst == 2'b01, {nm, ": AWBURST == INCR"});
    endtask

    initial begin
        rst = 1; wr_en = 0; wr_addr = 0; wr_data = 0;
        aw_stall_cyc = 0; w_backpressure = 0; bresp_val = 0;
        tick(4); rst = 0; tick(2);

        $display("\ntb_axi_hp_master_wrap  (TILE_W=%0d, WORDS_PER_TILE=%0d)", TILE_W, WORDS_PER_TILE);

        // Test 1: clean burst, no backpressure
        $display("\n-- Test 1: single clean burst --");
        send_tile(32'h1000_0000);
        wait_burst();
        check_tile(32'h1000_0000, "clean");

        // Test 2: AW stalled a few cycles (slave slow to accept address)
        $display("\n-- Test 2: AWREADY delayed 5 cycles --");
        aw_stall_cyc = 5;
        send_tile(32'h1000_0100);
        wait_burst();
        check_tile(32'h1000_0100, "aw-stall");
        aw_stall_cyc = 0;

        // Test 3: W backpressure (WREADY every other cycle)
        $display("\n-- Test 3: WREADY backpressure --");
        w_backpressure = 1;
        send_tile(32'h1000_0200);
        wait_burst();
        check_tile(32'h1000_0200, "w-backpressure");
        w_backpressure = 0;

        // Test 4: back-to-back tiles (does it re-arm for the next burst?)
        $display("\n-- Test 4: two consecutive tiles --");
        send_tile(32'h1000_0300);
        wait_burst();
        check_tile(32'h1000_0300, "consec-1");
        send_tile(32'h1000_0400);
        wait_burst();
        check_tile(32'h1000_0400, "consec-2");

        // Test 5: error response sets err_flag
        $display("\n-- Test 5: SLVERR response --");
        bresp_val = 2'b10;
        send_tile(32'h1000_0500);
        wait_burst();
        chk(err_flag, "slverr: err_flag set on bad BRESP");
        bresp_val = 2'b00;

        $display("\n========================================");
        $display("  RESULTS: %0d / %0d passed", passes, tests);
        if (fails == 0) $display("  ALL TESTS PASSED");
        else            $display("  %0d TEST(S) FAILED", fails);
        $display("========================================\n");
        $finish;
    end

    // watchdog
    initial begin #500000; $display("[WATCHDOG] timeout"); $finish; end

endmodule
