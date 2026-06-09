`timescale 1ns/1ps

// Single-run per_sixteenth_engine testbench.
// Uses top-full config (pan=-2.0/+2.0, zoom=0, max_iter=3).
// Runs exactly once — no resets, no reruns.
// Waits for sixteenth_complete then dumps bram/dram/image CSVs.

module tb_pse_single;

    localparam CLK_HALF = 5;
    logic clk = 0;
    always #CLK_HALF clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // ── DUT signals ──────────────────────────────────────────────────────────
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

    // Match top-full config exactly
    localparam logic [31:0] PAN_X = 32'hFFFF_0000;  // -1.0 Q1.16
    localparam logic [31:0] PAN_Y = 32'h0001_0000;  // +1.0 Q1.16
    localparam logic [31:0] ZOOM  = 32'd1;
    localparam logic [11:0] MAX_I = 12'd3;
    localparam logic [31:0] BASE  = 32'h0000_0000;

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

    // ── Capture arrays ───────────────────────────────────────────────────────
    localparam int MAX_BRAM = 65536;
    localparam int MAX_DRAM = 8192;

    logic [7:0]  bram_x   [0:MAX_BRAM-1];
    logic [7:0]  bram_y   [0:MAX_BRAM-1];
    logic [7:0]  bram_col [0:MAX_BRAM-1];
    int          bram_cnt = 0;

    logic [31:0] dram_addr [0:MAX_DRAM-1];
    logic [63:0] dram_data [0:MAX_DRAM-1];
    int          dram_cnt  = 0;

    always @(posedge clk) begin
        if (dut.u_control_unit.u_bram_rw.bram_wr_en && bram_cnt < MAX_BRAM) begin
            bram_x  [bram_cnt] = dut.u_control_unit.u_bram_rw.res_a;
            bram_y  [bram_cnt] = dut.u_control_unit.u_bram_rw.res_b;
            bram_col[bram_cnt] = dut.u_control_unit.u_bram_rw.res_colour;
            bram_cnt++;
        end
        if (axi_wr_en && axi_wr_ready && dram_cnt < MAX_DRAM) begin
            dram_addr[dram_cnt] = axi_wr_addr;
            dram_data[dram_cnt] = axi_wr_data;
            dram_cnt++;
        end
    end

    // ── Heartbeat ─────────────────────────────────────────────────────────────
    longint cyc = 0;
    always @(posedge clk) cyc++;
    always @(posedge clk)
        if ((cyc % 100_000) == 0)
            $display("  [hb] cyc=%0d  eng_done=%0b  sxt_complete=%0b  transferred=%0d  bram=%0d  dram=%0d  sched=%0d",
                     cyc, engine_done, sixteenth_complete,
                     $countones(dut.u_bram_to_dram.transferred),
                     bram_cnt, dram_cnt, dut.u_scheduler.state);

    // ── Log when cu_tile_done_set fires for any tile ───────────────────────────
    logic [255:0] tile_done_prev;
    always @(posedge clk) begin
        tile_done_prev <= dut.tile_done;
        for (int _i = 0; _i < 256; _i++) begin
            if (dut.tile_done[_i] && !tile_done_prev[_i])
                $display("  [tile_done] cyc=%0d  tile=%0d  pixel_cnt=%0d  tt_filled=%0b  bram_writes_so_far=%0d",
                         cyc, _i,
                         dut.u_control_unit.tile_pixel_cnt[_i],
                         dut.u_tile_table.tile_table[_i][6],
                         bram_cnt);
        end
    end

    // ── CSV tasks ─────────────────────────────────────────────────────────────
    task automatic dump_bram_csv(input string path);
        integer fd;
        fd = $fopen(path, "w");
        $fwrite(fd, "write_index,x,y,colour\n");
        for (int i = 0; i < bram_cnt; i++)
            $fwrite(fd, "%0d,%0d,%0d,%0d\n", i, bram_x[i], bram_y[i], bram_col[i] & 8'h3F);
        $fclose(fd);
        $display("  wrote %s  (%0d rows)", path, bram_cnt);
    endtask

    task automatic dump_dram_csv(input string path);
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
        $fwrite(fd, "row,col,colour\n");
        for (int r = 0; r < 256; r++)
            for (int c = 0; c < 256; c++)
                $fwrite(fd, "%0d,%0d,%0d\n", r, c, image[r][c] & 8'h3F);
        $fclose(fd);
        $display("  wrote %s  (256x256)", path);
    endtask

    // ── Direct colour_bram dump (reads mem array after sixteenth_complete) ───────
    task automatic dump_bram_direct_csv(input string path);
        integer fd;
        logic [63:0] word;
        int px, py;
        fd = $fopen(path, "w");
        $fwrite(fd, "row,col,colour\n");
        // colour_bram is tile-ordered: word addr = {tile_y[3:0], tile_x[3:0], word_in_tile[4:0]}
        // tile_idx = {tile_row[3:0], tile_col[3:0]}, 256 tiles, 32 words each
        for (int tile = 0; tile < 256; tile++) begin
            for (int w = 0; w < 32; w++) begin
                word = dut.u_colour_bram.mem[tile * 32 + w];
                // 8 pixels per word, 2 words per tile row → row_in_tile = w>>1, col_offset = (w&1)*8
                for (int b = 0; b < 8; b++) begin
                    px = (tile[3:0]) * 16 + (w[0] ? 8 : 0) + b;
                    py = (tile[7:4]) * 16 + (w >> 1);
                    $fwrite(fd, "%0d,%0d,%0d\n", py, px, word[b*8 +: 8] & 8'h3F);
                end
            end
        end
        $fclose(fd);
        $display("  wrote %s  (256x256 direct)", path);
    endtask

    // ── Main ─────────────────────────────────────────────────────────────────
    int _t;
    initial begin
        $dumpfile("sim/waves/tb_pse_single.vcd");
        $dumpvars(0, tb_pse_single);

        fractal_type        = 5'b0_0000;
        pan_x               = PAN_X;
        pan_y               = PAN_Y;
        zoom_level          = ZOOM;
        max_iter            = MAX_I;
        x_offset            = 10'd0;
        y_offset            = 10'd0;
        sixteenth_id        = 4'd0;
        sixteenth_base_addr = BASE;
        axi_wr_ready        = 1'b1;
        start               = 1'b0;

        // Reset
        rst = 1; tick(4); rst = 0; tick(2);

        // One-shot start
        start = 1; tick(1); start = 0;

        // Wait for sixteenth_complete
        _t = 0;
        while (!sixteenth_complete && _t < 20_000_000) begin tick(1); _t++; end

        if (sixteenth_complete)
            $display("\n  sixteenth_complete at cyc=%0d  bram=%0d  dram=%0d", cyc, bram_cnt, dram_cnt);
        else
            $display("\n  [TIMEOUT] sixteenth_complete not seen after %0d cycles", _t);

        $display("\n  Writing CSVs...");
        dump_bram_csv("sim/render/single_bram.csv");
        dump_bram_direct_csv("sim/render/single_bram_direct.csv");
        dump_dram_csv("sim/render/single_dram.csv");
        dump_image_csv("sim/render/single_image.csv", BASE);

        $finish;
    end

endmodule
