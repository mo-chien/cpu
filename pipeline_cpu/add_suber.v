`timescale 1ns / 1ps
`include "adder.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:56:41
// Design Name: 
// Module Name: add_suber
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


module add_suber(
    input [`datawidth-1:0] data_A,data_B,
    input sub_flag,
    output [`datawidth-1:0] result,
    output co,zero,result_sign,overflow
    );
    wire [`datawidth-1:0] Y;
    assign Y = data_B ^ {`datawidth{sub_flag}};//补码转换,实现运行加法时不转换，运行减法是转换
    
    adder u_adder(
        .data_A      ( data_A      ),
        .data_B      ( Y      ),
        .ci          ( sub_flag    ),
        .result      ( result      ),
        .co          ( co          ),
        .zero        ( zero        ),
        .result_sign ( result_sign ),
        .overflow    ( overflow    )
    );

endmodule
