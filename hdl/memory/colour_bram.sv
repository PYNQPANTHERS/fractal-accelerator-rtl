// Dual-port colour BRAM for one 256x256 sixteenth, tile-ordered
// Write port is full-word; caller does RMW to merge a single byte

module colour_bram (
    input  logic        clk,
    input  logic        rst,   // resets tile_wr_cnt only; mem is untouched

    input  logic [7:0]  ctrl_rd_x,
    input  logic [7:0]  ctrl_rd_y,
    input  logic        ctrl_rd_en,
    output logic [7:0]  ctrl_rd_data,

    // Full-word write: caller must do RMW externally
    input  logic [12:0] ctrl_wr_waddr,
    input  logic [63:0] ctrl_wr_word,
    input  logic        ctrl_wr_en,

    input  logic [12:0] b2d_word_addr,
    input  logic        b2d_rd_en,
    output logic        b2d_rd_grant,
    output logic [63:0] b2d_rd_data,

    // Word read for RMW — returns the 64-bit word at ctrl_rd_waddr one cycle later
    input  logic [12:0] ctrl_rmw_rd_addr,
    input  logic        ctrl_rmw_rd_en,
    output logic [63:0] ctrl_rmw_rd_data,

    // Per-tile pixel write counter: bit set once all 256 pixels written
    output logic [255:0] tile_done
);

    (* ram_style = "block" *)
    logic [63:0] mem [0:8191];

    initial begin
        for (int i = 0; i < 8192; i++) mem[i] = 64'h0;
    end

    // Tile address: {y[7:4], x[7:4], y[3:0], x[3:0]}
    logic [15:0] ctrl_rd_ta;
    logic [12:0] ctrl_rd_waddr_i;
    logic [2:0]  ctrl_rd_boff;

    assign ctrl_rd_ta      = {ctrl_rd_y[7:4], ctrl_rd_x[7:4], ctrl_rd_y[3:0], ctrl_rd_x[3:0]};
    assign ctrl_rd_waddr_i = ctrl_rd_ta[15:3];
    assign ctrl_rd_boff    = ctrl_rd_ta[2:0];

    // Port A: controller byte read
    logic [63:0] a_rd_word;
    logic [2:0]  a_byte_off_reg;

    always_ff @(posedge clk) begin
        if (ctrl_rd_en) begin
            a_rd_word      <= mem[ctrl_rd_waddr_i];
            a_byte_off_reg <= ctrl_rd_boff;
        end
    end

    always_comb
        ctrl_rd_data = a_rd_word[a_byte_off_reg*8 +: 8];

    // Port B: RMW pre-read and b2d read (wr beats b2d); grant registered to align with data
    always_ff @(posedge clk)
        b2d_rd_grant <= b2d_rd_en && !ctrl_wr_en && !ctrl_rmw_rd_en;

    always_ff @(posedge clk) begin
        if (ctrl_wr_en)
            mem[ctrl_wr_waddr] <= ctrl_wr_word;
        else if (ctrl_rmw_rd_en)
            ctrl_rmw_rd_data <= mem[ctrl_rmw_rd_addr];
        else if (b2d_rd_en)
            b2d_rd_data <= mem[b2d_word_addr];
    end

    // Per-tile write counter, ping-pong banks. rst rising edge flips active bank and
    // starts a background 256-cycle clear of the inactive bank. Saturates at bit[8].
    logic [8:0] tile_wr_cnt_a [0:255];
    logic [8:0] tile_wr_cnt_b [0:255];
    logic [7:0] tile_wr_idx;
    assign tile_wr_idx = ctrl_wr_waddr[12:5];

    logic       active;     // 0 = bank_a active, 1 = bank_b active
    logic       rst_d;
    logic       clr_active;
    logic [7:0] clr_addr;

    always_ff @(posedge clk) rst_d <= rst;

    always_ff @(posedge clk) begin
        if (rst && !rst_d) begin
            active     <= ~active;
            clr_active <= 1'b1;
            clr_addr   <= 8'h00;
        end else if (clr_active) begin
            if (clr_addr == 8'hFF)
                clr_active <= 1'b0;
            else
                clr_addr <= clr_addr + 8'h01;
        end
    end

    always_ff @(posedge clk) begin
        if (!active) begin
            if (clr_active)                                    tile_wr_cnt_b[clr_addr]   <= 9'h000;
            if (ctrl_wr_en && !tile_wr_cnt_a[tile_wr_idx][8]) tile_wr_cnt_a[tile_wr_idx] <= tile_wr_cnt_a[tile_wr_idx] + 9'h001;
        end else begin
            if (clr_active)                                    tile_wr_cnt_a[clr_addr]   <= 9'h000;
            if (ctrl_wr_en && !tile_wr_cnt_b[tile_wr_idx][8]) tile_wr_cnt_b[tile_wr_idx] <= tile_wr_cnt_b[tile_wr_idx] + 9'h001;
        end
    end

    genvar ti;
    generate
        for (ti = 0; ti < 256; ti++) begin : tile_done_gen
            assign tile_done[ti] = active ? tile_wr_cnt_b[ti][8] : tile_wr_cnt_a[ti][8];
        end
    endgenerate

    initial begin
        active     = 1'b0;
        rst_d      = 1'b0;
        clr_active = 1'b0;
        clr_addr   = 8'h00;
        for (int ti = 0; ti < 256; ti++) begin
            tile_wr_cnt_a[ti] = 9'h000;
            tile_wr_cnt_b[ti] = 9'h000;
        end
    end

endmodule
