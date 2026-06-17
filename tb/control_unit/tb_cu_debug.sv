// Minimal debug testbench — IMAGE_SIZE=16, CLUSTER_COUNT=2, CLUSTER_SIZE=4
// Traces grant/cu_wr_en to see where deadlock happens
`timescale 1ns/1ps

module tb_cu_debug;

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
        .c_x(c_x), .c_y(c_y), .sixteenth('0),
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

    int collected;
    int dispatched;
    longint clk_count;

    always_ff @(posedge clk) begin
        clk_count <= clk_count + 1;
        if (grant) begin
            dispatched <= dispatched + 1;
            $display("[%6d] GRANT  coord=%04h (row=%0d col=%0d) dispatched=%0d queue=%0d",
                     clk_count, coord_out, coord_out[15:8], coord_out[7:0],
                     dispatched+1, sched_queue.size());
        end
        if (cu_wr_en) begin
            collected <= collected + 1;
            $display("[%6d] RESULT x=%0d y=%0d data=%0d  collected=%0d",
                     clk_count, cu_wr_x, cu_wr_y, cu_wr_data, collected+1);
        end
    end

    initial begin
        collected  = 0;
        dispatched = 0;
        clk_count  = 0;

        // reset
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

        for (int row=0;row<IMAGE_SIZE;row++)
            for (int col=0;col<IMAGE_SIZE;col++)
                sched_queue.push_back({PIXEL_W'(row), PIXEL_W'(col)});

        $display("Queued %0d pixels", IMAGE_SIZE*IMAGE_SIZE);
        start_flag=1; @(posedge clk); start_flag=0;

        // wait for completion or timeout
        begin : drain_loop
            int timeout, last_collected;
            timeout=0; last_collected=0;
            while (collected < IMAGE_SIZE*IMAGE_SIZE && timeout < 2_000_000) begin
                @(posedge clk);
                timeout++;
                if (collected != last_collected) begin
                    last_collected = collected;
                end
                // print periodic status
                if (timeout % 10000 == 0)
                    $display("[%6d] STATUS: collected=%0d dispatched=%0d wants_job=%b grant=%b queue=%0d",
                             clk_count, collected, dispatched, wants_job, grant, sched_queue.size());
            end
            $display("DONE: collected=%0d / %0d  dispatched=%0d  cycles=%0d",
                     collected, IMAGE_SIZE*IMAGE_SIZE, dispatched, timeout);
        end

        $finish;
    end

    initial begin
        #(CLK_PERIOD * 2_100_000);
        $display("WATCHDOG");
        $finish;
    end

endmodule
