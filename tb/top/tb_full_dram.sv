`timescale 1ns/1ps
//
// Full-image render testbench that reconstructs the image from what actually
// reaches DRAM — NOT from the colour-BRAM write stream.
//
//   make full-dram DESIGN=dual_core       (2 engines, compiled with -D DUAL)
//   make full-dram DESIGN=dual_precision   (1 engine)
//
// WHY THIS EXISTS
//   tb_full holds hp_axi_wr_ready=1 and reconstructs the image by probing the
//   colour BRAM (dut.u_engine_*.u_control_unit.u_bram_rw.*). That proves the
//   compute path but says NOTHING about whether the bram_to_dram -> arbiter ->
//   hp_axi_wr_* path delivers the right bytes to DRAM. This TB closes that gap:
//   it is the ONLY consumer of the HP write bus, models a byte-addressed DRAM,
//   and writes the CSV purely from the captured AXI words. Any dropped/duplicated
//   word, wrong address, or arbiter handoff bug shows up here.
//
// DRAM MODEL
//   The HP write stream is {wr_addr[31:0], wr_data[63:0], wr_en, wr_ready}. Each
//   accepted beat (wr_en && wr_ready) writes 8 bytes little-endian at wr_addr.
//   wr_ready is driven with intermittent backpressure so the arbiter/bram_to_dram
//   ready handshaking is genuinely exercised (not stubbed high).
//
// IMAGE RECONSTRUCTION (mirrors sim/render/visualise.py render_dram_csv +
// the bram_to_dram address generator exactly):
//   addr = base + sixteenth*65536 + (tile_idx << log2(TILE_W*TILE_W))
//               + (word_in_tile << 3)
//   tile_idx     = tile_row*TILES_PER_AXIS + tile_col   (linear, book order)
//   word_in_tile : row_in_tile = word_in_tile / (TILE_W/8)
//                  col_start    = (word_in_tile % (TILE_W/8)) * 8
//   each 64-bit word = 8 consecutive pixels in one tile row (byte b -> +b in x).
//   global pixel = (sixteenth_col*256 + tile_col*TILE_W + col_start + b,
//                   sixteenth_row*256 + tile_row*TILE_W + row_in_tile)
//
// OUTPUTS
//   sim/render/<tag>_dram_full_image.csv   row,col,colour      (1024x1024, from DRAM)
//   sim/render/<tag>_dram_raw.csv          write_index,addr_hex,b0..b7  (raw AXI beats)

module tb_full_dram;

    localparam int TILE_W    = 8;
    localparam int TILE_BITS = $clog2(TILE_W);

    localparam int BYTES_PER_TILE  = TILE_W * TILE_W;          // 1 byte/pixel
    localparam int WORDS_PER_TILE  = BYTES_PER_TILE / 8;
    localparam int TILES_PER_AXIS  = 256 / TILE_W;
    localparam int WORDS_PER_ROW   = TILE_W / 8;               // words per tile-row
    localparam int LOG2_BPT        = $clog2(BYTES_PER_TILE);
    localparam int SIXTEENTH_BYTES = 65536;                    // 256*256, always

    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // ── DUT ──────────────────────────────────────────────────────────────────
    logic        rst;
    wire         irq_all_done;
    wire         irq_started;

    wire  [31:0] hp_axi_wr_addr;
    wire  [63:0] hp_axi_wr_data;
    wire         hp_axi_wr_en;
    logic        hp_axi_wr_ready;          // DRIVEN by the DRAM model (with backpressure)

    logic        ps_start         = 1'b0;
    logic [4:0]  cfg_fractal_type = 5'b0;
    logic [34:0] cfg_julia_real   = 35'b0;
    logic [34:0] cfg_julia_imag   = 35'b0;
    logic [34:0] cfg_centre_x        = 35'h4_C000_0000;
    logic [34:0] cfg_centre_y        = 35'h1_C000_0000;
    logic [15:0] cfg_zoom_level   = 16'd20;
    logic [11:0] cfg_max_iter     = 12'd0;
    logic [31:0] cfg_image_base_addr = 32'b0;

    top_level #(.TILE_W(TILE_W)) dut (
        .clk                (clk),
        .rst                (rst),
        .ps_start           (ps_start),
        .cfg_fractal_type   (cfg_fractal_type),
        .cfg_julia_real     (cfg_julia_real),
        .cfg_julia_imag     (cfg_julia_imag),
        .cfg_centre_x          (cfg_centre_x),
        .cfg_centre_y          (cfg_centre_y),
        .cfg_zoom_level     (cfg_zoom_level),
        .cfg_max_iter       (cfg_max_iter),
        .cfg_image_base_addr(cfg_image_base_addr),
        .hp_axi_wr_addr     (hp_axi_wr_addr),
        .hp_axi_wr_data     (hp_axi_wr_data),
        .hp_axi_wr_en       (hp_axi_wr_en),
        .hp_axi_wr_ready    (hp_axi_wr_ready),
        .irq_all_done       (irq_all_done),
        .irq_started        (irq_started)
    );

    // ── DRAM model ─────────────────────────────────────────────────────────────
    // 16 sixteenths * 65536 bytes = 1 MiB. Byte-addressed, init 0xFF (= "unwritten",
    // emitted as -1 so the visualiser greys it out, exactly like tb_full).
    localparam int DRAM_BYTES = 16 * SIXTEENTH_BYTES;
    logic [7:0] dram [0:DRAM_BYTES-1];

    // Raw beat capture (every accepted AXI word) for the dram_raw CSV round-trip.
    localparam int MAX_BEATS = 200_000;       // >> 16*1024 tiles*words, safe margin
    logic [31:0] beat_addr [0:MAX_BEATS-1];
    logic [63:0] beat_data [0:MAX_BEATS-1];
    int          beat_cnt = 0;

    // Backpressure: ready deasserts on a cheap pseudo-random schedule so the
    // bram_to_dram BP_AXI_WAIT / arbiter handshake is genuinely exercised. Using a
    // free-running LFSR-ish counter; ~3/4 duty so it still finishes promptly.
    logic [7:0] bp_lfsr = 8'hA5;
    always @(posedge clk) bp_lfsr <= {bp_lfsr[6:0], bp_lfsr[7] ^ bp_lfsr[5] ^ bp_lfsr[4] ^ bp_lfsr[3]};
    always_comb hp_axi_wr_ready = (bp_lfsr[1:0] != 2'b00);   // ready ~75% of cycles

    // Capture accepted beats into DRAM + raw log.
    always @(posedge clk) begin
        if (!rst && hp_axi_wr_en && hp_axi_wr_ready) begin
            for (int b = 0; b < 8; b++)
                if ((hp_axi_wr_addr + b) < DRAM_BYTES)
                    dram[hp_axi_wr_addr + b] <= hp_axi_wr_data[b*8 +: 8];
            if (beat_cnt < MAX_BEATS) begin
                beat_addr[beat_cnt] = hp_axi_wr_addr;
                beat_data[beat_cnt] = hp_axi_wr_data;
                beat_cnt++;
            end
        end
    end

    // ── Heartbeat ──────────────────────────────────────────────────────────────
    longint cyc = 0;
    always @(posedge clk) cyc++;

    // sixteenth-id being rendered: dual has per-engine _a/_b, single has one.
`ifdef DUAL
    wire [3:0] sxt_id_a = dut.ctrl_sixteenth_id_a;
    wire [3:0] sxt_id_b = dut.ctrl_sixteenth_id_b;
    always @(posedge clk)
        if ((cyc % 100_000) == 0)
            $display("  [hb] cyc=%0d  sxt_a=%0d sxt_b=%0d  beats=%0d",
                     cyc, sxt_id_a, sxt_id_b, beat_cnt);
`else
    wire [3:0] sxt_id = dut.ctrl_sixteenth_id;
    always @(posedge clk)
        if ((cyc % 100_000) == 0)
            $display("  [hb] cyc=%0d  sxt=%0d  beats=%0d", cyc, sxt_id, beat_cnt);
`endif

    // ── DRAM -> 1024x1024 image CSV ─────────────────────────────────────────────
    task automatic dump_dram_full_image_csv(input string path);
        logic [7:0] image [0:1023][0:1023];
        integer fd;
        int sxt, sxt_col, sxt_row, tile_idx, word_in_tile, tile_col, tile_row;
        int row_in_tile, col_start, px, py, addr;
        logic [7:0] byte_v;
        for (int r = 0; r < 1024; r++)
            for (int c = 0; c < 1024; c++) image[r][c] = 8'hFF;

        // Walk DRAM word-by-word and place each byte at its decoded pixel.
        for (int a = 0; a < DRAM_BYTES; a += 8) begin
            sxt          = a / SIXTEENTH_BYTES;
            addr         = a % SIXTEENTH_BYTES;                 // offset within sixteenth
            tile_idx     = addr >> LOG2_BPT;
            word_in_tile = (addr & ((1 << LOG2_BPT) - 1)) >> 3;
            tile_col     = tile_idx % TILES_PER_AXIS;
            tile_row     = tile_idx / TILES_PER_AXIS;
            row_in_tile  = word_in_tile / WORDS_PER_ROW;
            col_start    = (word_in_tile % WORDS_PER_ROW) * 8;
            sxt_col      = sxt & 3;
            sxt_row      = sxt >> 2;
            for (int b = 0; b < 8; b++) begin
                px = sxt_col * 256 + tile_col * TILE_W + col_start + b;
                py = sxt_row * 256 + tile_row * TILE_W + row_in_tile;
                byte_v = dram[a + b];
                if (px < 1024 && py < 1024)
                    image[py][px] = byte_v;
            end
        end

        fd = $fopen(path, "w");
        $fwrite(fd, "row,col,colour\n");
        for (int r = 0; r < 1024; r++)
            for (int c = 0; c < 1024; c++)
                if (image[r][c] === 8'hFF)
                    $fwrite(fd, "%0d,%0d,-1\n", r, c);
                else
                    $fwrite(fd, "%0d,%0d,%0d\n", r, c, image[r][c] & 8'h3F);
        $fclose(fd);
        $display("  wrote %s  (1024x1024, from DRAM)", path);
    endtask

    // ── Raw AXI beat log: write_index,addr_hex,b0..b7 (round-trips render_dram_csv)
    task automatic dump_dram_raw_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        $fwrite(fd, "write_index,addr_hex,b0,b1,b2,b3,b4,b5,b6,b7\n");
        for (int i = 0; i < beat_cnt; i++) begin
            $fwrite(fd, "%0d,%08x", i, beat_addr[i]);
            for (int b = 0; b < 8; b++)
                $fwrite(fd, ",%0d", beat_data[i][b*8 +: 8] & 8'h3F);
            $fwrite(fd, "\n");
        end
        $fclose(fd);
        $display("  wrote %s  (%0d AXI beats)", path, beat_cnt);
    endtask

    // ── plusarg config (same knobs as tb_full) ─────────────────────────────────
    logic [34:0] run_cx, run_cy, run_jr, run_ji;
    logic [31:0] run_zoom, run_maxi, run_ft;
    string       run_tag;
    initial begin
        for (int i = 0; i < DRAM_BYTES; i++) dram[i] = 8'hFF;

        run_cx = 35'h4_C000_0000; run_cy = 35'h1_C000_0000; run_jr = 0; run_ji = 0;
        run_zoom = 16'd20; run_maxi = 12'd0; run_ft = 0; run_tag = "full";
        void'($value$plusargs("centre_x=%h", run_cx));
        void'($value$plusargs("centre_y=%h", run_cy));
        void'($value$plusargs("julia_re=%h", run_jr));
        void'($value$plusargs("julia_im=%h", run_ji));
        void'($value$plusargs("zoom=%d",     run_zoom));
        void'($value$plusargs("max_i=%d",    run_maxi));
        void'($value$plusargs("ftype=%d",    run_ft));
        void'($value$plusargs("tag=%s",      run_tag));

        $display("\ntb_full_dram — rendering 16 sixteenths from DRAM  [tag=%s]", run_tag);
        $display("CENTRE_X=0x%09X  CENTRE_Y=0x%09X  ZOOM=%0d  MAX_I=%0d  FTYPE=%0d",
                 run_cx, run_cy, run_zoom, run_maxi, run_ft);

        rst = 1; tick(4); rst = 0; tick(2);

        force dut.cfg_fractal_type    = run_ft[4:0];
        force dut.cfg_centre_x        = run_cx;
        force dut.cfg_centre_y        = run_cy;
        force dut.cfg_zoom_level      = run_zoom[15:0];
        force dut.cfg_max_iter        = run_maxi[11:0];
        force dut.cfg_image_base_addr = 32'b0;
        force dut.cfg_julia_real      = run_jr;
        force dut.cfg_julia_imag      = run_ji;
        force dut.ps_start            = 1'b1;
        tick(1);
        release dut.ps_start;

        begin : wait_irq
            longint t;
            t = 0;
            while (!irq_all_done && t < 500_000_000) begin
                tick(1); t++;
            end
            if (irq_all_done)
                $display("  irq_all_done at cycle %0d  beats=%0d", cyc, beat_cnt);
            else
                $display("  [TIMEOUT] irq_all_done not seen after %0d cycles  beats=%0d", cyc, beat_cnt);
        end

        release dut.cfg_fractal_type; release dut.cfg_centre_x; release dut.cfg_centre_y;
        release dut.cfg_zoom_level; release dut.cfg_max_iter; release dut.cfg_image_base_addr;
        release dut.cfg_julia_real; release dut.cfg_julia_imag;
        tick(20);   // let the last burst drain through the arbiter

        $display("\n  Writing DRAM CSVs...");
        dump_dram_full_image_csv({"sim/render/", run_tag, "_dram_full_image.csv"});
        dump_dram_raw_csv       ({"sim/render/", run_tag, "_dram_raw.csv"});
        $display("\n  Total cycles: %0d  AXI beats: %0d", cyc, beat_cnt);
        $finish;
    end

endmodule
