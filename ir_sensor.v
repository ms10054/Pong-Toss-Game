`timescale 1ns / 1ps
module ir_score_counter(
    input clk_100MHz,
    input reset,
    input ir_sensor,       // Active high when ball breaks beam
    output reg [6:0] seg,
    output reg [3:0] an
);
    // Score: 0 to 50
    reg [5:0] score = 0;
    
    // Debounce parameters (20ms debounce time)
    localparam DEBOUNCE_TIME = 2_000_000; // 20ms at 100MHz
    reg [20:0] debounce_counter = 0;
    reg ir_debounced = 0;
    reg ir_prev = 0;
    wire ir_rising_edge;
    
    // 7-segment multiplexing
    reg [16:0] refresh_counter = 0;
    reg digit_select = 0;
    
    // Digits
    wire [3:0] ones = score % 10;
    wire [3:0] tens = score / 10;
    
    // --------------------- IR Sensor Debounce & Edge Detect ---------------------
    always @(posedge clk_100MHz) begin
        if (reset) begin
            debounce_counter <= 0;
            ir_debounced <= 0;
            ir_prev <= 0;
        end else begin
            // If sensor state matches debounced state, reset counter
            if (ir_sensor == ir_debounced) begin
                debounce_counter <= 0;
            end 
            // If sensor state differs, increment counter
            else begin
                debounce_counter <= debounce_counter + 1;
                // Once counter reaches threshold, update debounced value
                if (debounce_counter >= DEBOUNCE_TIME) begin
                    ir_debounced <= ir_sensor;
                    debounce_counter <= 0;
                end
            end
            
            // Store previous debounced value for edge detection
            ir_prev <= ir_debounced;
        end
    end
    
    // Detect rising edge on debounced signal
    assign ir_rising_edge = (ir_debounced && !ir_prev);
    
    // --------------------- Score Counter ---------------------
    always @(posedge clk_100MHz) begin
        if (reset) begin
            score <= 0;
        end else if (ir_rising_edge && score < 50) begin
            score <= score + 1;
        end
    end
    
    // --------------------- 7-Segment Refresh (~800 Hz total, ~400 Hz per digit) ---------------------
    always @(posedge clk_100MHz) begin
        if (reset) begin
            refresh_counter <= 0;
            digit_select <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter == 0)  // Every ~1.31 ms
                digit_select <= ~digit_select;
        end
    end
    
    // --------------------- Digit Selection ---------------------
    reg [3:0] current_digit;
    always @(*) begin
        case (digit_select)
            1'b0: begin
                an = 4'b1110;          // Right digit (ones)
                current_digit = ones;
            end
            1'b1: begin
                an = 4'b1101;          // Left digit (tens)
                current_digit = tens;
            end
            default: begin
                an = 4'b1111;
                current_digit = 4'd0;
            end
        endcase
    end
    
    // --------------------- 7-Segment Decoder (Common Anode) ---------------------
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111; // Off
        endcase
    end
endmodule