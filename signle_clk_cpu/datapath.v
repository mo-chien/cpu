`include "signle_clk_cpu/IFU.v"
`include "signle_clk_cpu/IDU.v"
`include "signle_clk_cpu/EXU.v"
`include "signle_clk_cpu/MEM.v"
`include "signle_clk_cpu/Branch.v"
`include "signle_clk_cpu/WB.v"
module datapath (
    input clk,
    input rst_n,
    input  [`datawidth-1:0]  instr,
    input  [`datawidth-1:0]  dataRAM_data,
    output  [`addrwidth-1:0] instr_addr                    ,  
    output  [`datawidth-1:0]      dataRAM_Wr_data          ,
    output  [`addrwidth-1:0]      dataRAM_adder            ,
    output                        data_RAM_W_en                            
);
wire JALR_instr   ;
wire JAL_instr    ;
wire B_type_jump_flag ;
wire [`datawidth-1:0] PC_add_imme;
wire [`datawidth-1:0] ALU_res;
wire [`datawidth-1:0] PC_add_4;
wire [`datawidth-1:0] PC_now;
IFU u_IFU(
    .clk               ( clk               ),
    .rst_n             ( rst_n             ),
    .JALR_instr        ( JALR_instr        ),
    .JAL_instr         ( JAL_instr         ),
    .B_type_jump_flag  ( B_type_jump_flag  ),
    .ALU_res           ( ALU_res           ),
    .PC_add_imme       ( PC_add_imme       ),
    .instr_addr        ( instr_addr        ),
    .PC_add_4          ( PC_add_4          ),
    .PC_now            ( PC_now            )
);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire W_en;
wire [`datawidth-1:0] Wr_data;
wire [2:0] func3;
wire func7;
wire [31:0]imme;
wire I_type                               ;
wire L_type                               ;
wire S_type                               ;
wire R_type                               ;
wire LUI_instr                            ;
wire AUIPC_instr                          ;
wire B_type                               ;
wire [`datawidth-1:0] regs_rs1_data       ;
wire [`datawidth-1:0] regs_rs2_data       ; 
IDU u_IDU(
    .clk            ( clk            ),
    .rst_n          ( rst_n          ),
    .W_en           ( W_en           ),
    .Wr_data        ( Wr_data        ),
    .instr          ( instr          ),
    .PC_now         ( PC_now         ),
    .PC_add_imme    ( PC_add_imme    ),
    .func3          ( func3          ),
    .func7          ( func7          ),
    .imme           ( imme           ),
    .I_type         ( I_type         ),
    .L_type         ( L_type         ),
    .S_type         ( S_type         ),
    .R_type         ( R_type         ),
    .JAL_instr      ( JAL_instr      ),
    .JALR_instr     ( JALR_instr     ),
    .LUI_instr      ( LUI_instr      ),
    .AUIPC_instr    ( AUIPC_instr    ),
    .B_type         ( B_type         ),
    .regs_rs1_data  ( regs_rs1_data  ),
    .regs_rs2_data  ( regs_rs2_data  )
);

//////////////////////////////////////////////////////////////////////////////////////////
wire ALU_ZERO ;
EXU u_EXU(
    .Rd_data1    ( regs_rs1_data    ),
    .Rd_data2    ( regs_rs2_data    ),
    .imme        ( imme        ),
    .func3       ( func3       ),
    .func7       ( func7       ),
    .I_type      ( I_type      ),
    .L_type      ( L_type      ),
    .S_type      ( S_type      ),
    .R_type      ( R_type      ),
    .JALR_instr  ( JALR_instr  ),
    .B_type      ( B_type      ),
    .ALU_ZERO    ( ALU_ZERO    ),
    .ALU_res     ( ALU_res     )
);

/////////////////////////////////////////////////////////////////////////////////////////
Branch u_Branch(
    .clk       ( clk       ),
    .rst_n     ( rst_n     ),
    .ALU_res   ( ALU_res   ),
    .func3     ( func3     ),
    .B_type    ( B_type    ),
    .ALU_ZERO  ( ALU_ZERO  ),
    .B_type_jump_flag  ( B_type_jump_flag  )
);

/////////////////////////////////////////////////////////////////////////////////////////
wire [`datawidth-1:0] Read_data ;

MEM u_MEM(
    .L_type             ( L_type             ),
    .S_type             ( S_type             ),
    .data_type          ( func3              ),
    .data_in            ( regs_rs2_data            ),
    .dataRAM_Read_data  ( dataRAM_data  ),
    .addr               ( ALU_res               ),
    .dataRAM_Wr_data     ( dataRAM_Wr_data            ),
    .Read_data          ( Read_data          ),
    .data_RAM_W_en      ( data_RAM_W_en      ),
    .ram_adder          ( dataRAM_adder          )
);




///////////////////////////////////////////////////////////////////////////////////////////////////
wire [`datawidth-1:0] WB_data;
WB u_WB(
    .I_type         ( I_type         ),
    .L_type         ( L_type         ),
    .S_type         ( S_type         ),
    .R_type         ( R_type         ),
    .JAL_instr      ( JAL_instr      ),
    .JALR_instr     ( JALR_instr     ),
    .LUI_instr      ( LUI_instr      ),
    .AUIPC_instr    ( AUIPC_instr    ),
    .B_type         ( B_type         ),
    .data_men_dout  ( Read_data      ),
    .ALU_res        ( ALU_res        ),
    .imme           ( imme           ),
    .PC_add_4       ( PC_add_4       ),
    .PC_add_imme    ( PC_add_imme    ),
    .WB_data        ( WB_data        ),
    .registers_W_en  ( registers_W_en  )
);
assign Wr_data = WB_data;
assign W_en    = registers_W_en;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule //datapath

