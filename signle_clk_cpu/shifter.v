`timescale 1ns / 1ps
`include "signle_clk_cpu/defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 18:49:09
// Design Name: 
// Module Name: shifter
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


module shifter(
    input [`datawidth-1:0] Indata,
    input [`SHIFT_NUM_width] SHIFT_NUM,
    input [`shift_ctr] Shiftctr,
    output [`datawidth-1:0] shift_result);
    
    wire [`datawidth-1:0] left,right,A_right;
    assign left = Indata<<SHIFT_NUM;
    assign right = Indata>>SHIFT_NUM;
    assign A_right = (~(32'b1111_1111_1111_1111_1111_1111_1111_1111>>SHIFT_NUM))| right ;
    assign shift_result = Shiftctr[1]&Indata[31]? A_right:~Shiftctr[0]?left:right;
endmodule
