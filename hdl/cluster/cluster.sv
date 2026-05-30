// ─────────────────────────────────────────────────────────────────────────────
// cluster
//   Pool of CLUSTER_SIZE fractal cores with local arbitration, pixel-address
//   bookkeeping, and result buffering using a local FIFO.
//
//   Dispatch:
//     disp_valid held high for the full multi-word transfer to ONE cluster.
//     The first cycle of disp_valid_q selects and starts the winning core and
//     writes its pixel address into pixel_mem.
//
//   Pixel address:
//     disp_pixel_addr is always PIXEL_ADDR_W bits = {row[7:0], col[7:0]}.
//     The same format is used for both narrow and wide Z transfers — the
//     address width does not change with wide mode.
//
//   Result:
//     When any core finishes, pa_rdata reads the stored address out of
//     pixel_mem and the result is pushed to the output FIFO.
// ─────────────────────────────────────────────────────────────────────────────
module cluster #(
    parameter  int CLUSTER_SIZE  = 8,
    parameter  int PIXEL_ADDR_W  = 16,
    parameter  int PIXEL_W       = 8,
    parameter  int JOB_DATA_W    = 18,
    localparam int LOCAL_IDX_W   = $clog2(CLUSTER_SIZE)
) (
    input  logic                     clk,
    input  logic                     rst_n,

    // dispatch in — disp_valid held for all words of one transfer
    input  logic                     disp_valid,
    input  logic [PIXEL_ADDR_W-1:0]  disp_pixel_addr,
    input  logic [JOB_DATA_W-1:0]    disp_job_data,

    // request out
    output logic                     cluster_wants_job,

    // result out
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

    // per-core signals
    logic [CLUSTER_SIZE-1:0] core_wants_job;
    logic [CLUSTER_SIZE-1:0] core_start;
    logic [CLUSTER_SIZE-1:0] core_done;
    logic [CLUSTER_SIZE-1:0] core_received;
    logic [PIXEL_W-1:0]      core_result [CLUSTER_SIZE];

    // wants encoder — picks the next free core for dispatch
    logic [CLUSTER_SIZE-1:0] wants_onehot;
    logic [LOCAL_IDX_W-1:0]  local_winner_idx;
    logic                    local_any_free;

    priority_encoder #(.BUS_WIDTH(CLUSTER_SIZE)) u_wants_enc (
        .core_bus    (core_wants_job),
        .core_select (wants_onehot),
        .core_address(local_winner_idx),
        .any_valid   (local_any_free)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) cluster_wants_job <= 1'b0;
        else        cluster_wants_job <= local_any_free;
    end

    assign core_start = disp_valid_q ? wants_onehot : '0;

    // pixel-address register file 
    // written on dispatch, read combinationally when a core finishes
    logic [PIXEL_ADDR_W-1:0] pixel_mem [CLUSTER_SIZE];
    logic [PIXEL_ADDR_W-1:0] pa_rdata;

    always_ff @(posedge clk) begin
        if (disp_valid_q && local_any_free)
            pixel_mem[local_winner_idx] <= disp_pixel_addr_q;
    end

   

    // cores
    generate
        for (genvar g = 0; g < CLUSTER_SIZE; g++) begin : gen_cores
            fractal_core #(
                .JOB_DATA_W (JOB_DATA_W),
                .PIXEL_W    (PIXEL_W)
            ) u_core (
                .clk      (clk),
                .rst_n    (rst_n),
                .live_data(core_start[g]),
                .data_in  (disp_job_data_q),
                .ready    (core_wants_job[g]),
                .done     (core_done[g]),
                .result   (core_result[g]),
                .received (core_received[g])
            );
        end
    endgenerate


     // done encoder — picks the next finished core to drain
    logic [CLUSTER_SIZE-1:0] done_onehot;
    logic [LOCAL_IDX_W-1:0]  done_winner_idx;
    logic                    any_done;

    priority_encoder #(.BUS_WIDTH(CLUSTER_SIZE)) u_done_enc (
        .core_bus    (core_done),
        .core_select (done_onehot),
        .core_address(done_winner_idx),
        .any_valid   (any_done)
    );


    // comb pixel read
    always_comb begin:
        if (narrow) begin
            pa_rdata = pixel_mem[{done_winner_idx, left_right}];
        end
        else pa_rdata = pixel_mem[{done_winner_idx, 1'b0}];
    end



    // result FIFO
    localparam int FIFO_DW    = PIXEL_ADDR_W + PIXEL_W;
    localparam int FIFO_DEPTH = (CLUSTER_SIZE < 4) ? 4 : CLUSTER_SIZE;

    logic               fifo_wr_en;
    logic [FIFO_DW-1:0] fifo_wr_data;
    logic               fifo_full;

    logic               fifo_rd_en;
    logic [FIFO_DW-1:0] fifo_rd_data;
    logic               fifo_empty;

    assign fifo_wr_en   = any_done && !fifo_full;
    assign fifo_wr_data = {pa_rdata, core_result[done_winner_idx]};

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
