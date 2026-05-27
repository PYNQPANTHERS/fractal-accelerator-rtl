module cluster #(
    parameter  int CLUSTER_SIZE  = 8,
    parameter  int PIXEL_ADDR_W  = 16,   // {row, col} for 256x256
    parameter  int PIXEL_W       = 8,    // iteration count
    parameter  int JOB_DATA_W    = 18,   // job payload to core (c-value etc.)
    localparam int LOCAL_IDX_W   = $clog2(CLUSTER_SIZE)
) (
    input  logic                     clk,
    input  logic                     rst_n,

    // ──── top-level dispatch interface (in) ────
    input  logic                     disp_valid,        // flag for this cluster
    input  logic [PIXEL_ADDR_W-1:0]  disp_pixel_addr,   // where the result goes. -  might remove this just output core addr from core then have demux reduce wires
    input  logic [JOB_DATA_W-1:0]    disp_job_data,     // job payload

    // ──── top-level request interface (out) ────
    output logic                     cluster_wants_job, // at least one core in this cluster is free

    // ──── top-level result interface (out) ────
    output logic                     result_valid,
    output logic [PIXEL_ADDR_W-1:0]  result_pixel_addr,
    output logic [PIXEL_W-1:0]       result_data,
    input  logic                     result_ready       // top FIFO can accept
);

    // ──────────────────────────────────────────────────────────────
    // register dispatch inputs immediately — kills fanout from top
    // ──────────────────────────────────────────────────────────────
    logic                     disp_valid_q;
    logic [PIXEL_ADDR_W-1:0]  disp_pixel_addr_q;
    logic [JOB_DATA_W-1:0]    disp_job_data_q;

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

    // ──────────────────────────────────────────────────────────────
    // per-core signals
    // ──────────────────────────────────────────────────────────────
    logic [CLUSTER_SIZE-1:0]        core_wants_job;
    logic [CLUSTER_SIZE-1:0]        core_start;
    logic [CLUSTER_SIZE-1:0]        core_done;
    logic [PIXEL_W-1:0]             core_result         [CLUSTER_SIZE];
    logic [PIXEL_ADDR_W-1:0]        core_pixel_addr_out [CLUSTER_SIZE];

    // ──────────────────────────────────────────────────────────────
    // local priority encoder: which free core gets the incoming job
    // ──────────────────────────────────────────────────────────────
    logic [CLUSTER_SIZE-1:0]  wants_onehot;
    logic [LOCAL_IDX_W-1:0]   local_winner_idx;   // not used directly here
    logic                     local_any_free;

    priority_encoder #(
        .BUS_WIDTH (CLUSTER_SIZE)
    ) u_wants_enc (
        .core_bus     (core_wants_job),
        .core_select  (wants_onehot),     // one-hot: which core wins locally
        .core_address (local_winner_idx),
        .any_valid    (local_any_free)
    );

    // register the upward-facing request so arbiter can see
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) cluster_wants_job <= 1'b0;
        else        cluster_wants_job <= local_any_free;
    end

    // ──────────────────────────────────────────────────────────────
    // dispatch couting
    // ──────────────────────────────────────────────────────────────
    assign core_start = disp_valid_q ? wants_onehot : '0;

    // ──────────────────────────────────────────────────────────────
    // generate CLUSTER_SIZE cores
    // ──────────────────────────────────────────────────────────────
    generate
        for (genvar g = 0; g < CLUSTER_SIZE; g++) begin : gen_cores
            fractal_core #(
                .PIXEL_ADDR_W (PIXEL_ADDR_W),
                .PIXEL_W      (PIXEL_W),
                .JOB_DATA_W   (JOB_DATA_W)
            ) u_core (
                .clk             (clk),
                .rst_n           (rst_n),
                .start           (core_start[g]),
                .job_data        (disp_job_data_q),
                .pixel_addr_in   (disp_pixel_addr_q),
                .wants_job       (core_wants_job[g]),
                .done            (core_done[g]),
                .result          (core_result[g]),
                .pixel_addr_out  (core_pixel_addr_out[g])
            );
        end
    endgenerate

    // ──────────────────────────────────────────────────────────────
    // done encoder: lowest-index done core wins the FIFO write
    // ──────────────────────────────────────────────────────────────
    logic [CLUSTER_SIZE-1:0]  done_sel_unused;
    logic [LOCAL_IDX_W-1:0]   done_winner_idx;
    logic                     any_done;

    priority_encoder #(
        .BUS_WIDTH (CLUSTER_SIZE)
    ) u_done_enc (
        .core_bus     (core_done),
        .core_select  (done_sel_unused),
        .core_address (done_winner_idx),
        .any_valid    (any_done)
    );

    // ──────────────────────────────────────────────────────────────
    // small output FIFO
    // ──────────────────────────────────────────────────────────────
    localparam int FIFO_DW = PIXEL_ADDR_W + PIXEL_W;

    logic               fifo_wr_en;
    logic [FIFO_DW-1:0] fifo_wr_data;
    logic               fifo_full;

    logic               fifo_rd_en;
    logic [FIFO_DW-1:0] fifo_rd_data;
    logic               fifo_empty;

    assign fifo_wr_en   = any_done && !fifo_full;
    assign fifo_wr_data = {core_pixel_addr_out[done_winner_idx],
                           core_result         [done_winner_idx]};

    sync_fifo #(
        .DW    (FIFO_DW),
        .DEPTH (CLUSTER_SIZE)
    ) u_result_fifo (
        .clk     (clk),
        .rst_n   (rst_n),
        .wr_en   (fifo_wr_en),
        .wr_data (fifo_wr_data),
        .full    (fifo_full),
        .rd_en   (fifo_rd_en),
        .rd_data (fifo_rd_data),
        .empty   (fifo_empty)
    );

    // drive the top-level result interface from the FIFO
    assign result_valid                     = !fifo_empty;
    assign {result_pixel_addr, result_data} = fifo_rd_data;
    assign fifo_rd_en                       = result_valid && result_ready;

endmodule