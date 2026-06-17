module job_datapath #(
    parameter  int DATA_WIDTH = 18,
    parameter  int JOB_DATA_W = 18,
    parameter  int OPCODE_W   = 5,
    parameter  int Z_WIDE     = 35
) (
    input  logic [Z_WIDE-1:0]      z_real,
    input  logic [Z_WIDE-1:0]      z_imag,
    input  logic                   wide,
    input  logic [1:0]             word_idx,          // 0123
    input  logic                   opcode_en,         // from FSM OPCODE_BROADCAST
    input  logic                   load_c_en,         // from FSM LOAD_C_NARROW/WIDE
    input  logic [34:0]            c_real,
    input  logic [34:0]            c_imag,
    input  logic [OPCODE_W-1:0]    fractal_type,
    input  logic [OPCODE_W-1:0]    max_iter,
    output logic [JOB_DATA_W-1:0]  disp_job_data
);

    // upper-half width (whatever is left above the low JOB_DATA_W bits)
    localparam int UPPER_W = Z_WIDE - JOB_DATA_W;

    // lower halves: low JOB_DATA_W bits of each value
    logic [JOB_DATA_W-1:0] real_lower, imag_lower;
    assign real_lower = z_real[JOB_DATA_W-1:0];
    assign imag_lower = z_imag[JOB_DATA_W-1:0];

    // upper halves: if upper slice is wider than bus, take the low JOB_DATA_W bits of it
    //               (top bits are redundant sign extension from multiply); otherwise pad.
    logic [JOB_DATA_W-1:0] real_upper, imag_upper;
    generate
        if (UPPER_W >= JOB_DATA_W) begin : gen_upper_trunc
            assign real_upper = z_real[JOB_DATA_W + JOB_DATA_W - 1 : JOB_DATA_W];
            assign imag_upper = z_imag[JOB_DATA_W + JOB_DATA_W - 1 : JOB_DATA_W];
        end else begin : gen_upper_pad
            localparam int UPPER_PAD = JOB_DATA_W - UPPER_W;
            assign real_upper = {{UPPER_PAD{z_real[Z_WIDE-1]}}, z_real[Z_WIDE-1:JOB_DATA_W]};
            assign imag_upper = {{UPPER_PAD{z_imag[Z_WIDE-1]}}, z_imag[Z_WIDE-1:JOB_DATA_W]};
        end
    endgenerate

    always_comb begin : word_mux
        disp_job_data = '0;
        if (opcode_en) begin
            // opcode broadcast — always first after rst, one cycle only
            // format matches core_top LOADING_OPCODES: {wide, julia/mag[4:0], maxiter[4:0]}
            disp_job_data = {{(JOB_DATA_W - 2*OPCODE_W){1'b0}},
                            wide,
                            fractal_type,
                            max_iter};
        end else if (load_c_en) begin
            // Julia c in narrow mode: top 18 bits = Q2.16 representation
            case (word_idx)
                2'd0:    disp_job_data = c_real[34:17];
                2'd1:    disp_job_data = c_imag[34:17];
                default: disp_job_data = '0;
            endcase
        end else if (wide) begin
            unique case (word_idx)
                2'd0:    disp_job_data = real_lower;
                2'd1:    disp_job_data = real_upper;
                2'd2:    disp_job_data = imag_lower;
                2'd3:    disp_job_data = imag_upper;
                default: disp_job_data = '0;
            endcase
        end else begin
            // narrow mode: top 18 bits of Q2.33 = Q2.16 coordinate
            unique case (word_idx)
                2'd0:    disp_job_data = z_real[34:17];
                2'd1:    disp_job_data = z_imag[34:17];
                default: disp_job_data = '0;
            endcase
        end
    end

endmodule