`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2025 12:58:35 PM
// Design Name: 
// Module Name: VGATopModule
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


module VGATopModule(
    input clk,
    output h_sync,
    output v_sync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
    );
    wire video_on;
    wire [9:0] x_loc;
    wire [9:0] y_loc;
    wire c_div;
    TOPLEVEL t1(clk,h_sync,v_sync,video_on,x_loc,y_loc);
    clk_div t2(clk, c_div);
    start_screen p(c_div, x_loc, y_loc, video_on, red, green, blue);
endmodule
