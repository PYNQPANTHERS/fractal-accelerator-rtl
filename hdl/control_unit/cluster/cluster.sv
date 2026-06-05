// ─────────────────────────────────────────────────────────────────────────────
// cluster
//   Pool of CLUSTER_SIZE core_top instances with local arbitration,
//   pixel-address bookkeeping, and result buffering.
// ─────────────────────────────────────────────────────────────────────────────
module cluster #(
    parameter  int CLUSTER_SIZE        = 8,
    parameter  int PIXEL_ADDR_W        = 16,
    parameter  int PIXEL_W             = 8,
    parameter  int JOB_DATA_W          = 18,
    parameter  int ITER_W              = 16,
    parameter  int INTEGER_BITS        = 2,
    parameter  int LOWEST_MAX_ITER_POW = 6,
    localparam int LOCAL_IDX_W         = $clog2(CLUSTER_SIZE)
) (
    input  logic                     clk,
    input  logic                     rst_n,   

    input  logic                     opcode_reset,
    input  logic                     wide,

    input  logic                     disp_valid,
    input  logic [PIXEL_ADDR_W-1:0]  disp_pixel_addr,
    input  logic [JOB_DATA_W-1:0]    disp_job_data,

    output logic                     cluster_wants_job,

    output logic                     result_valid,
    output logic [PIXEL_ADDR_W-1:0]  result_pixel_addr,
    output logic [PIXEL_W-1:0]       result_data,
    input  logic                     result_ready
);

    // pipeline dispatch inputs one cycle to meet timing
    logic                    disp_valid_q;
    logic [PIXEL_ADDR_W-1:0] disp_pixel_addr_q;
    logic [JOB_DATA_W-1:0]   disp_job_data_q;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            disp_valid_q      <= 1'b0;
            disp_pixel_addr_q <= '0;
            disp_job_data_q   <= '0;
        end else begin
            disp_valid_q      <= disp_valid;
            disp_pixel_addr_q <= disp_pixel_addr;
            disp_job_data_q   <= disp_job_data;
        end
    end

    logic [CLUSTER_SIZE-1:0] core_wants_job;
    logic [CLUSTER_SIZE-1:0] core_start;
    logic [CLUSTER_SIZE-1:0] core_done;
    logic [CLUSTER_SIZE-1:0] core_received;
    logic [CLUSTER_SIZE-1:0] core_done_side;
    logic [CLUSTER_SIZE-1:0] core_will_load_into;
    logic [ITER_W-1:0]       core_result [CLUSTER_SIZE];

    logic [CLUSTER_SIZE-1:0] wants_onehot;
    logic [LOCAL_IDX_W-1:0]  local_winner_idx;
    logic                    local_any_free;

    priority_encoder #(.BUS_WIDTH(CLUSTER_SIZE)) u_wants_enc (
        .core_bus    (core_wants_job),
        .core_select (wants_onehot),
        .core_address(local_winner_idx),
        .any_valid   (local_any_free)
    );

    // fixes dispatch and ready signal disparity
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) cluster_wants_job <= 1'b0;
        else        cluster_wants_job <= local_any_free && !disp_valid_q;
    end

    // lock the winning core for the entire multi-word dispatch
    logic                    disp_valid_q_d;
    logic [CLUSTER_SIZE-1:0] locked_onehot;
    logic [LOCAL_IDX_W-1:0]  locked_idx;
    logic                    locked_any_free;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            disp_valid_q_d  <= 1'b0;
            locked_onehot   <= '0;
            locked_idx      <= '0;
            locked_any_free <= 1'b0;
        end else begin
            disp_valid_q_d <= disp_valid_q;
            if (disp_valid_q && !disp_valid_q_d) begin
                locked_onehot   <= wants_onehot;
                locked_idx      <= local_winner_idx;
                locked_any_free <= local_any_free;
            end
        end
    end

    logic [CLUSTER_SIZE-1:0] eff_onehot;
    logic [LOCAL_IDX_W-1:0]  eff_idx;
    logic                    eff_any_free;

    always_comb begin
        if (disp_valid_q && disp_valid_q_d) begin
            eff_onehot   = locked_onehot;
            eff_idx      = locked_idx;
            eff_any_free = locked_any_free;
        end else begin
            eff_onehot   = wants_onehot;
            eff_idx      = local_winner_idx;
            eff_any_free = local_any_free;
        end
    end

    assign core_start = disp_valid_q ? eff_onehot : '0;

    // pixel-address register file: 2 slots per core (left=0, right=1)
    logic [PIXEL_ADDR_W-1:0] pixel_mem [CLUSTER_SIZE][2];
    logic [PIXEL_ADDR_W-1:0] pa_rdata;

    logic wr_side;
    assign wr_side = wide ? 1'b0 : core_will_load_into[eff_idx];

    always_ff @(posedge clk) begin
        if (disp_valid_q && !disp_valid_q_d && eff_any_free)
            pixel_mem[eff_idx][wr_side] <= disp_pixel_addr_q;
    end

    logic [CLUSTER_SIZE-1:0] done_onehot;
    logic [LOCAL_IDX_W-1:0]  done_winner_idx;
    logic                    any_done;

    priority_encoder #(.BUS_WIDTH(CLUSTER_SIZE)) u_done_enc (
        .core_bus    (core_done),
        .core_select (done_onehot),
        .core_address(done_winner_idx),
        .any_valid   (any_done)
    );

    logic rd_side;
    assign rd_side  = wide ? 1'b0 : core_done_side[done_winner_idx];
    assign pa_rdata = pixel_mem[done_winner_idx][rd_side];


    // broadcast always occurs after opcode reset no need for arbitration,
    // cores will always except whats on the datapath not withstanding the live_data/ load_into signals
    // core and fsm will perform logic on wide flag and julia flag and decide 
    // if c needs loading and how many cycles
    generate
        for (genvar g = 0; g < CLUSTER_SIZE; g++) begin : gen_cores
            core_top #(
                .NARROW_WIDTH               (JOB_DATA_W),
                .ITERATION_COUNT_WIDTH      (ITER_W),
                .INTEGER_BITS               (INTEGER_BITS),
                .LOWEST_MAX_ITERATION_POWER (LOWEST_MAX_ITER_POW)
            ) u_core (
                .clk            (clk),
                .rst            (~rst_n),  // core_top active-high; rst_n active-low
                .opcode_reset   (opcode_reset),
                .live_data      (core_start[g]),
                .data_in        (disp_job_data_q),
                .done           (core_done[g]),
                .done_side      (core_done_side[g]),
                .will_load_into (core_will_load_into[g]),
                .received       (core_received[g]),
                .ready          (core_wants_job[g]),
                .iteration_count(core_result[g])
            );
        end
    endgenerate

    // result FIFO — carries pixel addr + lower PIXEL_W bits of iteration count
    localparam int FIFO_DW    = PIXEL_ADDR_W + PIXEL_W;
    localparam int FIFO_DEPTH = CLUSTER_SIZE;

    logic               fifo_wr_en;
    logic [FIFO_DW-1:0] fifo_wr_data;
    logic               fifo_full;
    logic               fifo_rd_en;
    logic [FIFO_DW-1:0] fifo_rd_data;
    logic               fifo_empty;

    assign fifo_wr_en   = any_done && !fifo_full;
    assign fifo_wr_data = {pa_rdata, core_result[done_winner_idx][PIXEL_W-1:0]};
    assign core_received = fifo_wr_en ? done_onehot : '0;

    sync_fifo #(.DW(FIFO_DW), .DEPTH(FIFO_DEPTH)) u_result_fifo (
        .clk    (clk),
        .rst_n  (rst_n),
        .wr_en  (fifo_wr_en),
        .wr_data(fifo_wr_data),
        .full   (fifo_full),
        .rd_en  (fifo_rd_en),
        .rd_data(fifo_rd_data),
        .empty  (fifo_empty)
    );

    assign result_valid                     = !fifo_empty;
    assign {result_pixel_addr, result_data} = fifo_rd_data;
    assign fifo_rd_en                       = result_valid && result_ready;

endmodule
