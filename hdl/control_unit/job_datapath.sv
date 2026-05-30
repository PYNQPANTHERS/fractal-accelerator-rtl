// ─────────────────────────────────────────────────────────────────────────────
// job_datapath
//   Word multiplexer that drives disp_job_data across the cycles of a transfer.
//
//   Opcode broadcast (always the first thing after rst, one cycle):
//     opcode_en = 1  ->  word = { {pad}, iteration_count, fractal_type }
//                        bits [OPCODE_W-1:0]          = fractal_type
//                        bits [2*OPCODE_W-1:OPCODE_W] = iteration_count
//                        remaining high bits           = 0
//
//   Z word ordering (opcode_en = 0):
//     NARROW (2 words):  word0 = real_lower
//                        word1 = imag_lower
//     WIDE   (4 words):  word0 = real_lower
//                        word1 = real_upper
//                        word2 = imag_lower
//                        word3 = imag_upper
// ─────────────────────────────────────────────────────────────────────────────
module job_datapath #(
    parameter  int DATA_WIDTH = 17,
    parameter  int JOB_DATA_W = 18,
    parameter  int OPCODE_W   = 5,
    localparam int Z_WIDTH    = DATA_WIDTH + 1,
    localparam int Z_WIDE     = Z_WIDTH * 2 - 1
) (
    input  logic [Z_WIDE-1:0]      z_real,
    input  logic [Z_WIDE-1:0]      z_imag,
    input  logic                   wide,
    input  logic [1:0]             word_idx,          // 0..3
    input  logic                   opcode_en,         // from FSM OPCODE_BROADCAST
    input  logic [OPCODE_W-1:0]    fractal_type,
    input  logic [OPCODE_W-1:0]    iteration_count,
    output logic [JOB_DATA_W-1:0]  disp_job_data
);

    // upper-half width (whatever is left above the low JOB_DATA_W bits)
    localparam int UPPER_W = Z_WIDE - JOB_DATA_W;
    localparam int UPPER_PAD = JOB_DATA_W - UPPER_W;   // pad upper slice to bus width

    // lower halves: low JOB_DATA_W bits of each value
    logic [JOB_DATA_W-1:0] real_lower, imag_lower;
    assign real_lower = z_real[JOB_DATA_W-1:0];
    assign imag_lower = z_imag[JOB_DATA_W-1:0];

    // upper halves: high bits, zero-padded up to the bus width
    logic [JOB_DATA_W-1:0] real_upper, imag_upper;
    assign real_upper = {{UPPER_PAD{1'b0}}, z_real[Z_WIDE-1:JOB_DATA_W]};
    assign imag_upper = {{UPPER_PAD{1'b0}}, z_imag[Z_WIDE-1:JOB_DATA_W]};

    always_comb begin : word_mux
        disp_job_data = '0;
        if (opcode_en) begin
            // opcode broadcast — always first after rst, one cycle only
            disp_job_data = {{(JOB_DATA_W - 2*OPCODE_W){1'b0}},
                             iteration_count,
                             fractal_type};
        end else if (wide) begin
            unique case (word_idx)
                2'd0:    disp_job_data = real_lower;
                2'd1:    disp_job_data = real_upper;
                2'd2:    disp_job_data = imag_lower;
                2'd3:    disp_job_data = imag_upper;
                default: disp_job_data = '0;
            endcase
        end else begin
            unique case (word_idx)
                2'd0:    disp_job_data = real_lower;
                2'd1:    disp_job_data = imag_lower;
                default: disp_job_data = '0;
            endcase
        end
    end

endmodule