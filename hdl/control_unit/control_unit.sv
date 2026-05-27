module control_unit #(
    parameter int DATA_WIDTH    = 17,
    parameter int PIXEL_WIDTH   = 9,   // translate resolution
    parameter int CLUSTER_COUNT = 4,   // number of clusters
    parameter int CLUSTER_SIZE  = 8,   // cores per cluster
    parameter int PIXEL_ADDR_W  = 16,  // pixel address bits
    parameter int JOB_DATA_W    = 18,  // job payload bits
    parameter int PIXEL_W       = 8    // result pixel bits
) (
    input  logic            clk,
    input  logic            rst,
    input  logic            start_flag,
    input  logic            width_flag,      
    input  logic [4:0]      fractal_type,    
    input  logic [4:0]      iteration_count,
    output logic []           result
);

    // --------------------------------------------------------------------
    // Local params
    // --------------------------------------------------------------------
    localparam int Z_WIDTH      = DATA_WIDTH + 1;         // 1 sign + DATA_WIDTH data
    localparam int Z_WIDE       = Z_WIDTH * 2 - 1;        // packed case {signed, upper, lower}
    localparam int CLUST_ADDR_W = $clog2(CLUSTER_COUNT);  // bits to address a cluster

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
        OPCODE_BROADCAST,       // drives everycore with opcode in one cycle
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
    // Cluster signals
    // --------------------------------------------------------------------
    logic [CLUSTER_COUNT-1:0]              cluster_wants_job;
    logic [CLUSTER_COUNT-1:0]              cluster_disp_valid;
    logic [PIXEL_ADDR_W-1:0]              disp_pixel_addr;   // TODO: drive from scan counter
    logic [JOB_DATA_W-1:0]               disp_job_data;     // TODO: drive from datapath

    logic [CLUSTER_COUNT-1:0]              cluster_result_valid;
    logic [CLUSTER_COUNT-1:0]              cluster_result_ready;
    logic [PIXEL_ADDR_W-1:0]              cluster_result_pixel_addr [CLUSTER_COUNT];
    logic [PIXEL_W-1:0]                   cluster_result_data       [CLUSTER_COUNT];

    // Placeholder until datapath is wired
    assign disp_pixel_addr = '0;
    assign disp_job_data   = '0;
    assign cluster_result_ready = '1; // TODO: backpressure from output stage

    // --------------------------------------------------------------------
    // Priority encoder: arbitrate between clusters wanting a job
    // --------------------------------------------------------------------
    logic [CLUSTER_COUNT-1:0]  wants_onehot;
    logic [CLUST_ADDR_W-1:0]  winner_idx;
    logic                      any_cluster_free;

    priority_encoder #(
        .BUS_WIDTH (CLUSTER_COUNT)
    ) u_cluster_arb (
        .core_bus    (cluster_wants_job),
        .core_select (wants_onehot),
        .core_address(winner_idx),
        .any_valid   (any_cluster_free)
    );

    // --------------------------------------------------------------------
    // Pipeline the encoder output by one cycle for timing / hand-off
    // --------------------------------------------------------------------
    logic [CLUSTER_COUNT-1:0] ichooseyou;
    logic                     ichooseyou_flag;

    always_ff @(posedge clk) begin
        if (rst) begin
            ichooseyou      <= '0;
            ichooseyou_flag <= 1'b0;
        end else begin
            ichooseyou      <= wants_onehot;
            ichooseyou_flag <= any_cluster_free;
        end
    end

    // Only the winning cluster receives disp_valid
    assign cluster_disp_valid = (current_state == LOAD_Z_NARROW ||
                                 current_state == LOAD_Z_WIDE)
                                 ? ichooseyou : '0;

    // --------------------------------------------------------------------
    // Generate CLUSTER_COUNT cluster instances
    // --------------------------------------------------------------------
    generate
        for (genvar g = 0; g < CLUSTER_COUNT; g++) begin : gen_clusters
            cluster #(
                .CLUSTER_SIZE (CLUSTER_SIZE),
                .PIXEL_ADDR_W (PIXEL_ADDR_W),
                .PIXEL_W      (PIXEL_W),
                .JOB_DATA_W   (JOB_DATA_W)
            ) u_cluster (
                .clk               (clk),
                .rst_n             (~rst),
                .disp_valid        (cluster_disp_valid[g]),
                .disp_pixel_addr   (disp_pixel_addr),
                .disp_job_data     (disp_job_data),
                .cluster_wants_job (cluster_wants_job[g]),
                .result_valid      (cluster_result_valid[g]),
                .result_pixel_addr (cluster_result_pixel_addr[g]),
                .result_data       (cluster_result_data[g]),
                .result_ready      (cluster_result_ready[g])
            );
        end
    endgenerate

endmodule