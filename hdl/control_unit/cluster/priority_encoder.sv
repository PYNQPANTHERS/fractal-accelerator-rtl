// ─────────────────────────────────────────────────────────────────────────────
// priority_encoder
//   Lowest-index-wins priority encoder.
//   Produces both a one-hot and a binary index, plus a "any_valid" flag.
//   Purely combinational.
// ─────────────────────────────────────────────────────────────────────────────
module priority_encoder #(
    parameter  int BUS_WIDTH   = 8,
    localparam int ADDRESS_LEN = $clog2(BUS_WIDTH)
) (
    input  logic [BUS_WIDTH-1:0]   core_bus,
    output logic [BUS_WIDTH-1:0]   core_select,
    output logic [ADDRESS_LEN-1:0] core_address,
    output logic                   any_valid
);

    always_comb begin
        core_select  = '0;
        core_address = '0;
        any_valid    = 1'b0;
        for (int i = 0; i < BUS_WIDTH; i++) begin
            if (core_bus[i] && !any_valid) begin
                core_select[i] = 1'b1;
                core_address   = i[ADDRESS_LEN-1:0];
                any_valid      = 1'b1;
            end
        end
    end

endmodule