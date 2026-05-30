module bram_read #(
    parameter int PIXEL_ADDR_W = 16,
    parameter int PIXEL_W      = 8,
    parameter int COLOURWIDTH  = 5
) (
    input  logic                    clk,
    input  logic                    rst,

    // check flag from frame_fsm
    input  logic                    check_bram,

    // pixel coordinates (registered in control_unit, stable during check)
    input  logic [PIXEL_W-1:0]      a,
    input  logic [PIXEL_W-1:0]      b,

    // external BRAM interface — 1-cycle read latency
    // bram_rd_en asserted cycle N → bram_rd_data valid cycle N+1
    output logic                    bram_rd_en,
    input  logic [15:0]             bram_rd_data, // [7:0]=status  [15:8]=colour

    // output flags — valid for one cycle in DECODE state
    output logic                    miss,
    output logic                    started,
    output logic                    done,
    output logic [COLOURWIDTH-1:0]  colour
);

    typedef enum logic {
        IDLE,
        DECODE
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (rst) current_state <= IDLE;
        else     current_state <= next_state;
    end

    always_comb begin
        next_state = current_state;
        unique case (current_state)
            IDLE:    if (check_bram) next_state = DECODE;
            DECODE:                 next_state = IDLE;
            default:                next_state = IDLE;
        endcase
    end

    // Issue read the cycle check_bram fires; data arrives next cycle in DECODE.
    assign bram_rd_en = (current_state == IDLE) && check_bram;

    logic in_decode;
    assign in_decode = (current_state == DECODE);

    logic [7:0] ds_dout;
    logic [7:0] colour_dout;
    assign ds_dout     = bram_rd_data[7:0];
    assign colour_dout = bram_rd_data[15:8];

    assign started = in_decode &  ds_dout[0] & ~ds_dout[1];
    assign done    = in_decode &  ds_dout[1];
    assign miss    = in_decode & ~ds_dout[0] & ~ds_dout[1];
    assign colour  = colour_dout[COLOURWIDTH-1:0];

endmodule
