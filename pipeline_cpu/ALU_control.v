`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/25 17:07:26
// Design Name: 
// Module Name: control
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


module ALU_control(
    input I_type                               ,
    input L_type                               ,
    input S_type                               ,
    input R_type                               ,
    //input JAL_instr                            ,
    input JALR_instr                           ,
    //input LUI_instr                            ,
    //input AUIPC_instr                          ,
    input B_type                               ,
    input [2:0]func3,
    input func7,
    output [3:0] ALUop,
    output ALUdata_flag
    );
    wire [3:0] R_ALUop;
    wire [3:0] I_ALUop;
    wire [3:0] B_ALUop;
    wire [3:0] JALR_ALUop;
    wire [3:0] L_S_ALUop;
    assign R_ALUop = {func7,func3};
    assign I_ALUop = {~func3[1]&func3[2]&func3[0]&func7,func3};//I类指令ALU控制数与R类指令相近仅当fun3为101时会出现最高位不为0的情况
    assign B_ALUop = {3'b001,func3[2]&func3[1]};//ALU执行R类指令中的slt和sltu
    assign JALR_ALUop = {1'b0,func3};
    assign L_S_ALUop = 4'b0000;//Load 和store 指令执行加法计算dataRAM的访存地址，ALU_DB的输入数据为立即数
    assign ALUop = R_type ? R_ALUop : I_type ? I_ALUop : 
                   B_type ? B_ALUop : (L_type |S_type )? L_S_ALUop :
                   JALR_instr ? JALR_ALUop : 4'b1111;

    assign ALUdata_flag = R_type | B_type ; //为1时数据输入为rd2，判定为B和R类指令
endmodule
