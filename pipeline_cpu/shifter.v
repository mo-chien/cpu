`timescale 1ns / 1ps
`include "defines.v"
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
    
    wire [5:0] shift_n;
    assign shift_n = 6'd32 - SHIFT_NUM;
    wire [`datawidth-1:0] left,right,A_right;
    assign left = Indata<<SHIFT_NUM;
    assign right = Indata>>SHIFT_NUM;
    assign A_right =({32{Indata[`datawidth-1]}}<<shift_n)| right ;
    //11:算术右移；10：逻辑右移；01，00：左移
    assign shift_result = Shiftctr[1]&Shiftctr[0]? A_right:~Shiftctr[1]?left:right;
endmodule
