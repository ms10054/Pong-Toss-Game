`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 10:55:16 AM
// Design Name: 
// Module Name: h_counter
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



module h_counter(clk,count,trig_v_signal);
input clk;
output [9:0] count;
output trig_v_signal;
reg [9:0] count;
reg trig_v_signal;
initial count = 0;
initial trig_v_signal = 0;
always @(posedge clk)
begin
    if (count < 799)
    begin
        count <= count + 1;
        trig_v_signal <= 0;
    end
    else
    begin
        count <= 0;
        trig_v_signal <= 1;
    end
end 
endmodule
