`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2025 12:14:12 PM
// Design Name: 
// Module Name: TOPLEVEL
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


module TOPLEVEL(
input clk,
output h_sync,
output v_sync,
output video_on,
output [9:0] x_loc,
output [9:0] y_loc 
    );
wire [9:0] h_count;
wire [9:0] v_count;

TopLevelModule t1(clk, h_count, v_count);
vga_sync t2(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
endmodule
