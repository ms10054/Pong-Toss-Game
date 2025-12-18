`timescale 1ns / 1ps

module VGATopModule(
    input clk,
    input reset,              // Reset button
    input start_button,       // Button to start game (switch from start screen to game)
    input enable,             // Enable/Start button for timer (not used - auto-starts)
    input [2:0] ir_sensor_p1, // 3 IR sensors for Player 1
    input [2:0] ir_sensor_p2, // 3 IR sensors for Player 2
    output h_sync,
    output v_sync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output buzzer_out         // Buzzer output
);
    
    // VGA signals
    wire video_on;
    wire [9:0] x_loc;
    wire [9:0] y_loc;
    wire c_div;
    
    // Game state: 0 = start screen, 1 = game screen, 2 = end screen
    reg [1:0] game_state = 2'b00;
    localparam STATE_START = 2'b00;
    localparam STATE_GAME  = 2'b01;
    localparam STATE_END   = 2'b10;
    
    reg game_reset = 1;   // Start with reset HIGH to initialize properly
    wire clock_stopped;
    
    // Score signals
    wire [5:0] score_p1;
    wire [5:0] score_p2;
    
    // Win condition signals
    reg player1_win = 0;
    reg player2_win = 0;
    reg draw = 0;
    wire game_over;
    
    // Buzzer control signals
    reg buzzer_enable = 0;
    reg [28:0] buzzer_timer = 0;
    localparam BUZZER_DURATION = 300_000_000; // 3 seconds at 100MHz
    
    // Game over ONLY when timer reaches 0
    assign game_over = clock_stopped;
    
    // Debounced start button
    wire start_button_stable;
    wire start_button_edge;
    
    // Debounced reset button
    wire reset_stable;
    wire reset_edge;
    
    // VGA timing generator
    TOPLEVEL t1(
        .clk(clk),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .video_on(video_on),
        .x_loc(x_loc),
        .y_loc(y_loc)
    );
    
    // Clock divider
    clk_div t2(clk, c_div);
    
    // Debounce the start button
    debounce start_db(
        .clk(clk),
        .btn_in(start_button),
        .btn_out(start_button_stable)
    );
    
    // Edge detector for start button
    edge_detector start_ed(
        .clk(clk),
        .signal_in(start_button_stable),
        .edge_out(start_button_edge)
    );
    
    // Debounce the reset button
    debounce reset_db(
        .clk(clk),
        .btn_in(reset),
        .btn_out(reset_stable)
    );
    
    // Edge detector for reset button
    edge_detector reset_ed(
        .clk(clk),
        .signal_in(reset_stable),
        .edge_out(reset_edge)
    );
    
    // Buzzer timer logic - runs for 3 seconds when end screen appears
    always @(posedge clk) begin
        if (reset_edge || game_state == STATE_START || game_state == STATE_GAME) begin
            buzzer_timer <= 0;
            buzzer_enable <= 0;
        end else if (game_state == STATE_END) begin
            if (buzzer_timer < BUZZER_DURATION) begin
                buzzer_timer <= buzzer_timer + 1;
                buzzer_enable <= 1;
            end else begin
                buzzer_enable <= 0;
            end
        end
    end
    
    // State machine: manage screen transitions
    always @(posedge clk) begin
        if (reset_edge) begin
            // Go back to start screen on any reset press
            game_state <= STATE_START;
            game_reset <= 1;  // Assert reset to clear scores and timer
            player1_win <= 0;
            player2_win <= 0;
            draw <= 0;
        end else begin
            case (game_state)
                STATE_START: begin
                    game_reset <= 1;  // Keep reset HIGH while in start screen
                    if (start_button_edge) begin
                        game_state <= STATE_GAME;
                        game_reset <= 0;  // Release reset when entering game
                    end
                end
                STATE_GAME: begin
                    game_reset <= 0;  // Keep reset LOW during game
                    if (game_over) begin
                        game_state <= STATE_END;
                        if (score_p1 > score_p2) begin
                            player1_win <= 1;
                            player2_win <= 0;
                            draw <= 0;
                        end else if (score_p2 > score_p1) begin
                            player1_win <= 0;
                            player2_win <= 1;
                            draw <= 0;
                        end else begin
                            player1_win <= 0;
                            player2_win <= 0;
                            draw <= 1;
                        end
                    end
                end
                STATE_END: begin
                    game_reset <= 1;  // Assert reset while in end screen
                    // Stay in end screen until reset button is pressed
                end
                default: begin
                    game_state <= STATE_START;
                    game_reset <= 1;
                end
            endcase
        end
    end
    
    // RGB outputs from start screen
    wire [3:0] start_red, start_green, start_blue;
    
    // RGB outputs from game screen
    wire [3:0] game_red, game_green, game_blue;
    
    // RGB outputs from end screen
    wire [3:0] end_red, end_green, end_blue;
    
    // Start screen module
    start_screen start_scr(
        .clk_d(c_div),
        .pixel_x(x_loc),
        .pixel_y(y_loc),
        .video_on(video_on),
        .red(start_red),
        .green(start_green),
        .blue(start_blue)
    );
    
    // Game screen module (buzzer removed from here)
    game_screen game_scr(
        .clk(clk),
        .clk_25MHz(c_div),
        .reset(game_reset),
        .enable(1'b1),                 // Always enabled (timer auto-starts internally)
        .ir_sensor_p1(ir_sensor_p1),
        .ir_sensor_p2(ir_sensor_p2),
        .score_p1(score_p1),           // Pass score from top module
        .score_p2(score_p2),           // Pass score from top module
        .video_on(video_on),
        .x_loc(x_loc),
        .y_loc(y_loc),
        .red(game_red),
        .green(game_green),
        .blue(game_blue),
        .clock_stopped(clock_stopped),
        .buzzer_out()                  // Not used - buzzer controlled at top level
    );
    
    // Score counters (need to instantiate here to get scores for win condition)
    ir_score_counter_multi score_counter_p1(
        .clk_100MHz(clk),
        .reset(game_reset),
        .ir_sensors(ir_sensor_p1),
        .seg(),
        .an(),
        .score_out(score_p1)
    );
    
    ir_score_counter_multi score_counter_p2(
        .clk_100MHz(clk),
        .reset(game_reset),
        .ir_sensors(ir_sensor_p2),
        .seg(),
        .an(),
        .score_out(score_p2)
    );
    
    // End screen module
    end_screen end_scr(
        .clk_d(c_div),
        .pixel_x(x_loc),
        .pixel_y(y_loc),
        .video_on(video_on),
        .player1_win(player1_win),
        .player2_win(player2_win),
        .draw(draw),
        .red(end_red),
        .green(end_green),
        .blue(end_blue)
    );
    
    // Buzzer module - controlled by buzzer_enable signal
    buzzer end_buzzer(
        .clk_100MHz(clk),
        .enable(buzzer_enable),
        .buzzer_out(buzzer_out)
    );
    
    // Multiplex between screens based on game state
    assign red   = (game_state == STATE_START) ? start_red   :
                   (game_state == STATE_GAME)  ? game_red    :
                   (game_state == STATE_END)   ? end_red     : 4'h0;
                   
    assign green = (game_state == STATE_START) ? start_green :
                   (game_state == STATE_GAME)  ? game_green  :
                   (game_state == STATE_END)   ? end_green   : 4'h0;
                   
    assign blue  = (game_state == STATE_START) ? start_blue  :
                   (game_state == STATE_GAME)  ? game_blue   :
                   (game_state == STATE_END)   ? end_blue    : 4'h0;
    
endmodule
