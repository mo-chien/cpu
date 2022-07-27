`include "defines.v"
module ID_EX_regs (
    input clk,
    input rst_n,
    input validin,
    input pipe_ready_go,   
    input  out_allow, 
    input clear                                                  ,
    //上级未使用数据
    input [`datawidth-1:0]  in_PC_add_4                          ,
    //上级数据处理后输出的数据
    //PC+imme output
    input [`datawidth-1:0]  in_PC_add_imme                       ,
    //decode output
    input [2:0]             in_func3                             ,
    input [`datawidth-1:0]  in_imme                              ,
    //input [4:0]             in_opcode           ,
    input [4:0]             in_Rd                                ,
    input                   in_func7                             ,
    input                   in_I_type                            ,
    input                   in_L_type                            ,
    input                   in_S_type                            ,
    input                   in_R_type                            ,
    input                   in_JAL_instr                         ,
    input                   in_JALR_instr                        ,
    input                   in_LUI_instr                         ,
    input                   in_AUIPC_instr                       ,
    input                   in_B_type                            ,
    
    //registers output
    input [`datawidth-1:0]  in_Rd_data1                          ,
    input [`datawidth-1:0]  in_Rd_data2                          ,



    output in_allow,
    output validout,
    //PC_next和通用寄存器的写回数据
    output reg [`datawidth-1:0] out_PC_add_4            ,
    output reg [`datawidth-1:0] out_PC_add_imme         ,
    //通用寄存器写地址
    output reg [4:0]            out_Rd                  ,
    //ALU的输入数据
    output reg [`datawidth-1:0] out_Rd_data1            ,
    output reg [`datawidth-1:0] out_Rd_data2            ,
    output reg [`datawidth-1:0] out_imme                ,
    //ALU_control 控制信号
    output reg [2:0]            out_func3               ,
    output reg                  out_func7               ,
    //output reg [4:0]            out_opcode
    output reg                      out_I_type          ,
    output reg                      out_L_type          ,
    output reg                      out_S_type          ,
    output reg                      out_R_type          ,
    output reg                      out_JAL_instr       ,
    output reg                      out_JALR_instr      ,
    output reg                      out_LUI_instr       ,
    output reg                      out_AUIPC_instr     ,
    output reg                      out_B_type           
);
reg pipe_valid;
always @(posedge clk ) begin

    if(!rst_n )
    begin
        pipe_valid <= 1'b0;
        out_PC_add_4                          <=  0;
        out_PC_add_imme                       <=  0;
        out_func3                             <=  0;
        out_imme                              <=  0;
        out_Rd                                <=  0;
        out_func7                             <=  0;
        out_I_type                            <=  0;
        out_L_type                            <=  0;
        out_S_type                            <=  0;
        out_R_type                            <=  0;
        out_JAL_instr                         <=  0;
        out_JALR_instr                        <=  0;
        out_LUI_instr                         <=  0;
        out_AUIPC_instr                       <=  0;
        out_B_type                            <=  0;
        out_Rd_data1                          <=  0;
        out_Rd_data2                          <=  0;
    end
    else if (clear)
        begin
        out_PC_add_4                          <=  0;
        out_PC_add_imme                       <=  0;
        out_func3                             <=  0;
        out_imme                              <=  0;
        out_Rd                                <=  0;
        out_func7                             <=  0;
        out_I_type                            <=  0;
        out_L_type                            <=  0;
        out_S_type                            <=  0;
        out_R_type                            <=  0;
        out_JAL_instr                         <=  0;
        out_JALR_instr                        <=  0;
        out_LUI_instr                         <=  0;
        out_AUIPC_instr                       <=  0;
        out_B_type                            <=  0;
        out_Rd_data1                          <=  0;
        out_Rd_data2                          <=  0; 
        end   

    else if (validin && in_allow)
    begin
        out_PC_add_4                          <=  in_PC_add_4                          ;
        out_PC_add_imme                       <=  in_PC_add_imme                       ;
        out_func3                             <=  in_func3                             ;
        out_imme                              <=  in_imme                              ;
        out_Rd                                <=  in_Rd                                ;
        out_func7                             <=  in_func7                             ;
        out_I_type                            <=  in_I_type                            ;
        out_L_type                            <=  in_L_type                            ;
        out_S_type                            <=  in_S_type                            ;
        out_R_type                            <=  in_R_type                            ;
        out_JAL_instr                         <=  in_JAL_instr                         ;
        out_JALR_instr                        <=  in_JALR_instr                        ;
        out_LUI_instr                         <=  in_LUI_instr                         ;
        out_AUIPC_instr                       <=  in_AUIPC_instr                       ;
        out_B_type                            <=  in_B_type                            ;
        out_Rd_data1                          <=  in_Rd_data1                          ;
        out_Rd_data2                          <=  in_Rd_data2                          ;
    end
    if (in_allow)
        pipe_valid <= validin;
end
assign in_allow = !pipe_valid || pipe_ready_go && out_allow ;//当前级允许数据输入的情况：1：上条指令为接受数据；2：本级数据处理完成且下级发起读数据请求
assign validout = pipe_valid && pipe_ready_go;
endmodule //ID_EX_regs