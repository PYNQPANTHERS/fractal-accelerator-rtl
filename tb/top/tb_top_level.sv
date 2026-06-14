`timescale 1ns/1ps

// Run all 16 sixteenths; dump DRAM and image CSVs to sim/render/
module tb_top_level;

    localparam int TILE_W       = 8;            // tile width/height in pixels (must be power of 2)
    localparam int TILE_BITS    = $clog2(TILE_W);
    localparam int TILES_P_AXIS = 256 / TILE_W;
    localparam int WORDS_P_TILE = TILE_W * TILE_W / 8;
    localparam int WORDS_P_ROW  = TILE_W / 8;   // 64-bit words per pixel row of a tile
    localparam int LOG2_BPT     = 2 * TILE_BITS; // log2(BYTES_PER_TILE) = log2(TILE_W*TILE_W)
    localparam int LOG2_WPR     = $clog2(WORDS_P_ROW > 0 ? WORDS_P_ROW : 1);

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

    logic        ps_start         = 1'b0;
    logic [4:0]  cfg_fractal_type = 5'b0;
    logic [34:0] cfg_julia_real   = 35'b0;
    logic [34:0] cfg_julia_imag   = 35'b0;
    logic [34:0] cfg_pan_x        = 35'h4_C000_0000; // -1.625 i
    logic [34:0] cfg_pan_y        = 35'h1_C000_0000; // ~+2.0 in Q2.33
    logic [15:0] cfg_zoom_level   = 16'd20;
    logic [11:0] cfg_max_iter     = 12'b0;
    logic [31:0] cfg_image_base_addr = 32'b0;

    top_level #(.TILE_W(TILE_W)) dut (
        .clk                (clk),
        .rst                (rst),
        .hp_axi_wr_addr     (hp_axi_wr_addr),
        .hp_axi_wr_data     (hp_axi_wr_data),
        .hp_axi_wr_en       (hp_axi_wr_en),
        .hp_axi_wr_ready    (hp_axi_wr_ready),
        .irq_all_done       (irq_all_done),
        .irq_started        (irq_started),
        .ps_start           (ps_start),
        .cfg_fractal_type   (cfg_fractal_type),
        .cfg_julia_real     (cfg_julia_real),
        .cfg_julia_imag     (cfg_julia_imag),
        .cfg_pan_x          (cfg_pan_x),
        .cfg_pan_y          (cfg_pan_y),
        .cfg_zoom_level     (cfg_zoom_level),
        .cfg_max_iter       (cfg_max_iter),
        .cfg_image_base_addr(cfg_image_base_addr)
    );

    localparam logic [34:0] CFG_PAN_X  = 35'h4_C000_0000; // -1.625 in Q2.33 (top-left real); centers on (-0.75, 0) cardioid/period-2 junction
    localparam logic [34:0] CFG_PAN_Y  = 35'h1_C000_0000; // +0.875 in Q2.33 (top-left imag)
    localparam logic [15:0] CFG_ZOOM   = 16'd20;
    localparam logic [34:0] CFG_JULIA  = 35'b0;
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

    // ta = {y[7:TILE_BITS], x[7:TILE_BITS], y[TILE_BITS-1:0], x[TILE_BITS-1:0]}
    // x = {ta[ (8-TILE_BITS) + (16-2*TILE_BITS) -1 -: (8-TILE_BITS)], ta[TILE_BITS-1:0] }
    //   = upper-x field is ta bits [ (16-2*TILE_BITS) + (8-TILE_BITS) -1 : (16-2*TILE_BITS) ]
    localparam int HI = 8 - TILE_BITS;          // bits of tile col/row index per axis
    always @(posedge clk) begin
        if (bram_wr_en_w && bram_cnt < MAX_BRAM) begin
            logic [15:0] ta;
            ta = {bram_waddr_w, bram_boff_w};
            // x = {x_hi(HI bits), x_lo(TILE_BITS bits)}
            bram_x  [bram_cnt] = { ta[ (2*TILE_BITS) +: HI ], ta[ 0 +: TILE_BITS ] };
            // y = {y_hi(HI bits), y_lo(TILE_BITS bits)}
            bram_y  [bram_cnt] = { ta[ (2*TILE_BITS + HI) +: HI ], ta[ TILE_BITS +: TILE_BITS ] };
            bram_col[bram_cnt] = bram_col_w;
            bram_sxt[bram_cnt] = 4'(dut.u_sixteenth_controller.sixteenth_index);
            bram_cnt++;
        end
    end


    longint cyc = 0;
    always @(posedge clk) cyc++;

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

    always @(posedge clk) begin
        if ((cyc % 100_000) == 0)
            $display("  [heartbeat] cyc=%0d  sxt=%0d  transferred=%0d  sched=%0d  seen=%0d  expected=%0d  inject=%0b  rfifo_empty=%0b  brw_state=%0d  cluster_done=%04b",
                     cyc, dut.u_sixteenth_controller.sixteenth_index,
                     $countones(dut.u_engine.u_bram_to_dram.transferred),
                     dut.u_engine.u_scheduler.current_state,
                     dut.u_engine.u_comparator.seen_count,
                     dut.u_engine.u_comparator.expected_count,
                     dut.u_engine.u_control_unit.inject_pending,
                     dut.u_engine.u_control_unit.res_fifo_empty,
                     dut.u_engine.u_control_unit.u_bram_rw.current_state,
                     dut.u_engine.u_control_unit.cluster_done);
    end

    // ── Border-generator emit-count probe ─────────────────────────────────────
    // Count actual `valid` pulses from border_pixel_generator per box (reset each
    // time the scheduler re-arms the generator). When the scheduler stalls in WAIT
    // (no comparator progress for a long window), dump the failing box so we can
    // compare the generator's real emit count against expected_count.
    int  gen_emit_cnt = 0;
    int  gen_emit_latched = 0;   // emit count captured when generator returns to IDLE
    int  jq_push_cnt = 0;        // actual job_queue pushes for this box
    int  jq_grant_cnt = 0;       // grants issued (control_unit accepted a coord)
    int  cq_done_cnt = 0;        // results entering complete_queue (cu done pulses)
    longint last_seen_cyc = 0;
    int  last_seen_val = -1;
    logic stall_reported = 1'b0;

    // SC_WAIT = WAIT state ordinal in the scheduler enum (IDLE,STARTUP,INCREASE_LEVEL,
    // INCREASE_LEVEL_SECOND,BEGIN_SEARCH_BOX,WAIT,...) → 5
    localparam int SC_WAIT = 5;

    always @(posedge clk) begin
        // reset all per-box counters whenever the generator is re-armed for a new box
        if (dut.u_engine.u_scheduler.pixel_generator_reset) begin
            gen_emit_cnt <= 0;
            jq_push_cnt  <= 0;
            jq_grant_cnt <= 0;
            cq_done_cnt  <= 0;
        end else begin
            if (dut.u_engine.u_scheduler.border_pixel_valid)
                gen_emit_cnt <= gen_emit_cnt + 1;
            if (dut.u_engine.u_job_queue_handler.q_push)
                jq_push_cnt <= jq_push_cnt + 1;
            if (dut.u_engine.u_job_queue_handler.grant)
                jq_grant_cnt <= jq_grant_cnt + 1;
            if (dut.u_engine.cqh_done)
                cq_done_cnt <= cq_done_cnt + 1;
        end

        // latch the final emit count when the generator stops (valid falls, back to IDLE)
        if (dut.u_engine.u_scheduler.pixel_generator.current_state ==
                dut.u_engine.u_scheduler.pixel_generator.IDLE)
            gen_emit_latched <= gen_emit_cnt;

        // track comparator progress
        if (int'(dut.u_engine.u_comparator.seen_count) != last_seen_val) begin
            last_seen_val  <= int'(dut.u_engine.u_comparator.seen_count);
            last_seen_cyc  <= cyc;
            stall_reported <= 1'b0;
        end

        // stall: in WAIT, no seen progress for 200k cycles, not yet reported
        if (int'(dut.u_engine.u_scheduler.current_state) == SC_WAIT
                && (cyc - last_seen_cyc) > 200_000
                && !stall_reported) begin
            stall_reported <= 1'b1;
            $display("  [STALL] cyc=%0d  sxt=%0d  box_id=%0d  zoom=%0d  tlx=%0d tly=%0d",
                     cyc, dut.u_sixteenth_controller.sixteenth_index,
                     dut.u_engine.u_scheduler.box_id,
                     dut.u_engine.u_scheduler.zoom_level,
                     dut.u_engine.u_scheduler.tlx, dut.u_engine.u_scheduler.tly);
            $display("          all_left=%0b all_top=%0b  normal_width=%0d  pw_x=%0d pw_y=%0d",
                     dut.u_engine.u_scheduler.all_left_quadrants,
                     dut.u_engine.u_scheduler.all_top_quadrants,
                     dut.u_engine.u_scheduler.normal_width,
                     dut.u_engine.u_scheduler.pixel_width_x,
                     dut.u_engine.u_scheduler.pixel_width_y);
            $display("          expected_count=%0d  seen_count=%0d  gen_emit=%0d  gen_emit_latched=%0d",
                     dut.u_engine.u_scheduler.expected_count,
                     dut.u_engine.u_comparator.seen_count,
                     gen_emit_cnt, gen_emit_latched);
            $display("          PIPELINE: gen_emit=%0d  jq_push=%0d  jq_grant=%0d  cq_done=%0d  seen=%0d",
                     gen_emit_cnt, jq_push_cnt, jq_grant_cnt, cq_done_cnt,
                     dut.u_engine.u_comparator.seen_count);
            $display("          q_full=%0b q_empty=%0b wants_job=%0b grant=%0b  brw_state=%0d  inject=%0b rfifo_empty=%0b",
                     dut.u_engine.u_job_queue_handler.q_full,
                     dut.u_engine.u_job_queue_handler.q_empty,
                     dut.u_engine.u_job_queue_handler.wants_job,
                     dut.u_engine.u_job_queue_handler.grant,
                     dut.u_engine.u_control_unit.u_bram_rw.current_state,
                     dut.u_engine.u_control_unit.inject_pending,
                     dut.u_engine.u_control_unit.res_fifo_empty);
        end
    end

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

                tile_idx     = within_sxt >> LOG2_BPT;
                word_in_tile = within_sxt[LOG2_BPT-1:3];
                tile_col     = tile_idx % TILES_P_AXIS;
                tile_row     = tile_idx / TILES_P_AXIS;
                row_in_tile  = word_in_tile >> LOG2_WPR;
                col_start    = (word_in_tile % WORDS_P_ROW) * 8;

                sxt_col = sxt_id & 3;
                sxt_row = sxt_id >> 2;

                for (int b = 0; b < 8; b++) begin
                    px = sxt_col * 256 + tile_col * TILE_W + col_start + b;
                    py = sxt_row * 256 + tile_row * TILE_W + row_in_tile;
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
                tile_idx     = within_sxt >> LOG2_BPT;
                word_in_tile = within_sxt[LOG2_BPT-1:3];
                tile_col     = tile_idx % TILES_P_AXIS;
                tile_row     = tile_idx / TILES_P_AXIS;
                row_in_tile  = word_in_tile >> LOG2_WPR;
                col_start    = (word_in_tile % WORDS_P_ROW) * 8;
                for (int b = 0; b < 8; b++) begin
                    px = tile_col * TILE_W + col_start + b;
                    py = tile_row * TILE_W + row_in_tile;
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

    // Runtime config (overridable via +plusargs so one compiled binary serves
    // many runs). Defaults fall back to the CFG_* localparams.
    logic [34:0] run_pan_x, run_pan_y, run_julia_re, run_julia_im;
    logic [31:0] run_zoom, run_max_i, run_ftype;
    string       run_tag;

    initial begin
        //$dumpfile("sim/waves/tb_top_level.vcd");
        //$dumpvars(0, tb_top_level);

        hp_axi_wr_ready = 1'b1;

        // plusarg overrides (all hex except zoom/max_i/ftype which are decimal):
        //   +pan_x=H +pan_y=H +julia_re=H +julia_im=H +zoom=N +max_i=N +ftype=N +tag=name
        run_pan_x    = CFG_PAN_X;
        run_pan_y    = CFG_PAN_Y;
        run_julia_re = CFG_JULIA;
        run_julia_im = CFG_JULIA;
        run_zoom     = CFG_ZOOM;
        run_max_i    = CFG_MAX_I;
        run_ftype    = 0;
        run_tag      = "top";
        void'($value$plusargs("pan_x=%h",    run_pan_x));
        void'($value$plusargs("pan_y=%h",    run_pan_y));
        void'($value$plusargs("julia_re=%h", run_julia_re));
        void'($value$plusargs("julia_im=%h", run_julia_im));
        void'($value$plusargs("zoom=%d",     run_zoom));
        void'($value$plusargs("max_i=%d",    run_max_i));
        void'($value$plusargs("ftype=%d",    run_ftype));
        void'($value$plusargs("tag=%s",      run_tag));

        $display("\ntb_top_level — rendering 16 sixteenths  [tag=%s]", run_tag);
        $display("PAN_X=0x%09X  PAN_Y=0x%09X  ZOOM=%0d  MAX_I=%0d  FTYPE=%0d",
                 run_pan_x, run_pan_y, run_zoom, run_max_i, run_ftype);

        rst = 1; tick(4); rst = 0; tick(2);

        force dut.cfg_fractal_type    = run_ftype[4:0];
        force dut.cfg_pan_x           = run_pan_x;
        force dut.cfg_pan_y           = run_pan_y;
        force dut.cfg_zoom_level      = run_zoom[15:0];
        force dut.cfg_max_iter        = run_max_i[11:0];
        force dut.cfg_image_base_addr = CFG_BASE;
        force dut.cfg_julia_real      = run_julia_re;
        force dut.cfg_julia_imag      = run_julia_im;
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
        release dut.cfg_julia_real;
        release dut.cfg_julia_imag;

        tick(10);

        $display("\n  Writing CSVs...");
        begin
            string dram_path, full_img_path;
            $sformat(dram_path,     "sim/render/%s_dram.csv",       run_tag);
            $sformat(full_img_path, "sim/render/%s_full_image.csv", run_tag);
            dump_full_dram_csv(dram_path);
            dump_full_image_csv(full_img_path);
        end

        for (int s = 0; s < 16; s++) begin
            string bram_path, img_path;
            $sformat(bram_path, "sim/render/%s_sixteenth_%0d_bram.csv",  run_tag, s);
            $sformat(img_path,  "sim/render/%s_sixteenth_%0d_image.csv", run_tag, s);
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
