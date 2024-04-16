module booth_multiplier (
    input signed [7:0] multiplicand,
    input signed [7:0] multiplier,
    output reg signed [15:0] product
);
    reg signed [15:0] a, s;
    reg [3:0] i;

    // Instantiate shift register
    shift_register shift_reg_inst (
        .data_in({8'b0, multiplier}),
        .shift(1),
        .data_out(s)
    );

    // Instantiate PIPO
    pipo pipo_inst (
        .data_in(multiplicand),
        .data_out(a)
    );

    // Instantiate ALU
    alu alu_inst (
        .a(a),
        .b(s),
        .add_sub(1),
        .result(product)
    );

    // Instantiate counter
    counter counter_inst (
        .clk(1'b1), // You need to provide a clock signal
        .ldcnt(1),
        .decr(0),
        .count(i)
    );

    always @* begin
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
