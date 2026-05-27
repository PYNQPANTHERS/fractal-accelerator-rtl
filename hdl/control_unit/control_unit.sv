module control_unit #(
    parameter int DATA_WIDTH  = 17,
    parameter int CORE_COUNT  = 8,
    parameter int PIXEL_WIDTH = 9
) (
    input  logic            clk,
    input  logic            rst,
    input  logic            start_flag,
    input  logic            width_flag,      
    input  logic [4:0]      fractal_type,    
    input  logic [4:0]      iteration_count,
    output logic            result
);

    // --------------------------------------------------------------------
    // Local params
    // --------------------------------------------------------------------
    localparam int Z_WIDTH    = DATA_WIDTH + 1;      // 1 sign + DATA_WIDTH data
    localparam int Z_WIDE     = Z_WIDTH * 2 - 1;     // packed case {signed, upper, lower}
    localparam int ADDR_LEN   = $clog2(CORE_COUNT);

    // --------------------------------------------------------------------
    // Translate: pixel coord -> complex plane
    // --------------------------------------------------------------------
    logic [DATA_WIDTH-1:0] pan_x, pan_y;
    logic [RESOLUTION-1:0] pix_a, pix_b;
    logic [3:0]            zoom;
    logic [Z_WIDE-1:0]     z_real, z_imag;

    translate #(
        .DATA_WIDTH (Z_WIDE),
        .RESOLUTION (PIXEL_WIDTH)
    ) cheezy_translator (
        .pan_x  (pan_x),
        .pan_y  (pan_y),
        .a      (pix_a),
        .b      (pix_b),
        .zoom   (zoom),
        .z_real (z_real),
        .z_imag (z_imag)
    );

    // --------------------------------------------------------------------
    // sign bits of the translated coordinate. The MSB of z_real/z_imag is
    // the sign bit out of translate; rename for readability.
    // --------------------------------------------------------------------
    logic re_sgn, im_sgn;
    assign re_sgn = z_real[Z_WIDE-1];
    assign im_sgn = z_imag[Z_WIDE-1];

    // --------------------------------------------------------------------
    // latched load values - aligns to FSM
    // narrow case just uses lower reg
    // --------------------------------------------------------------------

    logic [Z_WIDTH-1:0]  load_real_lower, load_imag_lower;
    logic [Z_WIDTH-1:0]  load_real_upper,   load_imag_upper;
    logic [Z_WIDE-1:0]   load_z_wide;     

    // --------------------------------------------------------------------
    // FSM
    // --------------------------------------------------------------------
    typedef enum logic [2:0] {
        IDLE,                   // pre-frame request
        START,                  // opcode and c load
        WAIT,                   // wait for free core and start of z load
        
        LOAD_C_NARROW,          // c load for narrow
        LOAD_C_WIDE,            // c load for wide
        LOAD_Z_NARROW,          // z load for narrow
        LOAD_Z_WIDE             // z load for wide
    } my_state;

    my_state current_state, next_state;


    // state register with reset
    always_ff @(posedge clk) begin : state_reg
        if (rst) current_state <= IDLE;
        else     current_state <= next_state;
    end

    // next-state logic (pure combinational, default assignment up top)

    // TODO loading rules
    always_comb begin : next-state_logic
        next_state = current_state; // default: hold

        unique case (current_state)
            IDLE: begin
                if (start_flag) next_state = START;
            end

            START: begin
                if (julia) next_state = wide ? LOAD_C_WIDE : LOAD_C_NARROW;
                else       next_state = WAIT; // Mandelbrot: skip C-load, go pick a core
            end

            WAIT: begin
                if (ichooseyou_flag)
                    next_state = wide ? LOAD_Z_WIDE : LOAD_Z_NARROW;
            end

            LOAD_C_NARROW,
            LOAD_C_WIDE: begin
                // After loading the Julia constant C, fall through to the
                // per-pixel Z dispatch loop.
                next_state = WAIT;
            end

            LOAD_Z_NARROW,
            LOAD_Z_WIDE: begin
                // TODO: when scan is finished, go back to IDLE; otherwise
                //       loop back to WAIT to grab the next free core for
                //       the next pixel.
                next_state = WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // --------------------------------------------------------------------
    // datapath latching: drive the registers 
    // NOT from inside always_comb. The values we want to capture
    // are the transfered z_real/z_imag at the moment a core becomes free.
    // --------------------------------------------------------------------
    always_ff @(posedge clk) begin : load_latch
        if (rst) begin
            load_real_upper     <= '0;
            load_imag_upper     <= '0;
            load_real_lower     <= '0;
            load_imag_lower     <= '0;
        end
        else if (current_state == WAIT && ichooseyou_flag) begin
            load_real_upper     <= {z_real[DATA_WIDE-1:DATA_WIDTH]};
            load_imag_upper     <= {z_imag[DATA_WIDE-1:DATA_WIDTH]};
            load_real_lower     <= {re_sgn, z_real[DATA_WIDTH-1:0]};
            load_imag_lower     <= {im_sgn, z_imag[DATA_WIDTH-1:0]};
        end
    end

    // --------------------------------------------------------------------
    // output logic
    // TODO: pass result and neccessaryy state transitions 
    // --------------------------------------------------------------------
    always_comb begin : output_logic
        result = 1'b0;
        unique case (current_state)
            START: begin
                // e.g. result = 1'b1; // frame-start pulse?
            end
            default: ;
        endcase
    end

    // --------------------------------------------------------------------
    // Core selection
    // TODO: core_bus needs to be driven by the cores themselves
    //       (1 = free / done). Tied off for now.
    // --------------------------------------------------------------------
    logic [CORE_COUNT-1:0] core_bus;
    logic [CORE_COUNT-1:0] core_sel;
    logic [ADDR_LEN-1:0]   core_addr;

    assign core_bus = '0; // TODO: connect to per-core free/done signals

    priority_encoder #(
        .core_number  (CORE_COUNT)
    ) u_priority_encoder (
        .core_bus     (core_bus),
        .core_select  (core_sel),
        .core_address (core_addr)
    );

    // Pipeline the encoder output by one cycle for timing / hand-off
    logic [CORE_COUNT-1:0] ichooseyou;
    logic                  ichooseyou_flag;

    always_ff @(posedge clk) begin
        if (rst) begin
            ichooseyou      <= '0;
            ichooseyou_flag <= 1'b0;
        end
        else begin
            ichooseyou      <= core_sel;
            ichooseyou_flag <= |core_sel; // any bit set => a core was picked
        end
    end

s

    // --------------------------------------------------------------------
    // op-code broadcast to cores
    // --------------------------------------------------------------------
    logic [10:0]           op_code;       // {width_flag, fractal_type[4:0], iteration_count[4:0]}
    logic [DATA_WIDTH-1:0] data_path;     // TODO: hook up if/when needed

    always_ff @(posedge clk) begin
        if (rst) op_code <= '0;
        else     op_code <= {width_flag, fractal_type, iteration_count};
    end

    // TODO: instantiate / connect the N iterator cores here, fed by
    //       ichooseyou (one-hot enable), load_real_*/load_imag_*, op_code.

endmodule