// ─────────────────────────────────────────────────────────────────────────────
// bram_read_write
//   Arbitrates BRAM access between the FSM read path and the result write
//   path using a round-robin scheme so dont get stuck draining or allocating.
//
//   BRAM word (8-bit): { colour[5:0], done, started }
//     bit[0]   = started
//     bit[1]   = done
//     bits[7:2] = colour[5:0]
// ─────────────────────────────────────────────────────────────────────────────
module bram_read_write #(
    parameter int PIXEL_W = 8
) (
    input  logic                clk,
    input  logic                rst,

    // read request from frame_fsm — held until decoded
    input  logic                check_bram,
    input  logic [PIXEL_W-1:0]  a,
    input  logic [PIXEL_W-1:0]  b,

    // BRAM interface — 8-bit data: {colour[5:0], done, started}
    output logic                bram_rd_en,
    input  logic [7:0]          bram_rd_data,
    output logic                bram_wr_en,
    output logic [PIXEL_W-1:0]  bram_wr_a,
    output logic [PIXEL_W-1:0]  bram_wr_b,
    output logic [7:0]          bram_wr_data,

    // result write from cluster result FIFO (show-ahead)
    input  logic                res_valid,
    input  logic [PIXEL_W-1:0]  res_a,
    input  logic [PIXEL_W-1:0]  res_b,
    input  logic [5:0]          res_colour,
    output logic                res_rd_en,

    // decoded outputs — registered, hold until next READ
    output logic                miss,
    output logic                started,
    output logic                done,
    output logic [5:0]          colour
);

    typedef enum logic [1:0] {
        IDLE,
        READ,
        WRITE
    } state_t;

    state_t current_state, next_state;

    // 0 = last action was read  →  prefer write next
    // 1 = last action was write →  prefer read  next
    logic prev_load;

    logic              started_write_pending;
    logic [PIXEL_W-1:0] a_latch, b_latch;

    // arbitration 
    logic any_wr_pending;
    assign any_wr_pending = started_write_pending || res_valid;

    logic go_read, go_write;
    always_comb begin
        if (check_bram && any_wr_pending) begin
            go_read  = ~prev_load;
            go_write =  prev_load;
        end else begin
            go_read  =  check_bram;
            go_write =  any_wr_pending && !check_bram;
        end
    end

    logic bram_action;
    assign bram_action = (current_state == IDLE) && (go_read || go_write);

    // started write beats result write within the write slot
    logic serve_started, serve_result;
    assign serve_started = started_write_pending;
    assign serve_result  = res_valid && !started_write_pending;

    // state machine 
    always_ff @(posedge clk) begin
        if (rst) current_state <= IDLE;
        else     current_state <= next_state;
    end

    always_comb begin
        next_state = current_state;
        unique case (current_state)
            IDLE:    if      (go_read)  next_state = READ;
                     else if (go_write) next_state = WRITE;
            READ:                       next_state = IDLE;
            WRITE:                      next_state = IDLE;
            default:                    next_state = IDLE;
        endcase
    end

    // datapath registers 
    always_ff @(posedge clk) begin
        if (rst) begin
            prev_load             <= 1'b0;
            started_write_pending <= 1'b0;
            a_latch               <= '0;
            b_latch               <= '0;
            miss                  <= 1'b0;
            started               <= 1'b0;
            done                  <= 1'b0;
            colour                <= 6'b0;
        end else begin
            if (bram_action) prev_load <= ~prev_load;

            if (bram_action && go_read) begin
                a_latch <= a;
                b_latch <= b;
            end

            // latch decoded outputs in READ — hold until next READ
            if (current_state == READ) begin
                started <= bram_rd_data[0] & ~bram_rd_data[1];
                done    <= bram_rd_data[1];
                miss    <= ~bram_rd_data[0] & ~bram_rd_data[1];
                colour  <= bram_rd_data[7:2];

                if (~bram_rd_data[0] & ~bram_rd_data[1])
                    started_write_pending <= 1'b1;
            end

            if (current_state == WRITE && serve_started)
                started_write_pending <= 1'b0;
        end
    end

    // BRAM read 
    assign bram_rd_en = (current_state == IDLE) && go_read;

    // BRAM write 
    // started write: {6'b0,    done=0, started=1} = 8'h01
    // result  write: {colour,  done=1, started=1}
    assign bram_wr_en   = (current_state == WRITE);
    assign bram_wr_a    = serve_started ? a_latch              : res_a;
    assign bram_wr_b    = serve_started ? b_latch              : res_b;
    assign bram_wr_data = serve_started ? 8'h01                : {res_colour, 2'b11};

    assign res_rd_en = (current_state == WRITE) && serve_result;

endmodule
