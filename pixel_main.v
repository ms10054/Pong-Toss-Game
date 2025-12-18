`timescale 1ns / 1ps

module pixel_main(
    input [2:0] ir_sensor_p1,   // 3 IR sensors for player 1
    input [2:0] ir_sensor_p2,   // 3 IR sensors for player 2
    input clk,
    input reset,                // Reset input
    input video_on,
    input [9:0] x, y,
    input [3:0] sec_1s, sec_10s,
    input [3:0] min_1s, min_10s,
    input [5:0] score_p1,       // Player 1 score (0-50)
    input [5:0] score_p2,       // Player 2 score (0-50)
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
    );

    // *** Timer Display Constants ***
    localparam M10_X_L = 256;
    localparam M10_X_R = 287;
    localparam M10_Y_T = 30;
    localparam M10_Y_B = 93;
    
    localparam M1_X_L = 288;
    localparam M1_X_R = 319;
    localparam M1_Y_T = 30;
    localparam M1_Y_B = 93;
    
    localparam COLON_X_L = 320;
    localparam COLON_X_R = 351;
    localparam COLON_Y_T = 30;
    localparam COLON_Y_B = 93;
    
    localparam S10_X_L = 352;
    localparam S10_X_R = 383;
    localparam S10_Y_T = 30;
    localparam S10_Y_B = 93;
    
    localparam S1_X_L = 384;
    localparam S1_X_R = 415;
    localparam S1_Y_T = 30;
    localparam S1_Y_B = 93;
    
    // *** Score Display Constants ***
    localparam SCORE1_10_X_L = 160;
    localparam SCORE1_10_X_R = 191;
    localparam SCORE1_10_Y_T = 192;
    localparam SCORE1_10_Y_B = 255;
    
    localparam SCORE1_1_X_L = 192;
    localparam SCORE1_1_X_R = 223;
    localparam SCORE1_1_Y_T = 192;
    localparam SCORE1_1_Y_B = 255;

    localparam SCORE2_10_X_L = 416;
    localparam SCORE2_10_X_R = 447;
    localparam SCORE2_10_Y_T = 192;
    localparam SCORE2_10_Y_B = 255;
    
    localparam SCORE2_1_X_L = 448;
    localparam SCORE2_1_X_R = 479;
    localparam SCORE2_1_Y_T = 192;
    localparam SCORE2_1_Y_B = 255;

    // *** Cup Circle Constants (Upside Down Triangle Formation) ***
    localparam CIRCLE_RADIUS = 30;
    
    // Player 1 circles (left side)
    localparam P1_CIRCLE1_X = 130;
    localparam P1_CIRCLE1_Y = 350;
    localparam P1_CIRCLE2_X = 190;
    localparam P1_CIRCLE2_Y = 350;
    localparam P1_CIRCLE3_X = 160;
    localparam P1_CIRCLE3_Y = 280;
    
    // Player 2 circles (right side)
    localparam P2_CIRCLE1_X = 450;
    localparam P2_CIRCLE1_Y = 350;
    localparam P2_CIRCLE2_X = 510;
    localparam P2_CIRCLE2_Y = 350;
    localparam P2_CIRCLE3_X = 480;
    localparam P2_CIRCLE3_Y = 280;

    // Timer constant for 1 second flash (assuming 100MHz clock)
    localparam FLASH_DURATION = 100_000_000; // 1 second at 100MHz

    // *** Circle Color State (RED by default, GREEN when hit for 1 second) ***
    reg p1_circle1_green;
    reg p1_circle2_green;
    reg p1_circle3_green;
    reg p2_circle1_green;
    reg p2_circle2_green;
    reg p2_circle3_green;
    
    // Timers for green flash duration
    reg [26:0] p1_circle1_timer;
    reg [26:0] p1_circle2_timer;
    reg [26:0] p1_circle3_timer;
    reg [26:0] p2_circle1_timer;
    reg [26:0] p2_circle2_timer;
    reg [26:0] p2_circle3_timer;
    
    // Previous IR sensor states for edge detection
    reg [2:0] ir_sensor_p1_prev;
    reg [2:0] ir_sensor_p2_prev;
    
    // Edge detection and color update WITH RESET and TIMED FLASH
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p1_circle1_green <= 0;
            p1_circle2_green <= 0;
            p1_circle3_green <= 0;
            p2_circle1_green <= 0;
            p2_circle2_green <= 0;
            p2_circle3_green <= 0;
            p1_circle1_timer <= 0;
            p1_circle2_timer <= 0;
            p1_circle3_timer <= 0;
            p2_circle1_timer <= 0;
            p2_circle2_timer <= 0;
            p2_circle3_timer <= 0;
            ir_sensor_p1_prev <= 0;
            ir_sensor_p2_prev <= 0;
        end else begin
            ir_sensor_p1_prev <= ir_sensor_p1;
            ir_sensor_p2_prev <= ir_sensor_p2;
            
            // P1 Circle 1
            if (ir_sensor_p1[0] && !ir_sensor_p1_prev[0]) begin
                p1_circle1_green <= 1;
                p1_circle1_timer <= FLASH_DURATION;
            end else if (p1_circle1_timer > 0) begin
                p1_circle1_timer <= p1_circle1_timer - 1;
            end else begin
                p1_circle1_green <= 0;
            end
            
            // P1 Circle 2
            if (ir_sensor_p1[1] && !ir_sensor_p1_prev[1]) begin
                p1_circle2_green <= 1;
                p1_circle2_timer <= FLASH_DURATION;
            end else if (p1_circle2_timer > 0) begin
                p1_circle2_timer <= p1_circle2_timer - 1;
            end else begin
                p1_circle2_green <= 0;
            end
            
            // P1 Circle 3
            if (ir_sensor_p1[2] && !ir_sensor_p1_prev[2]) begin
                p1_circle3_green <= 1;
                p1_circle3_timer <= FLASH_DURATION;
            end else if (p1_circle3_timer > 0) begin
                p1_circle3_timer <= p1_circle3_timer - 1;
            end else begin
                p1_circle3_green <= 0;
            end
            
            // P2 Circle 1
            if (ir_sensor_p2[0] && !ir_sensor_p2_prev[0]) begin
                p2_circle1_green <= 1;
                p2_circle1_timer <= FLASH_DURATION;
            end else if (p2_circle1_timer > 0) begin
                p2_circle1_timer <= p2_circle1_timer - 1;
            end else begin
                p2_circle1_green <= 0;
            end
            
            // P2 Circle 2
            if (ir_sensor_p2[1] && !ir_sensor_p2_prev[1]) begin
                p2_circle2_green <= 1;
                p2_circle2_timer <= FLASH_DURATION;
            end else if (p2_circle2_timer > 0) begin
                p2_circle2_timer <= p2_circle2_timer - 1;
            end else begin
                p2_circle2_green <= 0;
            end
            
            // P2 Circle 3
            if (ir_sensor_p2[2] && !ir_sensor_p2_prev[2]) begin
                p2_circle3_green <= 1;
                p2_circle3_timer <= FLASH_DURATION;
            end else if (p2_circle3_timer > 0) begin
                p2_circle3_timer <= p2_circle3_timer - 1;
            end else begin
                p2_circle3_green <= 0;
            end
        end
    end

    // Object Status Signals
    wire COLON_on, M10_on, M1_on, S10_on, S1_on;
    wire SCORE1_10_on, SCORE1_1_on, SCORE2_10_on, SCORE2_1_on;
    
    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;
    wire [6:0] char_addr_m10, char_addr_m1, char_addr_s10, char_addr_s1;
    wire [6:0] char_addr_score1_10, char_addr_score1_1;
    wire [6:0] char_addr_score2_10, char_addr_score2_1;
    wire [6:0] char_addr_colon;
    reg [3:0] row_addr;
    wire [3:0] row_addr_m10, row_addr_m1, row_addr_s10, row_addr_s1;
    wire [3:0] row_addr_score1_10, row_addr_score1_1;
    wire [3:0] row_addr_score2_10, row_addr_score2_1;
    wire [3:0] row_addr_colon;
    reg [2:0] bit_addr;
    wire [2:0] bit_addr_m10, bit_addr_m1, bit_addr_s10, bit_addr_s1;
    wire [2:0] bit_addr_score1_10, bit_addr_score1_1;
    wire [2:0] bit_addr_score2_10, bit_addr_score2_1;
    wire [2:0] bit_addr_colon;
    wire [7:0] digit_word;
    wire digit_bit;
    
    // Calculate score digits for both players
    wire [3:0] score1_ones = score_p1 % 10;
    wire [3:0] score1_tens = score_p1 / 10;
    wire [3:0] score2_ones = score_p2 % 10;
    wire [3:0] score2_tens = score_p2 / 10;
    
    // Timer digit addressing
    assign char_addr_m10 = {3'b011, min_10s};
    assign row_addr_m10 = y[5:2];
    assign bit_addr_m10 = x[4:2];
    
    assign char_addr_m1 = {3'b011, min_1s};
    assign row_addr_m1 = y[5:2];
    assign bit_addr_m1 = x[4:2];
    
    assign char_addr_colon = 7'h3a;
    assign row_addr_colon = y[5:2];
    assign bit_addr_colon = x[4:2];
    
    assign char_addr_s10 = {3'b011, sec_10s};
    assign row_addr_s10 = y[5:2];
    assign bit_addr_s10 = x[4:2];
    
    assign char_addr_s1 = {3'b011, sec_1s};
    assign row_addr_s1 = y[5:2];
    assign bit_addr_s1 = x[4:2];
    
    // Player 1 score addressing
    assign char_addr_score1_10 = {3'b011, score1_tens};
    assign row_addr_score1_10 = y[5:2];
    assign bit_addr_score1_10 = x[4:2];
    
    assign char_addr_score1_1 = {3'b011, score1_ones};
    assign row_addr_score1_1 = y[5:2];
    assign bit_addr_score1_1 = x[4:2];
    
    // Player 2 score addressing
    assign char_addr_score2_10 = {3'b011, score2_tens};
    assign row_addr_score2_10 = y[5:2];
    assign bit_addr_score2_10 = x[4:2];
    
    assign char_addr_score2_1 = {3'b011, score2_ones};
    assign row_addr_score2_1 = y[5:2];
    assign bit_addr_score2_1 = x[4:2];

    // Instantiate digit rom
    clock_digit_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
    // Assert signals for timer
    assign COLON_on = (COLON_X_L <= x) && (x <= COLON_X_R) &&
                      (COLON_Y_T <= y) && (y <= COLON_Y_B);
                               
    assign M10_on = (M10_X_L <= x) && (x <= M10_X_R) &&
                    (M10_Y_T <= y) && (y <= M10_Y_B);
    assign M1_on =  (M1_X_L <= x) && (x <= M1_X_R) &&
                    (M1_Y_T <= y) && (y <= M1_Y_B);
    
    assign S10_on = (S10_X_L <= x) && (x <= S10_X_R) &&
                    (S10_Y_T <= y) && (y <= S10_Y_B);
    assign S1_on =  (S1_X_L <= x) && (x <= S1_X_R) &&
                    (S1_Y_T <= y) && (y <= S1_Y_B);
    
    // Assert signals for Player scores
    assign SCORE1_10_on = (SCORE1_10_X_L <= x) && (x <= SCORE1_10_X_R) &&
                          (SCORE1_10_Y_T <= y) && (y <= SCORE1_10_Y_B);
    assign SCORE1_1_on =  (SCORE1_1_X_L <= x) && (x <= SCORE1_1_X_R) &&
                          (SCORE1_1_Y_T <= y) && (y <= SCORE1_1_Y_B);
    
    assign SCORE2_10_on = (SCORE2_10_X_L <= x) && (x <= SCORE2_10_X_R) &&
                          (SCORE2_10_Y_T <= y) && (y <= SCORE2_10_Y_B);
    assign SCORE2_1_on =  (SCORE2_1_X_L <= x) && (x <= SCORE2_1_X_R) &&
                          (SCORE2_1_Y_T <= y) && (y <= SCORE2_1_Y_B);

    // *** FIXED CIRCLE DETECTION - Using simpler bounding box + refined check ***
    // This eliminates timing issues that cause vertical lines
    
    // Check if pixel is within circle using optimized calculation
    function in_circle_fixed;
        input signed [10:0] px, py, cx, cy;
        input [10:0] radius;
        reg signed [10:0] dx, dy;
        reg [21:0] dist_sq, radius_sq;
        begin
            dx = px - cx;
            dy = py - cy;
            dist_sq = (dx * dx) + (dy * dy);
            radius_sq = radius * radius;
            in_circle_fixed = (dist_sq <= radius_sq);
        end
    endfunction
    
    // Determine which circles to draw using fixed function
    wire p1_circle1 = in_circle_fixed(x, y, P1_CIRCLE1_X, P1_CIRCLE1_Y, CIRCLE_RADIUS);
    wire p1_circle2 = in_circle_fixed(x, y, P1_CIRCLE2_X, P1_CIRCLE2_Y, CIRCLE_RADIUS);
    wire p1_circle3 = in_circle_fixed(x, y, P1_CIRCLE3_X, P1_CIRCLE3_Y, CIRCLE_RADIUS);
    wire p2_circle1 = in_circle_fixed(x, y, P2_CIRCLE1_X, P2_CIRCLE1_Y, CIRCLE_RADIUS);
    wire p2_circle2 = in_circle_fixed(x, y, P2_CIRCLE2_X, P2_CIRCLE2_Y, CIRCLE_RADIUS);
    wire p2_circle3 = in_circle_fixed(x, y, P2_CIRCLE3_X, P2_CIRCLE3_Y, CIRCLE_RADIUS);
                      
    // Mux for ROM Addresses and RGB
    reg [11:0] rgb_reg;
    
    always @* begin
        rgb_reg = 12'h0FF;     // cyan background
        
        // Timer display (light orange)
        if(M10_on) begin
            char_addr = char_addr_m10;
            row_addr = row_addr_m10;
            bit_addr = bit_addr_m10;
            if(digit_bit)
                rgb_reg = 12'hFA0;
        end
        else if(M1_on) begin
            char_addr = char_addr_m1;
            row_addr = row_addr_m1;
            bit_addr = bit_addr_m1;
            if(digit_bit)
                rgb_reg = 12'hFA0;
        end
        else if(COLON_on) begin
            char_addr = char_addr_colon;
            row_addr = row_addr_colon;
            bit_addr = bit_addr_colon;
            if(digit_bit)
                rgb_reg = 12'hFA0;
        end
        else if(S10_on) begin
            char_addr = char_addr_s10;
            row_addr = row_addr_s10;
            bit_addr = bit_addr_s10;
            if(digit_bit)
                rgb_reg = 12'hFA0;
        end
        else if(S1_on) begin
            char_addr = char_addr_s1;
            row_addr = row_addr_s1;
            bit_addr = bit_addr_s1;
            if(digit_bit)
                rgb_reg = 12'hFA0;
        end 
        // Player 1 score (light orange, left side)
        else if(SCORE1_10_on) begin
            char_addr = char_addr_score1_10;
            row_addr = row_addr_score1_10;
            bit_addr = bit_addr_score1_10;
            if(digit_bit)
                rgb_reg = 12'hFA0;
        end
        else if(SCORE1_1_on) begin
            char_addr = char_addr_score1_1;
            row_addr = row_addr_score1_1;
            bit_addr = bit_addr_score1_1;
            if(digit_bit)
                rgb_reg = 12'hFA0;
        end
        // Player 2 score (light orange, right side)
        else if(SCORE2_10_on) begin
            char_addr = char_addr_score2_10;
            row_addr = row_addr_score2_10;
            bit_addr = bit_addr_score2_10;
            if(digit_bit)
                rgb_reg = 12'hFA0;
        end
        else if(SCORE2_1_on) begin
            char_addr = char_addr_score2_1;
            row_addr = row_addr_score2_1;
            bit_addr = bit_addr_score2_1;
            if(digit_bit)
                rgb_reg = 12'hFA0;
        end
        else begin 
            rgb_reg = 12'h0FF;  // cyan
            
            // Draw "P1" text (left side) - light orange
            if (
                // P
                (x >= 100 && x <= 120 && y >= 120 && y <= 130)||
                (x >= 100 && x <= 105 && y >= 130 && y <= 160)||
                (x >= 115 && x <= 120 && y >= 130 && y <= 145)||
                (x >= 100 && x <= 115 && y >= 145 && y <= 150)||
                // 1
                (x >= 125 && x <= 140 && y >= 120 && y <= 160)
            ) begin
                rgb_reg = 12'hFA0;  // Light orange for Player 1
            end
            // Draw "P2" text (right side) - light orange
            else if (
                // P
                (x >= 500 && x <= 520 && y >= 120 && y <= 130)||
                (x >= 500 && x <= 505 && y >= 130 && y <= 160)||
                (x >= 515 && x <= 520 && y >= 130 && y <= 145)||
                (x >= 500 && x <= 515 && y >= 145 && y <= 150)||
                // 2
                (x >= 525 && x <= 545 && y >= 120 && y <= 130)||
                (x >= 540 && x <= 545 && y >= 130 && y <= 145)||
                (x >= 525 && x <= 545 && y >= 145 && y <= 150)||
                (x >= 525 && x <= 530 && y >= 150 && y <= 160)||
                (x >= 525 && x <= 545 && y >= 155 && y <= 160)
            ) begin
                rgb_reg = 12'hFA0;  // Light orange for Player 2
            end
            // Draw circles - RED by default, GREEN when hit for 1 second
            // Order matters - check circles in priority order
            else if (p1_circle1) rgb_reg = p1_circle1_green ? 12'h0F0 : 12'hF00;
            else if (p1_circle2) rgb_reg = p1_circle2_green ? 12'h0F0 : 12'hF00;
            else if (p1_circle3) rgb_reg = p1_circle3_green ? 12'h0F0 : 12'hF00;
            else if (p2_circle1) rgb_reg = p2_circle1_green ? 12'h0F0 : 12'hF00;
            else if (p2_circle2) rgb_reg = p2_circle2_green ? 12'h0F0 : 12'hF00;
            else if (p2_circle3) rgb_reg = p2_circle3_green ? 12'h0F0 : 12'hF00;
        end
    end

    // Output RGB based on video_on
    always @* begin
        if (video_on) begin
            red = rgb_reg[11:8];
            green = rgb_reg[7:4];
            blue = rgb_reg[3:0];
        end else begin
            red = 4'h0;
            green = 4'h0;
            blue = 4'h0;
        end
    end

    // ROM Interface    
    assign rom_addr = {char_addr, row_addr};
    assign digit_bit = digit_word[~bit_addr];    
               
endmodule