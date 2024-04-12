module linear_convolution_fsm (
    input signed [7:0] signal1 [0:7], // Input signal 1 (8 samples of 8-bit 2's complement)
    input signed [7:0] signal2 [0:7], // Input signal 2 (8 samples of 8-bit 2's complement)
    output reg signed [15:0] result [0:15], // Convolution result (16 samples of 16-bit 2's complement)
    input clk, // Clock input
    input rst // Reset input
);

// Data path controller instantiation
data_path_controller dp_controller (
    .clk(clk),
    .rst(rst),
    .start(state == IDLE), // Start convolution when in IDLE state
    .conv_done(next_state == IDLE) // Move to IDLE state when convolution is done
);

// Define states of the FSM
typedef enum logic [2:0] {
    IDLE,
    MULTIPLY,
    ACCUMULATE
} state_t;

reg [2:0] state, next_state; // State register and next state register
reg signed [15:0] temp; // Temporary variable for storing multiplication result
reg [3:0] i, j; // Counters for loop iterations

// FSM state logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset FSM and result
        state <= IDLE;
        for (i = 0; i < 16; i = i + 1) begin
            result[i] <= 0;
        end
    end else begin
        state <= next_state;
    end
end

// FSM next state logic
always @* begin
    next_state = state;

    case (state)
        IDLE: begin
            next_state = MULTIPLY;
        end
        MULTIPLY: begin
            if (i == 7 && j == 7) begin
                next_state = ACCUMULATE;
            end
        end
        ACCUMULATE: begin
            // No further state transition needed
        end
    endcase
end

// FSM output logic
always @* begin
    case (state)
        IDLE: begin
            i = 0;
            j = 0;
        end
        MULTIPLY: begin
            // Booth's multiplier instantiation
            booth_multiplier bm_inst (
                .multiplicand(signal1[i]),
                .multiplier(signal2[j]),
                .product(temp)
            );

            if (j == 7) begin
                i = i + 1;
                j = 0;
            end else begin
                j = j + 1;
            end
        end
        ACCUMULATE: begin
            result[i + j] = result[i + j] + temp;
        end
    endcase
end

endmodule
