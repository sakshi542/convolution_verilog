module top_module (
    input clk,
    input rst,
    input signed [7:0] signal1 [0:7],
    input signed [7:0] signal2 [0:7],
    output reg signed [15:0] result [0:15]
);

// Instantiate the linear_convolution_fsm module
datapath_controller datapathController_inst (
    .signal1(signal1),
    .signal2(signal2),
    .result(result),
    .clk(clk),
    .rst(rst)
);

endmodule
