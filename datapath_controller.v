module data_path_controller (
    input clk, // Clock input
    input rst, // Asynchronous reset input
    input start, // Start signal to initiate convolution
    output reg conv_done // Convolution done signal
);

reg [2:0] state, next_state; // State register and next state register
reg [3:0] i, j; // Counters for loop iterations

// Define states of the controller
parameter IDLE = 3'b000;
parameter MULTIPLY = 3'b001;
parameter ACCUMULATE = 3'b010;

// FSM state logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset FSM and result
        state <= IDLE;
        conv_done <= 0;
    end else begin
        state <= next_state;
    end
end

// FSM next state logic
always @* begin
    next_state = state;

    case (state)
        IDLE: begin
            if (start) begin
                next_state = MULTIPLY;
            end
        end
        MULTIPLY: begin
            if (i == 7 && j == 7) begin
                next_state = ACCUMULATE;
            end
        end
        ACCUMULATE: begin
            next_state = IDLE;
            conv_done = 1;
        end
    endcase
end

// Loop counters
always @(posedge clk) begin
    if (state == MULTIPLY) begin
        if (j == 7) begin
            i <= i + 1;
            j <= 0;
        end else begin
            j <= j + 1;
        end
    end
end

endmodule
