`timescale 1ns/1ps
//
// Shared full-image render testbench for BOTH designs:
//   make full DESIGN=dual_core       (2 engines, compiled with -D DUAL)
//   make full DESIGN=dual_precision   (1 engine)
//
// Reconstructs the 1024x1024 image from the colour-BRAM write stream via
// hierarchical references — no DRAM/AXI in the loop (axi_wr_ready is stubbed high
// inside top_level). Engine B probes/monitors are compiled only when DUAL is set.
//
// Hierarchy assumptions (identical across both trees):
//   dut.u_engine_a.u_control_unit.u_bram_rw.{bram_wr_en, wr_waddr_q, wr_boff_q, wr_data_q}
//   dual: also u_engine_b.*, controller signals dut.ctrl_sixteenth_id_a/_b
//   single: controller signal dut.ctrl_sixteenth_id (no _a/_b)

module tb_full;

    localparam int TILE_W    = 8;
    localparam int TILE_BITS = $clog2(TILE_W);
    localparam int HI        = 8 - TILE_BITS;  // tile-index bits per axis (256/TILE_W)

    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // ── DUT ──────────────────────────────────────────────────────────────────
    logic        rst;
    wire         irq_all_done;
    wire         irq_started;

    // HP write port — the TB reconstructs the image from the colour-BRAM write
    // stream (hierarchical), so it just holds ready high and ignores the bus.
    wire  [31:0] hp_axi_wr_addr;
    wire  [63:0] hp_axi_wr_data;
    wire         hp_axi_wr_en;
    logic        hp_axi_wr_ready = 1'b1;

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

    // ── BRAM write probes — engine A (always present) ─────────────────────────
    wire        bram_wr_en_a  = dut.u_engine_a.u_control_unit.u_bram_rw.bram_wr_en;
    wire [12:0] bram_waddr_a  = dut.u_engine_a.u_control_unit.u_bram_rw.wr_waddr_q;
    wire [2:0]  bram_boff_a   = dut.u_engine_a.u_control_unit.u_bram_rw.wr_boff_q;
    wire [7:0]  bram_col_a    = dut.u_engine_a.u_control_unit.u_bram_rw.wr_data_q;

    wire [15:0] ta_a        = {bram_waddr_a, bram_boff_a};
    wire [7:0]  decoded_x_a = { ta_a[(2*TILE_BITS) +: HI],    ta_a[0 +: TILE_BITS]         };
    wire [7:0]  decoded_y_a = { ta_a[(2*TILE_BITS+HI) +: HI], ta_a[TILE_BITS +: TILE_BITS] };

`ifdef DUAL
    wire        bram_wr_en_b  = dut.u_engine_b.u_control_unit.u_bram_rw.bram_wr_en;
    wire [12:0] bram_waddr_b  = dut.u_engine_b.u_control_unit.u_bram_rw.wr_waddr_q;
    wire [2:0]  bram_boff_b   = dut.u_engine_b.u_control_unit.u_bram_rw.wr_boff_q;
    wire [7:0]  bram_col_b    = dut.u_engine_b.u_control_unit.u_bram_rw.wr_data_q;

    wire [15:0] ta_b        = {bram_waddr_b, bram_boff_b};
    wire [7:0]  decoded_x_b = { ta_b[(2*TILE_BITS) +: HI],    ta_b[0 +: TILE_BITS]         };
    wire [7:0]  decoded_y_b = { ta_b[(2*TILE_BITS+HI) +: HI], ta_b[TILE_BITS +: TILE_BITS] };
`endif

    // sixteenth-id for tagging captures: dual has per-engine *_a/_b, single has one.
`ifdef DUAL
    wire [3:0] sxt_id_a = dut.ctrl_sixteenth_id_a;
    wire [3:0] sxt_id_b = dut.ctrl_sixteenth_id_b;
`else
    wire [3:0] sxt_id_a = dut.ctrl_sixteenth_id;
`endif

    // Capture arrays (16 sixteenths × 256×256 = 1 M pixels total)
    localparam int MAX_BRAM = 1_048_576;
    logic [7:0] bram_x   [0:MAX_BRAM-1];
    logic [7:0] bram_y   [0:MAX_BRAM-1];
    logic [7:0] bram_col [0:MAX_BRAM-1];
    logic [3:0] bram_sxt [0:MAX_BRAM-1];
    int         bram_cnt = 0;

    always @(posedge clk) begin
        if (bram_wr_en_a && bram_cnt < MAX_BRAM) begin
            bram_x  [bram_cnt] = decoded_x_a;
            bram_y  [bram_cnt] = decoded_y_a;
            bram_col[bram_cnt] = bram_col_a;
            bram_sxt[bram_cnt] = sxt_id_a;
            bram_cnt++;
        end
`ifdef DUAL
        if (bram_wr_en_b && bram_cnt < MAX_BRAM) begin
            bram_x  [bram_cnt] = decoded_x_b;
            bram_y  [bram_cnt] = decoded_y_b;
            bram_col[bram_cnt] = bram_col_b;
            bram_sxt[bram_cnt] = sxt_id_b;
            bram_cnt++;
        end
`endif
    end

    // ── Heartbeat + per-sixteenth completion ──────────────────────────────────
    longint cyc = 0;
    always @(posedge clk) cyc++;

    always @(posedge clk)
        if ((cyc % 100_000) == 0)
            $display("  [hb] cyc=%0d  sxt_a=%0d  bram=%0d", cyc, sxt_id_a, bram_cnt);

`ifdef DUAL
    logic da_p, db_p;
    always @(posedge clk) begin
        da_p <= dut.ctrl_sixteenth_complete_a;
        db_p <= dut.ctrl_sixteenth_complete_b;
        if (dut.ctrl_sixteenth_complete_a && !da_p)
            $display("  [done_a] cyc=%0d sxt=%0d bram=%0d", cyc, sxt_id_a, bram_cnt);
        if (dut.ctrl_sixteenth_complete_b && !db_p)
            $display("  [done_b] cyc=%0d sxt=%0d bram=%0d", cyc, sxt_id_b, bram_cnt);
    end
`else
    logic da_p;
    always @(posedge clk) begin
        da_p <= dut.ctrl_sixteenth_complete;
        if (dut.ctrl_sixteenth_complete && !da_p)
            $display("  [done] cyc=%0d sxt=%0d bram=%0d", cyc, sxt_id_a, bram_cnt);
    end
`endif

    // ── CSV dump tasks ────────────────────────────────────────────────────────
    task automatic dump_full_image_csv(input string path);
        logic [7:0] image [0:1023][0:1023];
        integer fd;
        int sxt_col, sxt_row, px, py;
        for (int r = 0; r < 1024; r++)
            for (int c = 0; c < 1024; c++) image[r][c] = 8'hFF;
        for (int i = 0; i < bram_cnt; i++) begin
            sxt_col = int'(bram_sxt[i]) & 3;
            sxt_row = int'(bram_sxt[i]) >> 2;
            px = sxt_col * 256 + int'(bram_x[i]);
            py = sxt_row * 256 + int'(bram_y[i]);
            if (px < 1024 && py < 1024) image[py][px] = bram_col[i];
        end
        fd = $fopen(path, "w");
        $fwrite(fd, "row,col,colour\n");
        // Unwritten pixels keep the 8'hFF init; emit them as -1 so the visualiser
        // renders them as background (grey) instead of collapsing 0xFF & 0x3F = 63
        // into the real red colour 63.
        for (int r = 0; r < 1024; r++)
            for (int c = 0; c < 1024; c++)
                if (image[r][c] === 8'hFF)
                    $fwrite(fd, "%0d,%0d,-1\n", r, c);
                else
                    $fwrite(fd, "%0d,%0d,%0d\n", r, c, image[r][c] & 8'h3F);
        $fclose(fd);
        $display("  wrote %s  (1024x1024)", path);
    endtask

    task automatic dump_sixteenth_bram_csv(input string path, input int s);
        integer fd, cnt;
        fd  = $fopen(path, "w");
        cnt = 0;
        $fwrite(fd, "x,y,colour\n");
        for (int i = 0; i < bram_cnt; i++) begin
            if (bram_sxt[i] == 4'(s)) begin
                $fwrite(fd, "%0d,%0d,%0d\n", bram_x[i], bram_y[i], bram_col[i] & 8'h3F);
                cnt++;
            end
        end
        $fclose(fd);
        $display("  wrote %s  (%0d pixels)", path, cnt);
    endtask

    // ── plusarg config ────────────────────────────────────────────────────────
    logic [34:0] run_cx, run_cy, run_jr, run_ji;
    logic [31:0] run_zoom, run_maxi, run_ft;
    string       run_tag;
    initial begin
        run_cx="h4_C000_0000"; run_cy="h1_C000_0000"; run_jr=0; run_ji=0;
        run_cx = 35'h4_C000_0000; run_cy = 35'h1_C000_0000;
        run_zoom = 16'd20; run_maxi = 12'd0; run_ft = 0; run_tag = "full";
        void'($value$plusargs("centre_x=%h", run_cx));
        void'($value$plusargs("centre_y=%h", run_cy));
        void'($value$plusargs("julia_re=%h", run_jr));
        void'($value$plusargs("julia_im=%h", run_ji));
        void'($value$plusargs("zoom=%d",     run_zoom));
        void'($value$plusargs("max_i=%d",    run_maxi));
        void'($value$plusargs("ftype=%d",    run_ft));
        void'($value$plusargs("tag=%s",      run_tag));

        $display("\ntb_full — rendering 16 sixteenths  [tag=%s]", run_tag);
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
                $display("  irq_all_done at cycle %0d  bram_cnt=%0d", cyc, bram_cnt);
            else
                $display("  [TIMEOUT] irq_all_done not seen after %0d cycles  bram=%0d", cyc, bram_cnt);
        end

        release dut.cfg_fractal_type; release dut.cfg_centre_x; release dut.cfg_centre_y;
        release dut.cfg_zoom_level; release dut.cfg_max_iter; release dut.cfg_image_base_addr;
        release dut.cfg_julia_real; release dut.cfg_julia_imag;
        tick(10);

        $display("\n  Writing CSVs...");
        dump_full_image_csv({"sim/render/", run_tag, "_full_image.csv"});
        for (int s = 0; s < 16; s++) begin
            string bram_path;
            $sformat(bram_path, "sim/render/%s_sixteenth_%0d_bram.csv", run_tag, s);
            dump_sixteenth_bram_csv(bram_path, s);
        end
        $display("\n  Total cycles: %0d  BRAM writes: %0d", cyc, bram_cnt);
        $finish;
    end

endmodule
