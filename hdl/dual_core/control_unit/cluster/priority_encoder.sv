module priority_encoder #(
    parameter  int BUS_WIDTH   = 8,
    localparam int ADDRESS_LEN = (BUS_WIDTH > 1) ? $clog2(BUS_WIDTH) : 1
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
                core_address   = ADDRESS_LEN'(i);
                any_valid      = 1'b1;
            end
        end
    end
endmodule