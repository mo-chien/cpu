`include "signle_clk_cpu/registers.v"
`include "signle_clk_cpu/decode.v"
module IDU (
    //registers input
    input clk ,
    input rst_n,
    input W_en,

    input [`datawidth-1:0] Wr_data                 ,
    //decode input
    input [`datawidth-1:0] instr                   ,
    //PC+imme input
    input [`datawidth-1:0] PC_now                  ,  
    //PC+imme output
    output [`datawidth-1:0] PC_add_imme,
    //decode output
    output [2:0]func3,
    output      func7 ,

    output [31:0]imme,
    output I_type                               ,
    output L_type                               ,
    output S_type                               ,
    output R_type                               ,
    output JAL_instr                            ,
    output JALR_instr                           ,
    output LUI_instr                            ,
    output AUIPC_instr                          ,
    output B_type                               ,
    //registers output
	output [`datawidth-1:0] regs_rs1_data       ,
	output [`datawidth-1:0] regs_rs2_data       
    
);
wire  [4:0] Rd,Rs1,Rs2;
decode u_decode(
    .instr       ( instr       ),
    .func3       ( func3       ),
    .func7       ( func7       ),
    .Rs1         ( Rs1         ),
    .Rs2         ( Rs2         ),
    .Rd          ( Rd          ),
    .imme        ( imme        ), 
    .I_type      ( I_type      ),
    .L_type      ( L_type      ),
    .S_type      ( S_type      ),
    .R_type      ( R_type      ),
    .JAL_instr   ( JAL_instr   ),
    .JALR_instr  ( JALR_instr  ),
    .LUI_instr   ( LUI_instr   ),
    .AUIPC_instr ( AUIPC_instr ),
    .B_type      ( B_type      )
);

registers u_registers(
    .clk      ( clk      ),
    .W_en     ( W_en     ),
    .Rs1      ( Rs1      ),
    .Rs2      ( Rs2      ),
    .Rd       ( Rd       ),
    .Wr_data  ( Wr_data  ),
    .Rd_data1 ( regs_rs1_data ),
    .Rd_data2  ( regs_rs2_data )
);
assign PC_add_imme = PC_now + imme; //该值作为PC_next 和 通用寄存器的写入数据
endmodule //IDU