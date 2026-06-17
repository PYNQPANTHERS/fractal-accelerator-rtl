// N-way ping-pong state memory (default 4 banks).
// Each sixteenth uses one active bank; vacated banks are background-cleared to 00.
// All dirty banks clear in parallel and the next sixteenth grabs any clean bank,
// so the 65536-cycle clear is hidden behind compute (no per-sixteenth stall).
// Simultaneous rd+we to the same address returns the pre-write value (READ_FIRST).

module state_bram #(
    parameter int NUM_BANKS = 4
)(
    input  logic        clk,
    input  logic        rst,

    input  logic [7:0]  x,
    input  logic [7:0]  y,
    input  logic        rd,
    input  logic        we,
    input  logic [1:0]  wstate,
    output logic [1:0]  rstate,
    output logic        rd_valid,   // high 1 cycle after rd when rst=0
    output logic        wr_done,    // high 1 cycle after we when rst=0
    output logic        clear_done  // high when a fresh bank is ready for next sixteenth
);

    localparam int BSEL_W = (NUM_BANKS > 1) ? $clog2(NUM_BANKS) : 1;

    logic [BSEL_W-1:0] active;
    logic [15:0]       pixel_addr;
    assign pixel_addr = {y, x};

    // clean[b]   : bank b is zeroed and ready to become active
    // clearing[b]: bank b is part of the in-flight clear sweep
    logic [NUM_BANKS-1:0] clean;
    logic [NUM_BANKS-1:0] clearing;
    logic                 clr_busy;
    logic [15:0]          clr_addr;

    logic rst_d;
    always_ff @(posedge clk) rst_d <= rst;

    // pick any clean bank (other than active) for the next sixteenth
    logic              have_clean;
    logic [BSEL_W-1:0] next_active;
    always_comb begin
        have_clean  = 1'b0;
        next_active = '0;
        for (int b = NUM_BANKS-1; b >= 0; b--)
            if (clean[b] && (BSEL_W'(b) != active)) begin
                have_clean  = 1'b1;
                next_active = BSEL_W'(b);
            end
    end

    // single driver for active/clean/clearing/clr_*; rst edge has priority
    always_ff @(posedge clk) begin
        if (rst && !rst_d) begin
            // vacate active bank, switch to a clean bank, restart full sweep
            clearing[active] <= 1'b1;
            clean[active]    <= 1'b0;
            if (have_clean) active <= next_active;
            clr_busy <= 1'b1;
            clr_addr <= 16'h0;
        end else begin
            if (we) clean[active] <= 1'b0;   // user write dirties active bank

            if (clr_busy) begin
                if (clr_addr == 16'hFFFF) begin
                    clr_busy <= 1'b0;
                    for (int b = 0; b < NUM_BANKS; b++)
                        if (clearing[b]) clean[b] <= 1'b1;
                    clearing <= '0;
                end else begin
                    clr_addr <= clr_addr + 16'h1;
                end
            end
        end
    end

    // Per-bank write port: clear write to any clearing bank, user write to active.
    logic              bank_we   [0:NUM_BANKS-1];
    logic [15:0]       bank_waddr[0:NUM_BANKS-1];
    logic [1:0]        bank_wdata[0:NUM_BANKS-1];
    logic [1:0]        bank_rdata[0:NUM_BANKS-1];

    always_comb begin
        for (int b = 0; b < NUM_BANKS; b++) begin
            if (clr_busy && clearing[b]) begin
                bank_we[b]    = 1'b1;
                bank_waddr[b] = clr_addr;
                bank_wdata[b] = 2'b00;
            end else begin
                bank_we[b]    = 1'b0;
                bank_waddr[b] = pixel_addr;
                bank_wdata[b] = 2'b00;
            end
        end
        // active is never in `clearing`, so this never collides with a clear write
        bank_we[active]    = we & ~rst;
        bank_waddr[active] = pixel_addr;
        bank_wdata[active] = wstate;
    end

    // Per-bank arrays in the generate block infer NUM_BANKS independent BRAMs
    // (1 write + 1 read each), so a clear and the active access run in parallel.
    genvar gb;
    generate
        for (gb = 0; gb < NUM_BANKS; gb++) begin : gen_bank
            (* ram_style = "block" *) logic [1:0] mem [0:65535];
            initial for (int i = 0; i < 65536; i++) mem[i] = 2'b00;
            always_ff @(posedge clk) begin
                if (bank_we[gb]) mem[bank_waddr[gb]] <= bank_wdata[gb];
                bank_rdata[gb] <= mem[pixel_addr];
            end
        end
    endgenerate

    assign rstate     = bank_rdata[active];
    assign clear_done = have_clean;   // a fresh bank exists for the next sixteenth

    always_ff @(posedge clk) rd_valid <= rd & ~rst;
    always_ff @(posedge clk) wr_done  <= we & ~rst;

    initial begin
        active   = '0;
        clr_busy = 1'b0;
        clr_addr = 16'h0;
        rst_d    = 1'b0;
        clean    = '1;
        clearing = '0;
    end

endmodule
