module translate #(
    parameter int DATA_WIDTH = 35,
    parameter int RESOLUTION = 8
) (
    input  logic                  clk,
    input  logic [DATA_WIDTH-1:0] centre_x,
    input  logic [DATA_WIDTH-1:0] centre_y,
    input  logic [RESOLUTION-1:0] a,
    input  logic [RESOLUTION-1:0] b,
    input  logic [15:0]            zoom,
    input  logic [3:0]            sixteenth,
    output logic [DATA_WIDTH-1:0] z_real,
    output logic [DATA_WIDTH-1:0] z_imag
);

    logic [DATA_WIDTH-1:0] scale_factor;     // combinational LUT output
    logic [DATA_WIDTH-1:0] scale_factor_q;   // registered: removes the 80-way LUT
                                             // mux from the multiply's critical
                                             // path. zoom is per-frame config so
                                             // the 1-cycle delay is harmless.

    always_ff @(posedge clk) scale_factor_q <= scale_factor;

// Each raw step value is multiplied by 2^17 so that x_prod = px * scale_factor
// places the Q2.16 coordinate in z_real[34:17] (the top 18 bits), matching the
// narrow-mode bit-select in job_datapath.
always_comb begin : zoom_lut
    case (zoom[6:0])  // 7 bits, 0-79
        // Band 0: 256 -> 128, step 8 (levels 0-16)
        7'd0:  scale_factor = DATA_WIDTH'(32'd33554432);
        7'd1:  scale_factor = DATA_WIDTH'(32'd32505856);
        7'd2:  scale_factor = DATA_WIDTH'(32'd31457280);
        7'd3:  scale_factor = DATA_WIDTH'(32'd30408704);
        7'd4:  scale_factor = DATA_WIDTH'(32'd29360128);
        7'd5:  scale_factor = DATA_WIDTH'(32'd28311552);
        7'd6:  scale_factor = DATA_WIDTH'(32'd27262976);
        7'd7:  scale_factor = DATA_WIDTH'(32'd26214400);
        7'd8:  scale_factor = DATA_WIDTH'(32'd25165824);
        7'd9:  scale_factor = DATA_WIDTH'(32'd24117248);
        7'd10: scale_factor = DATA_WIDTH'(32'd23068672);
        7'd11: scale_factor = DATA_WIDTH'(32'd22020096);
        7'd12: scale_factor = DATA_WIDTH'(32'd20971520);
        7'd13: scale_factor = DATA_WIDTH'(32'd19922944);
        7'd14: scale_factor = DATA_WIDTH'(32'd18874368);
        7'd15: scale_factor = DATA_WIDTH'(32'd17825792);
        7'd16: scale_factor = DATA_WIDTH'(32'd16777216);

        // Band 1: 128 -> 64, step 4 (levels 17-32)
        7'd17: scale_factor = DATA_WIDTH'(32'd16252928);
        7'd18: scale_factor = DATA_WIDTH'(32'd15728640);
        7'd19: scale_factor = DATA_WIDTH'(32'd15204352);
        7'd20: scale_factor = DATA_WIDTH'(32'd14680064);
        7'd21: scale_factor = DATA_WIDTH'(32'd14155776);
        7'd22: scale_factor = DATA_WIDTH'(32'd13631488);
        7'd23: scale_factor = DATA_WIDTH'(32'd13107200);
        7'd24: scale_factor = DATA_WIDTH'(32'd12582912);
        7'd25: scale_factor = DATA_WIDTH'(32'd12058624);
        7'd26: scale_factor = DATA_WIDTH'(32'd11534336);
        7'd27: scale_factor = DATA_WIDTH'(32'd11010048);
        7'd28: scale_factor = DATA_WIDTH'(32'd10485760);
        7'd29: scale_factor = DATA_WIDTH'(32'd9961472);
        7'd30: scale_factor = DATA_WIDTH'(32'd9437184);
        7'd31: scale_factor = DATA_WIDTH'(32'd8912896);
        7'd32: scale_factor = DATA_WIDTH'(32'd8388608);

        // Band 2: 64 -> 32, step 2 (levels 33-48)
        7'd33: scale_factor = DATA_WIDTH'(32'd8126464);
        7'd34: scale_factor = DATA_WIDTH'(32'd7864320);
        7'd35: scale_factor = DATA_WIDTH'(32'd7602176);
        7'd36: scale_factor = DATA_WIDTH'(32'd7340032);
        7'd37: scale_factor = DATA_WIDTH'(32'd7077888);
        7'd38: scale_factor = DATA_WIDTH'(32'd6815744);
        7'd39: scale_factor = DATA_WIDTH'(32'd6553600);
        7'd40: scale_factor = DATA_WIDTH'(32'd6291456);
        7'd41: scale_factor = DATA_WIDTH'(32'd6029312);
        7'd42: scale_factor = DATA_WIDTH'(32'd5767168);
        7'd43: scale_factor = DATA_WIDTH'(32'd5505024);
        7'd44: scale_factor = DATA_WIDTH'(32'd5242880);
        7'd45: scale_factor = DATA_WIDTH'(32'd4980736);
        7'd46: scale_factor = DATA_WIDTH'(32'd4718592);
        7'd47: scale_factor = DATA_WIDTH'(32'd4456448);
        7'd48: scale_factor = DATA_WIDTH'(32'd4194304);

        // Band 3: 32 -> 1, step 1 (levels 49-79)
        7'd49: scale_factor = DATA_WIDTH'(32'd4063232);
        7'd50: scale_factor = DATA_WIDTH'(32'd3932160);
        7'd51: scale_factor = DATA_WIDTH'(32'd3801088);
        7'd52: scale_factor = DATA_WIDTH'(32'd3670016);
        7'd53: scale_factor = DATA_WIDTH'(32'd3538944);
        7'd54: scale_factor = DATA_WIDTH'(32'd3407872);
        7'd55: scale_factor = DATA_WIDTH'(32'd3276800);
        7'd56: scale_factor = DATA_WIDTH'(32'd3145728);
        7'd57: scale_factor = DATA_WIDTH'(32'd3014656);
        7'd58: scale_factor = DATA_WIDTH'(32'd2883584);
        7'd59: scale_factor = DATA_WIDTH'(32'd2752512);
        7'd60: scale_factor = DATA_WIDTH'(32'd2621440);
        7'd61: scale_factor = DATA_WIDTH'(32'd2490368);
        7'd62: scale_factor = DATA_WIDTH'(32'd2359296);
        7'd63: scale_factor = DATA_WIDTH'(32'd2228224);
        7'd64: scale_factor = DATA_WIDTH'(32'd2097152);
        7'd65: scale_factor = DATA_WIDTH'(32'd1966080);
        7'd66: scale_factor = DATA_WIDTH'(32'd1835008);
        7'd67: scale_factor = DATA_WIDTH'(32'd1703936);
        7'd68: scale_factor = DATA_WIDTH'(32'd1572864);
        7'd69: scale_factor = DATA_WIDTH'(32'd1441792);
        7'd70: scale_factor = DATA_WIDTH'(32'd1310720);
        7'd71: scale_factor = DATA_WIDTH'(32'd1179648);
        7'd72: scale_factor = DATA_WIDTH'(32'd1048576);
        7'd73: scale_factor = DATA_WIDTH'(32'd917504);
        7'd74: scale_factor = DATA_WIDTH'(32'd786432);
        7'd75: scale_factor = DATA_WIDTH'(32'd655360);
        7'd76: scale_factor = DATA_WIDTH'(32'd524288);
        7'd77: scale_factor = DATA_WIDTH'(32'd393216);
        7'd78: scale_factor = DATA_WIDTH'(32'd262144);
        7'd79: scale_factor = DATA_WIDTH'(32'd131072);

        default: scale_factor = DATA_WIDTH'(32'd131072); // clamp anything > 79 to min
    endcase
end
    // Tile select within a 4x4 grid, book-reading order.
    logic [1:0] tile_col, tile_row;
    assign tile_col = sixteenth[1:0];   // X column
    assign tile_row = sixteenth[3:2];   // Y row = floor(sixteenth/4)

    localparam int unsigned HALF_SPAN = 512;

    // ── Per-sixteenth precompute (Fix 3) ──────────────────────────────────────
    // The original critical cone was, per pixel:
    //     px     = (tile<<8 + a) - 512                 (35-bit add/sub)
    //     x_prod = px * scale                          (35x18 DSP multiply)
    //     z_real = centre_x + trunc35(x_prod)          (35-bit fabric add, stacked)
    // i.e. add → multiply → add, all combinational in one cycle (CARRY4=6, DSP=2).
    //
    // Distribute px = base + a, where base = (tile<<8) - 512 depends ONLY on the
    // sixteenth, and a is the per-pixel coord. Then
    //     x_prod = base*scale + a*scale
    //     z_real = centre_x + trunc35(base*scale + a*scale)
    //            = trunc35( [centre_x_sext + base*scale]  +  a*scale )
    // The bracketed origin term is constant for the whole sixteenth, so register it
    // once. Per pixel only a*scale (an 8-bit multiply) and one add remain. Because
    // origin is carried at full product width, the final trunc35 is bit-identical to
    // the original 35-bit "centre + trunc35(prod)" (both equal (centre+prod) mod 2^35).
    //
    // base is one of {-512,-256,0,+256} for tile_col/tile_row in 0..3.
    //
    // ── Width note (narrow-only area trim) ────────────────────────────────────
    // dual_core is narrow-mode only (control_unit hardwires wide=0) and z_real is
    // consumed as z_real[34:17] downstream — so only the low DATA_WIDTH (=35) bits
    // of every product/accumulator ever matter. The old datapath carried the FULL
    // 2*DATA_WIDTH (=70) product through base*scale, origin, and the per-pixel MAC,
    // then threw the top 35 bits away at the final trunc35. Since the result is
    // (centre + base*scale + a*scale) mod 2^35, and add/sub/low-multiply all commute
    // with "mod 2^35", carrying every stage at 35 bits is bit-identical to the 70-bit
    // version (verified: 200k random cases, 0 mismatch). This halves every accumulator
    // and turns the 35x35->70 multiplies into 35x35->35 low-product multiplies,
    // recovering the LUT/DSP area the precompute fix had cost.
    localparam int PROD_W = DATA_WIDTH;

    // base = (tile<<8) - 512, one of {-512,-256,0,+256}. Depends only on sixteenth.
    logic signed [DATA_WIDTH-1:0]   base_x, base_y;
    assign base_x = $signed((DATA_WIDTH)'(tile_col << RESOLUTION)) - HALF_SPAN;
    assign base_y = $signed((DATA_WIDTH)'(tile_row << RESOLUTION)) - HALF_SPAN;

    // origin_x = centre_x + base_x*scale ; origin_y = centre_y - base_y*scale
    // (note z_imag subtracts the y product, so the per-sixteenth origin subtracts
    //  base_y*scale and the per-pixel term also subtracts a*scale — see below)
    //
    // This precompute updates only once per sixteenth, so it is pipelined across
    // 3 stages for free (origin is valid long before the first pixel dispatches —
    // the engine reset/load/render sequencing gives many idle cycles):
    //   stage 0: register base (cuts the combinational sixteenth_id -> subtract ->
    //            DSP chain that crossed dual_controller->engine and added CARRY4s
    //            ahead of the multiply; now BOTH multiply operands are registered so
    //            they land in the DSP AREG/BREG),
    //   stage 1: base*scale (DSP MREG),
    //   stage 2: + centre with the mac.sv pattern — (* use_dsp *) on the multiply-add
    //            result + full-width add, no mid-truncation — so the centre add packs
    //            into the DSP post-adder (C port) not a fabric CARRY4 chain.
    logic signed [DATA_WIDTH-1:0]   base_x_q, base_y_q;       // stage 0: registered base
    always_ff @(posedge clk) begin
        base_x_q <= base_x;
        base_y_q <= base_y;
    end

    logic signed [PROD_W-1:0] base_x_prod_q, base_y_prod_q;   // stage 1: base*scale
    always_ff @(posedge clk) begin
        base_x_prod_q <= base_x_q * $signed(scale_factor_q);
        base_y_prod_q <= base_y_q * $signed(scale_factor_q);
    end

    (* use_dsp = "yes" *) logic signed [PROD_W-1:0] origin_x; // stage 2: + centre (in-DSP)
    (* use_dsp = "yes" *) logic signed [PROD_W-1:0] origin_y;
    always_ff @(posedge clk) begin
        origin_x <= $signed(centre_x) + base_x_prod_q;
        origin_y <= $signed(centre_y) - base_y_prod_q;
    end

    // ── Per-pixel path (Fix B: a*scale + origin fuses into the DSP post-adder) ─
    // a/b are unsigned pixel offsets (0..255); zero-extend so they stay positive.
    // (* use_dsp *) + full-width multiply-add (no mid-truncation) packs this into a
    // single DSP A*B+C like mac.sv. Truncation to 35 bits happens once at the end,
    // which is bit-identical to the original centre + trunc35(prod) (mod 2^35).
    // The DSP multiply-add output is REGISTERED (lands in the DSP PREG, mac.sv
    // pattern) so the timing path ends at the DSP slice instead of running combin-
    // ationally through the 70->35 truncation and a long route to the dispatch FIFO
    // (the post-precompute critical path: route 4.0ns, fanout 14). This adds 1 cycle
    // of latency on z_real/z_imag; job_prefetch hides it (see SKIP_WAIT there).
    (* use_dsp = "yes" *) logic signed [PROD_W-1:0] zx_full;
    (* use_dsp = "yes" *) logic signed [PROD_W-1:0] zy_full;
    always_ff @(posedge clk) begin
        zx_full <= origin_x + ($signed({1'b0, a}) * $signed(scale_factor_q));
        zy_full <= origin_y - ($signed({1'b0, b}) * $signed(scale_factor_q));
    end

    assign z_real = DATA_WIDTH'(zx_full);
    assign z_imag = DATA_WIDTH'(zy_full);
endmodule