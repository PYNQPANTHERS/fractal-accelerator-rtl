// ─────────────────────────────────────────────────────────────────────────────
// tb_cu_tile
//   Renders a 256×256 Mandelbrot frame through control_unit and verifies that
//   cu_tile_done_set fires exactly once per 16×16-pixel tile (256 tiles total).
//
//   Tile address encoding: {cu_wr_x[7:4], cu_wr_y[7:4]} = {col/16, row/16}
//   Each tile: 16×16 = 256 pixels. cu_tile_done_set fires when the tile's
//   8-bit counter wraps 0xFF→0x00 (the 256th pixel written to that tile).
// ─────────────────────────────────────────────────────────────────────────────
`timescale 1ns/1ps

module tb_cu_tile;

    localparam int IMAGE_SIZE    = 256;
    localparam int TILE_SZ       = 16;
    localparam int TILE_COLS     = IMAGE_SIZE / TILE_SZ;   // 16
    localparam int TILE_ROWS     = IMAGE_SIZE / TILE_SZ;   // 16
    localparam int TILE_COUNT    = TILE_COLS * TILE_ROWS;  // 256
    localparam int PIX_PER_TILE  = TILE_SZ * TILE_SZ;     // 256

    localparam int CLUSTER_COUNT = 2;
    localparam int CLUSTER_SIZE  = 4;
    localparam int DATA_WIDTH    = 17;
    localparam int PIXEL_ADDR_W  = 16;
    localparam int JOB_DATA_W    = 18;
    localparam int PIXEL_W       = 8;
    localparam int OPCODE_W      = 5;
    localparam time CLK_PERIOD   = 10ns;

    localparam logic signed [DATA_WIDTH-1:0] PAN_X = 17'($signed(-65536));
    localparam logic signed [DATA_WIDTH-1:0] PAN_Y = 17'(65024);
    localparam logic [3:0] ZOOM             = 4'd0;
    localparam logic [4:0] MAX_ITER_FIELD   = 5'd1;

    // ── DUT signals ───────────────────────────────────────────────────────────
    logic                    clk, rst, opcode_reset, start_flag, width_flag;
    logic [4:0]              fractal_type, max_iter;
    logic [DATA_WIDTH-1:0]   pan_x, pan_y, c_x, c_y;
    logic [3:0]              zoom_level;

    logic                    wants_job, grant;
    logic [PIXEL_ADDR_W-1:0] coord_out;
    logic                    done;
    logic [PIXEL_W:0]        iter_x, iter_y;
    logic [7:0]              iter_colour;
    logic [PIXEL_W-1:0]      cu_rd_x, cu_rd_y;
    logic                    cu_rd_en;
    logic [7:0]              cu_rd_data;
    logic                    cu_wr_en;
    logic [PIXEL_W-1:0]      cu_wr_x, cu_wr_y;
    logic [7:0]              cu_wr_data;
    logic [PIXEL_W-1:0]      sb_x, sb_y;
    logic                    sb_rd, sb_we;
    logic [1:0]              sb_wstate, sb_rstate;
    logic                    cu_tile_done_set;

    // ── DUT ──────────────────────────────────────────────────────────────────
    control_unit #(
        .DATA_WIDTH    (DATA_WIDTH),
        .CLUSTER_COUNT (CLUSTER_COUNT),
        .CLUSTER_SIZE  (CLUSTER_SIZE),
        .PIXEL_ADDR_W  (PIXEL_ADDR_W),
        .JOB_DATA_W    (JOB_DATA_W),
        .PIXEL_W       (PIXEL_W),
        .OPCODE_W      (OPCODE_W)
    ) dut (
        .clk(clk), .rst(rst), .opcode_reset(opcode_reset),
        .start_flag(start_flag), .width_flag(width_flag),
        .fractal_type(fractal_type), .max_iter(max_iter),
        .pan_x(pan_x), .pan_y(pan_y), .zoom_level(zoom_level),
        .c_x(c_x), .c_y(c_y), .sixteenth('0),
        .wants_job(wants_job), .grant(grant), .coord_out(coord_out),
        .done(done), .iter_x(iter_x), .iter_y(iter_y), .iter_colour(iter_colour),
        .cu_rd_x(cu_rd_x), .cu_rd_y(cu_rd_y), .cu_rd_en(cu_rd_en), .cu_rd_data(cu_rd_data),
        .cu_wr_en(cu_wr_en), .cu_wr_x(cu_wr_x), .cu_wr_y(cu_wr_y), .cu_wr_data(cu_wr_data),
        .sb_x(sb_x), .sb_y(sb_y), .sb_rd(sb_rd), .sb_we(sb_we),
        .sb_wstate(sb_wstate), .sb_rstate(sb_rstate),
        .cu_tile_done_set(cu_tile_done_set)
    );

    // ── clock ─────────────────────────────────────────────────────────────────
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // ── memory models ─────────────────────────────────────────────────────────
    logic [7:0] cbram [0:IMAGE_SIZE-1][0:IMAGE_SIZE-1];
    logic [7:0] cbram_rd_q;
    always_ff @(posedge clk) begin
        if (cu_rd_en) cbram_rd_q <= cbram[cu_rd_x][cu_rd_y];
        if (cu_wr_en) cbram[cu_wr_x][cu_wr_y] <= cu_wr_data;
    end
    assign cu_rd_data = cbram_rd_q;

    logic [1:0] sbram [0:IMAGE_SIZE-1][0:IMAGE_SIZE-1];
    logic [1:0] sbram_rd_q;
    always_ff @(posedge clk) begin
        if (sb_rd) sbram_rd_q <= sbram[sb_x][sb_y];
        if (sb_we) sbram[sb_x][sb_y] <= sb_wstate;
    end
    assign sb_rstate = sbram_rd_q;

    // ── scheduler model (rising-edge pop) ─────────────────────────────────────
    logic [PIXEL_ADDR_W-1:0] sched_queue [$];
    logic wants_job_q;
    always_ff @(posedge clk) begin
        wants_job_q <= wants_job;
        grant       <= 0;
        coord_out   <= '0;
        if (wants_job && !wants_job_q && sched_queue.size() > 0) begin
            coord_out <= sched_queue.pop_front();
            grant     <= 1;
        end
    end

    // ── tile tracking ─────────────────────────────────────────────────────────
    // tile_done_addr is stable whenever cu_tile_done_set is high because
    // cu_tile_done_set is combinationally derived from cu_wr_x / cu_wr_y.
    wire [7:0] tile_done_addr = {cu_wr_x[7:4], cu_wr_y[7:4]};

    int tile_done_count;
    int tile_fired   [256];  // how many times each tile_addr fired cu_tile_done_set
    int pixel_in_tile[256];  // count of cu_wr_en writes per tile (sanity check)

    always_ff @(posedge clk) begin
        if (cu_wr_en) begin
            pixel_in_tile[tile_done_addr] <= pixel_in_tile[tile_done_addr] + 1;
        end
        if (cu_tile_done_set) begin
            tile_fired[tile_done_addr] <= tile_fired[tile_done_addr] + 1;
            tile_done_count            <= tile_done_count + 1;
            $display("[%7d] TILE_DONE addr=%02h (tile_col=%0d tile_row=%0d) total=%0d/%0d",
                     $time / CLK_PERIOD, tile_done_addr,
                     tile_done_addr[7:4], tile_done_addr[3:0],
                     tile_done_count + 1, TILE_COUNT);
        end
    end

    // ── pixel collection count (via cu_wr_en) ─────────────────────────────────
    int collected;
    longint clk_count;
    always_ff @(posedge clk) begin
        clk_count <= clk_count + 1;
        if (cu_wr_en) collected <= collected + 1;
    end

    // ── final verification ────────────────────────────────────────────────────
    task automatic verify_tiles();
        int fails;
        fails = 0;
        $display("\n── Tile verification (%0d tiles expected) ──", TILE_COUNT);

        // Check every expected tile_addr fired exactly once
        for (int tc = 0; tc < TILE_COLS; tc++) begin
            for (int tr = 0; tr < TILE_ROWS; tr++) begin
                automatic int ta = (tc << 4) | tr;
                if (tile_fired[ta] != 1) begin
                    $display("  FAIL tile_addr=%02h (col=%0d row=%0d): fired %0d times, pixel_count=%0d",
                             ta, tc, tr, tile_fired[ta], pixel_in_tile[ta]);
                    fails++;
                end
            end
        end

        // Check no unexpected tiles fired
        for (int ta = 0; ta < 256; ta++) begin
            automatic int tc = ta >> 4;
            automatic int tr = ta & 4'hF;
            if (tc >= TILE_COLS || tr >= TILE_ROWS) begin
                if (tile_fired[ta] != 0) begin
                    $display("  FAIL unexpected tile_addr=%02h fired %0d times", ta, tile_fired[ta]);
                    fails++;
                end
            end
        end

        if (tile_done_count != TILE_COUNT) begin
            $display("  FAIL tile_done_count=%0d (expected %0d)", tile_done_count, TILE_COUNT);
            fails++;
        end

        if (fails == 0)
            $display("  PASS: all %0d tiles completed, each exactly once.", TILE_COUNT);
        else
            $display("  FAIL: %0d tile error(s) detected.", fails);
    endtask

    // ── main ─────────────────────────────────────────────────────────────────
    initial begin
        collected       = 0;
        tile_done_count = 0;
        clk_count       = 0;
        for (int i = 0; i < 256; i++) begin
            tile_fired[i]    = 0;
            pixel_in_tile[i] = 0;
        end

        rst=1; start_flag=0; opcode_reset=0; width_flag=0;
        fractal_type='0; max_iter='0;
        pan_x=PAN_X; pan_y=PAN_Y; zoom_level=ZOOM;
        c_x='0; c_y='0;
        for (int i=0;i<IMAGE_SIZE;i++)
            for (int j=0;j<IMAGE_SIZE;j++) begin
                cbram[i][j]=8'h00; sbram[i][j]=2'b00;
            end
        sched_queue.delete();
        repeat(4) @(posedge clk);
        rst=0; @(posedge clk);

        // configure Mandelbrot frame
        fractal_type = 5'b00000;
        max_iter     = MAX_ITER_FIELD;
        opcode_reset = 1; @(posedge clk); opcode_reset = 0;

        // queue all 256×256 pixels as {row[7:0], col[7:0]}
        for (int row=0; row<IMAGE_SIZE; row++)
            for (int col=0; col<IMAGE_SIZE; col++)
                sched_queue.push_back({PIXEL_W'(row), PIXEL_W'(col)});

        $display("══ tb_cu_tile: 256×256 Mandelbrot ══");
        $display("  %0d pixels queued, %0d tiles expected", IMAGE_SIZE*IMAGE_SIZE, TILE_COUNT);

        start_flag=1; @(posedge clk); start_flag=0;

        // drain: wait for all pixels
        begin : drain
            int timeout, quiet;
            timeout = 0; quiet = 0;
            while ((collected < IMAGE_SIZE*IMAGE_SIZE || quiet < 20) && timeout < 15_000_000) begin
                @(posedge clk);
                timeout++;
                if (cu_wr_en) quiet = 0;
                else          quiet = quiet + 1;
                if (timeout % 200_000 == 0)
                    $display("  [%7d] collected=%0d tiles_done=%0d",
                             clk_count, collected, tile_done_count);
            end
            if (collected < IMAGE_SIZE*IMAGE_SIZE)
                $display("  TIMEOUT: only %0d/%0d pixels collected", collected, IMAGE_SIZE*IMAGE_SIZE);
        end

        $display("\n  Final: collected=%0d/%0d  tile_done_count=%0d/%0d  cycles=%0d",
                 collected, IMAGE_SIZE*IMAGE_SIZE, tile_done_count, TILE_COUNT, clk_count);

        verify_tiles();
        $finish;
    end

    initial begin
        #(CLK_PERIOD * 20_000_000);
        $display("WATCHDOG TIMEOUT");
        $finish;
    end

endmodule
