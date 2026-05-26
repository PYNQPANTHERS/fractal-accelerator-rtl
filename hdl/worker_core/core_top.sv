module core_top 
#(parameter NARROW_WIDTH = 17, ITERATION_COUNT_WIDTH = 16)
(
input clk,
input rst,
input opcode_reset,
input live_data, // live_data is the signal the control unit sends to a core to tell the core it is sending data that needs to be stored 
input [12:0] opcode, //{Width[12], Julia[11], |x|[10], |y|[9], -x[8], -y[7], n[6:5], MaxIter[4:0]}
input [NARROW_WIDTH-1:0] data_in,

output wire ready,
output reg done,
output reg [ITERATION_COUNT_WIDTH-1:0] iteration_count
);

typedef enum {BOTH_IDLE, L_ACTIVE_R_IDLE, L_IDLE_R_ACTIVE, BOTH_ACTIVE, LOADING_OPCODES, LOADING_JULIA} state;
typedef enum {NARROW = 1'b0, WIDE = 1'b1} width;

wire left_busy;
wire right_busy;


state core_state;
width width_mode;

reg julia_type; //0 - mandel, 1 - julia
reg [3:0] magnitude_negation_encoding; //{abs x, abs y, neg x, neg y}
reg [1:0] n_exponent; // 00 = 2, 01 = 3, 10 = 4, 11 = 5
reg [4:0] max_iteration;

reg [NARROW_WIDTH-1:0] julia_c_x; 
reg [NARROW_WIDTH-1:0] julia_c_y;

//where coordinates are loaded in, and where they come back to after exponentiation.
reg [NARROW_WIDTH-1:0] starting_x_reg_1; //upper
reg [NARROW_WIDTH-1:0] starting_x_reg_2;
reg [NARROW_WIDTH-1:0] starting_y_reg_1;
reg [NARROW_WIDTH-1:0] starting_y_reg_2;

reg [NARROW_WIDTH-1:0] magnitude_reg_1; //upper
reg [NARROW_WIDTH-1:0] magnitude_reg_2;
reg [ITERATION_COUNT_WIDTH-1:0] iteration_reg_1;
reg [ITERATION_COUNT_WIDTH-1:0] iteration_reg_2;

//this is where the exponentiator adds up partial products as the 'end' register
//note : this mean the way the exponentiator multiplies is either:
//multiply what is in the sum register by the starting value,
//square what is in the sum registers 
reg [NARROW_WIDTH-1:0] sum_x_reg_1; //upper
reg [NARROW_WIDTH-1:0] sum_x_reg_2;
reg [NARROW_WIDTH-1:0] sum_y_reg_1;
reg [NARROW_WIDTH-1:0] sum_y_reg_2;



reg [1:0] general_counter; //1 bit counter

always_ff @(posedge clk) begin
    if(rst) begin
        core_state <= BOTH_IDLE;
        done <= 1'b0;
    end
    else begin
        if(opcode_reset) begin
            core_state <= LOADING_OPCODES;
            done <= 1'b0;
            general_counter <= 2'b0;
        end

        else begin
        
            case (core_state)
            
            LOADING_OPCODES : { 
                                width_mode <= opcode[12];
                                julia_type <= opcode[11];
                                magnitude_negation_encoding <= opcode[10:7];
                                n_exponent <= opcode[6:5];
                                max_iteration <= opcode[4:0];
                                if(opcode[11]) begin
                                    core_state <= LOADING_JULIA;
                                    general_counter <= 2'b00;
                                end
                                else core_state <= BOTH_IDLE;
                            }

            LOADING_JULIA : {
                                if(general_counter == 0) begin
                                    julia_c_x <= data_in;
                                    general_counter <= 2'b01;
                                end
                                else begin
                                    julia_c_y <= data_in;
                                    general_counter <= 2'b00;
                                    core_state <= BOTH_IDLE;
                                end
                            }


            BOTH_IDLE : {
                            if(live_data) begin
                                if(width_mode == NARROW) begin
                                    if(general_counter == 2'b00) begin
                                        starting_x_reg_1 <= data_in;
                                        general_counter <= 2'b01;
                                    end
                                    else begin
                                        starting_y_reg_1 <= data_in;
                                        general_counter <= 2'b00;
                                        core_state <= L_ACTIVE_R_IDLE;
                                    end
                                end
                                else begin
                                    case(general_counter)
                                        2'b00 : {starting_x_reg_2 <= data_in;
                                                general_counter <= 2'b01;}
                                        2'b01 : {starting_y_reg_2 <= data_in;
                                                general_counter <= 2'b10;}
                                        2'b10 : {starting_x_reg_1 <= data_in;
                                                general_counter <= 2'b11;}
                                        2'b11 : {starting_y_reg_1 <= data_in;
                                                general_counter <= 2'b00;
                                                core_state <= BOTH_ACTIVE;}
                                    endcase                             
                                end
                            
                            
                            end


                        }
            
            
            
            
            
             L_ACTIVE_R_IDLE : if(live_data) begin
                
                if(general_counter == 2'b00) begin
                    starting_x_reg_2 <= data_in;
                    general_counter <= 2'b01;
                end
                else begin
                    starting_y_reg_2 <= data_in;
                    general_counter <= 2'b00;

                    if(left_busy) core_state <= BOTH_ACTIVE;
                    else core_state <= L_IDLE_R_ACTIVE;
                end
             end
             

            L_IDLE_R_ACTIVE : if(live_data) begin
                
                if(general_counter == 2'b00) begin
                    starting_x_reg_1 <= data_in;
                    general_counter <= 2'b01;
                end
                else begin
                    starting_y_reg_1 <= data_in;
                    general_counter <= 2'b00;

                    if(right_busy) core_state <= BOTH_ACTIVE;
                    else core_state <= L_ACTIVE_R_IDLE;
                end
             end

            default : core_state <= core_state;
            endcase
        
        
        
        end






        
        
        end
    end
end



always_comb begin
    if(core_state == BOTH_ACTIVE) ready = 1'b0;
    else ready = 1'b1;
end





endmodule