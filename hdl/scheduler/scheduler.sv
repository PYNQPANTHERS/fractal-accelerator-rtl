
//     // Job queue push
//     output logic [17:0] sched_coord,
//     output logic        sched_push,
//     output logic        job_queue_flush,
//     input  logic        sched_stall,

//     // Comparator configuration
//     output logic        sched_reset,
//     output logic [8:0]  top_left_x,
//     output logic [8:0]  top_left_y,

//     output logic [8:0]  quad_size, done
//     output logic [10:0] comparator_expected_count, done

//     // Comparator results
//     input  logic        differ, called comparator_differ
//     input  logic        complete, called comparator_complete
//     input  logic [5:0]  ref_colour_o, called comparator_ref_colour_o

//     // Tile done (flood fill path)
//     output logic [255:0] sched_tile_done_set,




module scheduler #(
    parameter int COORD_W      = 8,  // coordinate bit width (image = 2**COORD_W pixels per axis)
    parameter int ZOOM_WIDTH   = 3,  // max zoom level bit width
    parameter int COLOUR_WIDTH = 6,  // width of colour
    parameter int TILE_W       = 16  // tile width/height in pixels (must be power of 2)
)(
    // general logic
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    start,
    output logic                    engine_done,

    // comparator communications
    input  logic                    differ,
    input  logic                    complete,
    input  logic [COLOUR_WIDTH-1:0] ref_colour_o,
    output logic                    sched_reset,
    output logic [10:0]             expected_count,
    output logic [COORD_W:0]        quad_size_x,
    output logic [COORD_W:0]        quad_size_y,
    output logic [COORD_W-1:0]      top_left_x,
    output logic [COORD_W-1:0]      top_left_y,

    // job queue logic
    output logic [COORD_W-1:0]      sched_x,
    output logic [COORD_W-1:0]      sched_y,
    output logic                    sched_first_time_queued,
    output logic                    sched_push,
    output logic                    sched_stall_out,  // unused; kept for symmetry
    input  logic                    sched_stall,
    input  logic                    gen_stall,        // queue almost-full: freeze border generator (1-cycle lookahead)
    output logic                    flush,
    input  logic                    job_queue_empty,

    // fill box logic
    output logic                    tt_wr_quad_en,
    output logic [COORD_W-1:0]      tt_wr_quad_tlx,
    output logic [COORD_W-1:0]      tt_wr_quad_tly,
    output logic [COORD_W:0]        tt_wr_quad_size,
    output logic [COLOUR_WIDTH-1:0] tt_wr_quad_colour,

    // BRAM to DRAM logic
    output logic [TOTAL_TILES-1:0]  sched_tile_done_set
);

    localparam int TILE_BITS      = $clog2(TILE_W);
    localparam int TILES_PER_AXIS = (1 << COORD_W) / TILE_W;
    localparam int TOTAL_TILES    = TILES_PER_AXIS * TILES_PER_AXIS;


typedef enum {IDLE, STARTUP, INCREASE_LEVEL, INCREASE_LEVEL_SECOND, BEGIN_SEARCH_BOX, WAIT, QUEUE_BOX_INIT, QUEUE_BOX, QUEUE_BOX_DRAIN, FILL_BOX, NEXT_BOX, DESCEND_LEVEL, FINISHED} my_states;
my_states current_state, next_state;

logic [COORD_W-1:0] tlx, tly, x_coord_to_queue, y_coord_to_queue;
logic border_first_time_flag, queue_first_time_flag;
logic [1:0] box_id;
logic [COORD_W:0] pixel_width_x, pixel_width_y;
logic [ZOOM_WIDTH-1:0] zoom_level;
logic pixel_generator_reset;
logic all_left_quadrants, all_top_quadrants;
logic current_is_left, current_is_top;
logic border_pixel_valid;
// Internal counter registers (only used by QUEUE_BOX)
logic [COORD_W-1:0] qbox_x, qbox_y;

border_pixel_generator #(.N(COORD_W)) pixel_generator(
    .clk(clk), .rst(rst), .rst_start(pixel_generator_reset),
    .advance(!gen_stall),
    .all_left_flag(all_left_quadrants), .all_top_flag(all_top_quadrants),
    .top_left_x(tlx), .top_left_y(tly), .box_id(box_id),
    .normal_width(normal_width), .x_coord(x_coord_to_queue),
    .y_coord(y_coord_to_queue), .first_time_queued(border_first_time_flag),
    .valid(border_pixel_valid));

// STACK LOGIC
localparam int STACK_W    = 2*COORD_W + ZOOM_WIDTH + 2 + 2;

logic [STACK_W-1:0] stack_data_in;
logic [STACK_W-1:0] stack_data_out;

// pack
// Store the descended box's id, position and ancestor flags. On
// INCREASE_LEVEL the entry is restored and routed through NEXT_BOX, which
// advances to box_id+1 and computes the sibling's position.
assign stack_data_in = {popped_all_top, popped_all_left,
                        box_id, zoom_level,
                        tly, tlx};

// unpack: split via concatenation to avoid parameterized bit-select bounds
logic [COORD_W-1:0]     _stk_tlx, _stk_tly;
logic [ZOOM_WIDTH-1:0]  _stk_zoom;
logic [1:0]             _stk_box;
logic                   _stk_all_left, _stk_all_top;
assign {_stk_all_top, _stk_all_left, _stk_box, _stk_zoom, _stk_tly, _stk_tlx} = stack_data_out;

logic [COORD_W-1:0]     popped_top_left_x, popped_top_left_y;
logic [ZOOM_WIDTH-1:0]  popped_zoom;
logic [1:0]             popped_box_id;
logic                   popped_all_left, popped_all_top;

// popped_all_left/top are registered in always_ff, not continuous assigns
assign popped_top_left_x  = _stk_tlx;
assign popped_top_left_y  = _stk_tly;
assign popped_zoom        = _stk_zoom;
assign popped_box_id      = _stk_box;

// stack itself
logic stack_push, stack_pop;
logic stack_empty, stack_full;

// instantiate stack
scheduler_stack #(.WIDTH(STACK_W), .DEPTH(10)) my_stack (
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

// pixel width of a left-column box at the current zoom/ancestor context.
// used by the 01→10 x-step in NEXT_BOX, which must subtract w00 (not the right-box width w01).
logic [COORD_W:0] pixel_width_x_left;

localparam logic [ZOOM_WIDTH-1:0] MAX_ZOOM = ZOOM_WIDTH'($clog2((1 << COORD_W) / TILE_W));

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
                tlx        <= '0;
                tly        <= '0;
            end

            INCREASE_LEVEL_SECOND: begin
                tlx             <= popped_top_left_x;
                tly             <= popped_top_left_y;
                zoom_level      <= popped_zoom;
                box_id          <= popped_box_id;
                // restore ancestor flags from the stack entry
                popped_all_left <= stack_out_all_left;
                popped_all_top  <= stack_out_all_top;
            end

            DESCEND_LEVEL: begin
                box_id          <= 2'b0;
                zoom_level      <= zoom_level + 1'b1;
                // save current all_left/top so the child level can use them
                popped_all_left <= all_left_quadrants;
                popped_all_top  <= all_top_quadrants;
            end

            QUEUE_BOX_INIT: begin
                qbox_x <= tlx;
                qbox_y <= tly;
            end

            QUEUE_BOX: begin
                if (!sched_stall) begin
                    if (qbox_x == tlx + pixel_width_x - 1'b1) begin
                        qbox_x <= tlx;
                        qbox_y <= qbox_y + 1'b1;
                    end
                    else begin
                        qbox_x <= qbox_x + 1'b1;
                    end
                end
            end

            NEXT_BOX: begin
                if(box_id != 2'b11) begin
                    box_id <= box_id + 1'b1;
                    case(box_id)
                        2'b00: begin
                            tlx <= tlx + pixel_width_x[COORD_W-1:0] - 1'b1;
                        end

                        2'b01: begin
                            tlx <= tlx - pixel_width_x_left[COORD_W-1:0] + 1'b1;
                            tly <= tly + pixel_width_y[COORD_W-1:0] - 1'b1;
                        end

                        2'b10: begin
                            tlx <= tlx + pixel_width_x[COORD_W-1:0] - 1'b1;
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
logic [COORD_W:0] normal_width;

always_comb begin

    // defaults
    next_state              = current_state;
    stack_push              = 1'b0;
    stack_pop               = 1'b0;
    pixel_generator_reset   = 1'b0;
    engine_done             = 1'b0;
    flush                   = 1'b0;
    sched_push              = 1'b0;
    queue_first_time_flag = 1'b0;
    sched_reset             = 1'b0;
    sched_stall_out         = 1'b0;
    tt_wr_quad_en           = 1'b0;
    tt_wr_quad_tlx          = '0;
    tt_wr_quad_tly          = '0;
    tt_wr_quad_size         = '0;
    tt_wr_quad_colour       = '0;
    pixel_width_x_left      = pixel_width_x;
    quad_size_x             = pixel_width_x;
    quad_size_y             = pixel_width_y;
    top_left_x              = tlx;
    top_left_y              = tly;

    // calculate standard width based on zoom level (standard for a left or topmost box)
    normal_width = 9'd256 >> (zoom_level);

    // zoom=0: no pixel-width correction applies (root level)
    // zoom=1: only the current box position determines left/top status
    // zoom>1: must also check all ancestors were left/top (stored in popped_all_left/top)
    if (zoom_level == '0) begin
        all_left_quadrants = 1'b1;
        all_top_quadrants  = 1'b1;
    end else if (zoom_level == ZOOM_WIDTH'(1)) begin
        all_left_quadrants = current_is_left;
        all_top_quadrants  = current_is_top;
    end else begin
        all_left_quadrants = popped_all_left && current_is_left;
        all_top_quadrants  = popped_all_top  && current_is_top;
    end

    // logic dictating which variable is sent to the queue.
    if (current_state == WAIT || current_state == QUEUE_BOX_INIT) begin
        sched_x = x_coord_to_queue;  // direct from pixel generator
        sched_y = y_coord_to_queue;
    end else if (current_state == QUEUE_BOX) begin
        sched_x = qbox_x;            // from counter
        sched_y = qbox_y;
    end else begin
        sched_x = '0;
        sched_y = '0;
    end

    // pixel width modifiers (one greater if not a leftmost or topmost box)
    pixel_width_x = all_left_quadrants ? normal_width : normal_width + 1'b1;
    pixel_width_y = all_top_quadrants  ? normal_width : normal_width + 1'b1;

    // width of a left-column box (box 00 / box 10 equivalent).
    // at zoom≤1, a left box always has all_left=1 → no +1 correction.
    // at zoom>1, inherits popped_all_left from the ancestor chain.
    if (zoom_level <= '0)
        pixel_width_x_left = normal_width;
    else
        pixel_width_x_left = popped_all_left? normal_width : normal_width +1'b1;

    // perimeter of the box (2W + 2H - 4); must match the generator's emit count,
    // whose effective extent is pixel_width_x/y
    expected_count = (pixel_width_x << 1) + (pixel_width_y << 1) - 11'd4;

    sched_first_time_queued = (zoom_level == '0) ?
                                1'b1 : ((current_state == WAIT)? border_first_time_flag : queue_first_time_flag;)

    case(current_state)

        IDLE: begin
            if(start)begin
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
            // Restored box_id is the descended box; NEXT_BOX advances to the
            // sibling (box_id+1) and positions it correctly before searching.
            next_state = NEXT_BOX;
        end

        BEGIN_SEARCH_BOX: begin
            pixel_generator_reset = 1'b1;
            sched_reset           = 1'b1;
            next_state            = WAIT;
        end

        WAIT: begin
            if (complete) begin
                next_state = FILL_BOX;
            end else if (differ) begin
                // colour mismatch — descend or queue all pixels at leaf
                if (zoom_level == MAX_ZOOM) begin
                    next_state = QUEUE_BOX_INIT;
                end else begin
                    next_state = DESCEND_LEVEL;
                    // flush      = 1'b1;
                end
            end else begin
                // still collecting border pixels
                if (border_pixel_valid && !sched_stall)
                    sched_push = 1'b1;
            end
        end

        QUEUE_BOX_INIT: begin
            next_state = QUEUE_BOX;
        end

        QUEUE_BOX: begin
            if (!sched_stall) begin
                sched_push = 1'b1;
                // flag interior pixels (not on the perimeter of this box)
                if ((qbox_x != tlx) &&
                    ({1'b0, qbox_x} != {1'b0, tlx} + pixel_width_x - 1'b1) &&
                    (qbox_y != tly) &&
                    ({1'b0, qbox_y} != {1'b0, tly} + pixel_width_y - 1'b1))
                    queue_first_time_flag = 1'b1;
                if ((sched_x == tlx + pixel_width_x[COORD_W-1:0] - 1'b1) &&
                    (sched_y == tly + pixel_width_y[COORD_W-1:0] - 1'b1)) begin
                    // if (box_id == 2'b11) next_state = INCREASE_LEVEL;
                    // else                 next_state = NEXT_BOX;
                    next_state = QUEUE_BOX_DRAIN;
                end
            end
        end

        QUEUE_BOX_DRAIN: begin
            if (job_queue_empty) begin
                if (box_id == 2'b11) next_state = INCREASE_LEVEL;
                else                 next_state = NEXT_BOX;
            end
        end

        FILL_BOX: begin
            tt_wr_quad_en     = 1'b1;
            tt_wr_quad_tlx    = all_left_quadrants ? tlx : tlx + 1'b1;
            tt_wr_quad_tly    = all_top_quadrants  ? tly : tly + 1'b1;
            tt_wr_quad_size   = normal_width;
            tt_wr_quad_colour = ref_colour_o;
            if(zoom_level == '0) begin
                next_state = FINISHED;
            end
            else begin
                if(box_id == 2'b11) begin
                    next_state = INCREASE_LEVEL;
                end
                else begin
                    next_state = NEXT_BOX;
                end
            end
        end

        NEXT_BOX: begin
            next_state = BEGIN_SEARCH_BOX;
        end

        // adds to the stack and changes values of top_left etc.
        DESCEND_LEVEL: begin
            flush = 1'b1;
            if(!stack_full) begin
                if((box_id != 2'b11) && (zoom_level != '0)) begin
                    // skip pushing the stack if box_id = 2'b11, can simply change values
                    stack_push = 1'b1;          // fire the push signal
                end
                next_state = BEGIN_SEARCH_BOX;
            end
            // $display("DESCEND: box_id=%0b zoom=%0d push=%0b", box_id, zoom_level, stack_push);
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

// ── sched_tile_done_set ─────────────────────────────────────────────────
// One bit per TILE_W×TILE_W tile. Set for FILL_BOX (combinational from tt_wr_quad_en).

logic [COORD_W:0]         fill_x_end, fill_y_end;
localparam int TILE_IDX_BITS = $clog2(TILES_PER_AXIS);
logic [TILE_IDX_BITS-1:0]  tile_c0, tile_c1, tile_r0, tile_r1;
logic [TILES_PER_AXIS-1:0] tile_col_mask, tile_row_mask;
logic [TOTAL_TILES-1:0]   tile_done_mask;

assign fill_x_end = {1'b0, tt_wr_quad_tlx} + tt_wr_quad_size - 1'b1;
assign fill_y_end = {1'b0, tt_wr_quad_tly} + tt_wr_quad_size - 1'b1;
assign tile_c0 = tt_wr_quad_tlx[7:TILE_BITS];
assign tile_r0 = tt_wr_quad_tly[7:TILE_BITS];
assign tile_c1 = fill_x_end[7:TILE_BITS];
assign tile_r1 = fill_y_end[7:TILE_BITS];

always_comb begin
    for (int c = 0; c < TILES_PER_AXIS; c++)
        tile_col_mask[c] = (c >= int'(tile_c0)) && (c <= int'(tile_c1));
    for (int r = 0; r < TILES_PER_AXIS; r++)
        tile_row_mask[r] = (r >= int'(tile_r0)) && (r <= int'(tile_r1));
    for (int r = 0; r < TILES_PER_AXIS; r++)
        for (int c = 0; c < TILES_PER_AXIS; c++)
            tile_done_mask[r*TILES_PER_AXIS + c] = tile_row_mask[r] & tile_col_mask[c];
end

// One-cycle combinational pulse — per_sixteenth_engine latches it
assign sched_tile_done_set = tt_wr_quad_en ? tile_done_mask : '0;

endmodule