`include "signle_clk_cpu/defines.v"
module Branch (
    input clk,
    input rst_n,
    input [`datawidth-1:0] ALU_res                              ,
    input [2:0]            func3                                ,
    input                  B_type                               ,
    input                  ALU_ZERO                             ,
    output B_type_jump_flag                                                                               
);
//B类指令判断跳转
wire B_type_flag;
assign B_type_flag = (~func3[2])&(~func3[0])&ALU_ZERO|
                     (~func3[2])&(func3[0])&(~ALU_ZERO)|
                     (func3[2])&(~func3[0])&ALU_res[0]|
                      (func3[2])&(func3[0])&(~ALU_res[0]);
assign B_type_jump_flag = B_type_flag & B_type;
endmodule