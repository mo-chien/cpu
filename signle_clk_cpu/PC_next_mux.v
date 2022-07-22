`include "signle_clk_cpu/defines.v"
module PC_next_mux (
    input                   JALR_instr                           ,
    input                   JAL_instr                            ,
    input                   B_type_jump_flag                     ,
    input  [`datawidth-1:0] ALU_res                              ,
    input  [`datawidth-1:0] PC_add_imme                          ,
    input  [`datawidth-1:0] PC_add_4                             ,
    output [`datawidth-1:0] PC_next 
);
assign PC_next =  B_type_jump_flag  |  JAL_instr       ? PC_add_imme:
                  JALR_instr                           ? ALU_res    : PC_add_4;


endmodule //PC_next_mux