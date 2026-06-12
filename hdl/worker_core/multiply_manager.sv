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

localparam NARROW_FRACTIONAL_BITS = NARROW_WIDTH - INTEGER_BITS; //16

reg signed [2*NARROW_WIDTH-1:0] sum_x_reg_1; //upper
reg signed [2*NARROW_WIDTH-1:0] sum_x_reg_2; 
reg signed [2*NARROW_WIDTH-1:0] sum_y_reg_1;
reg signed [2*NARROW_WIDTH-1:0] sum_y_reg_2;

reg signed [2*NARROW_WIDTH-1:0] wide_partial_1;
reg signed [2*NARROW_WIDTH-1:0] wide_partial_2;

wire sum_x_reg_1_overflow_flag;
wire sum_x_reg_2_overflow_flag;
wire sum_y_reg_1_overflow_flag;
wire sum_y_reg_2_overflow_flag;

logic is_wide;

coord_flagger #(.NARROW_WIDTH(NARROW_WIDTH), .NARROW_FRACTIONAL_BITS(NARROW_FRACTIONAL_BITS), .INTEGER_BITS(INTEGER_BITS)) x_1 
(
.coordinate(sum_x_reg_1),
.is_wide(is_wide),
.flag(sum_x_reg_1_overflow_flag)
);
coord_flagger #(.NARROW_WIDTH(NARROW_WIDTH), .NARROW_FRACTIONAL_BITS(NARROW_FRACTIONAL_BITS), .INTEGER_BITS(INTEGER_BITS)) x_2 
(
.coordinate(sum_x_reg_2),
.is_wide(is_wide),
.flag(sum_x_reg_2_overflow_flag)
);
coord_flagger #(.NARROW_WIDTH(NARROW_WIDTH), .NARROW_FRACTIONAL_BITS(NARROW_FRACTIONAL_BITS), .INTEGER_BITS(INTEGER_BITS)) y_1 
(
.coordinate(sum_y_reg_1),
.is_wide(is_wide),
.flag(sum_y_reg_1_overflow_flag)
);
coord_flagger #(.NARROW_WIDTH(NARROW_WIDTH), .NARROW_FRACTIONAL_BITS(NARROW_FRACTIONAL_BITS), .INTEGER_BITS(INTEGER_BITS)) y_2 
(
.coordinate(sum_y_reg_2),
.is_wide(is_wide),
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
typedef enum {W_IDLE, W_ALTER_SUM, W_X_SQUARED, W_X_SQUARED_2, W_Y_SQUARED, W_Y_SQUARED_2, W_TWO_I_XY, W_TWO_I_XY_2, W_ADD_COORD, W_ADD_JULIA, W_DONE} wide_cycle;

joint_state grouping_status;

thread_state left_thread;
thread_cycle left_cycle;

thread_state right_thread;
thread_cycle right_cycle;

wide_cycle joint_cycle;

wire signed [2*NARROW_WIDTH-1:0] encoded_x_reg_1;
wire signed [2*NARROW_WIDTH-1:0] encoded_x_reg_2;
wire signed [2*NARROW_WIDTH-1:0] encoded_y_reg_1;
wire signed [2*NARROW_WIDTH-1:0] encoded_y_reg_2;

logic signed [NARROW_WIDTH-1:0] multiply_operand_A_1;
logic signed [NARROW_WIDTH-1:0] multiply_operand_A_2;

logic signed [NARROW_WIDTH-1:0] multiply_operand_B_1;
logic signed [NARROW_WIDTH-1:0] multiply_operand_B_2;

logic signed [NARROW_WIDTH-1:0] x_high;
logic signed [NARROW_WIDTH-1:0] x_low; // still signed needs 0 pad at the MSB

logic signed [NARROW_WIDTH-1:0] y_high;
logic signed [NARROW_WIDTH-1:0] y_low;

(* keep_hierarchy = "yes" *) sum_alter #(.NARROW_WIDTH(NARROW_WIDTH), .INTEGER_BITS(INTEGER_BITS)) mag_neg_encoder (
    .magnitude_negation_encoding(magnitude_negation_encoding),
    .is_wide(is_wide),
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

wire signed [2*NARROW_WIDTH-1:0] right_multiply_result;
logic [1:0] right_multiply_mode;

always_comb begin

    case (grouping_status) 
        SPLIT : begin
            is_wide = 1'b0;

            multiply_operand_A_1 = spare_x_reg_1;
            multiply_operand_A_2 = spare_x_reg_2;

            multiply_operand_B_1 = sum_y_reg_1[NARROW_FRACTIONAL_BITS+NARROW_WIDTH-1:NARROW_FRACTIONAL_BITS];
            multiply_operand_B_2 = sum_y_reg_2[NARROW_FRACTIONAL_BITS+NARROW_WIDTH-1:NARROW_FRACTIONAL_BITS];

            case(left_cycle) 
                X_SQUARED : left_multiply_mode = 2'b00;
                Y_SQUARED : left_multiply_mode = 2'b01;
                TWO_I_XY : left_multiply_mode = 2'b10;
                default : left_multiply_mode = 2'b00;
            endcase

            case(right_cycle) 
                X_SQUARED : right_multiply_mode = 2'b00;
                Y_SQUARED : right_multiply_mode = 2'b01;
                TWO_I_XY : right_multiply_mode = 2'b10;
                default : right_multiply_mode = 2'b00;
            endcase
        end

        JOINED : begin

            is_wide = 1'b1;

            case(joint_cycle) 
                W_X_SQUARED : begin // x_high_high & y_high_high
                    left_multiply_mode = 2'b00;
                    right_multiply_mode = 2'b00;

                    //multiplier 1
                    multiply_operand_A_1 = x_high;
                    multiply_operand_B_1 = x_low;
                    
                    //multiplier 2
                    multiply_operand_A_2 = y_high;                    
                    multiply_operand_B_2 = y_low;

                end
                W_X_SQUARED_2 : begin // x_high_low << 1 & y_high_low << 1
                    left_multiply_mode = 2'b10;
                    right_multiply_mode = 2'b10;
                end
                W_Y_SQUARED : begin // x_low_low & y_low_low
                    left_multiply_mode = 2'b01;
                    right_multiply_mode = 2'b01;
                end
                W_Y_SQUARED_2 : begin
                    left_multiply_mode = 2'b00;
                    right_multiply_mode = 2'b00;

                    // swap for cross term 2
                    multiply_operand_B_1 = y_low;

                    multiply_operand_B_2 = x_low;
                end
                W_TWO_I_XY  : begin
                    left_multiply_mode = 2'b11;
                    right_multiply_mode = 2'b11;

                    // swap for cross term 2
                    multiply_operand_A_2 = y_low;

                    multiply_operand_B_1 = y_high;
                end
                W_TWO_I_XY_2 : begin
                    left_multiply_mode = 2'b11;
                    right_multiply_mode = 2'b11;
                end
                default : begin
                    left_multiply_mode = 2'b00;
                    right_multiply_mode = 2'b00;
                end
            endcase
        end

        default : begin
            left_multiply_mode = 2'b00;
            right_multiply_mode = 2'b00;

            is_wide = 1'b0;
        end
    endcase
end

(* keep_hierarchy = "yes" *) multiply #(.NARROW_WIDTH(NARROW_WIDTH)) left_multiply 
(
    .clk(clk),
    .mode(left_multiply_mode),

    .operand_A(multiply_operand_A_1),
    .operand_B(multiply_operand_B_1),


    .result(left_multiply_result)
);

(* keep_hierarchy = "yes" *) multiply #(.NARROW_WIDTH(NARROW_WIDTH)) right_multiply 
(
    .clk(clk),
    .mode(right_multiply_mode),

    .operand_A(multiply_operand_A_2),
    .operand_B(multiply_operand_B_2),


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
                        sum_y_reg_1 <= $signed(left_multiply_result <<< 1) + ($signed(julia_c_y) <<< NARROW_FRACTIONAL_BITS);
                        iteration_reg_1 <= iteration_reg_1 + 1;
                    end
                end

                ADD_COORD : begin


                    
                    if(left_magnitude_flag) left_cycle <= DONE;
                    else begin
                        left_cycle <= ALTER_SUM;
                        sum_x_reg_1 <= sum_x_reg_1 + ($signed(starting_x_reg_1) <<< NARROW_FRACTIONAL_BITS);
                        sum_y_reg_1 <= $signed(left_multiply_result <<< 1) + ($signed(starting_y_reg_1) <<< NARROW_FRACTIONAL_BITS);
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
                        sum_y_reg_2 <= $signed(right_multiply_result <<< 1) + ($signed(julia_c_y) <<< NARROW_FRACTIONAL_BITS);
                        iteration_reg_2 <= iteration_reg_2 + 1;                    
                    end
                end

                ADD_COORD : begin

                    
                    if(right_magnitude_flag) right_cycle <= DONE;
                    else begin
                        right_cycle <= ALTER_SUM;
                        sum_x_reg_2 <= sum_x_reg_2 + ($signed(starting_x_reg_2) <<< NARROW_FRACTIONAL_BITS);
                        sum_y_reg_2 <= $signed(right_multiply_result <<< 1) + ($signed(starting_y_reg_2) <<< NARROW_FRACTIONAL_BITS);
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

            iteration_reg_1 <= '0;

            if(julia_type) begin //julia set setup

                {sum_x_reg_1, sum_x_reg_2} <= {{INTEGER_BITS{starting_x_reg_1[NARROW_WIDTH-1]}}, starting_x_reg_1, starting_x_reg_2[NARROW_WIDTH-2:0], {2*NARROW_WIDTH-1{1'b0}}};
                {sum_y_reg_1, sum_y_reg_2} <= {{INTEGER_BITS{starting_y_reg_1[NARROW_WIDTH-1]}}, starting_y_reg_1, starting_y_reg_2[NARROW_WIDTH-2:0], {2*NARROW_WIDTH-1{1'b0}}};
                
                // $display("julia: enc=%b starting_x_reg_1=%18b starting_x_reg_2=%18b starting_y_reg_1=%18b starting_y_reg_2=%18b",
                //     magnitude_negation_encoding,
                //     starting_x_reg_1,
                //     starting_x_reg_2,
                //     starting_y_reg_1,
                //     starting_y_reg_2);

                wide_partial_1 <= '0;
                wide_partial_2 <= '0;
            end
            else begin // mandelbrot set setup
                sum_x_reg_1 <= '0;
                sum_x_reg_2 <= '0;

                sum_y_reg_1 <= '0;
                sum_y_reg_2 <= '0;

                wide_partial_1 <= '0;
                wide_partial_2 <= '0;
            end

            joint_cycle <= W_ALTER_SUM;
        end 
        else if(right_thread == RUNNING && left_thread == RUNNING && grouping_status == JOINED) begin
            case(joint_cycle)
                W_ALTER_SUM : begin
                    if(sum_x_reg_1_overflow_flag || sum_y_reg_1_overflow_flag) begin 
                        joint_cycle <= W_DONE;
                        // $display("sum overflow");
                        // $display("[%0t] OVERFLOW FLAGS: sum_x=%b sum_y=%b ? jumping to W_DONE",$time,sum_x_reg_1_overflow_flag,sum_y_reg_1_overflow_flag);
                        // $display("sum_x_reg_1 = %36b (raw int)", (sum_x_reg_1));
                        // $display("sum_y_reg_1 = %36b (raw int)", ((sum_y_reg_1)));
                        
                    end
                    else begin
                        //multiplier 1
                        x_high <= encoded_x_reg_1[2*NARROW_WIDTH-INTEGER_BITS-1:NARROW_FRACTIONAL_BITS];
                        x_low <= {1'b0, encoded_x_reg_1[NARROW_FRACTIONAL_BITS-1:0], encoded_x_reg_2[2*NARROW_WIDTH-1]}; //0 pad to keep unsigned

                        //multiplier 2
                        y_high <= encoded_y_reg_1[2*NARROW_WIDTH-INTEGER_BITS-1:NARROW_FRACTIONAL_BITS]; //y_high                        
                        y_low <= {1'b0, encoded_y_reg_1[NARROW_FRACTIONAL_BITS-1:0], encoded_y_reg_2[2*NARROW_WIDTH-1]}; //y_low (unsigned)

                        // $display("ALTER: is_wide=%b enc=%b x_in=%b\n x_out=%b\n y_in=%b\n y_out=%b\n",
                        //     is_wide,
                        //     magnitude_negation_encoding,
                        //     $signed(sum_x_reg_1),
                        //     $signed(encoded_x_reg_1),
                        //     $signed(sum_y_reg_1),
                        //     $signed(encoded_y_reg_1));

                        if(left_max_iteration_flag) joint_cycle <= W_DONE;
                        else joint_cycle <= W_X_SQUARED;
                    end
                    
                end

                W_X_SQUARED : begin
                    
                    joint_cycle <= W_X_SQUARED_2;
                end

                W_X_SQUARED_2 : begin
                    {sum_x_reg_1, sum_x_reg_2} <= $signed({left_multiply_result, {2*NARROW_WIDTH{1'b0}}}); //x_high_high
                    {wide_partial_1, wide_partial_2} <= $signed({right_multiply_result, {2*NARROW_WIDTH{1'b0}}}); //y_high_high   

                    joint_cycle <= W_Y_SQUARED;
                end

                W_Y_SQUARED : begin
                    
                    {sum_x_reg_1, sum_x_reg_2} <= $signed({sum_x_reg_1, sum_x_reg_2}) 
                    + $signed({{NARROW_WIDTH-2{left_multiply_result[2*NARROW_WIDTH-1]}}, left_multiply_result, {NARROW_WIDTH+2{1'b0}}}); //now contains x_high_high and x_high_low <<< 1
                    
                    {wide_partial_1, wide_partial_2} <= $signed({wide_partial_1, wide_partial_2}) 
                    + $signed({{NARROW_WIDTH-2{right_multiply_result[2*NARROW_WIDTH-1]}}, right_multiply_result, {NARROW_WIDTH+2{1'b0}}}); //now contains y_high_high and y_high_low <<< 1

                    joint_cycle <= W_Y_SQUARED_2;
                end

                W_Y_SQUARED_2 : begin
                    {sum_x_reg_1, sum_x_reg_2} <= $signed({sum_x_reg_1, sum_x_reg_2}) 
                    + $signed({{2*NARROW_WIDTH-2{1'b0}}, left_multiply_result, 2'b0}); //now contains x^2
                    
                    {wide_partial_1, wide_partial_2} <= $signed({wide_partial_1, wide_partial_2}) 
                    + $signed({{2*NARROW_WIDTH-2{1'b0}}, right_multiply_result, 2'b0}); //now contains y^2

                    if(left_magnitude_flag) joint_cycle <= W_DONE;
                    else begin
                        joint_cycle <= W_TWO_I_XY;
                    end
                end

                W_TWO_I_XY : begin
                    //here we have a flag if the magnitude is greater from the comparitor
                    {sum_x_reg_1, sum_x_reg_2} <= $signed({sum_x_reg_1, sum_x_reg_2}) - $signed({wide_partial_1, wide_partial_2}); //now contains x^2 - y^2

                    {magnitude_reg_1, magnitude_reg_2} <= $signed({sum_x_reg_1, sum_x_reg_2}) + $signed({wide_partial_1, wide_partial_2}); //now contains x^2 + y^2

                    {sum_y_reg_1, sum_y_reg_2} <= $signed({{NARROW_WIDTH-1{left_multiply_result[2*NARROW_WIDTH-1]}}, left_multiply_result, {NARROW_WIDTH+1{1'b0}}}) // taken from 2ixy_2 suspected cycle mismatch
                        + $signed({{NARROW_WIDTH-1{right_multiply_result[2*NARROW_WIDTH-1]}}, right_multiply_result, {NARROW_WIDTH+1{1'b0}}}); // now accumulating 2xy 

                    if(left_magnitude_flag) begin
                        joint_cycle <= W_DONE;
                    end else begin
                        joint_cycle <= W_TWO_I_XY_2;
                    end
                end

                W_TWO_I_XY_2 : begin
                    if(left_magnitude_flag) joint_cycle <= W_DONE;
                    else begin

                        // {sum_y_reg_1, sum_y_reg_2} <= $signed({{NARROW_WIDTH-1{left_multiply_result[2*NARROW_WIDTH-1]}}, left_multiply_result, {NARROW_WIDTH+1{1'b0}}}) 
                        // + $signed({{NARROW_WIDTH-1{right_multiply_result[2*NARROW_WIDTH-1]}}, right_multiply_result, {NARROW_WIDTH+1{1'b0}}}); // now accumulating 2xy    

                        {sum_y_reg_1, sum_y_reg_2} <= ($signed({sum_y_reg_1, sum_y_reg_2}) + $signed({left_multiply_result, {2*NARROW_WIDTH{1'b0}}}) + $signed({{2*NARROW_WIDTH-2{1'b0}}, right_multiply_result, 2'b0})) <<< 1;

                        if(julia_type) joint_cycle <= W_ADD_JULIA;
                        else joint_cycle <= W_ADD_COORD;
                    end
                end

                W_ADD_JULIA : begin
                    sum_x_reg_1 <= $signed(sum_x_reg_1) + ($signed({{NARROW_WIDTH{julia_c_x[NARROW_WIDTH-1]}}, julia_c_x}) <<< NARROW_FRACTIONAL_BITS);


                    sum_y_reg_1 <= $signed(sum_y_reg_1) + ($signed({{NARROW_WIDTH{julia_c_y[NARROW_WIDTH-1]}}, julia_c_y}) <<< NARROW_FRACTIONAL_BITS);
                    
                    iteration_reg_1 <= iteration_reg_1 + 1;
                    

                    if (left_magnitude_flag) joint_cycle <= W_DONE;
                    else joint_cycle <= W_ALTER_SUM;
                end

                W_ADD_COORD : begin
                    {sum_x_reg_1, sum_x_reg_2} <= $signed({sum_x_reg_1, sum_x_reg_2}) 
                    + $signed({{INTEGER_BITS{starting_x_reg_1[NARROW_WIDTH-1]}}, starting_x_reg_1, starting_x_reg_2[NARROW_WIDTH-2:0], {2*NARROW_WIDTH-1{1'b0}}});
                    
                    {sum_y_reg_1, sum_y_reg_2} <= $signed({sum_y_reg_1, sum_y_reg_2}) 
                    + $signed({{INTEGER_BITS{starting_y_reg_1[NARROW_WIDTH-1]}}, starting_y_reg_1, starting_y_reg_2[NARROW_WIDTH-2:0], {2*NARROW_WIDTH-1{1'b0}}});

                    iteration_reg_1 <= iteration_reg_1 + 1;

                    if (left_magnitude_flag) joint_cycle <= W_DONE;
                    else joint_cycle <= W_ALTER_SUM;
                end

                W_DONE : begin
                    if(done && received) begin
                        left_thread <= T_IDLE;
                        right_thread <= T_IDLE;
                        joint_cycle <= W_IDLE;
                    end
                end
                default : joint_cycle <= joint_cycle;
            endcase
        end

    end
end



always_comb begin
    done = 0;
    done_side = 0;
    iteration_out = iteration_reg_1;
    if((grouping_status == JOINED) && (joint_cycle == W_DONE)) begin
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

