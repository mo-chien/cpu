`include "defines.v"
module Branch (
    input clk,
    input rst_n,
    input [`datawidth-1:0] EXE_ALU_res                              ,
    input [2:0]            EXE_func3                                ,
    input                  EXE_B_type                               ,
    input                  EXE_ALU_ZERO                             ,
    output clear                                                                               
);
//B类指令判断跳转
wire B_type_flag;
assign B_type_flag = (~EXE_func3[2])&(~EXE_func3[0])&EXE_ALU_ZERO|
                     (~EXE_func3[2])&(EXE_func3[0])&(~EXE_ALU_ZERO)|
                     (EXE_func3[2])&(~EXE_func3[0])&EXE_ALU_res[0]|
                      (EXE_func3[2])&(EXE_func3[0])&(~EXE_ALU_res[0]);
assign clear = B_type_flag & EXE_B_type;
endmodule