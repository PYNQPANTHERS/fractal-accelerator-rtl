
// load_sequencer
//
//   Usage:
//     - pulse start_load for one cycle with n_words set to the transfer
//       length (2 for narrow, 4 for wide).
//     - load_active stays high for the whole transfer
//     - word_idx counts 0,1,2,... identifying which word to drive this cycle
//     - load_last high on last cycle

module load_sequencer #(
    parameter  int MAX_WORDS = 2,
    localparam int CNT_W     = $clog2(MAX_WORDS + 1)
) (
    input  logic              clk,
    input  logic              rst,

    input  logic              start_load,   // pulse to begin a transfer
    input  logic [CNT_W-1:0]  n_words,      // number of cycles in this transfer

    output logic [CNT_W-1:0]  word_idx,     // 0-based index of current word
    output logic              load_active,  // high for the whole transfer
    output logic              load_last     // high on the final cycle
);

    logic [CNT_W-1:0] remaining;

    assign load_active = (remaining != 0);
    // current word index = (n_words - remaining); but we also need the value
    // latched at start. Simpler: track word_idx directly.
    // load_last is the cycle where exactly one word remains.
    assign load_last   = (remaining == 1);

    logic [CNT_W-1:0] total_words;

    always_ff @(posedge clk) begin
        if (rst) begin
            remaining   <= '0;
            total_words <= '0;
            word_idx    <= '0;
        end else if (start_load) begin
            remaining   <= n_words;
            total_words <= n_words;
            word_idx    <= '0;
        end else if (load_active) begin
            if (remaining != 0) remaining <= remaining - 1'b1;
            if (remaining != 1) word_idx  <= word_idx + 1'b1; // stop advancing on last
        end
    end

endmodule