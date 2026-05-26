module complex_mul #(parameter DATA_WIDTH = 32) (
    input  logic signed [DATA_WIDTH-1:0] a_r,
    input  logic signed [DATA_WIDTH-1:0] a_i,
    input  logic signed [DATA_WIDTH-1:0] b_r,
    input  logic signed [DATA_WIDTH-1:0] b_i,

    output logic signed [DATA_WIDTH-1:0] p_r,
    output logic signed [DATA_WIDTH-1:0] p_i
);

    localparam FRAC_BITS = DATA_WIDTH - 2; // Q2.30

    //karatsuba intermediate bits
    logic signed [2*DATA_WIDTH-1:0] m1, m2, m3;
    logic signed [DATA_WIDTH:0]     a_sum, b_sum;

    logic signed [2*DATA_WIDTH-1:0] pr_full, pi_full;

    always_comb begin
        a_sum   = a_r + a_i;
        b_sum   = b_r + b_i;

        m1      = a_r * b_r;
        m2      = a_i * b_i;
        m3      = a_sum * b_sum;

        pr_full = m1 - m2;
        pi_full = m3 - m1 - m2;

        p_r      = pr_full >>> FRAC_BITS;
        p_i      = pi_full >>> FRAC_BITS;
    end

endmodule


