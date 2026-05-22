module complex_pow #(
    parameter DATA_WIDTH = 32,
    parameter MULTIPLICATIONS = 3
) (

    input logic clk,
    input logic rst,
    input logic start,

    //z input
    input logic signed [DATA_WIDTH-1:0] z_r,    
    input logic signed [DATA_WIDTH-1:0] z_i,

    //for optimal multiplication
    input logic [MULTIPLICATIONS-1:0] square,
    input logic [MULTIPLICATIONS-1:0] single,

    //result
    output logic signed [DATA_WIDTH-1:0] zi_r,
    output logic signed [DATA_WIDTH-1:0] zi_i,
    output logic done
);

//inputs to muliplier
logic signed [DATA_WIDTH-1:0] a_r;
logic signed [DATA_WIDTH-1:0] a_i;

logic signed [DATA_WIDTH-1:0] b_r;
logic signed [DATA_WIDTH-1:0] b_i;

//multiplier output
logic signed [DATA_WIDTH-1:0] p_r;
logic signed [DATA_WIDTH-1:0] p_i;

typedef enum logic [1:0] { 
    SQUARE,
    SINGLE,
    IDLE
} mul_state;

logic [MULTIPLICATIONS-1:0] square_count;
logic [MULTIPLICATIONS-1:0] single_count;

mul_state multiplier_state;

complex_mul multiplier (
    .a_r(a_r),
    .a_i(a_i),
    .b_r(b_r),
    .b_i(b_i),
    .p_r(p_r),
    .p_i(p_i)
);

always_ff @(posedge clk) begin
    if (rst) begin
        square_count <= 0;
        single_count <= 0;
        
        zi_r <= 0;
        zi_i <= 0;

        multiplier_state <= IDLE; 
        done <= 0;

    end else if (start) begin
        square_count <= square;
        single_count <= single;

        done <= 0;

        zi_r <= z_r;
        zi_i <= z_i;

        //if function is z^1 + c
        if (square == 0 && single == 0) begin
            done <= 1;
            multiplier_state <= IDLE;
        end else begin
            multiplier_state <= (square == 0) ? SINGLE : SQUARE;
        end

    end else begin

        done <= 0;
        
        case (multiplier_state)
            SQUARE: begin
                zi_r <= p_r;
                zi_i <= p_i;
                if (square_count <= 1) begin
                    if (single == 0) begin
                        done <= 1;        
                        multiplier_state <= IDLE;
                    end else begin
                        multiplier_state <= SINGLE;
                        single_count <= single;
                    end
                end else begin
                    square_count <= square_count - 1;
                end
            end

            SINGLE: begin
                zi_r <= p_r;
                zi_i <= p_i;
                if (single_count <= 1) begin
                    done <= 1;
                    multiplier_state <= IDLE;
                end else begin
                    single_count <= single_count - 1;
                end
            end
                    
            default: ;

        endcase
    end
end

always_comb begin
    case (multiplier_state)
        SQUARE: begin
            a_r = zi_r;
            a_i = zi_i;
            b_r = zi_r;
            b_i = zi_i;
        end

        SINGLE: begin
            a_r = zi_r;
            a_i = zi_i;
            b_r = z_r;
            b_i = z_i;
        end

        default: begin
            a_r = zi_r;
            a_i = zi_i;
            b_r = zi_r;
            b_i = zi_i;
        end
    endcase
end

endmodule