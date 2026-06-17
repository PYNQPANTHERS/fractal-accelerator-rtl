module max_iteration_flagger #(parameter ITERATION_COUNT_WIDTH = 16, LOWEST_MAX_ITERATION_POWER = 6) //this means our lowest iteration is 64
(input [ITERATION_COUNT_WIDTH-1:0] iteration_count,
input [4:0] max_iteration,
output logic flag
);

    assign flag = iteration_count[max_iteration+LOWEST_MAX_ITERATION_POWER];

endmodule