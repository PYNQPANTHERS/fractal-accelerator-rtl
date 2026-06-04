
//     // Job queue push
//     output logic [17:0] sched_coord,
//     output logic        sched_push,
//     output logic        job_queue_flush,
//     input  logic        sched_stall,

//     // Comparator configuration
//     output logic        sched_reset,
//     output logic [8:0]  top_left_x,
//     output logic [8:0]  top_left_y,

//     output logic [8:0]  quad_size,
//     output logic [10:0] expected_count,

//     // Comparator results
//     input  logic        differ, called compartor_flag_so_far
//     input  logic        complete, called comparator_flag_done
//     input  logic [5:0]  ref_colour_o, called comparator_colour

//     // Tile done (flood fill path)
//     output logic [255:0] sched_tile_done_set,




module scheduler #(
    parameter int N = 8, // bit width of 1/16th width
    parameter int Z = 3,  // max zoom level bit width
    parameter int COLOUR_WIDTH = 4   // width of colour        DO WE ACTUALLY NEED COLOUR PASSED IN NOW????
)(
    // general logic
    input logic                     clk,
    input logic                     rst,
    input logic                     start,
    output logic                    engine_done,

    // comparator communications
    input logic                     comparator_flag_so_far,
    input logic                     comparator_flag_done,
    input logic [COLOUR_WIDTH-1:0]  comparator_colour,
    
    // job queue logic
    output logic [8:0]              jq_x_coord_to_queue, jq_y_coord_to_queue,
    output logic                    job_queue_push,
    output logic                    job_queue_flush,

    // fill box logic
    output logic                    tt_wr_quad_en,
    output logic [7:0]              tt_wr_quad_tlx,
    output logic [7:0]              tt_wr_quad_tly,
    output logic [7:0]              tt_wr_quad_size,
    output logic [COLOUR_WIDTH-1:0] tt_wr_quad_colour
);


typedef enum {IDLE, STARTUP, INCREASE_LEVEL, INCREASE_LEVEL_SECOND, BEGIN_SEARCH_BOX, WAIT, QUEUE_BOX_INIT, QUEUE_BOX, FILL_BOX, NEXT_BOX, ADD_TO_STACK, DESCEND_LEVEL, FINISHED} my_states;
my_states current_state, next_state;

logic [N-1:0] top_left_x, top_left_y, x_coord_to_queue, y_coord_to_queue;
logic [1:0] box_id;
logic [N-1:0] pixel_width_x, pixel_width_y;
logic [3:0] zoom_level;
logic pixel_generator_reset;
logic all_left_quadrants, all_top_quadrants;
logic current_is_left, current_is_top;
logic border_pixel_chooser_done;
// Internal counter registers (only used by QUEUE_BOX)
logic [N-1:0] qbox_x, qbox_y;

border_pixel_chooser #(.N(N)) pixel_generator(
    .clk(clk), .rst(rst), .rst_start(pixel_generator_reset),
    .all_left_flag(all_left_quadrants), .all_top_flag(all_top_quadrants),
    .top_left_x({1'b0, top_left_x}),       .top_left_y({1'b0, top_left_y}),
    .width_pixels_x({1'b0, pixel_width_x}), .width_pixels_y({1'b0, pixel_width_y}),
    .x_coord(x_coord_to_queue), .y_coord(y_coord_to_queue),
    .done_flag(border_pixel_chooser_done));



// STACK LOGIC
localparam int STACK_W    = 2*N + Z + 2 + 2;

logic [STACK_W-1:0] stack_data_in;
logic [STACK_W-1:0] stack_data_out;

// pack
assign stack_data_in = {all_top_quadrants, all_left_quadrants,
                        (box_id + 1'b1), zoom_level[2:0],
                        top_left_y, top_left_x};

// unpack: split via concatenation to avoid parameterized bit-select bounds
logic [N-1:0] _stk_tlx, _stk_tly;
logic [Z-1:0] _stk_zoom;
logic [1:0]   _stk_box;
logic         _stk_all_left, _stk_all_top;
assign {_stk_all_top, _stk_all_left, _stk_box, _stk_zoom, _stk_tly, _stk_tlx} = stack_data_out;

logic [N-1:0]   popped_top_left_x, popped_top_left_y;
logic [3:0]     popped_zoom;
logic [1:0]     popped_box_id;
logic           popped_all_left, popped_all_top;

// popped_all_left/top are registered in always_ff, not continuous assigns
assign popped_top_left_x  = _stk_tlx;
assign popped_top_left_y  = _stk_tly;
assign popped_zoom        = {1'b0, _stk_zoom};
assign popped_box_id      = _stk_box;

// stack itself
logic stack_push, stack_pop;
logic stack_empty, stack_full;

// instantiate stack
scheduler_stack #(.WIDTH(STACK_W), .DEPTH(3)) my_stack (
    .clk(clk), .rst(rst),
    .push(stack_push), .pop(stack_pop),
    .data_in(stack_data_in), .data_out(stack_data_out),
    .full(stack_full), .empty(stack_empty)
);




// a box is a left quadrant if it's 2'b00 or 2'b10 i.e. if box_id[0] == 1'b0
assign current_is_left = (box_id[0] == 1'b0);
// a box is a top quadrant if it's 2'b00 or 2'b01 i.e. if box_id[1] == 1'b0
assign current_is_top = (box_id[1] == 1'b0);

logic stack_out_all_left, stack_out_all_top;
assign stack_out_all_left = _stk_all_left;
assign stack_out_all_top  = _stk_all_top;

// pixel width of a notional left-column box at the current zoom/ancestor context.
// used by the 01→10 x-step in NEXT_BOX, which must subtract w00 (not the right-box width w01).
logic [8:0] pixel_width_x_left;


always_ff @ (posedge clk or posedge rst) begin
    if(rst) begin
        current_state   <= IDLE;
        popped_all_left <= 1'b0;
        popped_all_top  <= 1'b0;
    end
    else begin
        current_state <= next_state;
        case(current_state)
            STARTUP: begin
                box_id     <= '0;
                zoom_level <= '0;
                top_left_x <= '0;
                top_left_y <= '0;   // could be calculated if needed.
            end

            INCREASE_LEVEL_SECOND: begin
                top_left_x      <= popped_top_left_x;
                top_left_y      <= popped_top_left_y;
                zoom_level      <= popped_zoom;
                box_id          <= popped_box_id;
                // restore ancestor flags from the stack entry
                popped_all_left <= stack_out_all_left;
                popped_all_top  <= stack_out_all_top;
            end

            BEGIN_SEARCH_BOX: begin
                
            end

            WAIT: begin
                jq_x_coord_to_queue <= x_coord_to_queue;
                jq_y_coord_to_queue <= y_coord_to_queue;

                // if(!comparator_flag_so_far) begin
                //     job_queue_push <= 0;
                // end
                // else if(border_pixel_chooser_done) begin
                //     job_queue_push <= 0;
                // end
                // else begin
                //     job_queue_push <= 1;
                // end
            end

            DESCEND_LEVEL: begin
                box_id          <= 2'b0;
                zoom_level      <= zoom_level + 1'b1;
                // save current all_left/top so the child level can use them
                popped_all_left <= all_left_quadrants;
                popped_all_top  <= all_top_quadrants;
            end

            QUEUE_BOX_INIT: begin
                // jq_x_coord_to_queue <= top_left_x;
                // jq_y_coord_to_queue <= top_left_y;
                // job_queue_push      <= 1'b1;
                qbox_x <= top_left_x;
                qbox_y <= top_left_y;
            end

            QUEUE_BOX: begin
                // if (jq_x_coord_to_queue == top_left_x + pixel_width_x - 2'd2) begin
                //     jq_x_coord_to_queue <= top_left_x;
                //     jq_y_coord_to_queue <= jq_y_coord_to_queue + 1'b1;
                // end else begin
                //     jq_x_coord_to_queue <= jq_x_coord_to_queue + 1'b1;
                // end
                if (qbox_x == top_left_x + pixel_width_x - 2'd2) begin
                    qbox_x <= top_left_x;
                    qbox_y <= qbox_y + 1'b1;
                end
                else begin
                    qbox_x <= qbox_x + 1'b1;
                end
            end

            FILL_BOX: begin
                
            end

            NEXT_BOX: begin
                // job_queue_push <= 1'b0;
                if(box_id != 2'b11) begin
                    box_id <= box_id + 1'b1;
                    case(box_id)
                        2'b00: begin
                            top_left_x <= top_left_x + pixel_width_x - 1'b1;
                        end

                        2'b01: begin
                            top_left_x <= top_left_x - pixel_width_x_left + 1'b1;
                            top_left_y <= top_left_y + pixel_width_y - 1'b1;    // pixel_width_y here reflects box_id 01 (pre-increment),
                            // which is the correct top-row height
                        end

                        2'b10: begin
                            top_left_x <= top_left_x + pixel_width_x - 1'b1;
                        end
                    endcase
                end
            end

            FINISHED: begin

            end
        endcase
    end


end


// pixel width logic (256 >> zoom fits in 9 bits: range 16–256)
logic [8:0] normal_width;

always_comb begin

    // defaults
    next_state            = current_state;
    stack_push            = 1'b0;
    stack_pop             = 1'b0;
    pixel_generator_reset = 1'b0;
    engine_done           = 1'b0;
    job_queue_flush           = 1'b0;
    job_queue_push        = 1'b0;
    tt_wr_quad_en         = 1'b0;
    tt_wr_quad_tlx        = '0;
    tt_wr_quad_tly        = '0;
    tt_wr_quad_size       = '0;
    tt_wr_quad_colour     = '0;

    // calculate standard width based on zoom level (standard for a left or topmost box)
    normal_width = 9'd256 >> zoom_level;

    // zoom=0: no pixel-width correction applies (root level)
    // zoom=1: only the current box position determines left/top status
    // zoom>1: must also check all ancestors were left/top (stored in popped_all_left/top)
    if (zoom_level == 4'd0) begin
        all_left_quadrants = 1'b0;
        all_top_quadrants  = 1'b0;
    end else if (zoom_level == 4'd1) begin
        all_left_quadrants = current_is_left;
        all_top_quadrants  = current_is_top;
    end else begin
        all_left_quadrants = popped_all_left && current_is_left;
        all_top_quadrants  = popped_all_top  && current_is_top;
    end

    // logic dictating which variable is sent to the queue.
    if (current_state == WAIT || current_state == QUEUE_BOX_INIT) begin
        jq_x_coord_to_queue = x_coord_to_queue;  // direct from pixel generator
        jq_y_coord_to_queue = y_coord_to_queue;
    end else if (current_state == QUEUE_BOX) begin
        jq_x_coord_to_queue = qbox_x;            // from counter
        jq_y_coord_to_queue = qbox_y;
    end else begin
        jq_x_coord_to_queue = '0;
        jq_y_coord_to_queue = '0;
    end

    // pixel width modifiers (one greater if not a leftmost or topmost box)
    pixel_width_x = normal_width + ~all_left_quadrants;
    pixel_width_y = normal_width + ~all_top_quadrants;

    // width of a left-column box (box 00 / box 10 equivalent).
    // at zoom≤1, a left box always has all_left=1 → no +1 correction.
    // at zoom>1, inherits popped_all_left from the ancestor chain.
    if (zoom_level <= 4'd1)
        pixel_width_x_left = normal_width;
    else
        pixel_width_x_left = normal_width + ~popped_all_left;


    case(current_state)

        IDLE: begin
            if(start)begin            // TO DO!!!
                next_state = STARTUP;
            end
            else begin
                next_state = IDLE;
            end
        end

        STARTUP: begin
            next_state = BEGIN_SEARCH_BOX;
        end

        INCREASE_LEVEL: begin
            // read from the stack, all boxes in subbox done, increment box number taken from the stack by 1.
            // If this is greater than 2'b11, INCREASE_LEVEL again.
            if(stack_empty) begin
                next_state = FINISHED;
            end
            else begin
                stack_pop  = 1'b1;           // Fire the pop signal
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
            // resets pixel generator
            pixel_generator_reset = 1'b1;
            next_state = WAIT;
        end


        // wait on flags from the comparator, expecting either, completed the queue, or, flag goes low.
        // If completed the queue, next_state = FILL_BOX.
        // Otherwise, if the comparator flag goes low, next_state = ADD_TO_STACK.
        WAIT: begin
            if(comparator_flag_done)
                next_state = FILL_BOX;
            else begin
                if(!comparator_flag_so_far) begin
                    if(!border_pixel_chooser_done)
                        job_queue_push = 1'b1;
                    // splits again
                    if(zoom_level == 3'd4) begin        // need to be sure this max zoom level is correct. Starts at sixteenths = 0.
                        next_state = QUEUE_BOX_INIT;
                    end
                    else begin
                        next_state  = DESCEND_LEVEL;
                        job_queue_flush = 1'b1;
                    end
                end
            end
        end

        

        QUEUE_BOX_INIT: begin
            next_state = QUEUE_BOX;
            job_queue_push = 1'b1;
        end

        QUEUE_BOX: begin
            // Keep pushing every cycle until counter reaches end.
            // Termination is detected here combinationally so the
            // last pixel is pushed on the same cycle we exit.
            job_queue_push = 1'b1;
            if ((jq_x_coord_to_queue == top_left_x + pixel_width_x - 2'd2) && (jq_y_coord_to_queue == top_left_y + pixel_width_y - 2'd2)) begin
                next_state = NEXT_BOX;
            end
            else begin
                next_state = QUEUE_BOX;
            end
        end

        FILL_BOX: begin
            tt_wr_quad_en     = 1'b1;
            tt_wr_quad_tlx    = top_left_x;
            tt_wr_quad_tly    = top_left_y;
            tt_wr_quad_size   = normal_width;
            tt_wr_quad_colour = comparator_colour;
            next_state        = NEXT_BOX;
        end

        NEXT_BOX: begin
            if(box_id == 2'b11) begin
                next_state = INCREASE_LEVEL;
            end
            else begin
                next_state = BEGIN_SEARCH_BOX;
            end
        end

        // adds to the stack and changes values of top_left etc.
        DESCEND_LEVEL: begin
            if(!stack_full) begin
                if((box_id != 2'b11) && (zoom_level != '0)) begin
                    // skip pushing the stack if box_id = 2'b11, can simply change values
                    stack_push = 1'b1;          // fire the push signal
                end
                next_state = BEGIN_SEARCH_BOX;
            end
        end


        FINISHED: begin
            engine_done = 1'b1;
            next_state  = IDLE;
            // When the highest level box is completed
            // increment box id by 1 if not already 2'b11
            // could mean finished all or just finished a sixteenth.
            // depends on what we want.
        end
    endcase
end
endmodule
