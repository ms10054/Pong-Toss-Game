`timescale 1ns / 1ps

module end_screen(
    input clk_d,              // pixel clock
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    input player1_win,        // High if Player 1 wins
    input player2_win,        // High if Player 2 wins
    input draw,               // High if scores are equal (draw)
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
);

    always @(posedge clk_d) begin
        if (video_on) begin
            // Default background color (cyan)
            red <= 4'h0;
            green <= 4'hF;
            blue <= 4'hF;
            
            if (player1_win) begin
                // Display "PLAYER 1" (Top) - light orange
                if (
                    // P
                    (pixel_x >= 80 && pixel_x <= 100 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 100 && pixel_x <= 140 && pixel_y >= 80 && pixel_y <= 100) ||
                    (pixel_x >= 100 && pixel_x <= 140 && pixel_y >= 135 && pixel_y <= 145) ||
                    (pixel_x >= 140 && pixel_x <= 160 && pixel_y >= 100 && pixel_y <= 135) ||
                    
                    // L
                    (pixel_x >= 170 && pixel_x <= 190 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 170 && pixel_x <= 230 && pixel_y >= 190 && pixel_y <= 210) ||
                    
                    // A
                    (pixel_x >= 240 && pixel_x <= 260 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 300 && pixel_x <= 320 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 260 && pixel_x <= 300 && pixel_y >= 80 && pixel_y <= 100) ||
                    (pixel_x >= 260 && pixel_x <= 300 && pixel_y >= 135 && pixel_y <= 145) ||
                    
                    // Y
                    (pixel_x >= 330 && pixel_x <= 350 && pixel_y >= 80 && pixel_y <= 135) ||
                    (pixel_x >= 390 && pixel_x <= 410 && pixel_y >= 80 && pixel_y <= 135) ||
                    (pixel_x >= 330 && pixel_x <= 410 && pixel_y >= 135 && pixel_y <= 145) ||
                    (pixel_x >= 360 && pixel_x <= 380 && pixel_y >= 145 && pixel_y <= 210) ||
                    
                    // E
                    (pixel_x >= 420 && pixel_x <= 440 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 420 && pixel_x <= 480 && pixel_y >= 80 && pixel_y <= 100) ||
                    (pixel_x >= 420 && pixel_x <= 480 && pixel_y >= 135 && pixel_y <= 145) ||
                    (pixel_x >= 420 && pixel_x <= 480 && pixel_y >= 190 && pixel_y <= 210) ||
                    
                    // R
                    (pixel_x >= 490 && pixel_x <= 510 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 490 && pixel_x <= 550 && pixel_y >= 80 && pixel_y <= 100) ||
                    (pixel_x >= 490 && pixel_x <= 550 && pixel_y >= 135 && pixel_y <= 145) ||
                    (pixel_x >= 530 && pixel_x <= 550 && pixel_y >= 100 && pixel_y <= 135) ||
                    (pixel_x >= 510 && pixel_x <= 550 && pixel_y >= 145 && pixel_y <= 210) ||
                    
                    // Space (no pixels)
                    
                    // 1
                    (pixel_x >= 580 && pixel_x <= 600 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 600 && pixel_x <= 620 && pixel_y >= 190 && pixel_y <= 210)
                ) begin
                    red <= 4'hF;
                    green <= 4'hA;
                    blue <= 4'h0;
                end
                
                // Display "WINS!" (Bottom) - light orange
                else if (
                    // W
                    (pixel_x >= 120 && pixel_x <= 140 && pixel_y >= 300 && pixel_y <= 400) ||
                    (pixel_x >= 160 && pixel_x <= 180 && pixel_y >= 300 && pixel_y <= 370) ||
                    (pixel_x >= 200 && pixel_x <= 220 && pixel_y >= 300 && pixel_y <= 400) ||
                    (pixel_x >= 120 && pixel_x <= 220 && pixel_y >= 380 && pixel_y <= 400) ||

                    // I
                    (pixel_x >= 240 && pixel_x <= 300 && pixel_y >= 300 && pixel_y <= 310) ||
                    (pixel_x >= 270 && pixel_x <= 280 && pixel_y >= 310 && pixel_y <= 390) ||
                    (pixel_x >= 240 && pixel_x <= 300 && pixel_y >= 390 && pixel_y <= 400) ||

                    // N
                    (pixel_x >= 320 && pixel_x <= 340 && pixel_y >= 300 && pixel_y <= 400) ||
                    (pixel_x >= 400 && pixel_x <= 420 && pixel_y >= 300 && pixel_y <= 400) ||
                    (pixel_x >= 340 && pixel_x <= 400 && pixel_y >= 300 && pixel_y <= 320) ||
                    
                    // S
                    (pixel_x >= 440 && pixel_x <= 500 && pixel_y >= 300 && pixel_y <= 310) ||
                    (pixel_x >= 440 && pixel_x <= 460 && pixel_y >= 300 && pixel_y <= 340) ||
                    (pixel_x >= 440 && pixel_x <= 500 && pixel_y >= 330 && pixel_y <= 340) ||
                    (pixel_x >= 480 && pixel_x <= 500 && pixel_y >= 340 && pixel_y <= 390) ||
                    (pixel_x >= 440 && pixel_x <= 500 && pixel_y >= 390 && pixel_y <= 400) ||
                    
                    // !
                    (pixel_x >= 520 && pixel_x <= 530 && pixel_y >= 300 && pixel_y <= 380) ||
                    (pixel_x >= 520 && pixel_x <= 530 && pixel_y >= 390 && pixel_y <= 400)
                ) begin
                    red <= 4'hF;
                    green <= 4'hA;
                    blue <= 4'h0;
                end
            end else if (player2_win) begin
                // Display "PLAYER 2" (Top) - light orange
                if (
                    // P
                    (pixel_x >= 80 && pixel_x <= 100 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 100 && pixel_x <= 140 && pixel_y >= 80 && pixel_y <= 100) ||
                    (pixel_x >= 100 && pixel_x <= 140 && pixel_y >= 135 && pixel_y <= 145) ||
                    (pixel_x >= 140 && pixel_x <= 160 && pixel_y >= 100 && pixel_y <= 135) ||
                    
                    // L
                    (pixel_x >= 170 && pixel_x <= 190 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 170 && pixel_x <= 230 && pixel_y >= 190 && pixel_y <= 210) ||
                    
                    // A
                    (pixel_x >= 240 && pixel_x <= 260 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 300 && pixel_x <= 320 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 260 && pixel_x <= 300 && pixel_y >= 80 && pixel_y <= 100) ||
                    (pixel_x >= 260 && pixel_x <= 300 && pixel_y >= 135 && pixel_y <= 145) ||
                    
                    // Y
                    (pixel_x >= 330 && pixel_x <= 350 && pixel_y >= 80 && pixel_y <= 135) ||
                    (pixel_x >= 390 && pixel_x <= 410 && pixel_y >= 80 && pixel_y <= 135) ||
                    (pixel_x >= 330 && pixel_x <= 410 && pixel_y >= 135 && pixel_y <= 145) ||
                    (pixel_x >= 360 && pixel_x <= 380 && pixel_y >= 145 && pixel_y <= 210) ||
                    
                    // E
                    (pixel_x >= 420 && pixel_x <= 440 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 420 && pixel_x <= 480 && pixel_y >= 80 && pixel_y <= 100) ||
                    (pixel_x >= 420 && pixel_x <= 480 && pixel_y >= 135 && pixel_y <= 145) ||
                    (pixel_x >= 420 && pixel_x <= 480 && pixel_y >= 190 && pixel_y <= 210) ||
                    
                    // R
                    (pixel_x >= 490 && pixel_x <= 510 && pixel_y >= 80 && pixel_y <= 210) ||
                    (pixel_x >= 490 && pixel_x <= 550 && pixel_y >= 80 && pixel_y <= 100) ||
                    (pixel_x >= 490 && pixel_x <= 550 && pixel_y >= 135 && pixel_y <= 145) ||
                    (pixel_x >= 530 && pixel_x <= 550 && pixel_y >= 100 && pixel_y <= 135) ||
                    (pixel_x >= 510 && pixel_x <= 550 && pixel_y >= 145 && pixel_y <= 210) ||
                    
                    // Space (no pixels)
                    
                    // 2
                    (pixel_x >= 580 && pixel_x <= 620 && pixel_y >= 80 && pixel_y <= 100) ||
                    (pixel_x >= 600 && pixel_x <= 620 && pixel_y >= 100 && pixel_y <= 145) ||
                    (pixel_x >= 580 && pixel_x <= 620 && pixel_y >= 135 && pixel_y <= 145) ||
                    (pixel_x >= 580 && pixel_x <= 600 && pixel_y >= 145 && pixel_y <= 190) ||
                    (pixel_x >= 580 && pixel_x <= 620 && pixel_y >= 190 && pixel_y <= 210)
                ) begin
                    red <= 4'hF;
                    green <= 4'hA;
                    blue <= 4'h0;
                end
                
                // Display "WINS!" (Bottom) - light orange
                else if (
                    // W
                    (pixel_x >= 120 && pixel_x <= 140 && pixel_y >= 300 && pixel_y <= 400) ||
                    (pixel_x >= 160 && pixel_x <= 180 && pixel_y >= 300 && pixel_y <= 370) ||
                    (pixel_x >= 200 && pixel_x <= 220 && pixel_y >= 300 && pixel_y <= 400) ||
                    (pixel_x >= 120 && pixel_x <= 220 && pixel_y >= 380 && pixel_y <= 400) ||

                    // I
                    (pixel_x >= 240 && pixel_x <= 300 && pixel_y >= 300 && pixel_y <= 310) ||
                    (pixel_x >= 270 && pixel_x <= 280 && pixel_y >= 310 && pixel_y <= 390) ||
                    (pixel_x >= 240 && pixel_x <= 300 && pixel_y >= 390 && pixel_y <= 400) ||

                    // N
                    (pixel_x >= 320 && pixel_x <= 340 && pixel_y >= 300 && pixel_y <= 400) ||
                    (pixel_x >= 400 && pixel_x <= 420 && pixel_y >= 300 && pixel_y <= 400) ||
                    (pixel_x >= 340 && pixel_x <= 400 && pixel_y >= 300 && pixel_y <= 320) ||
                    
                    // S
                    (pixel_x >= 440 && pixel_x <= 500 && pixel_y >= 300 && pixel_y <= 310) ||
                    (pixel_x >= 440 && pixel_x <= 460 && pixel_y >= 300 && pixel_y <= 340) ||
                    (pixel_x >= 440 && pixel_x <= 500 && pixel_y >= 330 && pixel_y <= 340) ||
                    (pixel_x >= 480 && pixel_x <= 500 && pixel_y >= 340 && pixel_y <= 390) ||
                    (pixel_x >= 440 && pixel_x <= 500 && pixel_y >= 390 && pixel_y <= 400) ||
                    
                    // !
                    (pixel_x >= 520 && pixel_x <= 530 && pixel_y >= 300 && pixel_y <= 380) ||
                    (pixel_x >= 520 && pixel_x <= 530 && pixel_y >= 390 && pixel_y <= 400)
                ) begin
                    red <= 4'hF;
                    green <= 4'hA;
                    blue <= 4'h0;
                end
            end else if (draw) begin
                // Display "DRAW!" in the middle - light orange
                if (
                    // D
                    (pixel_x >= 80 && pixel_x <= 100 && pixel_y >= 180 && pixel_y <= 300) ||
                    (pixel_x >= 80 && pixel_x <= 160 && pixel_y >= 180 && pixel_y <= 200) ||
                    (pixel_x >= 80 && pixel_x <= 160 && pixel_y >= 280 && pixel_y <= 300) ||
                    (pixel_x >= 140 && pixel_x <= 160 && pixel_y >= 200 && pixel_y <= 280) ||
                    
                    // R
                    (pixel_x >= 180 && pixel_x <= 200 && pixel_y >= 180 && pixel_y <= 300) ||
                    (pixel_x >= 180 && pixel_x <= 260 && pixel_y >= 180 && pixel_y <= 200) ||
                    (pixel_x >= 180 && pixel_x <= 260 && pixel_y >= 230 && pixel_y <= 250) ||
                    (pixel_x >= 240 && pixel_x <= 260 && pixel_y >= 200 && pixel_y <= 230) ||
                    (pixel_x >= 240 && pixel_x <= 260 && pixel_y >= 250 && pixel_y <= 270) ||
                    (pixel_x >= 220 && pixel_x <= 240 && pixel_y >= 270 && pixel_y <= 290) ||
                    (pixel_x >= 200 && pixel_x <= 220 && pixel_y >= 290 && pixel_y <= 300) ||
                    
                    // A
                    (pixel_x >= 280 && pixel_x <= 300 && pixel_y >= 180 && pixel_y <= 300) ||
                    (pixel_x >= 360 && pixel_x <= 380 && pixel_y >= 180 && pixel_y <= 300) ||
                    (pixel_x >= 300 && pixel_x <= 360 && pixel_y >= 180 && pixel_y <= 200) ||
                    (pixel_x >= 300 && pixel_x <= 360 && pixel_y >= 230 && pixel_y <= 250) ||
                    
                    // W
                    (pixel_x >= 400 && pixel_x <= 420 && pixel_y >= 180 && pixel_y <= 300) ||
                    (pixel_x >= 440 && pixel_x <= 460 && pixel_y >= 180 && pixel_y <= 270) ||
                    (pixel_x >= 480 && pixel_x <= 500 && pixel_y >= 180 && pixel_y <= 300) ||
                    (pixel_x >= 400 && pixel_x <= 500 && pixel_y >= 280 && pixel_y <= 300) ||
                    
                    // !
                    (pixel_x >= 520 && pixel_x <= 540 && pixel_y >= 180 && pixel_y <= 260) ||
                    (pixel_x >= 520 && pixel_x <= 540 && pixel_y >= 280 && pixel_y <= 300)
                ) begin
                    red <= 4'hF;
                    green <= 4'hA;
                    blue <= 4'h0;
                end
            end
        end
        else begin
            // Blanking period
            red <= 4'h0;
            green <= 4'h0;
            blue <= 4'h0;
        end
    end

endmodule