module cluster_dispatch_path #(
    parameter int DATA_WIDTH   = 18,
    parameter int JOB_DATA_W   = 18,
    parameter int OPCODE_W     = 5,
    parameter int PIXEL_ADDR_W = 16,
    parameter int Z_WIDE       = 37,
    parameter int MAX_WORDS    = 5   // WORDS_WIDE + 1
) (
    input  logic clk,
    input  logic rst,

    // broadcast frame params — same for all clusters
    input  logic                    wide,
    input  logic                    opcode_broadcast_en,
    input  logic                    load_c_en,
    input  logic [1:0]              shared_word_idx,   // from shared load_sequencer (C loading)
    input  logic [34:0]             c_real,
    input  logic [34:0]             c_imag,
    input  logic [OPCODE_W-1:0]     fractal_type,
    input  logic [OPCODE_W-1:0]     max_iter,

    // dispatch FIFO (show-ahead, shared; arbitrated in control_unit)
    input  logic                                  dispatch_empty,
    input  logic [PIXEL_ADDR_W + Z_WIDE*2 - 1:0] dispatch_rd_data,
    output logic                                  dispatch_req,
    input  logic                                  dispatch_grant,

    // cluster interface
    input  logic                    cluster_wants_job,
    output logic                    disp_valid,
    output logic [PIXEL_ADDR_W-1:0] disp_pixel_addr,
    output logic [JOB_DATA_W-1:0]   disp_job_data
);

    localparam int SEQ_CNT_W = $clog2(MAX_WORDS + 1);

    typedef enum logic { IDLE, LOADING } state_t;
    state_t state;

    logic [Z_WIDE-1:0]       z_real_q, z_imag_q;
    logic [PIXEL_ADDR_W-1:0] pixel_addr_q;

    // per-cluster Z-load sequencer
    logic                 start_z_load;
    logic [SEQ_CNT_W-1:0] z_word_idx;
    logic                 z_load_active, z_load_last;
    logic [SEQ_CNT_W-1:0] n_z_words;

    assign n_z_words    = wide ? SEQ_CNT_W'(4) : SEQ_CNT_W'(2);
    assign start_z_load = (state == IDLE) && dispatch_grant;
    assign dispatch_req = (state == IDLE) && cluster_wants_job && !dispatch_empty;
    assign disp_valid   = z_load_active;
    assign disp_pixel_addr = pixel_addr_q;

    load_sequencer #(.MAX_WORDS(MAX_WORDS)) u_seq (
        .clk        (clk),
        .rst        (rst),
        .start_load (start_z_load),
        .n_words    (n_z_words),
        .word_idx   (z_word_idx),
        .load_active(z_load_active),
        .load_last  (z_load_last)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            z_real_q     <= '0;
            z_imag_q     <= '0;
            pixel_addr_q <= '0;
        end else begin
            unique case (state)
                IDLE: if (dispatch_grant) begin
                    z_real_q     <= dispatch_rd_data[PIXEL_ADDR_W + Z_WIDE*2 - 1 -: Z_WIDE];
                    z_imag_q     <= dispatch_rd_data[PIXEL_ADDR_W + Z_WIDE   - 1 -: Z_WIDE];
                    pixel_addr_q <= dispatch_rd_data[PIXEL_ADDR_W-1:0];
                    state        <= LOADING;
                end
                LOADING: if (z_load_last) state <= IDLE;
            endcase
        end
    end

    // During C broadcast use shared sequencer index so all clusters stay in sync;
    // during Z loading use the per-cluster sequencer index.
    logic [1:0] eff_word_idx;
    assign eff_word_idx = load_c_en ? shared_word_idx : z_word_idx[1:0];

    job_datapath #(
        .DATA_WIDTH (DATA_WIDTH),
        .JOB_DATA_W (JOB_DATA_W),
        .OPCODE_W   (OPCODE_W),
        .Z_WIDE     (Z_WIDE)
    ) u_dp (
        .z_real       (z_real_q),
        .z_imag       (z_imag_q),
        .wide         (wide),
        .word_idx     (eff_word_idx),
        .opcode_en    (opcode_broadcast_en),
        .load_c_en    (load_c_en),
        .c_real       (c_real),
        .c_imag       (c_imag),
        .fractal_type (fractal_type),
        .max_iter     (max_iter),
        .disp_job_data(disp_job_data)
    );

endmodule
