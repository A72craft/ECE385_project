`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 19:41:30
// Design Name: 
// Module Name: top_level
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


module top_level(
    input  logic clk,
    output logic [15:0] led,
    input  logic [3:0] btn,
    output logic uart_rxd,
    input  logic uart_txd);

  mb_pacman mb_pacman_i
        (.clk_100MHz(clk),
        .reset_rtl_0(~btn[0]),      //Note the inversion of the reset button. Buttons are active low, but the MicroBlaze reset is active high
        .uart_rtl_0_rxd(uart_txd),  //Note the switcheroo between RTX and TXD. This is a common source of confusion in embedded development
        .uart_rtl_0_txd(uart_rxd));
endmodule
