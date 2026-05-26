module control_unit #(
    parameter int DATA_WIDTH  = 17,
    parameter int CORE_COUNT  = 8
) (
    input logic clk,
    input logic rst,
    input logic start_flag,
    input logic width_flag,
    input logic fractal_type,
    input logic [4:0] iteration_count, 
    output logic result
);


    localparam int RESOLUTION = 10;           // 2^10 = 1024 pixels
    localparam int Z_WIDTH    = DATA_WIDTH + 1; // 1 sign + 17 data = 18 bits
    localparam int Z_WIDE     = Z_WIDTH * 2;    // 36 bits (real + imag packed)

    logic [DATA_WIDTH-1:0] pan_x, pan_y;
    logic [RESOLUTION-1:0] pix_a, pix_b;
    logic [3:0]            zoom;
    logic [Z_WIDTH-1:0]    z_real, z_imag; 

    logic [Z_WIDE-1:0]  load_z_wide;
    logic [Z_WIDTH-1:0] load_z_narrow_real;
    logic [Z_WIDTH-1:0] load_z_narrow_imag;

    translate #(
        .DATA_WIDTH (Z_WIDTH),
        .RESOLUTION (RESOLUTION)
    ) cheezy_translator (
        .pan_x  (pan_x),
        .pan_y  (pan_y),
        .a      (pix_a),
        .b      (pix_b),
        .zoom   (zoom),
        .z_real (z_real),
        .z_imag (z_imag)
    );

    // state
    typedef enum data_type {IDLE, START, WAIT, LOAD_C_NARROW, LOAD_C_WIDE, LOAD_Z_NARROW, LOAD_Z_WIDE} my_state;
    my_state current_state, next_state;


    // state ticker
    always_ff @(posedge clk) begin: state_ticker
        current_state <= next_state;
    end

    // state logic
    always_comb begin: state_logic
        case(current_state)

            IDLE:   if (start_flag) begin
                        next_state = START;
                    end

            START:  if (julia) begin
                        if(wide) begin
                            next_state = LOAD_C_WIDE;
                        end
                        else begin
                            next_state = LOAD_C_NARROW;
                        end
                    end

            WAIT:   if (ichooseyou_flag) begin
                        load_real_wide        <= {re_sgn, z_real[DATA_WIDTH-1:0]};
                        load_imag_wide        <= {im_sgn, z_imag[DATA_WIDTH-1:0]};
                        load_real_narrow      <= {re_sgn, z_real[DATA_WIDTH-1:0]};
                        load_imag_narrow      <= {im_sgn, z_imag[DATA_WIDTH-1:0]};
                        if(wide) begin 
                            next_state = LOAD_Z_WIDE;
                        end
                        else begin
                            next_state = LOAD_Z_NARROW;
                        end
                    end
            
            LOAD_Z_NARROW:

            // x then y 


        endcase
    end

    // out logic
    always_comb begin: output_logic
        case(current_state)

            START: 
        endcase    
    end


    // core handler
    localparam int ADDR_LEN = $clog2(CORE_COUNT);
    logic [CORE_COUNT-1:0] core_bus;   // one bit per core: 1 = free
    logic [CORE_COUNT-1:0] core_sel;   // one-hot selected core
    logic [ADDR_LEN-1:0]   core_addr;  // binary index of selected core

    priority_encoder #(
        .core_number    (CORE_COUNT)
    ) u_priority_encoder (
        .core_bus       (core_bus),
        .core_select    (core_sel),
        .core_address   (core_addr)
    );

    // align ichooseyou
    logic [CORE_COUNT-1:0]  ichooseyou;
    logic                   ichooseyou_flag;

    always_ff @(posedge clk) begin
        ichooseyou <= core_sel;
        ichooseyou_flag <= (core_addr != 0) ? 1b'1 : 1b'0;
    end



    // need a ram for each iterator store each pixel need to be able to get address from core
    // to pass final it count and pixel coord

    localparam int PIXEL_WIDTH = 40;

    logic                    ram_we;
    logic [PIXEL_WIDTH-1:0]  ram_din;
    logic [PIXEL_WIDTH-1:0]  ram_dout;

    core_ram #(
        .CORE_COUNT  (CORE_COUNT),
        .PIXEL_WIDTH (PIXEL_WIDTH)
    ) u_core_ram (
        .clk  (clk),
        .we   (ram_we),
        .addr (core_addr),
        .din  (ram_din),
        .dout (ram_dout)
    );

  

    // Z packing for core loading
    //   wide:   upper = z_real (sign intact), lower = z_imag with sign forced 0
    //   narrow: load real then imag separately, imag sign forced 0

   
    //datapath
    logic [10:0]           op_code;
    logic [DATA_WIDTH-1:0] data_path;

    always_ff @(posedge clk) begin
        op_code   <= {width_flag, fractal_type, iteration_count};
    end

    // call n cores
endmodule 