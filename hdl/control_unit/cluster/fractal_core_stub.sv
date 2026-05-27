// ─────────────────────────────────────────────────────────────────────────────
// fractal_core (TESTBENCH STUB)
//   Behavioural stub modelling the contract the real fractal_core must obey.
//   - Asserts 'ready' after reset and after each 'received' handshake.
//   - On 'live_data' high: latches 'data_in', drops 'ready', starts an internal
//     countdown of 'compute_cycles' cycles.
//   - When countdown reaches zero: asserts 'done' and presents 'result',
//     holding both stable until 'received' strobes high.
//   - 'result' is a deterministic function of `data_in` (XOR-fold) so the
//     scoreboard can predict it.
//
//   Latency is randomised by the testbench by poking `compute_cycles_next`
//   between jobs. Default range is set via the LAT_MIN/LAT_MAX parameters
//   and can be overridden through a hierarchical reference if needed.
// ─────────────────────────────────────────────────────────────────────────────
module fractal_core #(
    parameter int JOB_DATA_W = 18,
    parameter int PIXEL_W    = 8,
    parameter int LAT_MIN    = 5,
    parameter int LAT_MAX    = 50
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  live_data,
    input  logic [JOB_DATA_W-1:0] data_in,
    output logic                  ready,
    output logic                  done,
    output logic [PIXEL_W-1:0]    result,
    input  logic                  received
);

    typedef enum logic [1:0] {
        S_IDLE,    // ready=1, waiting for live_data
        S_BUSY,    // computing
        S_DONE     // done=1, waiting for received
    } state_t;

    state_t                  state;
    logic [31:0]             countdown;
    logic [JOB_DATA_W-1:0]   latched_data;

    // Predictable transfer function: XOR-fold data_in down to PIXEL_W bits.
    function automatic logic [PIXEL_W-1:0] xfer(input logic [JOB_DATA_W-1:0] d);
        logic [PIXEL_W-1:0] r;
        r = '0;
        for (int i = 0; i < JOB_DATA_W; i++) r[i % PIXEL_W] ^= d[i];
        return r;
    endfunction

    // Random latency drawn at each new job. Seeded per-instance for variety.
    int unsigned seed;
    initial begin
        seed = $urandom;
    end

    function automatic int unsigned next_latency();
        int unsigned span;
        span = LAT_MAX - LAT_MIN + 1;
        return LAT_MIN + ($urandom(seed) % span);
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= S_IDLE;
            countdown    <= '0;
            latched_data <= '0;
            ready        <= 1'b0;
            done         <= 1'b0;
            result       <= '0;
        end else begin
            unique case (state)
                S_IDLE: begin
                    ready <= 1'b1;
                    if (live_data) begin
                        latched_data <= data_in;
                        countdown    <= next_latency();
                        ready        <= 1'b0;
                        state        <= S_BUSY;
                    end
                end

                S_BUSY: begin
                    if (countdown <= 1) begin
                        result <= xfer(latched_data);
                        done   <= 1'b1;
                        state  <= S_DONE;
                    end else begin
                        countdown <= countdown - 1;
                    end
                end

                S_DONE: begin
                    if (received) begin
                        done   <= 1'b0;
                        ready  <= 1'b1;
                        state  <= S_IDLE;
                    end
                end
            endcase
        end
    end

endmodule