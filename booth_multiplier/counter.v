module counter (
    input clk,ldcnt,decr;
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (ldcnt) begin
            count <= 4'b1000;
        end else if (decr) begin
            count <= count - 1;
        end
    end
endmodule
