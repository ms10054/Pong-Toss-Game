`timescale 1ns / 1ps

module ir_score_counter_multi(
    input clk_100MHz,
    input reset,
    input [2:0] ir_sensors,    // 3 IR sensors
    output [6:0] seg,
    output [3:0] an,
    output [5:0] score_out
    );
    
    // Internal signals for sensor processing
    wire [2:0] ir_stable;
    wire [2:0] ir_edge;
    
    // 5-second lockout parameters
    // 100MHz * 5 seconds = 500,000,000 clock cycles
    localparam LOCKOUT_DURATION = 500_000_000; 
    reg [28:0] lockout_counter = 0; // 29 bits needed to reach 500 million
    reg is_locked = 0;              // High when ignoring inputs
    
    // Generate debounce and edge detection for each sensor
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : sensor_processing
            debounce db(
                .clk(clk_100MHz),
                .btn_in(ir_sensors[i]),
                .btn_out(ir_stable[i])
            );
            
            edge_detector ed(
                .clk(clk_100MHz),
                .signal_in(ir_stable[i]),
                .edge_out(ir_edge[i])
            );
        end
    endgenerate
    
    reg [5:0] score = 6'd0;
    
    // A sensor trigger is only valid if we are NOT in the 5-second lockout period
    wire valid_trigger = (|ir_edge) && !is_locked;
    
    // Main logic for scoring and lockout timing
    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            score <= 6'd0;
            lockout_counter <= 0;
            is_locked <= 0;
        end else begin
            if (is_locked) begin
                // Lockout active: count down until 5 seconds pass
                if (lockout_counter < LOCKOUT_DURATION) begin
                    lockout_counter <= lockout_counter + 1;
                end else begin
                    // 5 seconds reached, unlock the sensors
                    is_locked <= 0;
                    lockout_counter <= 0;
                end
            end else if (valid_trigger && score < 6'd50) begin
                // Valid hit: increment score and start lockout
                score <= score + 1;
                is_locked <= 1;
                lockout_counter <= 0;
            end
        end
    end
    
    assign score_out = score;
    
    // BCD conversion for 7-segment display
    wire [3:0] ones, tens;
    assign ones = score % 10;
    assign tens = score / 10;
    
    seven_seg_controller ssc(
        .clk(clk_100MHz),
        .digit0(ones),
        .digit1(tens),
        .digit2(4'd0),
        .digit3(4'd0),
        .seg(seg),
        .an(an)
    );
    
endmodule

// ------------------------------------------------------------------
// Debounce module: Filters noise from the raw IR signal
// ------------------------------------------------------------------
module debounce(
    input clk,
    input btn_in,
    output reg btn_out
    );
    
    parameter DELAY = 1000000; // 10ms at 100MHz
    
    reg [19:0] counter;
    reg btn_sync_0, btn_sync_1;
    
    always @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
        
        if (btn_sync_1 == btn_out) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter >= DELAY) begin
                btn_out <= btn_sync_1;
                counter <= 0;
            end
        end
    end
endmodule

// ------------------------------------------------------------------
// Edge detector: Converts a stable high signal into a 1-cycle pulse
// ------------------------------------------------------------------
module edge_detector(
    input clk,
    input signal_in,
    output edge_out
    );
    
    reg signal_d;
    
    always @(posedge clk) begin
        signal_d <= signal_in;
    end
    
    assign edge_out = signal_in & ~signal_d;
    
endmodule

// ------------------------------------------------------------------
// 7-segment display controller
// ------------------------------------------------------------------
module seven_seg_controller(
    input clk,
    input [3:0] digit0,
    input [3:0] digit1,
    input [3:0] digit2,
    input [3:0] digit3,
    output reg [6:0] seg,
    output reg [3:0] an
    );
    
    reg [1:0] digit_select;
    reg [16:0] refresh_counter;
    reg [3:0] current_digit;
    
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        if (refresh_counter == 0) begin
            digit_select <= digit_select + 1;
        end
    end
    
    always @* begin
        case (digit_select)
            2'd0: begin an = 4'b1110; current_digit = digit0; end
            2'd1: begin an = 4'b1101; current_digit = digit1; end
            2'd2: begin an = 4'b1011; current_digit = digit2; end
            2'd3: begin an = 4'b0111; current_digit = digit3; end
            default: begin an = 4'b1111; current_digit = 4'd0; end
        endcase
    end
    
    always @* begin
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
            default: seg = 7'b1111111;
        endcase
    end
    
endmodule