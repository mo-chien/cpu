`timescale 1ns / 1ps
`include "signle_clk_cpu/defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/24 20:42:01
// Design Name: 
// Module Name: RAM
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

//在访存阶段进行读操作，在写回阶段进行写操作，需要双口RAM
module dataRAM(
    clk,
	W_en,
    addr,
    din,
	dout
    );

    localparam  MEMDEPTH = 1<< `addrwidth;
    input clk;
	input W_en;
    
	input [`addrwidth-1:0]addr;
	input [`datawidth-1:0]din;
	output [`datawidth-1:0]dout;

    reg [`datawidth - 1 : 0] ram [ MEMDEPTH - 1 : 0];


  always @(posedge clk ) begin
        if (W_en)
            ram[addr] <= din;
  end
  assign dout = ram[addr] ;
endmodule
