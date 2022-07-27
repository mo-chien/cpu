`include "regs_WB_control.v"
`include "dataRAM_control.v"
module WBU (
    input I_type                               ,
    input L_type                               ,
    input S_type                               ,
    input R_type                               ,
    input JAL_instr                            ,
    input JALR_instr                           ,
    input LUI_instr                            ,
    input AUIPC_instr                          ,
    input B_type                               ,
    //dataRAM_control input
    input   [`datawidth-1:0]      dataRAM_Read_data    ,
    input   [2:0]                 func3                ,
    input   [`datawidth-1:0]      Rd_data2             ,
    //regs_WB_control input
    input   [`datawidth-1:0]      ALU_res              ,
    input   [`datawidth-1:0]      imme                 ,
    input   [`datawidth-1:0]      PC_add_4             ,
    input   [`datawidth-1:0]      PC_add_imme          ,
    //regs_WB_control output
    output  [`datawidth-1:0]      regs_WB_data         , 
    output                        registers_W_en       ,
    //regs_WB_control output
    output [`datawidth-1:0]       dataRAM_Wr_data      ,
    output                     pipe_ready_go

);
wire [`datawidth-1:0] Load_data ;
wire [1:0] bytes ;
assign bytes = ALU_res[1:0];
dataRAM_control u_dataRAM_control(
    .data_type         ( func3             ),
    .bytes             ( bytes             ),
    .data_in           ( Rd_data2           ),
    .dataRAM_Read_data ( dataRAM_Read_data ),
    .Wr_data           ( dataRAM_Wr_data   ),
    .Read_data         ( Load_data         )
);
regs_WB_control u_regs_WB_control(
    .I_type         ( I_type         ),
    .L_type         ( L_type         ),
    .S_type         ( S_type         ),
    .R_type         ( R_type         ),
    .JAL_instr      ( JAL_instr      ),
    .JALR_instr     ( JALR_instr     ),
    .LUI_instr      ( LUI_instr      ),
    .AUIPC_instr    ( AUIPC_instr    ),
    .B_type         ( B_type         ),
    .data_men_dout  ( Load_data      ),
    .ALU_res        ( ALU_res        ),
    .imme           ( imme           ),
    .PC_add_4       ( PC_add_4       ),
    .PC_add_imme    ( PC_add_imme    ),
    .WB_data        ( regs_WB_data     ),
    .registers_W_en  ( registers_W_en  )
);

assign pipe_ready_go=1'b1; 
endmodule //WBU