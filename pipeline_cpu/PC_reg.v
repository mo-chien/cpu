`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/21 19:42:55
// Design Name: 
// Module Name: PC_reg
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


module PC_reg(
    input clk,
	input rst_n,
	input pc_en,
	input [`datawidth-1:0] pc_new,	
	output reg [`datawidth-1:0] pc_out
    );

	
	always@(posedge clk )
	begin
		if(!rst_n)
			pc_out<=`ZeroWord;
		else if (pc_en)
			pc_out<=pc_new;
		else pc_out<=pc_out;
	end	

endmodule
