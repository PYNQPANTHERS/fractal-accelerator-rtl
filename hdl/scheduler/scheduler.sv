module schedular #(
    parameter int N = 10, // bit width of 1/16th width 
    parameter int Z = 3,  // max zoom level bit width
    parameter int C = 4   // width of colour        DO WE ACTUALLY NEED COLOUR PASSED IN NOW????
)(
    input logic clk, rst, comparator_flag_so_far, comparator_flag_done,
    input logic [C-1:0] colour_from_comparator,
    input logic [N-1:0] width_pixels,
    input logic [3:0] upper_box,
    output logic schedular_done_flag,
    output logic [9:0] x_coord_to_queue, y_coord_to_queue
);


typedef enum {IDLE, STARTUP, INCREASE_LEVEL, INCREASE_LEVEL_SECOND, BEGIN_SEARCH_BOX, WAIT, FILL_BOX, ADD_TO_STACK, DESCEND_LEVEL, FINISHED} my_states;
my_states current_state, next_state;

logic [N-1:0] top_left_x, top_left_y,
logic [1:0] box_id;
logic [N-1:0] pixel_width;
logic [Z-1:0] zoom_level;
logic pixel_generator_reset, popped_all_left, popped_all_top;   // CHECK INTERNAL RESETS. CAN THEY BE DONE BY HIGHER LEVEL MODULE??
logic all_left_quadrants, all_top_quadrants;
logic current_is_left, current_is_top;




// border pixel coordinate generator
border_pixel_chooser #(.N(N), .Z(Z)) pixel_generator(
    .clk(clk), .rst(rst), .rst_start(pixel_generator_reset), .top_left_x(top_left_x),
    .top_left_y(top_left_y), .zoom_level(zoom_level),
    .box_number(box_id), .width_pixels_x(pixel_width_x), .width_pixels_y(width_pixels_y),
    .x_coord(x coord out to queue), .y_coord(y coord out to queue));



// STACK LOGIC
typedef struct packed {
    logic [N-1:0] x, tmp_x;
    logic [N-1:0] y;
    logic [Z-1:0] zoom;
    logic [1:0]   box;
    logic         all_left, all_top; // flag high if all previous quardants in stack are left hand or top ones
    // in this case, the pixel width is one less than normal.
} stack_packet_s;

// stack signals
stack_packet_s stack_data_in;
stack_packet_s stack_data_out;

// packing
assign stack_data_in = '{x: top_left_x, y: top_left_y, zoom: zoom_level, box: box_id + 1'b1, all_left: all_left_quadrants, all_top: all_top_quadrants};

// logic for unpacking
logic [N-1:0] popped_top_left_x, popped_top_left_y;
logic [Z-1:0] popped_zoom;
logic [1:0]   popped_box_id;

// unpacking
assign popped_top_left_x = stack_data_out.x;
assign popped_top_left_y = stack_data_out.y;
assign popped_zoom = stack_data_out.zoom;
assign popped_box_id = stack_data_out.box;
assign popped_all_left = stack_data_out.all_left;
assign popped_all_top = stack_data_out.all_top;


// stack itself
logic stack_push, stack_pop, stack_rst;
logic stack_empty, stack_full;

localparam int STACK_WIDTH = $bits(stack_packet_s);
// instantiate stack
schedular_stack #(.WIDTH(STACK_WIDTH), .DEPTH(8)) my_stack (
    .clk(clk), .rst(stack_rst),
    .push(stack_push), .pop(stack_pop),
    .data_in(stack_data_in), .data_out(stack_data_out),
    .full(stack_full), .empty(stack_empty)
);





// a box is a left quadrant if it's 2'b00 or 2'b10 i.e. if box_id[0] == 1'b0
assign current_is_left = (box_id[0] == 1'b0);
// then extended to top quadrant
assign current_is_top = (box_id[1] == 1'b0);

// when going from box_id 01 to 10, have to minus left width from top_left_x, if all prev were leftmost,
// then that leftmost box has a smaller pixel_width than the current width by 2.
logic [1:0] box_transition;
assign box_transition = {all_left_quadrants & ~current_is_left, 1'b0};


always_ff @ (posedge clk or posedge rst) begin
    if(rst) begin
        current_state <= STARTUP;
        upper_box <= 4'd0;
        popped_all_left <= 1'b1;
        popped_all_top <= 1'b1;
    end
    else begin
        current_state <= next_state;
    end

    case(current_state)
        STARTUP: begin
            box_id <= '0;
            zoom_level <= '0;

            top_left_x <= ins_top_left_x;
            top_left_y <= ins_top_left_y;   // could be calculated if needed.
            // if(upper_box == 4'b0000 or upper_box == 4'b0100 or upper_box == 4'b1000 or upper_box = 4'b1100)
            // then begin with popped_all_left high
            if(upper_box[1:0] == 2'b0) begin
                popped_all_left <= 1'b1;
            end
            else begin
                popped_all_left <= 1'b0;
            end

            // if(upper_box == 4'b0000 or upper_box == 4'b0001 or upper_box == 4'b0010 or upper_box = 4'b0011)
            // then begin with popped_all_left high
            if (upper_box[3:2] == 2'b0) begin
                popped_all_top <= 1'b1;
            end
            else begin
                popped_all_top <= 1'b0;
            end
        end

        INCREASE_LEVEL_SECOND: begin
            top_left_x <= popped_top_left_x;
            top_left_y <= popped_top_left_y;
            zoom_level <= popped_zoom;
            box_id <= popped_box_id;
        end

        BEGIN_SEARCH_BOX: begin

        end

        DESCEND_LEVEL: begin
            zoom_level <= zoom_level + 1'b1;
            box_id <= 2'b0;
            zoom_level <= zoom_level + 1'b1;
            if(box_id == 2'b11) begin
               popped_all_left <= 1'b0;
               popped_all_top <= 1'b0; 
            end
        end

        FILL_BOX: begin

            if(box_id != 2'b11) begin
                box_id <= box_id + 1'b1;
                case(box_id)
                    2'b00: begin
                        top_left_x <= top_left_x + width_pixels_x;
                    end

                    2'b01: begin
                        top_left_x <= top_left_x - width_pixels_x + box_transition;               // is only needed when transitioning when in a leftmost box.
                        // set pixel width - 1 if popped_all_left == 1'b1 and current_is_left ==1'b0?? Best way to do it I think!!!!
                        top_left_y <= top_left_y + width_pixels_y;
                    end

                    2'b10: begin
                        top_left_x <= top_left_x + width_pixels_x;
                    end

                endcase
            end
        end

        FINISHED: begin
            upper_box <= upper_box + 1'b1;
        end
    endcase
end


// pixel width logic
logic [9:0] normal_width;       // CHANGE THIS with the value in normal_width in always comb.

always_comb begin

    // defaults
    next_state = current_state;
    stack_rst  = 1'b0;
    stack_push = 1'b0;
    stack_pop  = 1'b0;
    schedular_done_flag = 1'b0;
    pixel_generator_reset = 1'b0;


    // calculate standard width based on zoom level (standard for a left or topmost box)
    normal_width = (9'd256 >> (zoom_level + 2'd2)); // divide by 2*(zoom level) + 4 as starting at sixteenths. Choose original width!!!!!!!

    all_left_quadrants = popped_all_left && current_is_left;
    all_top_quadrants = popped_all_top && current_is_top;

    // pixel width modifiers (one greater if not a leftmost or topmost box)
    pixel_width_x = normal_width + ~all_left_quadrants; // width_modifiers;
    pixel_width_y = normal_width + ~all_top_quadrants;


    case(current_state)

        IDLE: begin
            if(instruction)begin
                next_state = STARTUP;
            end
            else begin
                next_state = IDLE
            end
        end

        STARTUP: begin
            stack_rst = 1'b1;
            next_state = BEGIN_SEARCH_BOX;
        end

        INCREASE_LEVEL: begin
            // read from the stack, all boxes in subbox done, increment box number taken from the stack by 1.
            // If this is greater than 2'b11, INCREASE_LEVEL again.
            if(stack_empty) begin
                next_state = FINISHED;
            end
            else begin
                stack_pop = 1'b1;           // Fire the pop signal
                next_state = INCREASE_LEVEL_SECOND;
            end
            // Note: stack_data_out will be valid on the NEXT clock cycle
            // when you transition to your next state.
        end

        INCREASE_LEVEL_SECOND: begin
            next_state = BEGIN_SEARCH_BOX;
        end

        // Currently adding 1 to what is saved in the stack, assuming then no need to remember place in stack.
        // Therefore can skip saving to stack for case box_id = 2'b11
        BEGIN_SEARCH_BOX: begin
            // adds coordinate jobs to the queue using the border_pixel_chooser module.
            if(zoom_level == 3'd4) begin        // need to be sure this max zoom level is correct. Starts at sixteenths = 0. 
                next_state = QUEUE_BOX;
            end
            else begin
                // resets pixel generator
                pixel_generator_reset = 1'b1;
                next_state = WAIT;
            end
        end


        // wait on flags from the comparator, expecting either, completed the queue, or, flag goes low.
        // If completed the queue, next_state = FILL_BOX.
        // Otherwise, if the comparator flag goes low, next_state = ADD_TO_STACK.
        WAIT: begin
            if(comparator_flag_done)
                next_state = FILL_BOX;
            else begin
                if(!comparator_flag_so_far)
                    // splits again
                    next_state = DESCEND_LEVEL;    
            end
        end

        QUEUE_BOX: begin
            // send all coords between topleftx, toplefty and topleftx + width, toplefty + width        TO DO!!!!!
            if(box_id == 2'b11) begin
                next_state = INCREASE_LEVEL;
            end
            else begin
                next_state = BEGIN_SEARCH_BOX;
            end
        end

        FILL_BOX: begin

            // send in the way that Lucca asked, i.e. top left and width.       TO DO!!!!!
            if(box_id == 2'b11) begin
                next_state = INCREASE_LEVEL;
            end
            else begin
                next_state = BEGIN_SEARCH_BOX;
            end
            // leaves area blank, this is then dealt with as the BRAM is transported to DRAM.
        end


        // adds to the stack and changes values of top_left etc.
        DESCEND_LEVEL: begin
            if(!stack_full) begin
                if(box_id != 2'b11) begin
                    // skip pushing the stack if box_id = 2'b11, can simply change values
                    stack_push = 1'b1;          // fire the push signal
                end
                next_state = BEGIN_SEARCH_BOX;
            end
        end


        FINISHED: begin
            next_state = IDLE;
            schedular_done_flag = 1'b1;     // note that the schedular_done_flag will only pulse for one tick
//            if(upper_box == 4'd15) begin
//                next_state = IDLE;
//                schedular_done_flag = 1'b1;     // note that the schedular_done_flag will only pulse for one tick
//            end
//            else begin
//                next_state = STARTUP;
//            end
            // When the highest level box is completed
            // increment box id by 1 if not already 2'b11
            // could mean finished all or just finished a sixteenth.
            // depends on what we want.
        end
    endcase
end
endmodule