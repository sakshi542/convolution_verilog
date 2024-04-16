module datapath_controller (
    input signed [7:0] data_in [0:7], // Input data (8 samples of 8-bit 2's complement)
    output reg signed [15:0] result [0:15], // Convolution result (16 samples of 16-bit 2's complement)
    input clk, // Clock input
    input rst // Reset input
);

// Define states of the FSM
typedef enum bit [2:0] {
    S0, // Start
    S1, // Load signal1
    S2, // Load signal2
    S3, // Multiplication booths
    S4, // Accumulation
    S5  // Done state
} state_t;

reg [2:0] state, next_state; // State register and next state register
reg signed [15:0] temp = 0; // Temporary variable for storing multiplication result
reg [3:0] i, j; // Counters for loop iterations

// Signal data to load into signal1 and signal2
reg signed [7:0] signal1 [0:7]; // Signal 1 (8 samples of 8-bit 2's complement)
reg signed [7:0] signal2 [0:7]; // Signal 2 (8 samples of 8-bit 2's complement)

// Counter for loop iterations
reg [3:0] loop_counter;

// FSM state logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset FSM and result
        state <= S0;
        for (i = 0; i < 16; i = i + 1) begin
            result[i] <= 0;
        end
        loop_counter <= 15; // Initialize loop counter to 15
    end else begin
        state <= next_state;
    end
end

// FSM next state logic
always @(posedge clk) begin
    case (state)
        S0: begin
            next_state <= S1;
        end
        S1: begin
            next_state <= S2;
        end
        S2: begin
            next_state <= S3;
        end
        S3: begin
            next_state <= S4;
        end
        S4: begin
            // If loop counter is 0, transition to S5, otherwise transition back to S3
            if (loop_counter == 0) begin
                next_state <= S5;
            end else begin
                next_state <= S3;
            end
        end
        S5: begin
            // No next state needed, it's the done state
        end
    endcase
end

// FSM output logic
always @(*) begin
    case (state)
        S0: begin
            i = 0;
            j = 0;
        end
        S1: begin
            signal1[i] = data_in[i]; // Load data from data_in into signal1
        end
        S2: begin
            signal2[i] = data_in[i]; // Load data from data_in into signal2
        end
        S3: begin
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
        S4: begin
            result[i + j] = result[i + j] + temp;
            loop_counter = loop_counter - 1; // Decrement loop counter
        end
        S5: begin
            // No further action needed, it's the done state
        end
    endcase
end

endmodule
