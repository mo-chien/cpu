`timescale 1ns / 1ps
`include "defines.v"
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
    R_en,
	Wr_addr,
    Read_addr,
    din,
	dout
    );

    localparam  MEMDEPTH = 1<< `addrwidth;
    input clk;
	input W_en;
    input R_en;
    
	input [`addrwidth-1:0]Wr_addr;
    input [`addrwidth-1:0]Read_addr;
	input [`datawidth-1:0]din;
	output [`datawidth-1:0]dout;

    reg [`datawidth - 1 : 0] ram [ MEMDEPTH - 1 : 0];


  always @(posedge clk ) begin
        if (W_en)
            ram[Wr_addr] <= din;
  end
  reg R_en_reg;
  reg [`addrwidth-1:0] read_addr_regs;
  always @(posedge clk ) begin
        read_addr_regs<=Read_addr;
        R_en_reg<=R_en;
  end
  assign dout = R_en_reg ? ram[read_addr_regs] : 32'd0;
endmodule
