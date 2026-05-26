module control_unit #(
    parameter int DATA_WIDTH = 17
) (
    input logic clk,
    input logic rst,
    input logic start_flag,
    input logic width_flag,
    input logic fractal_type,
    input logic iteration_count
);
    // state
    typedef enum data_type {IDLE, START } my_state;
    my_state current_state, next_state;


    // state ticker
    always_ff @(posedge clk) begin: state_ticker
        current_state <= next_state;
    end

    // state logic
    always_comb begin: state_logic
        case(current_state)

            IDLE:   if (start_flag) begin
                        next_state = START;
                    end
            START:


        endcase
    end

    // out logic
    always_comb begin: output_logic
        case(current_state)

            START: 
        endcase    
    end


    // core handler
    // need a ram for each iterator store each pixel need to be able to get address from core 
    // to pass final it count and pixel coord






    // call translate 
    logic op_code   [9:0]           =    {width_flag, fractal_type, iteration_count};
    logic data_path [DATA_WIDTH-1:0];

    translate cheezy_translator ()




    // call n cores
endmodule 