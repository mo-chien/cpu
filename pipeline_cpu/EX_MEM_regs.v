`include "defines.v"
module EX_MEM_regs (
    input clk,
    input rst_n,
    input validin,
    input pipe_ready_go,   
    input  out_allow,
    //上级未使用数据 
    input [`datawidth-1:0]      in_PC_add_4             ,
    input [`datawidth-1:0]      in_PC_add_imme          ,
    input [4:0]                 in_Rd                   ,   
    //ALU output     
    input                       in_ALU_ZERO             ,
    input [`datawidth-1:0]      in_ALU_res              ,  
    //下一级可需要继续使用的数据
    input [`datawidth-1:0]      in_imme                 ,
    input [2:0]                 in_func3                ,
    input [`datawidth-1:0]      in_Rd_data2             ,
    input                       in_I_type               ,
    input                       in_L_type               ,
    input                       in_S_type               ,
    input                       in_R_type               ,
    input                       in_JAL_instr            ,
    input                       in_JALR_instr           ,
    input                       in_LUI_instr            ,
    input                       in_AUIPC_instr          ,
    input                       in_B_type               ,
 

    output  in_allow,
    output  validout,
    //MEM and BIU input   
    output reg [`datawidth-1:0]    out_ALU_res           , 
    //BIU input
    output reg                     out_ALU_ZERO         ,
    output reg [`datawidth-1:0]    out_PC_add_4         ,
    output reg [`datawidth-1:0]    out_PC_add_imme      , //可作为registers 写回数据
    //data_RAM 写数据
    output reg [`datawidth-1:0]    out_imme             ,

    //registers 写地址
    output reg [4:0]               out_Rd               , 
    //dataRAM_control input 
    output reg [`datawidth-1:0]    out_Rd_data2         ,
    output reg [2:0]               out_func3            ,
    //instr type
    output reg                     out_I_type               ,
    output reg                     out_L_type               ,
    output reg                     out_S_type               ,
    output reg                     out_R_type               ,
    output reg                     out_JAL_instr            ,
    output reg                     out_JALR_instr           ,
    output reg                     out_LUI_instr            ,
    output reg                     out_AUIPC_instr          ,
    output reg                     out_B_type               

);
reg pipe_valid;
always @(posedge clk ) begin

    if(!rst_n)
    begin
            pipe_valid <= 1'b0;
            out_PC_add_4             <=    0      ;
            out_PC_add_imme          <=    0      ;
            out_Rd                   <=    0      ;
            out_ALU_ZERO             <=    0      ;
            out_ALU_res              <=    0      ;
            out_imme                 <=    0      ;
            out_func3                <=    0      ;
            out_Rd_data2             <=    0      ;
            out_I_type               <=    0      ;
            out_L_type               <=    0      ;
            out_S_type               <=    0      ;
            out_R_type               <=    0      ;
            out_JAL_instr            <=    0      ;
            out_JALR_instr           <=    0      ;
            out_LUI_instr            <=    0      ;
            out_AUIPC_instr          <=    0      ;
            out_B_type               <=    0      ;
    end

    else if (in_allow)
        pipe_valid <= validin;
    if (validin && in_allow)
    begin
            out_PC_add_4             <=    in_PC_add_4             ;
            out_PC_add_imme          <=    in_PC_add_imme          ;
            out_Rd                   <=    in_Rd                   ;
            out_ALU_ZERO             <=    in_ALU_ZERO             ;
            out_ALU_res              <=    in_ALU_res              ;
            out_imme                 <=    in_imme                 ;
            out_func3                <=    in_func3                ;
            out_Rd_data2             <=    in_Rd_data2             ;
            out_I_type               <=    in_I_type               ;
            out_L_type               <=    in_L_type               ;
            out_S_type               <=    in_S_type               ;
            out_R_type               <=    in_R_type               ;
            out_JAL_instr            <=    in_JAL_instr            ;
            out_JALR_instr           <=    in_JALR_instr           ;
            out_LUI_instr            <=    in_LUI_instr            ;
            out_AUIPC_instr          <=    in_AUIPC_instr          ;
            out_B_type               <=    in_B_type               ;
    end

end
assign in_allow = !pipe_valid || pipe_ready_go && out_allow ;//当前级允许数据输入的情况：1：上条指令为接受数据；2：本级数据处理完成且下级发起读数据请求
assign validout = pipe_valid && pipe_ready_go;
endmodule //EX_MEM_regs