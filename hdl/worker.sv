module worker #(
    parameter DATA_WIDTH = 32,
    parameter ITERATIONS = 12,
    parameter MULTIPLICATIONS = 3
) (

    input logic clk,
    input logic rst,
    input logic start,

    //complex coordinate
    input logic signed [DATA_WIDTH-1:0] coordinate_r,    
    input logic signed [DATA_WIDTH-1:0] coordinate_i,

    //fractal type
    input logic julia_type,
    input logic burning_type,

    //julia global constant
    input logic signed [DATA_WIDTH-1:0] constant_r,    
    input logic signed [DATA_WIDTH-1:0] constant_i,

    //for optimal multiplication
    input logic [MULTIPLICATIONS-1:0] square,
    input logic [MULTIPLICATIONS-1:0] single,

    input logic [ITERATIONS-1:0] max_iteration,

    output logic escaped,
    output logic [ITERATIONS-1:0] iteration_count,
    output logic done
);

logic [ITERATIONS-1:0] iteration;

logic signed [DATA_WIDTH-1:0] z_r;
logic signed [DATA_WIDTH-1:0] z_i;

logic signed [DATA_WIDTH-1:0] c_r;
logic signed [DATA_WIDTH-1:0] c_i;

//exponent
logic signed [DATA_WIDTH-1:0] zi_r;
logic signed [DATA_WIDTH-1:0] zi_i;
logic pow_done;

typedef enum logic [1:0] { 
    EXP,
    ADD,
    IDLE
} worker_state;

worker_state iterator_stage;

complex_pow #(.DATA_WIDTH(DATA_WIDTH), .MULTIPLICATIONS(MULTIPLICATIONS)) pow_inst (
    .clk(clk),
    .rst(rst),
    .start(start),
    .z_r(z_r),
    .z_i(z_i),
    .square(square),
    .single(single),
    .zi_r(zi_r),
    .zi_i(zi_i),
    .done(pow_done)
);

always_ff @(posedge clk) begin
    if (rst) begin
        z_r <= 0;
        z_i <= 0;

        c_r <= 0;
        c_i <= 0;

        iteration <= 0;
        escaped <= 0;
        
        done <= 0;
        pow_start <= 0;

    end else if (start) begin

        if (julia_type) begin
            z_r <= coordinate_r;
            z_i <= coordinate_i;
            
            c_r <= constant_r;
            c_i <= constant_i;
        end else begin // need to do burning ship support next
            z_r <= 0;
            z_i <= 0;
            
            c_r <= coordinate_r;
            c_i <= coordinate_i;
        end

        iteration  <= 0;
        escaped    <= 0;
        
        done       <= 0;
        pow_start  <= 1;

    end else begin
        pow_start <= 0;

        if (pow_done) begin
            z_r       <= zi_r + c_r;
            z_i       <= zi_i + c_i;
            iteration <= iteration + 1;

            if (/* escape check */) begin // need to figure out best way to do this.
                escaped <= 1;
                done <= 1;
                iteration_count <= iteration + 1;

            end else if (iteration + 1 >= max_iteration) begin
                escaped <= 0;
                done <= 1;
                iteration_count <= iteration + 1;

            end else begin
                pow_start <= 1;
                
            end
        end
    end
end

endmodule