module booth_multiplier(
    input signed [7:0] multiplicand,
    input signed [7:0] multiplier,
    output reg signed [15:0] product
);

reg signed [15:0] a, s;
reg [3:0] i;

always @* begin
    a = multiplicand;
    s = {8'b0, multiplier};

    product = 0;

    for (i = 0; i < 8; i = i + 1) begin
        if (s[1:0] == 2'b01) begin
            product = product + a;
        end else if (s[1:0] == 2'b10) begin
            product = product - a;
        end

        // Arithmetic right shift
        s = {s[15], s[15:1]};
    end
end

endmodule
