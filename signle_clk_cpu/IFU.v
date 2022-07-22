`include "signle_clk_cpu/PC_reg.v"
`include "signle_clk_cpu/PC_next_mux.v"
module IFU 
(
 input clk,rst_n,
 input                   JALR_instr                           ,
 input                   JAL_instr                            ,
 input                   B_type_jump_flag                     ,
 input  [`datawidth-1:0] ALU_res                              ,
 input  [`datawidth-1:0] PC_add_imme                          ,
 output [`addrwidth-1:0] instr_addr                           ,
 output [`datawidth-1:0] PC_add_4                             ,
 output [`datawidth-1:0] PC_now

);
wire [`datawidth-1:0] PC_next ;
PC_next_mux u_PC_next_mux(
    .JALR_instr        ( JALR_instr        ),
    .JAL_instr         ( JAL_instr         ),
    .B_type_jump_flag  ( B_type_jump_flag  ),
    .ALU_res           ( ALU_res           ),
    .PC_add_imme       ( PC_add_imme       ),
    .PC_add_4          ( PC_add_4          ),
    .PC_next           ( PC_next           )
);

PC_reg u_PC_reg(
    .clk    ( clk    ),
    .rst_n  ( rst_n  ),
    .pc_new ( PC_next ),
    .pc_out  ( PC_now  )
);
assign instr_addr = PC_now [9:2] ; 
assign PC_add_4 = PC_now + 32'd4;  

endmodule //IFU