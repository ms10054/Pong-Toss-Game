`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 01:25:30 PM
// Design Name: 
// Module Name: TopLevelModule
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


module TopLevelModule(
input clk,
output [9:0] h_count,
output [9:0] v_count
    );
    wire trig_v;
    wire clk_d;
    clk_div c1(clk, clk_d);
    h_counter c2(clk_d,h_count,trig_v);
    v_counter c3(clk_d,trig_v,v_count);
endmodule
