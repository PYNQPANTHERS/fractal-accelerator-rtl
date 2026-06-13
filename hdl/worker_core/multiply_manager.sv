/*
 * Multiply Core Interface
 *
 * Inputs:
 *   clk, rst
 *
 *   start_left, start_right, start_wide - one-cycle pulses to begin computation.
 *   start_wide means both cores are used together for a wide-width computation.
 *
 *   width_mode - passed in so the core knows whether to assert side_done on completion.
 *   In wide mode, both halves finish as one result so side_done is not meaningful.
 *
    received - when we get the received signal we then eithe rchange to the other cores result, or deassert the done flag a neither are done and waiting to be 'taken'
    kill, when killed we deactive both multipliers



 *   julia_type                  - 0: Mandelbrot, 1: Julia
 *   magnitude_negation_encoding - {|x|, |y|, -x, -y}
 *   n_exponent                  - 00=2, 01=3, 10=4, 11=5
 *   max_iteration               - iteration limit
 *   julia_c_x, julia_c_y        - Julia set constant, only used when julia_type=1
 *
 *   starting_x_reg_1, starting_y_reg_1 - left core input coordinates
 *   starting_x_reg_2, starting_y_reg_2 - right core input coordinates
 *
 * Outputs:
 *   done      - stays high when a result is ready
 *   side_done - 0: left result, 1: right result. Undefined in wide mode.
 *   iteration_count - the output result, valid when done is high
 *
 * Behaviour:
 *   After receiving a start_* pulse, the core computes and then asserts done
 *   for one cycle with the result on iteration_count. It then waits for the
 *   next start_* pulse before beginning again.
 */




module multiply_manager #(parameter NARROW_WIDTH = 18, INTEGER_BITS = 2, ITERATION_COUNT_WIDTH = 16, LOWEST_MAX_ITERATION_POWER = 6)
(
input clk,
input rst,
input kill,
input received,

input start_left, // these are one-cycle pulses
input start_right,
input start_wide,

input julia_type, //0 - mandel, 1 - julia
input [3:0] magnitude_negation_encoding, //{abs x, abs y, neg x, neg y}
input [4:0] max_iteration,

input signed [NARROW_WIDTH-1:0] julia_c_x, 
input signed [NARROW_WIDTH-1:0] julia_c_y,

input signed [NARROW_WIDTH-1:0] starting_x_reg_1, //upper
input signed [NARROW_WIDTH-1:0] starting_x_reg_2,
input signed [NARROW_WIDTH-1:0] starting_y_reg_1,
input signed [NARROW_WIDTH-1:0] starting_y_reg_2,

output logic done,
output logic done_side, // 0 = left, 1 = right (only used for split mode)
output logic [ITERATION_COUNT_WIDTH-1:0] iteration_out // muxed between both threads

);

localparam NARROW_FRACTIONAL_BITS = NARROW_WIDTH - INTEGER_BITS;


reg signed [2*NARROW_WIDTH-1:0] sum_x_reg_1; //upper
reg signed [2*NARROW_WIDTH-1:0] sum_x_reg_2;
reg signed [2*NARROW_WIDTH-1:0] sum_y_reg_1;
reg signed [2*NARROW_WIDTH-1:0] sum_y_reg_2;

wire sum_x_reg_1_overflow_flag;
wire sum_x_reg_2_overflow_flag;
wire sum_y_reg_1_overflow_flag;
wire sum_y_reg_2_overflow_flag;


coord_flagger #(.NARROW_WIDTH(NARROW_WIDTH), .NARROW_FRACTIONAL_BITS(NARROW_FRACTIONAL_BITS), .INTEGER_BITS(INTEGER_BITS)) x_1 
(
.coordinate(sum_x_reg_1),
.flag(sum_x_reg_1_overflow_flag)
);
coord_flagger #(.NARROW_WIDTH(NARROW_WIDTH), .NARROW_FRACTIONAL_BITS(NARROW_FRACTIONAL_BITS), .INTEGER_BITS(INTEGER_BITS)) x_2 
(
.coordinate(sum_x_reg_2),
.flag(sum_x_reg_2_overflow_flag)
);
coord_flagger #(.NARROW_WIDTH(NARROW_WIDTH), .NARROW_FRACTIONAL_BITS(NARROW_FRACTIONAL_BITS), .INTEGER_BITS(INTEGER_BITS)) y_1 
(
.coordinate(sum_y_reg_1),
.flag(sum_y_reg_1_overflow_flag)
);
coord_flagger #(.NARROW_WIDTH(NARROW_WIDTH), .NARROW_FRACTIONAL_BITS(NARROW_FRACTIONAL_BITS), .INTEGER_BITS(INTEGER_BITS)) y_2 
(
.coordinate(sum_y_reg_2),
.flag(sum_y_reg_2_overflow_flag)
);



reg signed [NARROW_WIDTH-1:0] spare_x_reg_1;
reg signed [NARROW_WIDTH-1:0] spare_x_reg_2;


reg signed [2*NARROW_WIDTH-1:0] magnitude_reg_1; //upper
reg signed [2*NARROW_WIDTH-1:0] magnitude_reg_2;
reg [ITERATION_COUNT_WIDTH-1:0] iteration_reg_1;
reg [ITERATION_COUNT_WIDTH-1:0] iteration_reg_2;



typedef enum {T_IDLE, RUNNING} thread_state;
typedef enum {UNDEFINED, SPLIT, JOINED} joint_state;
typedef enum {C_IDLE, ALTER_SUM, X_SQUARED, Y_SQUARED, TWO_I_XY, ADD_COORD, ADD_JULIA, DONE} thread_cycle;

joint_state grouping_status;
thread_state left_thread;
thread_cycle left_cycle;

thread_state right_thread;
thread_cycle right_cycle;


wire signed [2*NARROW_WIDTH-1:0] encoded_x_reg_1;
wire signed [2*NARROW_WIDTH-1:0] encoded_x_reg_2;
wire signed [2*NARROW_WIDTH-1:0] encoded_y_reg_1;
wire signed [2*NARROW_WIDTH-1:0] encoded_y_reg_2;




sum_alter #(.NARROW_WIDTH(NARROW_WIDTH), .INTEGER_BITS(INTEGER_BITS)) mag_neg_encoder (
    .magnitude_negation_encoding(magnitude_negation_encoding),
    
    .sum_x_reg_1(sum_x_reg_1),
    .sum_x_reg_2(sum_x_reg_2),
    .sum_y_reg_1(sum_y_reg_1),
    .sum_y_reg_2(sum_y_reg_2),

    .changed_sum_x_reg_1(encoded_x_reg_1),
    .changed_sum_x_reg_2(encoded_x_reg_2),
    .changed_sum_y_reg_1(encoded_y_reg_1),
    .changed_sum_y_reg_2(encoded_y_reg_2)    
);



wire signed [2*NARROW_WIDTH-1:0] left_multiply_result;
logic [1:0] left_multiply_mode;

always_comb begin
    case(left_cycle) 
        X_SQUARED : left_multiply_mode = 2'b00;
        Y_SQUARED : left_multiply_mode = 2'b01;
        TWO_I_XY : left_multiply_mode = 2'b10;
        default : left_multiply_mode = 2'b00;
    endcase
end

wire signed [2*NARROW_WIDTH-1:0] right_multiply_result;
logic [1:0] right_multiply_mode;

always_comb begin
    case(right_cycle) 
        X_SQUARED : right_multiply_mode = 2'b00;
        Y_SQUARED : right_multiply_mode = 2'b01;
        TWO_I_XY : right_multiply_mode = 2'b10;
        default : right_multiply_mode = 2'b00;
    endcase
end

multiply #(.NARROW_WIDTH(NARROW_WIDTH)) left_multiply 
(
    .clk(clk),
    .mode(left_multiply_mode),

    .x(spare_x_reg_1),
    .y(sum_y_reg_1[NARROW_FRACTIONAL_BITS+NARROW_WIDTH-1:NARROW_FRACTIONAL_BITS]),

    .result(left_multiply_result)
);

multiply #(.NARROW_WIDTH(NARROW_WIDTH)) right_multiply 
(
    .clk(clk),
    .mode(right_multiply_mode),

    .x(spare_x_reg_2),
    .y(sum_y_reg_2[NARROW_FRACTIONAL_BITS+NARROW_WIDTH-1:NARROW_FRACTIONAL_BITS]),

    .result(right_multiply_result)
);

wire left_magnitude_flag;

magnitude_comparison_unit #(.NARROW_WIDTH(NARROW_WIDTH),.INTEGER_BITS(INTEGER_BITS)) left_magnitude 
(
    .magnitude(magnitude_reg_1),
    .mag_flag(left_magnitude_flag)
);

wire right_magnitude_flag;

magnitude_comparison_unit #(.NARROW_WIDTH(NARROW_WIDTH),.INTEGER_BITS(INTEGER_BITS)) right_magnitude 
(
    .magnitude(magnitude_reg_2),
    .mag_flag(right_magnitude_flag)
);

wire left_max_iteration_flag;

max_iteration_flagger #(.ITERATION_COUNT_WIDTH(ITERATION_COUNT_WIDTH), .LOWEST_MAX_ITERATION_POWER(LOWEST_MAX_ITERATION_POWER)) left_iteration_flagger (
    .iteration_count(iteration_reg_1),
    .max_iteration(max_iteration),
    .flag(left_max_iteration_flag)
);

wire right_max_iteration_flag;

max_iteration_flagger #(.ITERATION_COUNT_WIDTH(ITERATION_COUNT_WIDTH), .LOWEST_MAX_ITERATION_POWER(LOWEST_MAX_ITERATION_POWER)) right_iteration_flagger (
    .iteration_count(iteration_reg_2),
    .max_iteration(max_iteration),
    .flag(right_max_iteration_flag)
);




always_ff @(posedge clk) begin
    if(kill||rst) begin
        grouping_status <= UNDEFINED;
        left_thread <= T_IDLE;
        right_thread <= T_IDLE;
        left_cycle <= C_IDLE;
        right_cycle <= C_IDLE;
        magnitude_reg_1 <= '0;
        magnitude_reg_2 <= '0;
    end
    else begin
        if(start_left) begin
            magnitude_reg_1 <= '0;
            grouping_status <= SPLIT;
            left_thread <= RUNNING;


            iteration_reg_1 <= '0; 
            if(julia_type) begin //julia set setup
                sum_x_reg_1 <= $signed(starting_x_reg_1) <<< NARROW_FRACTIONAL_BITS;
                sum_y_reg_1 <= $signed(starting_y_reg_1) <<< NARROW_FRACTIONAL_BITS;
            end
            else begin // mandelbrot set setup
                sum_x_reg_1 <= '0;
                sum_y_reg_1 <= '0;             
            end

            left_cycle <= ALTER_SUM; 
        end
        else if(left_thread == RUNNING && grouping_status == SPLIT) begin
            case(left_cycle)
                ALTER_SUM : begin
                    //$display("[L] iter=%0d  sum_x=%0d  sum_y=%0d  mag=%0d",
                    //iteration_reg_1, $signed(sum_x_reg_1), $signed(sum_y_reg_1), $signed(magnitude_reg_1));
                    if(sum_x_reg_1_overflow_flag || sum_y_reg_1_overflow_flag) begin
                        left_cycle <= DONE;
                        //$display("[L] iter=%0d  OVERFLOW escape  sum_x=%0d sum_y=%0d", iteration_reg_1, sum_x_reg_1, sum_y_reg_1);
                    end
                    else begin
                        sum_x_reg_1 <= encoded_x_reg_1;
                        spare_x_reg_1 <= encoded_x_reg_1[NARROW_FRACTIONAL_BITS+NARROW_WIDTH-1:NARROW_FRACTIONAL_BITS];
                        sum_y_reg_1 <= encoded_y_reg_1;
                        if(left_max_iteration_flag) begin
                            left_cycle <= DONE;
                            //$display("[L] iter=%0d  MAX ITER escape", iteration_reg_1);
                        end
                        else left_cycle <= X_SQUARED;
                    end
                    
                end
                X_SQUARED : begin

                    left_cycle <= Y_SQUARED;
                end

                Y_SQUARED : begin
                    //pipeline register reads from x^2
                    sum_x_reg_1 <= left_multiply_result;
                    magnitude_reg_1 <= left_multiply_result;
                    //$display("    left_multiply_result=%0d", $signed(left_multiply_result));
                
                


                    left_cycle <= TWO_I_XY; 
                end

                TWO_I_XY : begin
                //pipeline register reads from y^2
                    //$display("    x^2 put in sum_x iter=%0d  sum_x=%0d  sum_y=%0d  mag=%0d",
                    //iteration_reg_1, $signed(sum_x_reg_1), $signed(sum_y_reg_1), $signed(magnitude_reg_1));

                    
                
                
                    //here we have a flag if the magnitude is greater from the comparitor
                    if(left_magnitude_flag) begin
                        left_cycle <= DONE;
                        //$display("[L] iter=%0d  MAGNITUDE escape  mag=%0d", iteration_reg_1, magnitude_reg_1);
                    end
                    else begin
                        sum_x_reg_1 <= sum_x_reg_1 - left_multiply_result;
                        magnitude_reg_1 <= magnitude_reg_1 + left_multiply_result;
                        if(julia_type) left_cycle <= ADD_JULIA;
                        else left_cycle <= ADD_COORD;
                    end
                end

                ADD_JULIA : begin
                    
                    if(left_magnitude_flag) begin
                        left_cycle <= DONE;
                        //$display("[L] iter=%0d  MAGNITUDE escape  mag=%0d", iteration_reg_1, magnitude_reg_1);
                    end
                    else begin
                        left_cycle <= ALTER_SUM;

                        sum_x_reg_1 <= sum_x_reg_1 + ($signed(julia_c_x) <<< NARROW_FRACTIONAL_BITS);
                        sum_y_reg_1 <= left_multiply_result + ($signed(julia_c_y) <<< NARROW_FRACTIONAL_BITS);
                        iteration_reg_1 <= iteration_reg_1 + 1;
                    end
                end

                ADD_COORD : begin

                    
                    
                    if(left_magnitude_flag) left_cycle <= DONE;
                    else begin
                        left_cycle <= ALTER_SUM;

                        sum_x_reg_1 <= sum_x_reg_1 + ($signed(starting_x_reg_1) <<< NARROW_FRACTIONAL_BITS);
                        sum_y_reg_1 <= left_multiply_result + ($signed(starting_y_reg_1) <<< NARROW_FRACTIONAL_BITS);
                        iteration_reg_1 <= iteration_reg_1 + 1;
                    end
                end

                DONE : begin
                    if((done_side == 0) && received) begin
                        left_thread <= T_IDLE;
                        left_cycle <= C_IDLE;
                    end
                end
                default : left_cycle <= left_cycle;
            endcase
        end







        if(start_right) begin
            magnitude_reg_2 <= '0;
            grouping_status <= SPLIT;
            right_thread <= RUNNING;


            iteration_reg_2 <= '0; 
            if(julia_type) begin //julia set setup
                sum_x_reg_2 <= $signed(starting_x_reg_2) <<< NARROW_FRACTIONAL_BITS;
                sum_y_reg_2 <= $signed(starting_y_reg_2) <<< NARROW_FRACTIONAL_BITS;
            end
            else begin // mandelbrot set setup
                sum_x_reg_2 <= '0;
                sum_y_reg_2 <= '0;             
            end

            right_cycle <= ALTER_SUM; 
        end
        else if(right_thread == RUNNING && grouping_status == SPLIT) begin
            case(right_cycle)
                ALTER_SUM : begin
                    if(sum_x_reg_2_overflow_flag || sum_y_reg_2_overflow_flag) begin
                        right_cycle <= DONE;
                    end
                    else begin
                        sum_x_reg_2 <= encoded_x_reg_2;
                        spare_x_reg_2 <= encoded_x_reg_2[NARROW_FRACTIONAL_BITS+NARROW_WIDTH-1:NARROW_FRACTIONAL_BITS];
                        sum_y_reg_2 <= encoded_y_reg_2;
                        if(right_max_iteration_flag) begin
                            right_cycle <= DONE;
                        end
                        else right_cycle <= X_SQUARED;
                    end
                    
                end
                X_SQUARED : begin

                    right_cycle <= Y_SQUARED;
                end

                Y_SQUARED : begin
                    //pipeline register reads from x^2
                    sum_x_reg_2 <= right_multiply_result;
                    magnitude_reg_2 <= right_multiply_result;
                
                


                    right_cycle <= TWO_I_XY; 
                end

                TWO_I_XY : begin
                //pipeline register reads from y^2
                
                    //here we have a flag if the magnitude is greater from the comparitor
                    if(right_magnitude_flag) right_cycle <= DONE;
                    else begin
                        sum_x_reg_2 <= sum_x_reg_2 - right_multiply_result;
                        magnitude_reg_2 <= magnitude_reg_2 + right_multiply_result;
                        if(julia_type) right_cycle <= ADD_JULIA;
                        else right_cycle <= ADD_COORD;
                    end
                end

                ADD_JULIA : begin
                    
                    
                    if(right_magnitude_flag) right_cycle <= DONE;
                    else begin
                        right_cycle <= ALTER_SUM;

                        sum_x_reg_2 <= sum_x_reg_2 + ($signed(julia_c_x) <<< NARROW_FRACTIONAL_BITS);
                        sum_y_reg_2 <= right_multiply_result + ($signed(julia_c_y) <<< NARROW_FRACTIONAL_BITS);
                        iteration_reg_2 <= iteration_reg_2 + 1;
                    end
                end

                ADD_COORD : begin
                    
                    
                    if(right_magnitude_flag) right_cycle <= DONE;
                    else begin
                        right_cycle <= ALTER_SUM;

                        sum_x_reg_2 <= sum_x_reg_2 + ($signed(starting_x_reg_2) <<< NARROW_FRACTIONAL_BITS);
                        sum_y_reg_2 <= right_multiply_result + ($signed(starting_y_reg_2) <<< NARROW_FRACTIONAL_BITS);
                        iteration_reg_2 <= iteration_reg_2 + 1;
                    end
                end

                DONE : begin
                    if((done_side == 1) && received) begin
                        right_thread <= T_IDLE;
                        right_cycle <= C_IDLE;
                    end
                end
                default : right_cycle <= right_cycle;
            endcase
        end
        if(start_wide) begin
            magnitude_reg_1 <= '0;
            magnitude_reg_2 <= '0;
            grouping_status <= JOINED;
            left_thread <= RUNNING;
            right_thread <= RUNNING;
        end 


    end
end



always_comb begin
    done = 0;
    done_side = 0;
    iteration_out = iteration_reg_1;
    if((grouping_status == JOINED) && (left_cycle == DONE)) begin
        done = 1;
        iteration_out = iteration_reg_1;
    end
    else if (grouping_status == SPLIT) begin
        if(left_cycle == DONE) begin
            done_side = 0;
            done = 1;
            iteration_out = iteration_reg_1;
        end
        if(right_cycle == DONE) begin //prioritises right side
            done_side = 1;
            done = 1;
            iteration_out = iteration_reg_2;
        end 
    end


end
endmodule