`timescale 1ns / 1ps

module tb_linear_convolution;

// Parameters
parameter CLK_PERIOD = 10; // Clock period in ns

// Signals
reg clk;
reg rst;
reg signed [7:0] signal1 [0:7];
reg signed [7:0] signal2 [0:7];
wire signed [15:0] result [0:15];

// Instantiate DUT
top_module dut (
    .clk(clk),
    .rst(rst),
    .signal1(signal1),
    .signal2(signal2),
    .result(result)
);

// Clock generation
always #((CLK_PERIOD / 2)) clk = ~clk;

// Reset generation
initial begin
    rst = 1;
    #10 rst = 0;
end

// Test vectors
initial begin
    // Provide input signals
    signal1[0] = 8'b00000001;
    signal1[1] = 8'b00000010;
    signal1[2] = 8'b00000011;
    signal1[3] = 8'b00000100;
    signal1[4] = 8'b00000101;
    signal1[5] = 8'b00000110;
    signal1[6] = 8'b00000111;
    signal1[7] = 8'b00001000;
    
    signal2[0] = 8'b00000001;
    signal2[1] = 8'b00000010;
    signal2[2] = 8'b00000011;
    signal2[3] = 8'b00000100;
    signal2[4] = 8'b00000101;
    signal2[5] = 8'b00000110;
    signal2[6] = 8'b00000111;
    signal2[7] = 8'b00001000;

    // Wait for simulation to stabilize
    #100;

    // Print convolution result
    $display("Convolution result:");
    for (int i = 0; i < 16; i = i + 1) begin
        $display("%d: %d", i, result[i]);
    end

    // End simulation
    $finish;
end

endmodule
