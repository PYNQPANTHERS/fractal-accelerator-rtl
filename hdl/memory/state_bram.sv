// Double-BRAM ping-pong: rst flips the active BRAM; inactive is cleared to 00 in background
// Simultaneous rd + we to the same address returns the value before the write (READ_FIRST)

module state_bram (
    input  logic        clk,
    input  logic        rst,

    input  logic [8:0]  x,
    input  logic [8:0]  y,
    input  logic        rd,
    input  logic        we,
    input  logic [1:0]  wstate,
    output logic [1:0]  rstate,
    output logic        rd_valid,  // high 1 cycle after rd when rst=0
    output logic        wr_done    // high 1 cycle after we when rst=0
);

    (* ram_style = "block" *) logic [1:0] mem_a [0:65535];
    (* ram_style = "block" *) logic [1:0] mem_b [0:65535];

    logic        active;       // 0 = mem_a active, 1 = mem_b active
    logic        clr_active;
    logic [15:0] clr_addr;
    logic        rst_d;

    logic [15:0] pixel_addr;
    assign pixel_addr = {y[7:0], x[7:0]};

    always_ff @(posedge clk) rst_d <= rst;

    // Rising edge of rst: flip active BRAM and restart background clear
    always_ff @(posedge clk) begin
        if (rst && !rst_d) begin
            active     <= ~active;
            clr_active <= 1'b1;
            clr_addr   <= 16'h0;
        end else if (clr_active) begin
            if (clr_addr == 16'hFFFF)
                clr_active <= 1'b0;
            else
                clr_addr <= clr_addr + 1;
        end
    end

    // Write steering: user writes go to active BRAM; bg-clear writes go to inactive
    logic        we_a,    we_b;
    logic [15:0] waddr_a, waddr_b;
    logic [1:0]  wdata_a, wdata_b;

    always_comb begin
        if (!active) begin
            we_a    = we & ~rst;  waddr_a = pixel_addr;  wdata_a = wstate;
            we_b    = clr_active;   waddr_b = clr_addr;    wdata_b = 2'b00;
        end else begin
            we_a    = clr_active;   waddr_a = clr_addr;    wdata_a = 2'b00;
            we_b    = we & ~rst;  waddr_b = pixel_addr;  wdata_b = wstate;
        end
    end

    logic [1:0] rdata_a, rdata_b;

    always_ff @(posedge clk) begin
        if (we_a) mem_a[waddr_a] <= wdata_a;
        rdata_a <= mem_a[pixel_addr];
    end

    always_ff @(posedge clk) begin
        if (we_b) mem_b[waddr_b] <= wdata_b;
        rdata_b <= mem_b[pixel_addr];
    end

    assign rstate = active ? rdata_b : rdata_a;

    always_ff @(posedge clk) rd_valid <= rd & ~rst;
    always_ff @(posedge clk) wr_done  <= we & ~rst;

    initial begin
        active     = 1'b0;
        clr_active = 1'b0;
        clr_addr   = 16'h0;
        rst_d      = 1'b0;
        for (int i = 0; i < 65536; i++) begin
            mem_a[i] = 2'b00;
            mem_b[i] = 2'b00;
        end
    end

endmodule
