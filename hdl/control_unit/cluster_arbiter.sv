// cluster_arbiter
//   Wraps the cluster-level priority encoder and the one-cycle pipeline 
//
//

module cluster_arbiter #(
    parameter  int CLUSTER_COUNT = 4,
    localparam int CLUST_ADDR_W  = $clog2(CLUSTER_COUNT)
) (
    input  logic                      clk,
    input  logic                      rst,

    input  logic [CLUSTER_COUNT-1:0]  cluster_wants_job,
    input  logic                      capture,   // latch a new winner this cycle
    input  logic                      hold,      // keep current winner stable

    output logic [CLUSTER_COUNT-1:0]  chosen_onehot,
    output logic [CLUST_ADDR_W-1:0]   chosen_idx,
    output logic                      chosen_valid,
    output logic                      any_free      // raw combinational: any cluster wants a job
);

    // combinational pick
    logic [CLUSTER_COUNT-1:0] wants_onehot;
    logic [CLUST_ADDR_W-1:0]  winner_idx;
    logic                     any_cluster_free;

    priority_encoder #(.BUS_WIDTH(CLUSTER_COUNT)) u_cluster_pe (
        .core_bus    (cluster_wants_job),
        .core_select (wants_onehot),
        .core_address(winner_idx),
        .any_valid   (any_cluster_free)
    );

    assign any_free = any_cluster_free;

    // registered / locked choice
    always_ff @(posedge clk) begin
        if (rst) begin
            chosen_onehot <= '0;
            chosen_idx    <= '0;
            chosen_valid  <= 1'b0;
        end else if (capture && any_cluster_free) begin
            chosen_onehot <= wants_onehot;
            chosen_idx    <= winner_idx;
            chosen_valid  <= 1'b1;
        end else if (hold) begin
            // keep current choice (do nothing)
        end else begin
            chosen_valid  <= 1'b0;
        end
    end

endmodule