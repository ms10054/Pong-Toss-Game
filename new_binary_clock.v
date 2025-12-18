module new_binary_clock (
    input  clk_100MHz,
    input  reset,          // active-high reset
    input  enable,         // start/pause the timer
    output reg tick_1Hz,       // one-cycle pulse per second
    output reg [3:0] sec_1s,
    output reg [3:0] sec_10s,
    output reg [3:0] min_1s,
    output reg [3:0] min_10s,
    output reg clock_stopped
);

    // =====================================================
    // 1 Hz tick generator - exact 1-second pulse
    // =====================================================
    reg [26:0] cnt;
    
    // Initialize all registers properly
    initial begin
        cnt = 0;
        tick_1Hz = 0;
        sec_1s = 4'd9;
        sec_10s = 4'd5;
        min_1s = 4'd1;
        min_10s = 4'd0;
        clock_stopped = 1'b0;
    end
    
    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            cnt <= 0;
            tick_1Hz <= 0;
        end else if (enable && !clock_stopped) begin
            if (cnt == 99_999_999) begin  // 100 MHz ÷ 100_000_000 cycles = 1 sec
                cnt <= 0;
                tick_1Hz <= 1;
            end else begin
                cnt <= cnt + 1;
                tick_1Hz <= 0;
            end
        end else begin
            tick_1Hz <= 0;
        end
    end

    // =====================================================
    // Countdown logic - runs only when enabled and on 1Hz tick
    // =====================================================
    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            sec_1s  <= 4'd9;
            sec_10s <= 4'd5;
            min_1s  <= 4'd1;
            min_10s <= 4'd0;
            clock_stopped <= 1'b0;
        end
        // Only count down when enabled AND we have a 1Hz pulse
        else if (enable && tick_1Hz && !clock_stopped) begin
            // Check if we've reached 0:00
            if (min_10s == 0 && min_1s == 0 && sec_10s == 0 && sec_1s == 0) begin
                clock_stopped <= 1'b1;  // Game Over! Stays high until reset
            end
            else begin
                // Normal countdown
                if (sec_1s == 0) begin
                    sec_1s <= 4'd9;
                    if (sec_10s == 0) begin
                        sec_10s <= 4'd5;
                        if (min_1s == 0) begin
                            min_1s <= 4'd9;
                            if (min_10s > 0) begin
                                min_10s <= min_10s - 1;
                            end
                        end else begin
                            min_1s <= min_1s - 1;
                        end
                    end else begin
                        sec_10s <= sec_10s - 1;
                    end
                end else begin
                    sec_1s <= sec_1s - 1;
                end
            end
        end
    end

endmodule