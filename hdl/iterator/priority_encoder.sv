module priority_encoder #(
    parameter int core_number = 100,
    parameter int BUS_WIDTH = core_number,
    parameter int address_len = $clog2(BUS_WIDTH)
) (
    input logic [BUS_WIDTH-1:0] core_bus,
    output logic [BUS_WIDTH-1:0] core_select,
    output logic [address_len-1:0] core_address
);

    // does priority encoding assignment

    always_comb begin
        ichooseyou = '0;
        for (int i = BUS_WIDTH-1; i >= 0; i--) begin
            if (core_bus[i]) begin
                ichooseyou[i] = 1'b1;
                break;
            end
        end
    end

    // address decode from onehot ichooseyou
    
    always_comb begin
        address = '0;
        for (int i = BUS_WIDTH-1; i >= 0; i--) begin
            if (ichooseyou[i]) begin
                address = i;
                break;
            end
        end
    end
endmodule