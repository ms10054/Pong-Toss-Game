module game_screen(
    input clk,
    input clk_25MHz,              // Clock divider output
    input reset,              // Reset button
    input enable,             // Enable/Start button for timer
    input [2:0] ir_sensor_p1, // 3 IR sensors for Player 1
    input [2:0] ir_sensor_p2, // 3 IR sensors for Player 2
    input [5:0] score_p1,     // Score from top module
    input [5:0] score_p2,     // Score from top module
    input video_on,
    input [9:0] x_loc,
    input [9:0] y_loc,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output clock_stopped,     // Output indicating timer has reached 0:00
    output buzzer_out         // Buzzer output
);
    
    // Timer signals - now connected to countdown timer
    wire [3:0] sec_1s;
    wire [3:0] sec_10s;
    wire [3:0] min_1s;
    wire [3:0] min_10s;
    wire tick_1Hz;
    
    // Internal enable signal - timer starts automatically when game screen is active
    reg timer_enable;
    
    // Auto-start timer when game screen loads, stop when timer reaches 0
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            timer_enable <= 1'b0;
        end else begin
            if (!clock_stopped) begin
                timer_enable <= 1'b1;  // Keep timer running until it stops
            end else begin
                timer_enable <= 1'b0;  // Stop when clock reaches 0:00
            end
        end
    end
    
    // Countdown Timer - 1:59 to 0:00
    new_binary_clock timer(
        .clk_100MHz(clk),
        .reset(reset),
        .enable(timer_enable),  // Use internal enable signal
        .tick_1Hz(tick_1Hz),
        .sec_1s(sec_1s),
        .sec_10s(sec_10s),
        .min_1s(min_1s),
        .min_10s(min_10s),
        .clock_stopped(clock_stopped)
    );
    
    // Pixel generator
    pixel_main pixel_gen(
        .ir_sensor_p1(ir_sensor_p1),
        .ir_sensor_p2(ir_sensor_p2),
        .clk(clk_25MHz),
        .reset(reset),
        .video_on(video_on),
        .x(x_loc),
        .y(y_loc),
        .sec_1s(sec_1s),
        .sec_10s(sec_10s),
        .min_1s(min_1s),
        .min_10s(min_10s),
        .score_p1(score_p1),
        .score_p2(score_p2),
        .red(red),
        .green(green),
        .blue(blue)
    );
    
    // Buzzer - sounds when timer reaches 0:00
    buzzer game_buzzer(
        .clk_100MHz(clk),
        .enable(clock_stopped),
        .buzzer_out(buzzer_out)
    );
    
endmodule