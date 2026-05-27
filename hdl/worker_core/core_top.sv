// needs to be updated with opcodes coming through datapath




module core_top 
#(parameter NARROW_WIDTH = 18, ITERATION_COUNT_WIDTH = 16)
(
input clk,
input rst,
input opcode_reset,
input live_data, // live_data is the signal the control unit sends to a core to tell the core it is sending data that needs to be stored 
input [10:0] opcode, //{Width[10], Julia[9], |x|[8], |y|[7], -x[6], -y[5], MaxIter[4:0]}
input [NARROW_WIDTH-1:0] data_in,

//this is to communicate to stack when done
output done,
output side_done, //0 = left, 1 = right
input received,



output wire ready,
output reg [ITERATION_COUNT_WIDTH-1:0] iteration_count
);

typedef enum {BOTH_IDLE, L_ACTIVE_R_IDLE, L_IDLE_R_ACTIVE, BOTH_ACTIVE, LOADING_OPCODES, LOADING_JULIA} state;
typedef enum {NARROW = 1'b0, WIDE = 1'b1} width;


reg start_left;
reg start_right; //signals to multiply cores to start working
reg start_wide;

reg received_during_live_signal; // this is essential to identify if we have had the result of a core acknowledged whilst loading another core.

state core_state;
width width_mode;

reg julia_type; //0 - mandel, 1 - julia
reg [3:0] magnitude_negation_encoding; //{abs x, abs y, neg x, neg y}
reg [4:0] max_iteration;

reg [NARROW_WIDTH-1:0] julia_c_x; 
reg [NARROW_WIDTH-1:0] julia_c_y;

//where coordinates are loaded in, and where they come back to after exponentiation.
reg [NARROW_WIDTH-1:0] starting_x_reg_1; //upper
reg [NARROW_WIDTH-1:0] starting_x_reg_2;
reg [NARROW_WIDTH-1:0] starting_y_reg_1;
reg [NARROW_WIDTH-1:0] starting_y_reg_2;



//this is where the exponentiator adds up partial products as the 'end' register
//note : this mean the way the exponentiator multiplies is either:
//multiply what is in the sum register by the starting value,
//square what is in the sum registers 




reg [1:0] general_counter; //1 bit counter

always_ff @(posedge clk) begin
    if(rst) begin
        core_state <= BOTH_IDLE;
        done <= 1'b0;
        start_left <= 1'b0;
        start_right <= 1'b0;
        start_wide <= 1'b0;
        received_during_live_signal <= 1'b0;
    end
    else begin
        if(opcode_reset) begin
            core_state <= LOADING_OPCODES;
            done <= 1'b0;
            general_counter <= 2'b0;
            start_left <= 1'b0;
            start_right <= 1'b0;
            start_wide <= 1'b0;
            received_during_live_signal <= 1'b0;
        end

        else begin
        
            case (core_state)
            
            LOADING_OPCODES : begin 
                                width_mode <= opcode[10];
                                julia_type <= opcode[9];
                                magnitude_negation_encoding <= opcode[8:5];
                                max_iteration <= opcode[4:0];
                                if(opcode[11]) begin
                                    core_state <= LOADING_JULIA;
                                    general_counter <= 2'b00;
                                end
                                else core_state <= BOTH_IDLE;
            end

            LOADING_JULIA : begin
                                if(general_counter == 0) begin
                                    julia_c_x <= data_in;
                                    general_counter <= 2'b01;
                                end
                                else begin
                                    julia_c_y <= data_in;
                                    general_counter <= 2'b00;
                                    core_state <= BOTH_IDLE;
                                end
            end


            BOTH_IDLE : begin
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
                                        start_left <= 1'b1;
                                    end
                                end
                                else begin
                                    case(general_counter)
                                        2'b00 : begin 
                                                starting_x_reg_2 <= data_in;
                                                general_counter <= 2'b01;
                                                end
                                        2'b01 : begin 
                                                starting_y_reg_2 <= data_in;
                                                general_counter <= 2'b10;
                                                end
                                        2'b10 : begin 
                                                starting_x_reg_1 <= data_in;
                                                general_counter <= 2'b11;
                                                end
                                        2'b11 : begin
                                                starting_y_reg_1 <= data_in;
                                                general_counter <= 2'b00;
                                                core_state <= BOTH_ACTIVE;
                                                start_wide <= 1'b1;
                                                end

                                    endcase                             
                                end
                            
                            
                            end


            end
            
            
            
            // need to get logic correct for when both new data and received arrive
            
             L_ACTIVE_R_IDLE : 
             
            begin
            start_left <= 1'b0; 
            if(live_data) begin
                
                if(general_counter == 2'b00) begin
                    if(received) received_during_live_signal <= 1'b1;
                    starting_x_reg_2 <= data_in;
                    general_counter <= 2'b01;
                end
                else begin
                    starting_y_reg_2 <= data_in;
                    general_counter <= 2'b00;

                    if(received_during_live_signal || received) begin
                        core_state <= L_IDLE_R_ACTIVE;
                        received_during_live_signal <= 1'b0;
                    end
                    else begin
                        core_state <= BOTH_ACTIVE;
                    end


                    start_right<= 1'b1;
                end
             end
            else if (received) begin
                core_state <= BOTH_IDLE;
            end
            end
             

            L_IDLE_R_ACTIVE : 
            begin
            start_right <= 1'b0; 
            
            if(live_data) begin
               
                if(general_counter == 2'b00) begin
                    if(received) received_during_live_signal <= 1'b1;
                    starting_x_reg_1 <= data_in;
                    general_counter <= 2'b01;
                end
                else begin
                    starting_y_reg_1 <= data_in;
                    general_counter <= 2'b00;

                    if(received_during_live_signal || received) begin
                        core_state <= L_ACTIVE_R_IDLE;
                        received_during_live_signal <= 1'b0;
                    end
                    else begin
                        core_state <= BOTH_ACTIVE;
                    end

                    start_left <= 1'b1;
                end
             end
            else if (received) begin
                core_state <= BOTH_IDLE;
            end
            end

            BOTH_ACTIVE : 
            begin
                start_left <= 1'b0;
                start_right <= 1'b0;
                start_wide <= 1'b0;


                if(received) begin
                    if(width_mode == WIDE) begin
                        core_state <= BOTH_IDLE;
                    end
                    else begin
                        if(side_done) begin
                            core_state <= L_ACTIVE_R_IDLE;
                        end
                        else begin
                            core_state <= L_IDLE_R_ACTIVE;
                        end
                    end

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