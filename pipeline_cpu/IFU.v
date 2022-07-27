`include "PC_reg.v"
`include "PC_next_mux.v"
//指令RAM采用同步RAM的形式，取值阶段仅向指令RAM发起读请求和读地址，不接受指令RAM的读数据，将指令RAM的读数据直接接入IDU
module IFU 
(
 input clk,rst_n,
 input pc_en,
 input                   IDU_JALR_instr                           ,
 input                   IDU_JAL_instr                            ,
 input                   B_type_jump_flag                         ,
 input  [`datawidth-1:0] EXE_ALU_res                              ,
 input  [`datawidth-1:0] IDU_PC_add_imme                          ,
 input  [`datawidth-1:0] EXE_PC_add_imme                          ,
 output [`addrwidth-1:0] instr_addr,
 output [`datawidth-1:0] PC_add_4,
 output [`datawidth-1:0] PC_now
 //output pipe_ready_go
);
wire [`datawidth-1:0] PC_next ;
PC_next_mux u_PC_next_mux(
    .IDU_JALR_instr    ( IDU_JALR_instr    ),
    .IDU_JAL_instr     ( IDU_JAL_instr     ),
    .B_type_jump_flag  ( B_type_jump_flag  ),
    .EXE_ALU_res       ( EXE_ALU_res       ),
    .IDU_PC_add_imme   ( IDU_PC_add_imme   ),
    .EXE_PC_add_imme   ( EXE_PC_add_imme   ),
    .IFU_PC_add_4      ( PC_add_4          ),
    .PC_next           ( PC_next           )
);
/*wire [`datawidth-1:0] PC_new;
wire jump_flag;
assign jump_flag = IDU_JALR_instr | IDU_JAL_instr | B_type_jump_flag ;
assign PC_new = jump_flag ? PC_next : PC_add_4 ;*/
PC_reg u_PC_reg(
    .clk    ( clk    ),
    .rst_n  ( rst_n  ),
    .pc_en  (pc_en   ),
    .pc_new ( PC_next ),
    .pc_out  ( PC_now  )
);
assign instr_addr = PC_next [9:2] ; //同步指令RAM 
assign PC_add_4 = PC_now + 32'd4;   //该值作为PC_next 和 通用寄存器的写入数据
//assign pipe_ready_go=1;
endmodule //IFU