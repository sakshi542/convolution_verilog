module pipo (
    input [15:0] data_in,
    output reg [15:0] data_out
);
    always @* begin
        data_out = data_in;
    end
endmodule
