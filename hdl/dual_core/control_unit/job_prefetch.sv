module job_prefetch #(
    parameter int PIXEL_ADDR_W = 16,
    parameter int PIXEL_W      = 8,
    parameter int Z_WIDE       = 37
) (
    input  logic clk,
    input  logic rst,

    // Scheduler handshake — skip=1 means pixel is guaranteed fresh, bypass BRAM check
    output logic                    wants_job,
    input  logic                    grant,
    input  logic                    skip,
    input  logic [PIXEL_ADDR_W-1:0] coord_out,

    // Latched coord — drives translate module in control_unit combinationally
    output logic [PIXEL_W-1:0] coord_a,
    output logic [PIXEL_W-1:0] coord_b,

    // Translated complex coordinates (combinational, from control_unit's translate)
    input  logic [Z_WIDE-1:0] z_real,
    input  logic [Z_WIDE-1:0] z_imag,

    // BRAM check interface (to bram_read_write)
    output logic       check_bram,
    input  logic       bram_miss,
    input  logic       bram_done,
    input  logic [7:0] bram_colour,
    input  logic       bram_read_done_pulse,

    // Dispatch FIFO push — space guaranteed on SKIP_PUSH (checked at IDLE accept)
    output logic                                    dispatch_wr_en,
    output logic [PIXEL_ADDR_W + Z_WIDE*2 - 1 : 0] dispatch_wr_data,
    input  logic                                    dispatch_full,

    // Done-pixel re-inject (single-slot latch)
    output logic                    inject_pending,
    output logic [PIXEL_ADDR_W-1:0] inject_addr,
    output logic [PIXEL_W-1:0]      inject_colour,
    input  logic                    res_fifo_full
);

    // SKIP_WAIT inserts one cycle so the registered translate output (z_real/z_imag
    // is now 1 cycle behind coord_a/coord_b) is valid before SKIP_PUSH writes it to
    // the dispatch FIFO. The CHECKING path already has >=1 BRAM-read cycle of latency
    // so it needs no extra wait.
    typedef enum logic [2:0] { IDLE, CHECKING, SKIP_WAIT, SKIP_PUSH } state_t;
    state_t state;

    // Suppress during reset so the scheduler sees a clean 0→1 edge on deassert
    assign wants_job  = (state == IDLE) && !dispatch_full && !inject_pending && !rst;
    assign check_bram = (state == CHECKING);

    always_ff @(posedge clk) begin
        if (rst) begin
            state          <= IDLE;
            coord_a        <= '0;
            coord_b        <= '0;
            inject_pending <= 1'b0;
            inject_addr    <= '0;
            inject_colour  <= '0;
        end else begin
            if (inject_pending && !res_fifo_full)
                inject_pending <= 1'b0;

            unique case (state)
                IDLE: begin
                    if (wants_job && grant) begin
                        coord_a <= coord_out[PIXEL_W-1:0];
                        coord_b <= coord_out[PIXEL_ADDR_W-1:PIXEL_W];
                        if (skip) state <= SKIP_WAIT;
                        else      state <= CHECKING;
                    end
                end

                // Skip path: pixel guaranteed fresh — push directly, no BRAM check.
                // dispatch_full is 0 here (guaranteed by wants_job gate at IDLE accept).
                // One wait cycle aligns the registered z_real/z_imag.
                SKIP_WAIT: state <= SKIP_PUSH;
                SKIP_PUSH: state <= IDLE;

                CHECKING: begin
                    if (bram_read_done_pulse) begin
                        if (bram_done) begin
                            inject_pending <= 1'b1;
                            inject_addr    <= {coord_a, coord_b};
                            inject_colour  <= bram_colour;
                        end
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign dispatch_wr_en   = ((state == CHECKING) && bram_read_done_pulse && !bram_done)
                            || (state == SKIP_PUSH);
    assign dispatch_wr_data = {z_real, z_imag, coord_a, coord_b};

endmodule
