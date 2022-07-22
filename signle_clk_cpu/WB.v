`include "signle_clk_cpu/defines.v"
module WB (
    //registers_control input
    input I_type                               ,
    input L_type                               ,
    input S_type                               ,
    input R_type                               ,
    input JAL_instr                            ,
    input JALR_instr                           ,
    input LUI_instr                            ,
    input AUIPC_instr                          ,
    input B_type                               ,
    //registers 写数据
    input  [`datawidth-1:0]    data_men_dout    ,
    input  [`datawidth-1:0]    ALU_res           , 
    input  [`datawidth-1:0]    imme             ,
    input  [`datawidth-1:0]    PC_add_4         ,
    input  [`datawidth-1:0]    PC_add_imme      ,
    output [`datawidth-1:0]    WB_data          ,
    output                     registers_W_en   
);
    assign registers_W_en = ~(S_type | B_type);

    assign WB_data = L_type             ?  data_men_dout :
                     (R_type |  I_type) ?  ALU_res       :
                     LUI_instr          ?  imme          :
                     (JAL_instr | JALR_instr)   ? PC_add_4      :
                     AUIPC_instr       ? PC_add_imme   : 32'd0 ;   
endmodule 