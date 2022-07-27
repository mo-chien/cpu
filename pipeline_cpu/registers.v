`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 10:26:24
// Design Name: 
// Module Name: registers
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


module registers(
    clk,
	rst_n,
	W_en,
	Rs1,
	Rs2,
	Rd,
	Wr_data,
	Rd_data1,
	Rd_data2
    );
    input clk;
	input W_en;
	input rst_n;
	input [4:0]Rs1;
	input [4:0]Rs2;
	input [4:0]Rd;
	input [31:0]Wr_data;
	
	output [31:0]Rd_data1;
	output [31:0]Rd_data2;
	
	reg [31:0] regs [31:0];

	
///write
	always@(posedge clk )
		begin
			if(W_en & (Rd!=0))
			regs[Rd] <= Wr_data;	
		end
//read

	assign Rd_data1=(Rs1==5'd0)?`ZeroWord: regs[Rs1];
	assign Rd_data2=(Rs2==5'd0)?`ZeroWord: regs[Rs2]; 


endmodule
