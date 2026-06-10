`timescale 1ns/1ps

// Run all 16 sixteenths; dump DRAM and image CSVs to sim/render/
module tb_top_level;

    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    logic        rst;
    wire  [31:0] hp_axi_wr_addr;
    wire  [63:0] hp_axi_wr_data;
    wire         hp_axi_wr_en;
    logic        hp_axi_wr_ready;
    wire         irq_all_done;
    wire         irq_started;

    top_level dut (
        .clk            (clk),
        .rst            (rst),
        .hp_axi_wr_addr (hp_axi_wr_addr),
        .hp_axi_wr_data (hp_axi_wr_data),
        .hp_axi_wr_en   (hp_axi_wr_en),
        .hp_axi_wr_ready(hp_axi_wr_ready),
        .irq_all_done   (irq_all_done),
        .irq_started    (irq_started)
    );

    localparam logic [31:0] CFG_PAN_X  = 32'hFFFF_0000;  // -1.0 Q1.16 (top-left real)
    localparam logic [31:0] CFG_PAN_Y  = 32'h0001_0000;  // +1.0 Q1.16 (top-left imag)
    localparam logic [31:0] CFG_ZOOM   = 32'd1;
    localparam logic [11:0] CFG_MAX_I  = 12'd0;
    localparam logic [31:0] CFG_BASE   = 32'h0000_0000;
    localparam logic [31:0] SXT_STRIDE = 32'd65536;

    localparam int MAX_DRAM = 131072;  // 16 × 8192
    logic [31:0] dram_addr [0:MAX_DRAM-1];
    logic [63:0] dram_data [0:MAX_DRAM-1];
    int          dram_cnt = 0;

    always @(posedge clk)
        if (hp_axi_wr_en && hp_axi_wr_ready && dram_cnt < MAX_DRAM) begin
            dram_addr[dram_cnt] = hp_axi_wr_addr;
            dram_data[dram_cnt] = hp_axi_wr_data;
            dram_cnt++;
        end

    localparam int MAX_BRAM = 1048576;
    logic [7:0]  bram_x   [0:MAX_BRAM-1];
    logic [7:0]  bram_y   [0:MAX_BRAM-1];
    logic [7:0]  bram_col [0:MAX_BRAM-1];
    logic [3:0]  bram_sxt [0:MAX_BRAM-1];
    int          bram_cnt = 0;

    wire        bram_wr_en_w  = dut.u_engine.u_control_unit.u_bram_rw.bram_wr_en;
    wire [12:0] bram_waddr_w  = dut.u_engine.u_control_unit.u_bram_rw.wr_waddr_q;
    wire [2:0]  bram_boff_w   = dut.u_engine.u_control_unit.u_bram_rw.wr_boff_q;
    wire [7:0]  bram_col_w    = dut.u_engine.u_control_unit.u_bram_rw.wr_data_q;

    always @(posedge clk) begin
        if (bram_wr_en_w && bram_cnt < MAX_BRAM) begin
            logic [15:0] ta;
            ta = {bram_waddr_w, bram_boff_w};  // ta = {y[7:4], x[7:4], y[3:0], x[3:0]}
            bram_x  [bram_cnt] = {ta[11:8], ta[3:0]};
            bram_y  [bram_cnt] = {ta[15:12], ta[7:4]};
            bram_col[bram_cnt] = bram_col_w;
            bram_sxt[bram_cnt] = 4'(dut.u_sixteenth_controller.sixteenth_index);
            bram_cnt++;
        end
    end


    logic sxt_complete_prev;
    always @(posedge clk) begin
        sxt_complete_prev <= dut.u_engine.u_bram_to_dram.sixteenth_complete;
        if (dut.u_engine.u_bram_to_dram.sixteenth_complete && !sxt_complete_prev)
            $display("  [sxt_done] cyc=%0d  sxt=%0d  bram=%0d  dram=%0d  transferred=%0d  cbram_tile_done=%0d  sched_tile_done=%0d  tile_done=%0d",
                     cyc,
                     dut.u_sixteenth_controller.sixteenth_index,
                     bram_cnt, dram_cnt,
                     $countones(dut.u_engine.u_bram_to_dram.transferred),
                     $countones(dut.u_engine.cbram_tile_done),
                     $countones(dut.u_engine.sched_tile_done),
                     $countones(dut.u_engine.tile_done));
    end

    longint cyc = 0;
    always @(posedge clk) cyc++;
    always @(posedge clk)
        if ((cyc % 100_000) == 0)
            $display("  [heartbeat] cyc=%0d  sxt=%0d  transferred=%0d  sched=%0d  seen=%0d  expected=%0d  inject=%0b  rfifo_empty=%0b  brw_state=%0d  cluster_done=%04b",
                     cyc, dut.u_sixteenth_controller.sixteenth_index,
                     $countones(dut.u_engine.u_bram_to_dram.transferred),
                     dut.u_engine.u_scheduler.state,
                     dut.u_engine.u_comparator.seen_count,
                     dut.u_engine.u_comparator.expected_count,
                     dut.u_engine.u_control_unit.inject_pending,
                     dut.u_engine.u_control_unit.res_fifo_empty,
                     dut.u_engine.u_control_unit.u_bram_rw.current_state,
                     dut.u_engine.u_control_unit.cluster_done);

    task automatic dump_full_dram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
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
    endtask

    task automatic dump_full_image_csv(input string path);
        logic [7:0] image [0:1023][0:1023];
        integer fd;
        logic [31:0] off_from_base, sxt_base, within_sxt;
        int sxt_id, tile_idx, word_in_tile, tile_col, tile_row;
        int row_in_tile, col_start, px, py, sxt_col, sxt_row;

        for (int r = 0; r < 1024; r++)
            for (int c = 0; c < 1024; c++) image[r][c] = 8'hFF;

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

    task automatic dump_sixteenth_image_csv(input string path, input int s);
        // Reconstruct 256×256 for sixteenth s from DRAM
        logic [7:0] image [0:255][0:255];
        integer fd;
        logic [31:0] sxt_base, within_sxt;
        int tile_idx, word_in_tile, tile_col, tile_row;
        int row_in_tile, col_start, px, py;

        for (int r = 0; r < 256; r++)
            for (int c = 0; c < 256; c++) image[r][c] = 8'hFF;

        sxt_base = CFG_BASE + 32'(s) * SXT_STRIDE;
        for (int i = 0; i < dram_cnt; i++) begin
            if (dram_addr[i] >= sxt_base && dram_addr[i] < sxt_base + SXT_STRIDE) begin
                within_sxt   = dram_addr[i] - sxt_base;
                tile_idx     = within_sxt[15:8];
                word_in_tile = within_sxt[7:3];
                tile_col     = tile_idx[3:0];
                tile_row     = tile_idx[7:4];
                row_in_tile  = word_in_tile >> 1;
                col_start    = (word_in_tile & 1) << 3;
                for (int b = 0; b < 8; b++) begin
                    px = tile_col * 16 + col_start + b;
                    py = tile_row * 16 + row_in_tile;
                    if (px < 256 && py < 256)
                        image[py][px] = dram_data[i][b*8 +: 8];
                end
            end
        end

        fd = $fopen(path, "w");
        $fwrite(fd, "row,col,colour\n");
        for (int r = 0; r < 256; r++)
            for (int c = 0; c < 256; c++)
                $fwrite(fd, "%0d,%0d,%0d\n", r, c, image[r][c] & 8'h3F);
        $fclose(fd);
        $display("  wrote %s  (256x256)", path);
    endtask

    initial begin
        $dumpfile("sim/waves/tb_top_level.vcd");
        $dumpvars(0, tb_top_level);

        hp_axi_wr_ready = 1'b1;

        $display("\ntb_top_level — rendering 16 sixteenths");
        $display("PAN_X=0x%08X  PAN_Y=0x%08X  ZOOM=%0d  MAX_I=%0d",
                 CFG_PAN_X, CFG_PAN_Y, CFG_ZOOM, CFG_MAX_I);

        rst = 1; tick(4); rst = 0; tick(2);

        force dut.cfg_fractal_type    = 5'b0_0000;
        force dut.cfg_pan_x           = CFG_PAN_X;
        force dut.cfg_pan_y           = CFG_PAN_Y;
        force dut.cfg_zoom_level      = CFG_ZOOM;
        force dut.cfg_max_iter        = CFG_MAX_I;
        force dut.cfg_image_base_addr = CFG_BASE;
        force dut.ps_start            = 1'b1;
        tick(1);
        release dut.ps_start;

        begin : wait_irq
            longint t;
            t = 0;
            while (!irq_all_done && t < 250_000_000) begin
                tick(1); t++;
            end
            if (irq_all_done)
                $display("  irq_all_done at cycle %0d  dram_cnt=%0d  bram_cnt=%0d",
                         cyc, dram_cnt, bram_cnt);
            else
                $display("  [TIMEOUT] irq_all_done not seen after %0d cycles  dram_cnt=%0d",
                         cyc, dram_cnt);
        end

        release dut.cfg_fractal_type;
        release dut.cfg_pan_x;
        release dut.cfg_pan_y;
        release dut.cfg_zoom_level;
        release dut.cfg_max_iter;
        release dut.cfg_image_base_addr;

        tick(10);

        $display("\n  Writing CSVs...");
        dump_full_dram_csv("sim/render/top_dram.csv");
        dump_full_image_csv("sim/render/top_full_image.csv");

        for (int s = 0; s < 16; s++) begin
            string bram_path, img_path;
            $sformat(bram_path, "sim/render/top_sixteenth_%0d_bram.csv", s);
            $sformat(img_path,  "sim/render/top_sixteenth_%0d_image.csv", s);
            dump_sixteenth_bram_csv(bram_path, s);
            dump_sixteenth_image_csv(img_path, s);
        end

        $display("\n  Total cycles: %0d  DRAM writes: %0d  BRAM writes: %0d",
                 cyc, dram_cnt, bram_cnt);
        $finish;
    end

    initial begin
        #(CLK_HALF * 2 * 260_000_000);
        $display("\n[WATCHDOG] timeout at cycle %0d  sxt=%0d  dram=%0d",
                 cyc, dut.u_sixteenth_controller.sixteenth_index, dram_cnt);
        $finish;
    end

endmodule
