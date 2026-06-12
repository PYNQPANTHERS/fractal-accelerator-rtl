// Balanced-tree "lowest set bit" finder.
// Returns the index of the lowest-index set bit of `bits`, and whether any bit
// is set. A log2(WIDTH)-depth reduction tree instead of a flat WIDTH-deep
// priority chain, so logic depth (and Fmax) scales with log2(WIDTH).
//
// Implemented with flat 2-D arrays (one row per tree level) rather than
// cross-generate hierarchical references, which all synthesis tools accept.

module lowest_set_tree #(
    parameter int WIDTH = 1024
)(
    input  logic [WIDTH-1:0]          bits,
    output logic                      any,
    output logic [$clog2(WIDTH)-1:0]  index
);

    localparam int IDX_W = $clog2(WIDTH);
    localparam int N     = 1 << IDX_W;   // WIDTH padded up to power of two

    // node_v[lvl][k] / node_i[lvl][k]: valid bit and index of subtree node k at
    // level lvl. Level 0 = leaves (N nodes), each successive level halves count,
    // level IDX_W = root (1 node). Arrays are sized to the widest level (N).
    logic             node_v [0:IDX_W][0:N-1];
    logic [IDX_W-1:0] node_i [0:IDX_W][0:N-1];

    // leaves
    genvar i, lvl, k;
    generate
        for (i = 0; i < N; i++) begin : gen_leaf
            assign node_v[0][i] = (i < WIDTH) ? bits[i] : 1'b0;
            assign node_i[0][i] = IDX_W'(i);
        end
        // reduction: each node prefers its lower child when that child is valid
        for (lvl = 1; lvl <= IDX_W; lvl++) begin : gen_lvl
            for (k = 0; k < (N >> lvl); k++) begin : gen_node
                assign node_v[lvl][k] = node_v[lvl-1][2*k] | node_v[lvl-1][2*k+1];
                assign node_i[lvl][k] = node_v[lvl-1][2*k] ? node_i[lvl-1][2*k]
                                                           : node_i[lvl-1][2*k+1];
            end
        end
    endgenerate

    assign any   = node_v[IDX_W][0];
    assign index = node_i[IDX_W][0];

endmodule
