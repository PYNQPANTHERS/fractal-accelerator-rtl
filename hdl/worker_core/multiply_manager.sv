/*
 * Multiply Core Interface
 *
 * Inputs:
 *   clk, rst
 *
 *   start_left, start_right, start_wide — one-cycle pulses to begin computation.
 *   start_wide means both cores are used together for a wide-width computation.
 *
 *   width_mode — passed in so the core knows whether to assert side_done on completion.
 *   In wide mode, both halves finish as one result so side_done is not meaningful.
 *
    received - when we get the received signal we then eithe rchange to the other cores result, or deassert the done flag a neither are done and waiting to be 'taken'
    kill, when killed we deactive both multipliers



 *   julia_type                  — 0: Mandelbrot, 1: Julia
 *   magnitude_negation_encoding — {|x|, |y|, -x, -y}
 *   n_exponent                  — 00=2, 01=3, 10=4, 11=5
 *   max_iteration               — iteration limit
 *   julia_c_x, julia_c_y        — Julia set constant, only used when julia_type=1
 *
 *   starting_x_reg_1, starting_y_reg_1 — left core input coordinates
 *   starting_x_reg_2, starting_y_reg_2 — right core input coordinates
 *
 * Outputs:
 *   done      — pulses high for one cycle when a result is ready
 *   side_done — 0: left result, 1: right result. Undefined in wide mode.
 *   iteration_count — the output result, valid when done is high
 *
 * Behaviour:
 *   After receiving a start_* pulse, the core computes and then asserts done
 *   for one cycle with the result on iteration_count. It then waits for the
 *   next start_* pulse before beginning again.
 */




module multiply_manager #(parameter NARROW_WIDTH = 18, INTEGER_BITS = 2)
(
input clk,
input rst,
input kill,

input start_left, // these are one-cycle pulses
input start_right,
input start_wide,

input julia_type; //0 - mandel, 1 - julia
input [3:0] magnitude_negation_encoding; //{abs x, abs y, neg x, neg y}
input [4:0] max_iteration;

input signed [NARROW_WIDTH-1:0] julia_c_x; 
input signed [NARROW_WIDTH-1:0] julia_c_y;

input signed [NARROW_WIDTH-1:0] starting_x_reg_1; //upper
input signed [NARROW_WIDTH-1:0] starting_x_reg_2;
input signed [NARROW_WIDTH-1:0] starting_y_reg_1;
input signed [NARROW_WIDTH-1:0] starting_y_reg_2;

);

localparam NARROW_FRACTIONAL_BITS = NARROW_WIDTH - INTEGER_BITS;


reg [2*NARROW_WIDTH-1:0] sum_x_reg_1; //upper
reg [2*NARROW_WIDTH-1:0] sum_x_reg_2;
reg [2*NARROW_WIDTH-1:0] sum_y_reg_1;
reg [2*NARROW_WIDTH-1:0] sum_y_reg_2;

reg [NARROW_WIDTH-1:0] spare_x_reg_1;
reg [NARROW_WIDTH-1:0] spare_y_reg_2;


reg [2*NARROW_WIDTH-1:0] magnitude_reg_1; //upper
reg [2*NARROW_WIDTH-1:0] magnitude_reg_2;
reg [ITERATION_COUNT_WIDTH-1:0] iteration_reg_1;
reg [ITERATION_COUNT_WIDTH-1:0] iteration_reg_2;



typedef enum {IDLE, RUNNING} thread_state;
typedef enum {UNDEFINED, SPLIT, JOINED} joint_state;
typedef enum {IDLE, ALTER_SUM, X_SQUARED, Y_SQUARED, TWO_I_XY, ADD_COORD, ADD_JULIA} thread_cycle;

joint_state grouping_status;
thread_state left_thread;
thread_cycle left_cycle;

thread_state right_thread;
thread_cycle right_cycle;


always_ff @(posedge clk) begin
    if(kill||rst) begin
        grouping_status <= UNDEFINED;
        left_thread <= IDLE;
        right_thread <= IDLE;
        left_cycle <= IDLE;
        right_cycle <= IDLE;
    end
    else begin
        if(start_left) begin
            grouping_status <= SPLIT;
            left_thread <= RUNNING;
            iteration_reg_1 <= ITERATION_COUNT_WIDTH(1'b0); 
            if(julia_type) begin //julia set setup
                sum_x_reg_1 <= {INTEGER_BITS(starting_x_reg_1[NARROW_WIDTH-1]),starting_x_reg_1,NARROW_FRACTIONAL_BITS(1'b0)};
                sum_y_reg_1 <= {INTEGER_BITS(starting_y_reg_1[NARROW_WIDTH-1]),starting_y_reg_1,NARROW_FRACTIONAL_BITS(1'b0)};
            end
            else begin // mandelbrot set setup
                sum_x_reg_1 <= {NARROW_WIDTH*2(1'b0)};
                sum_y_reg_1 <= {NARROW_WIDTH*2(1'b0)};             
            end
            
        end
        else if(start_right) begin
            grouping_status <= SPLIT;
            right_thread <= RUNNING;
            iteration_reg_2 <= ITERATION_COUNT_WIDTH(1'b0); 
            if(julia_type) begin //julia set setup
                sum_x_reg_2 <= {INTEGER_BITS(starting_x_reg_2[NARROW_WIDTH-1]),starting_x_reg_2,NARROW_FRACTIONAL_BITS(1'b0)};
                sum_y_reg_2 <= {INTEGER_BITS(starting_y_reg_2[NARROW_WIDTH-1]),starting_y_reg_2,NARROW_FRACTIONAL_BITS(1'b0)};
            end
            else begin // mandelbrot set setup
                sum_x_reg_2 <= {NARROW_WIDTH*2(1'b0)};
                sum_y_reg_2 <= {NARROW_WIDTH*2(1'b0)};             
            end
        end
        else if(start_wide) begin
            grouping_status <= JOINED;
            left_thread <= RUNNING;
            right_thread <= RUNNING;
        end 
    end







end







endmodule