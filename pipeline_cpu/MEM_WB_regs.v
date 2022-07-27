`include "defines.v"
module MEM_WB_regs (
    input clk,
    input rst_n,
    input validin,
    input pipe_ready_go,   
    input  out_allow,

    //上级未使用数据 
    input [4:0]                 in_Rd                   , 
    input [`datawidth-1:0]      in_Rd_data2             ,
    //MEM output 
    input                       in_data_RAM_W_en        , 
    //下一级可需要继续使用的数据  
    input [`datawidth-1:0]      in_imme                 ,  //LUI
    input [`datawidth-1:0]      in_ALU_res              ,  //R,I
    input [`datawidth-1:0]      in_PC_add_4             ,  //JAL,JALR  
    input [`datawidth-1:0]      in_PC_add_imme          ,  //AUIPC
    input [2:0]                 in_func3                ,
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
    //registers 写地址
    output reg [4:0]               out_Rd               , 
    //registers_control input
    output reg                     out_I_type               ,
    output reg                     out_L_type               ,
    output reg                     out_S_type               ,
    output reg                     out_R_type               ,
    output reg                     out_JAL_instr            ,
    output reg                     out_JALR_instr           ,
    output reg                     out_LUI_instr            ,
    output reg                     out_AUIPC_instr          ,
    output reg                     out_B_type               ,   
    //registers 写数据
    output reg [`datawidth-1:0]    out_ALU_res           , 
    output reg [`datawidth-1:0]    out_imme             ,
    output reg [`datawidth-1:0]    out_PC_add_4         ,
    output reg [`datawidth-1:0]    out_PC_add_imme      ,
    //dataRAM_control input 
    output reg [`datawidth-1:0]     out_Rd_data2             ,
    output reg                      out_data_RAM_W_en        ,
    output reg [2:0]                out_func3                               
);
reg pipe_valid;
always @(posedge clk ) begin

    if(!rst_n)
    begin
            pipe_valid <= 1'b0;
            out_Rd                   <= 0        ;
            out_Rd_data2             <= 0        ;
            out_data_RAM_W_en        <= 0        ;  
            out_imme                 <= 0        ;
            out_ALU_res              <= 0        ;
            out_PC_add_4             <= 0        ;
            out_PC_add_imme          <= 0        ;
            out_func3                <= 0        ;
            out_I_type               <= 0        ;
            out_L_type               <= 0        ;
            out_S_type               <= 0        ;
            out_R_type               <= 0        ;
            out_JAL_instr            <= 0        ;
            out_JALR_instr           <= 0        ;
            out_LUI_instr            <= 0        ;
            out_AUIPC_instr          <= 0        ;
            out_B_type               <= 0        ;
    end
    else if (in_allow)
        pipe_valid <= validin;
    if (validin && in_allow)
    begin
            out_Rd                   <= in_Rd                   ;
            out_Rd_data2             <= in_Rd_data2             ;
            out_data_RAM_W_en        <= in_data_RAM_W_en        ;  
            out_imme                 <= in_imme                 ;
            out_ALU_res              <= in_ALU_res              ;
            out_PC_add_4             <= in_PC_add_4             ;
            out_PC_add_imme          <= in_PC_add_imme          ;
            out_func3                <= in_func3                ;
            out_I_type               <= in_I_type               ;
            out_L_type               <= in_L_type               ;
            out_S_type               <= in_S_type               ;
            out_R_type               <= in_R_type               ;
            out_JAL_instr            <= in_JAL_instr            ;
            out_JALR_instr           <= in_JALR_instr           ;
            out_LUI_instr            <= in_LUI_instr            ;
            out_AUIPC_instr          <= in_AUIPC_instr          ;
            out_B_type               <= in_B_type               ;
    end
              
end
assign in_allow = !pipe_valid || pipe_ready_go && out_allow ;
assign validout = pipe_valid && pipe_ready_go;
endmodule //MEM_WB_regs