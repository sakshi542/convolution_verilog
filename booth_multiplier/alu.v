module alu (
    input [7:0] a,
    input [15:0] b,
    input add_sub,
    output reg [15:0] result
);
    always @* begin
        if (add_sub) begin
            result = a + b;
        end else begin
            result = a - b;
        end
    end
endmodule
