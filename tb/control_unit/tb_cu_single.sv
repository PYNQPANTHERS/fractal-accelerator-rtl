// Single-pixel smoke test: dispatch only pixel (0,0) and trace every write.
`timescale 1ns/1ps

module tb_cu_single;

    localparam int IMAGE_SIZE    = 16;
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
    localparam logic [3:0] ZOOM = 4'd0;
    localparam logic [4:0] MAX_ITER_FIELD = 5'd1;

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
        .c_x(c_x), .c_y(c_y),
        .wants_job(wants_job), .grant(grant), .coord_out(coord_out),
        .done(done), .iter_x(iter_x), .iter_y(iter_y), .iter_colour(iter_colour),
        .cu_rd_x(cu_rd_x), .cu_rd_y(cu_rd_y), .cu_rd_en(cu_rd_en), .cu_rd_data(cu_rd_data),
        .cu_wr_en(cu_wr_en), .cu_wr_x(cu_wr_x), .cu_wr_y(cu_wr_y), .cu_wr_data(cu_wr_data),
        .sb_x(sb_x), .sb_y(sb_y), .sb_rd(sb_rd), .sb_we(sb_we),
        .sb_wstate(sb_wstate), .sb_rstate(sb_rstate),
        .cu_tile_done_set(cu_tile_done_set)
    );

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

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

    // rising-edge scheduler — only pixel (0,0)
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

    longint clk_count;
    always_ff @(posedge clk) begin
        clk_count <= clk_count + 1;
        if (grant)
            $display("[%6d] GRANT  coord=%04h", clk_count, coord_out);
        if (sb_rd)
            $display("[%6d] SB_RD  x=%0d y=%0d", clk_count, sb_x, sb_y);
        if (sb_we)
            $display("[%6d] SB_WE  x=%0d y=%0d wstate=%02b", clk_count, sb_x, sb_y, sb_wstate);
        if (cu_rd_en)
            $display("[%6d] CU_RD_EN x=%0d y=%0d", clk_count, cu_rd_x, cu_rd_y);
        if (cu_wr_en)
            $display("[%6d] CU_WR  x=%0d y=%0d data=%0d  *** RESULT ***", clk_count, cu_wr_x, cu_wr_y, cu_wr_data);
    end

    // verbose first-50-cycle trace
    always_ff @(posedge clk) begin
        if (clk_count < 50)
            $display("[%3d] wj=%b gr=%b sb_rd=%b sb_we=%b cu_rd=%b cu_wr=%b wants_job=%b",
                     clk_count, wants_job, grant, sb_rd, sb_we, cu_rd_en, cu_wr_en, wants_job);
    end

    initial begin
        clk_count = 0;
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

        fractal_type=5'b00000; max_iter=MAX_ITER_FIELD;
        opcode_reset=1; @(posedge clk); opcode_reset=0;

        // Queue ONLY pixel (0,0)
        sched_queue.push_back(16'h0000);
        $display("Queued 1 pixel: (0,0)");

        start_flag=1; @(posedge clk); start_flag=0;

        // wait up to 10000 cycles
        begin : drain
            int t;
            t = 0;
            while (t < 10000) begin
                @(posedge clk);
                t++;
                if (cu_wr_en && cu_wr_x == 0 && cu_wr_y == 0) begin
                    $display("SUCCESS: pixel (0,0) returned at cycle %0d", clk_count);
                    $finish;
                end
            end
            $display("TIMEOUT after 10000 cycles — pixel (0,0) never returned");
            $display("Final: wants_job=%b grant=%b done=%b", wants_job, grant, done);
        end
        $finish;
    end

    initial begin
        #(CLK_PERIOD * 12000);
        $display("WATCHDOG");
        $finish;
    end

endmodule
