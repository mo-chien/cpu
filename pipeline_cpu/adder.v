`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/19 16:22:20
// Design Name: 
// Module Name: adder
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


module adder(
    input [`datawidth-1:0] data_A,data_B,
    input ci,
    output [`datawidth-1:0] result,
    output co,zero,result_sign,overflow
    );
    assign {co,result}=data_A+data_B+ci;
    assign overflow = data_A[`datawidth-1]&data_B[`datawidth-1]&(~result[`datawidth-1])|(~data_A[`datawidth-1])&(~data_B[`datawidth-1])&result[`datawidth-1];
    assign zero = ~(|result);
    assign result_sign=result[`datawidth-1];
endmodule
