module shift_register (
    input [15:0] data_in,
    input shift,
    output [15:0] data_out
);
    reg [15:0] reg_data;

    always @(posedge shift) begin
        reg_data <= {reg_data[15], reg_data[15:1]};
    end

    assign data_out = reg_data;
endmodule
