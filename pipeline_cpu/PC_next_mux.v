`include "defines.v"
module PC_next_mux (
    input                   IDU_JALR_instr                           ,
    input                   IDU_JAL_instr                            ,
    input                   B_type_jump_flag                         ,
    input  [`datawidth-1:0] EXE_ALU_res                              ,
    input  [`datawidth-1:0] IDU_PC_add_imme                          ,
    input  [`datawidth-1:0] EXE_PC_add_imme                          ,
    input  [`datawidth-1:0] IFU_PC_add_4                             ,
    output [`datawidth-1:0] PC_next 
);
assign PC_next =  B_type_jump_flag         ? EXE_PC_add_imme:
                  IDU_JALR_instr           ? EXE_ALU_res    : 
                  IDU_JAL_instr            ? IDU_PC_add_imme: IFU_PC_add_4;

endmodule //PC_next_mux