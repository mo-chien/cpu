`timescale 1ns / 1ps
`include "uint_diver.v"
module int_driver (
    input  clk,
    //input  rst_n,
    input diver_en,
    input  sign_flag,//为1时：无符号运算
    input  [`datawidth-1:0] dividend,divisor, 
    output [`datawidth-1:0] remainder,
    output [`datawidth-1:0] result,
    output end_flag
);
wire [`datawidth-1:0] dividend_temp,divisor_temp;
wire [`datawidth-1:0] remainder_temp,result_temp;
assign dividend_temp = sign_flag ? dividend : dividend [`datawidth-1] ? {1'b0,~dividend[`datawidth-2:0]}+1'b1:dividend;
assign divisor_temp = sign_flag ? divisor : divisor [`datawidth-1] ? {1'b0,~divisor[`datawidth-2:0]}+1'b1:divisor;
uint_diver u_uint_diver(
    .diver_en  ( diver_en  ),
    .clk       ( clk       ),
    //.rst_n     ( rst_n     ),
    .dividend  ( dividend_temp  ),
    .divisor   ( divisor_temp   ),
    .remainder ( remainder_temp ),
    .result    ( result_temp    ),
    .end_flag  ( end_flag  )
);
assign remainder =sign_flag ? remainder_temp : dividend [`datawidth-1]^divisor [`datawidth-1] ? ~remainder_temp[`datawidth-2:0]+1'b1 : remainder_temp;
assign result =sign_flag ? result_temp : dividend [`datawidth-1]^divisor [`datawidth-1] ? ~result_temp[`datawidth-2:0]+1'b1 : result_temp;

endmodule //int_driver