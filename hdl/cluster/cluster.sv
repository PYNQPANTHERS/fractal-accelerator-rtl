// ─────────────────────────────────────────────────────────────────────────────
// cluster
//   Pool of CLUSTER_SIZE fractal cores with local arbitration, pixel-address
//   bookkeeping, and result buffering using local fifo
//.  needs a FSM for the different data transfers to wait for datapath to be free again
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

    // dispatch in
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
    // state just to hold for certain amount of cycles for full data to be sent
    typedef enum data_type {
        IDLE,
        LOAD_OPCODE         // one cycle
        LOAD_Z_NARROW,      // holds handshake for 2
        LOAD_Z_WIDE,        // holds handshake for 4
        LOAD_C_NARROW,      // holds handshake for 2
        LOAD_C_WIDE         // holds handshake for 4
      } name;

    // register dispatch inputs
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

    // per-core signals
    logic [CLUSTER_SIZE-1:0]  core_wants_job;
    logic [CLUSTER_SIZE-1:0]  core_start;
    logic [CLUSTER_SIZE-1:0]  core_done;
    logic [CLUSTER_SIZE-1:0]  core_received;
    logic [PIXEL_W-1:0]       core_result [CLUSTER_SIZE];

    // wants encoder
    logic [CLUSTER_SIZE-1:0]  wants_onehot;
    logic [LOCAL_IDX_W-1:0]   local_winner_idx;
    logic                     local_any_free;

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

    // dispatch routing
    assign core_start = disp_valid_q ? wants_onehot : '0;

    // pixel-address RAM
    logic [PIXEL_ADDR_W-1:0] pixel_addr_mem [CLUSTER_SIZE];
    logic                    pa_we;
    logic [PIXEL_ADDR_W-1:0] pa_rdata;

    assign pa_we = disp_valid_q && local_any_free;

    always_ff @(posedge clk) begin
        if (pa_we) pixel_addr_mem[local_winner_idx] <= disp_pixel_addr_q;
    end

    // done encoder (declared early so pa_rdata can reference done_winner_idx)
    logic [CLUSTER_SIZE-1:0]  done_onehot;
    logic [LOCAL_IDX_W-1:0]   done_winner_idx;
    logic                     any_done;

    priority_encoder #(.BUS_WIDTH(CLUSTER_SIZE)) u_done_enc (
        .core_bus    (core_done),
        .core_select (done_onehot),
        .core_address(done_winner_idx),
        .any_valid   (any_done)
    );

    assign pa_rdata = pixel_addr_mem[done_winner_idx];

    // cores
    generate
        for (genvar g = 0; g < CLUSTER_SIZE; g++) begin : gen_cores
            fractal_core #(
                .JOB_DATA_W (JOB_DATA_W),
                .PIXEL_W    (PIXEL_W)
            ) u_core (
                .clk        (clk),
                .rst_n      (rst_n),
                .live_data  (core_start[g]),       // selects this core
                .data_in    (disp_job_data_q),     // job payload
                .ready      (core_wants_job[g]),   // ready for job
                .done       (core_done[g]),        // done flag
                .result     (core_result[g]),      // iteration count
                .received   (core_received[g])     // handshake: FIFO took it
            );
        end
    endgenerate

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
    assign fifo_wr_data = { pa_rdata, core_result[done_winner_idx] };

    // handshake back to the winning core
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