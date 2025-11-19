`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2025 03:21:41 PM
// Design Name: 
// Module Name: Irmodpong
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IR_Sensor_LED_Clocked(
    input wire clk,         // 100 MHz clock from FPGA
    input wire ir_sensor,   // IR sensor input
    output reg led,
    output [6:0] S,
    output [3:0] Display        // LED output
    );

    // Internal signal for debouncing or stable detection
    reg sensor_sync;
    reg [3:0] counter = 4'b0000;
    
    always @(posedge clk) begin
        // Synchronize input to the FPGA clock
        sensor_sync <= ir_sensor;

        // Check the synchronized sensor value
        if (sensor_sync == 1'b0) begin // Object detected (active LOW)
            led <= 1'b1;          // Turn ON LED
            counter <= counter + 1;
        end
        else begin
            led <= 1'b0;          // Turn OFF LED
        end
    end
    sevensegment s(counter, S);
    assign Display = 4'b1110;
endmodule
