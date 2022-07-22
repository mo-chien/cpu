`include "signle_clk_cpu/ALU.v"
`include "signle_clk_cpu/ALU_control.v"
module EXU (
    //ALU input
    input [`datawidth-1:0] Rd_data1                             ,
    input [`datawidth-1:0] Rd_data2                             ,
    input [`datawidth-1:0] imme                                 ,
    //ALU_control input
    input [2:0]            func3                                ,
    input                  func7                                ,
    input                  I_type                               ,
    input                  L_type                               ,
    input                  S_type                               ,
    input                  R_type                               ,
    //input JAL_instr                            ,
    input JALR_instr                                            ,
    //input LUI_instr                            ,
    //input AUIPC_instr                          ,
    input                  B_type                               ,
    //ALU output
    output ALU_ZERO,
    output [`datawidth-1:0] ALU_res

);
wire ALUdata_flag;
wire [3:0] ALUop;
wire [`datawidth-1:0] ALU_DA,ALU_DB;
assign ALU_DA = Rd_data1;
assign ALU_DB = ALUdata_flag ? Rd_data2   : imme;

ALU_control u_ALU_control(
    .I_type       ( I_type       ),
    .L_type       ( L_type       ),
    .S_type       ( S_type       ),
    .R_type       ( R_type       ),
    //.JAL_instr    ( JAL_instr    ),
    .JALR_instr   ( JALR_instr   ),
    //.LUI_instr    ( LUI_instr    ),
    //.AUIPC_instr  ( AUIPC_instr  ),
    .B_type       ( B_type       ),
    .func3        ( func3        ),
    .func7        ( func7        ),
    .ALUop        ( ALUop        ),
    .ALUdata_flag  ( ALUdata_flag  )
);

ALU u_ALU(
    .ALU_DA       ( ALU_DA       ),
    .ALU_DB       ( ALU_DB       ),
    .ALUop        ( ALUop       ),
    .ALU_ZERO     ( ALU_ZERO     ),
    .ALU_res       ( ALU_res       )
);
endmodule //EXU