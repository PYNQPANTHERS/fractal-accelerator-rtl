// Mariani-Silver quad-tree scheduler for one 256x256 sixteenth

module scheduler #(
    parameter int COORD_W = 8   // coordinate bit width; max coord = 2**COORD_W - 1
) (
    input  logic        clk,
    input  logic        rst,
    input  logic        start,
    output logic        engine_done,

    // Job queue push
    output logic [COORD_W*2-1:0] sched_coord,
    output logic        sched_push,
    input  logic        sched_stall,
    output logic        flush,

    // Comparator configuration
    output logic        sched_reset,
    output logic [COORD_W-1:0] top_left_x,
    output logic [COORD_W-1:0] top_left_y,
    output logic [COORD_W:0]   quad_size,  // 9 bits: holds root size 256
    output logic [10:0] expected_count,

    // Comparator results
    input  logic        differ,
    input  logic        complete,
    input  logic [5:0]  ref_colour_o,

    // tile_table quad write (flood-fill path)
    output logic        tt_wr_quad_en,
    output logic [7:0]  tt_wr_quad_tlx,
    output logic [7:0]  tt_wr_quad_tly,
    output logic [8:0]  tt_wr_quad_size,  // 9-bit to hold root size 256
    output logic [5:0]  tt_wr_quad_colour,

    // Tile-done bits — set combinationally in the FILL state
    output logic [255:0] sched_tile_done_set
);

    typedef enum logic [3:0] {
        IDLE, STARTUP, SEARCH, PUSH_BORDER, WAIT_COMP,
        FILL, SPLIT, QUEUE_ALL,
        ADVANCE, ADVANCE2, FINISHED
    } state_t;
    state_t state;

    // Current box
    logic [COORD_W-1:0] cur_tlx, cur_tly;
    logic [2:0] cur_depth;
    logic [COORD_W:0] cur_sz;  

    logic [COORD_W-1:0] half_sz;
    assign half_sz = cur_sz[COORD_W:1];

    logic [2:0] child_depth;
    assign child_depth = cur_depth + 3'd1;

    // Border-walk state
    logic [1:0] b_phase;        // 0=top 1=right 2=bottom 3=left
    logic [COORD_W-1:0] b_cnt;

    // SPLIT: 0=push BR, 1=push BL, 2=push TR, 3=descend TL
    logic [1:0] split_cnt;

    logic [3:0] qa_x, qa_y;

    // Stack: {depth[2:0], tly[COORD_W-1:0], tlx[COORD_W-1:0]}
    localparam int STACK_W = 3 + COORD_W * 2;
    logic [STACK_W-1:0] stack_din, stack_dout;
    logic stack_push, stack_pop, stack_full, stack_empty;

    scheduler_stack #(.WIDTH(STACK_W), .DEPTH(16)) u_stack (
        .clk     (clk),
        .rst     (rst),
        .push    (stack_push),
        .pop     (stack_pop),
        .data_in (stack_din),
        .data_out(stack_dout),
        .full    (stack_full),
        .empty   (stack_empty)
    );

    // Iverilog doesn't support non-constant part-selects in always_*
    logic [COORD_W-1:0] cur_sz_lo;
    logic [4:0] tiles_per_side;
    logic [3:0] tile_x0, tile_y0;
    assign cur_sz_lo      = cur_sz[COORD_W-1:0];
    assign tiles_per_side = cur_sz[COORD_W:4];
    assign tile_x0        = cur_tlx[COORD_W-1:4];
    assign tile_y0        = cur_tly[COORD_W-1:4];

    // Stack output fields
    logic [2:0]         popped_depth;
    logic [COORD_W-1:0] popped_tly, popped_tlx;
    assign popped_depth = stack_dout[STACK_W-1:STACK_W-3];
    assign popped_tly   = stack_dout[COORD_W*2-1:COORD_W];
    assign popped_tlx   = stack_dout[COORD_W-1:0];

    // COORD_W+1 bits for intermediate arithmetic (cur_sz can equal 2**COORD_W)
    logic [COORD_W:0] bpx, bpy;
    always_comb begin
        case (b_phase)
            2'b00: begin  // top row, left-to-right
                bpx = {1'b0, cur_tlx} + {1'b0, b_cnt};
                bpy = {1'b0, cur_tly};
            end
            2'b01: begin  // right col, top-to-bottom (top-right corner excluded)
                bpx = {1'b0, cur_tlx} + cur_sz - {{COORD_W{1'b0}}, 1'b1};
                bpy = {1'b0, cur_tly} + {1'b0, b_cnt};
            end
            2'b10: begin  // bottom row, right-to-left (bottom-right corner excluded)
                bpx = {1'b0, cur_tlx} + cur_sz - {{COORD_W{1'b0}}, 1'b1} - {1'b0, b_cnt};
                bpy = {1'b0, cur_tly} + cur_sz - {{COORD_W{1'b0}}, 1'b1};
            end
            default: begin  // left col, bottom-to-top (both corners excluded)
                bpx = {1'b0, cur_tlx};
                bpy = {1'b0, cur_tly} + cur_sz - {{COORD_W{1'b0}}, 1'b1} - {1'b0, b_cnt};
            end
        endcase
    end

    logic b_phase_done;
    always_comb begin
        case (b_phase)
            2'b00: b_phase_done = (b_cnt == cur_sz_lo - {{(COORD_W-1){1'b0}}, 1'b1});
            2'b01: b_phase_done = (b_cnt == cur_sz_lo - {{(COORD_W-1){1'b0}}, 1'b1});
            2'b10: b_phase_done = (b_cnt == cur_sz_lo - {{(COORD_W-1){1'b0}}, 1'b1});
            default: b_phase_done = (b_cnt == cur_sz_lo - {{(COORD_W-2){1'b0}}, 2'b10});
        endcase
    end

    logic b_done;
    assign b_done = (b_phase == 2'b11) && b_phase_done;

    assign top_left_x     = cur_tlx;
    assign top_left_y     = cur_tly;
    assign quad_size      = cur_sz;
    assign expected_count = (11'(cur_sz) << 2) - 11'd4;  // 4*sz - 4 border pixels

    always_comb begin
        sched_tile_done_set = '0;
        if (state == FILL) begin
            for (int ty = 0; ty < 16; ty++) begin
                for (int tx = 0; tx < 16; tx++) begin
                    if (ty < int'(tiles_per_side) && tx < int'(tiles_per_side)) begin
                        sched_tile_done_set[
                            (int'(tile_y0) + ty) * 16 +
                            (int'(tile_x0) + tx)
                        ] = 1'b1;
                    end
                end
            end
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            cur_tlx      <= '0;
            cur_tly      <= '0;
            cur_depth    <= '0;
            cur_sz    <= (COORD_W+1)'(1) << COORD_W;
            b_phase   <= '0;
            b_cnt     <= '0;
            split_cnt <= '0;
            qa_x      <= '0;
            qa_y      <= '0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= STARTUP;
                end

                STARTUP: begin
                    cur_tlx   <= '0;
                    cur_tly   <= '0;
                    cur_depth <= '0;
                    cur_sz    <= (COORD_W+1)'(1) << COORD_W;
                    state     <= SEARCH;
                end

                SEARCH: begin
                    b_phase <= '0;
                    b_cnt   <= '0;
                    state   <= PUSH_BORDER;
                end

                PUSH_BORDER: begin
                    if (differ) begin
                        split_cnt <= '0;
                        if (cur_depth == 3'd4) begin
                            qa_x  <= '0;
                            qa_y  <= '0;
                            state <= QUEUE_ALL;
                        end else
                            state <= SPLIT;
                    end else if (!sched_stall) begin
                        if (b_done)
                            state <= WAIT_COMP;
                        else if (b_phase_done) begin
                            b_phase <= b_phase + 2'd1;
                            b_cnt   <= {{(COORD_W-1){1'b0}}, 1'b1}; // skip corner already emitted by previous phase
                        end else
                            b_cnt <= b_cnt + {{(COORD_W-1){1'b0}}, 1'b1};
                    end
                end

                WAIT_COMP: begin
                    if (differ) begin
                        split_cnt <= '0;
                        if (cur_depth == 3'd4) begin
                            qa_x  <= '0;
                            qa_y  <= '0;
                            state <= QUEUE_ALL;
                        end else
                            state <= SPLIT;
                    end else if (complete)
                        state <= FILL;
                end

                FILL: begin
                    state <= ADVANCE;
                end

                // Push children BR, BL, TR onto stack then descend into TL (cur registers unchanged)
                SPLIT: begin
                    if (split_cnt == 2'd3) begin
                        split_cnt <= '0;
                        cur_depth <= child_depth;
                        cur_sz    <= {1'b0, half_sz};
                        state     <= SEARCH;
                    end else begin
                        split_cnt <= split_cnt + 2'd1;
                    end
                end

                QUEUE_ALL: begin
                    if (!sched_stall) begin
                        if (qa_x == 4'd15) begin
                            qa_x <= '0;
                            if (qa_y == 4'd15) begin
                                state <= ADVANCE;
                            end else
                                qa_y <= qa_y + 4'd1;
                        end else
                            qa_x <= qa_x + 4'd1;
                    end
                end

                ADVANCE: begin
                    state <= stack_empty ? FINISHED : ADVANCE2;
                end

                ADVANCE2: begin
                    cur_depth <= popped_depth;
                    cur_tly   <= popped_tly;
                    cur_tlx   <= popped_tlx;
                    cur_sz    <= ((COORD_W+1)'(1) << COORD_W) >> popped_depth;
                    state     <= SEARCH;
                end

                FINISHED: begin
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

    always_comb begin
        sched_push        = 1'b0;
        sched_coord       = '0;
        flush             = 1'b0;
        sched_reset       = 1'b0;
        engine_done       = 1'b0;
        tt_wr_quad_en     = 1'b0;
        tt_wr_quad_tlx    = cur_tlx;
        tt_wr_quad_tly    = cur_tly;
        tt_wr_quad_size   = cur_sz;  // pixel count (9-bit); tile_table shifts right by 4 to get tile count
        tt_wr_quad_colour = ref_colour_o;
        stack_push        = 1'b0;
        stack_pop         = 1'b0;
        stack_din         = '0;

        case (state)
            SEARCH: begin
                sched_reset = 1'b1;
            end

            PUSH_BORDER: begin
                if (!differ && !sched_stall) begin
                    sched_push  = 1'b1;
                    sched_coord = {bpy[COORD_W-1:0], bpx[COORD_W-1:0]};
                end
            end

            FILL: begin
                tt_wr_quad_en     = 1'b1;
                tt_wr_quad_tlx    = cur_tlx;
                tt_wr_quad_tly    = cur_tly;
                tt_wr_quad_size   = cur_sz;
                tt_wr_quad_colour = ref_colour_o;
            end

            SPLIT: begin
                flush = (split_cnt == 2'd0);  // one-cycle flush when first entering SPLIT
                case (split_cnt)
                    2'd0: begin stack_push = 1'b1; stack_din = {child_depth, cur_tly + half_sz, cur_tlx + half_sz}; end  // BR
                    2'd1: begin stack_push = 1'b1; stack_din = {child_depth, cur_tly + half_sz, cur_tlx}; end             // BL
                    2'd2: begin stack_push = 1'b1; stack_din = {child_depth, cur_tly, cur_tlx + half_sz}; end             // TR
                    default: ;  // cnt==3: descend to TL
                endcase
            end

            QUEUE_ALL: begin
                if (!sched_stall) begin
                    sched_push  = 1'b1;
                    sched_coord = {
                        cur_tly + {{(COORD_W-4){1'b0}}, qa_y},
                        cur_tlx + {{(COORD_W-4){1'b0}}, qa_x}
                    };
                end
            end

            ADVANCE: begin
                if (!stack_empty)
                    stack_pop = 1'b1;
            end

            FINISHED: begin
                engine_done = 1'b1;
            end

            default: ;
        endcase
    end

endmodule