module complex_mul #(parameter DATA_WIDTH = 32) (
    input  logic signed [DATA_WIDTH-1:0] ar,
    input  logic signed [DATA_WIDTH-1:0] ai,
    input  logic signed [DATA_WIDTH-1:0] br,
    input  logic signed [DATA_WIDTH-1:0] bi,

    output logic signed [DATA_WIDTH-1:0] pr,
    output logic signed [DATA_WIDTH-1:0] pi
);

    localparam FRAC_BITS = DATA_WIDTH - 2; // Q2.30

    //karatsuba intermediate bits
    logic signed [2*DATA_WIDTH-1:0] m1, m2, m3;
    logic signed [DATA_WIDTH:0]     a_sum, b_sum;

    logic signed [2*DATA_WIDTH-1:0] pr_full, pi_full;

    always_comb begin
        a_sum   = ar + ai;
        b_sum   = br + bi;

        m1      = ar * br;
        m2      = ai * bi;
        m3      = a_sum * b_sum;

        pr_full = m1 - m2;
        pi_full = m3 - m1 - m2;

        pr      = pr_full >>> FRAC_BITS;
        pi      = pi_full >>> FRAC_BITS;
    end

endmodule


