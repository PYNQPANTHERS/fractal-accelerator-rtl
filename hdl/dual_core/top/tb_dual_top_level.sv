`timescale 1ns/1ps

// Dual-engine full render testbench.
// Reconstructs the 1024×1024 image from BRAM writes captured via hierarchical
// references — no DRAM/AXI needed at this stage.
// Run with:  make dual-full

module tb_dual_top_level;

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

    logic        ps_start         = 1'b0;
    logic [4:0]  cfg_fractal_type = 5'b0;
    logic [34:0] cfg_julia_real   = 35'b0;
    logic [34:0] cfg_julia_imag   = 35'b0;
    logic [34:0] cfg_centre_x        = 35'h4_C000_0000;
    logic [34:0] cfg_centre_y        = 35'h1_C000_0000;
    logic [15:0] cfg_zoom_level   = 16'd20;
    logic [11:0] cfg_max_iter     = 12'd0;
    logic [31:0] cfg_image_base_addr = 32'b0;

    localparam logic [34:0] CFG_PAN_X = 35'h4_C000_0000;
    localparam logic [34:0] CFG_PAN_Y = 35'h1_C000_0000;
    localparam logic [15:0] CFG_ZOOM  = 16'd20;
    localparam logic [34:0] CFG_JULIA = 35'b0;
    localparam logic [11:0] CFG_MAX_I = 12'd0;

    dual_top_level #(.TILE_W(TILE_W)) dut (
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
        .irq_all_done       (irq_all_done),
        .irq_started        (irq_started)
    );

    // ── BRAM write probes ─────────────────────────────────────────────────────
    // Hierarchical references into each engine's bram_read_write instance.
    wire        bram_wr_en_a  = dut.u_engine_a.u_control_unit.u_bram_rw.bram_wr_en;
    wire [12:0] bram_waddr_a  = dut.u_engine_a.u_control_unit.u_bram_rw.wr_waddr_q;
    wire [2:0]  bram_boff_a   = dut.u_engine_a.u_control_unit.u_bram_rw.wr_boff_q;
    wire [7:0]  bram_col_a    = dut.u_engine_a.u_control_unit.u_bram_rw.wr_data_q;

    wire        bram_wr_en_b  = dut.u_engine_b.u_control_unit.u_bram_rw.bram_wr_en;
    wire [12:0] bram_waddr_b  = dut.u_engine_b.u_control_unit.u_bram_rw.wr_waddr_q;
    wire [2:0]  bram_boff_b   = dut.u_engine_b.u_control_unit.u_bram_rw.wr_boff_q;
    wire [7:0]  bram_col_b    = dut.u_engine_b.u_control_unit.u_bram_rw.wr_data_q;

    // Decode tile addresses to (x,y) in continuous logic to avoid local-var issues.
    wire [15:0] ta_a        = {bram_waddr_a, bram_boff_a};
    wire [7:0]  decoded_x_a = { ta_a[(2*TILE_BITS) +: HI],    ta_a[0 +: TILE_BITS]         };
    wire [7:0]  decoded_y_a = { ta_a[(2*TILE_BITS+HI) +: HI], ta_a[TILE_BITS +: TILE_BITS] };

    wire [15:0] ta_b        = {bram_waddr_b, bram_boff_b};
    wire [7:0]  decoded_x_b = { ta_b[(2*TILE_BITS) +: HI],    ta_b[0 +: TILE_BITS]         };
    wire [7:0]  decoded_y_b = { ta_b[(2*TILE_BITS+HI) +: HI], ta_b[TILE_BITS +: TILE_BITS] };

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
            bram_sxt[bram_cnt] = dut.ctrl_sixteenth_id_a;
            bram_cnt++;
        end
        if (bram_wr_en_b && bram_cnt < MAX_BRAM) begin
            bram_x  [bram_cnt] = decoded_x_b;
            bram_y  [bram_cnt] = decoded_y_b;
            bram_col[bram_cnt] = bram_col_b;
            bram_sxt[bram_cnt] = dut.ctrl_sixteenth_id_b;
            bram_cnt++;
        end
    end

    // ── Heartbeat and pair-complete monitors ──────────────────────────────────
    longint cyc = 0;
    always @(posedge clk) cyc++;

    always @(posedge clk)
        if ((cyc % 100_000) == 0)
            $display("  [hb] cyc=%0d  next_sxt=%0d  sxt_a=%0d(st=%0d)  sxt_b=%0d(st=%0d)  bram=%0d",
                     cyc,
                     dut.u_dual_controller.next_sxt,
                     dut.ctrl_sixteenth_id_a, dut.u_dual_controller.state_a,
                     dut.ctrl_sixteenth_id_b, dut.u_dual_controller.state_b,
                     bram_cnt);

    logic sxt_done_a_prev, sxt_done_b_prev;
    always @(posedge clk) begin
        sxt_done_a_prev <= dut.ctrl_sixteenth_complete_a;
        sxt_done_b_prev <= dut.ctrl_sixteenth_complete_b;
        if (dut.ctrl_sixteenth_complete_a && !sxt_done_a_prev)
            $display("  [done_a] cyc=%0d  sxt=%0d  bram=%0d",
                     cyc, dut.ctrl_sixteenth_id_a, bram_cnt);
        if (dut.ctrl_sixteenth_complete_b && !sxt_done_b_prev)
            $display("  [done_b] cyc=%0d  sxt=%0d  bram=%0d",
                     cyc, dut.ctrl_sixteenth_id_b, bram_cnt);
    end

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
            if (px < 1024 && py < 1024)
                image[py][px] = bram_col[i];
        end

        fd = $fopen(path, "w");
        $fwrite(fd, "row,col,colour\n");
        for (int r = 0; r < 1024; r++)
            for (int c = 0; c < 1024; c++)
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

    // ── Main ──────────────────────────────────────────────────────────────────
    initial begin
        $display("\ntb_dual_top_level — rendering 16 sixteenths (even/odd parallel)");
        $display("CENTRE_X=0x%09X  CENTRE_Y=0x%09X  ZOOM=%0d  MAX_I=%0d",
                 CFG_PAN_X, CFG_PAN_Y, CFG_ZOOM, CFG_MAX_I);

        rst = 1; tick(4); rst = 0; tick(2);

        force dut.cfg_fractal_type    = 5'b0_0000;
        force dut.cfg_centre_x           = CFG_PAN_X;
        force dut.cfg_centre_y           = CFG_PAN_Y;
        force dut.cfg_zoom_level      = CFG_ZOOM;
        force dut.cfg_max_iter        = CFG_MAX_I;
        force dut.cfg_image_base_addr = 32'b0;
        force dut.cfg_julia_real      = CFG_JULIA;
        force dut.cfg_julia_imag      = CFG_JULIA;
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
                $display("  [TIMEOUT] irq_all_done not seen after %0d cycles  bram=%0d",
                         cyc, bram_cnt);
        end

        release dut.cfg_fractal_type;
        release dut.cfg_centre_x;
        release dut.cfg_centre_y;
        release dut.cfg_zoom_level;
        release dut.cfg_max_iter;
        release dut.cfg_image_base_addr;
        release dut.cfg_julia_real;
        release dut.cfg_julia_imag;

        tick(10);

        $display("\n  Writing CSVs...");
        dump_full_image_csv("sim/render/dual_full_image.csv");

        for (int s = 0; s < 16; s++) begin
            string bram_path;
            $sformat(bram_path, "sim/render/dual_sixteenth_%0d_bram.csv", s);
            dump_sixteenth_bram_csv(bram_path, s);
        end

        $display("\n  Total cycles: %0d  BRAM writes: %0d", cyc, bram_cnt);
        $finish;
    end

    initial begin
        #(CLK_HALF * 2 * 500_000_000);
        $display("\n[WATCHDOG] timeout at cycle %0d  bram=%0d  next_sxt=%0d",
                 cyc, bram_cnt, dut.u_dual_controller.next_sxt);
        $finish;
    end

endmodule
