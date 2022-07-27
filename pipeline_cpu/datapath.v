`include "IFU.v"
`include "IF_ID_regs.v"
`include "IDU.v"
`include "WBR.v"
`include "ID_EX_regs.v"
`include "EXU.v"
`include "EX_MEM_regs.v"
`include "MEM.v"
`include "Branch.v"
`include "taken.v"
`include "MEM_WB_regs.v"
`include "WBU.v"
module datapath (
    input clk,
    input rst_n,
    input  [`datawidth-1:0] instr,
    input  [`datawidth-1:0] dataRAM_data,
    output  [`addrwidth-1:0] instr_addr                    ,
    output  [`addrwidth-1:0]      dataRAM_Read_adder       ,
    output                        data_RAM_R_en            ,    
    output  [`datawidth-1:0]      dataRAM_Wr_data          ,
    output  [`addrwidth-1:0]      dataRAM_Wr_adder         ,
    output                        data_RAM_W_en            ,
    output                        instrRam_hold_on                 
);
//PC+imme output
wire [`datawidth-1:0] ID_PC_add_imme;
//decode output
wire [2:0]ID_func3;
wire      ID_func7 ;
wire [4:0]ID_Rd;
wire [31:0]ID_imme;
wire ID_I_type     ;
wire ID_L_type     ;
wire ID_S_type     ;
wire ID_R_type     ;
wire ID_JAL_instr  ;
wire ID_JALR_instr ;
wire ID_LUI_instr  ;
wire ID_AUIPC_instr;
wire ID_B_type     ;
wire [4:0] ID_Rs1  ;        
wire [4:0] ID_Rs2  ;     
//registers output   
wire [`datawidth-1:0] ID_regs_rs1_data ;
wire [`datawidth-1:0] ID_regs_rs2_data ;

wire [4:0]              EXE_Rd    ;     
wire                    EXE_I_type     ;
wire                    EXE_L_type     ;
wire                    EXE_R_type     ;
wire                    EXE_JAL_instr  ;
wire                    EXE_JALR_instr ;
wire                    EXE_LUI_instr  ;
wire                    EXE_AUIPC_instr;
wire [`datawidth-1:0]   EXE_ALU_res ;
wire [`datawidth-1:0]   EXE_imme    ;
wire [`datawidth-1:0]   EXE_PC_add_imme;
wire [`datawidth-1:0]   EXE_PC_add_4;

wire [4:0]              MEM_Rd    ;     
wire                    MEM_I_type     ;
wire                    MEM_L_type     ;
wire                    MEM_R_type     ;
wire                    MEM_JAL_instr  ;
wire                    MEM_JALR_instr ;
wire                    MEM_LUI_instr  ;
wire                    MEM_AUIPC_instr;
wire [`datawidth-1:0]   MEM_ALU_res ;
wire [`datawidth-1:0]   MEM_imme ;
wire [`datawidth-1:0]   MEM_PC_add_imme;
wire [`datawidth-1:0]   MEM_PC_add_4;

wire [4:0]              WBU_Rd    ;     
wire                    WBU_I_type     ;
wire                    WBU_L_type     ;
wire                    WBU_R_type     ;
wire                    WBU_JAL_instr  ;
wire                    WBU_JALR_instr ;
wire                    WBU_LUI_instr  ;
wire                    WBU_AUIPC_instr;


wire [`datawidth-1:0] PC_next;
wire [`datawidth-1:0] IF_PC_add_4;
wire [`datawidth-1:0] IF_PC_now;
wire pc_en;
wire B_type_jump_flag;

IFU u_IFU(
    .clk               ( clk               ),
    .rst_n             ( rst_n             ),
    .pc_en             ( pc_en             ),
    .IDU_JALR_instr    ( ID_JALR_instr    ),
    .IDU_JAL_instr     ( ID_JAL_instr     ),
    .B_type_jump_flag  ( B_type_jump_flag  ),
    .EXE_ALU_res       ( EXE_ALU_res       ),
    .IDU_PC_add_imme   ( ID_PC_add_imme   ),
    .EXE_PC_add_imme   ( EXE_PC_add_imme   ),
    .instr_addr        ( instr_addr        ),
    .PC_add_4          ( IF_PC_add_4       ),
    .PC_now            ( IF_PC_now         )
);


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire  IF_ID_validin;
wire  IDU_pipe_ready_go;
wire  EX_ID_out_allow;   
wire  ID_EX_regs_valid;
//PC_next和通用寄存器的写回数据  
wire [`datawidth-1:0] ID_PC_add_4   ; 
//作为PC+imme的输入
wire [`datawidth-1:0] ID_PC_now;
wire [`datawidth-1:0] ID_instr;
wire ID_in_allow;
wire clear;
IF_ID_regs u_IF_ID_regs(
    .clk           ( clk           ),
    .rst_n         ( rst_n         ),
    .clear         (clear          ),
    .validin       ( IF_ID_validin  ),//来自上级流水线
    .pipe_ready_go ( IDU_pipe_ready_go ),//来自该级流水线中的数据处理模块
    .out_allow     ( EX_ID_out_allow     ),//来自下级流水线
    .in_PC_add_4   ( IF_PC_add_4   ),
    .in_PC_now     ( IF_PC_now        ),
    .in_instr      (instr             ),
    .in_allow      (ID_in_allow       ),//用来暂停PC
    .validout      ( ID_EX_regs_valid ),//作为下级流水线validin的输入
    .out_PC_add_4  ( ID_PC_add_4   ),
    .out_PC_now    ( ID_PC_now     ),
    .out_instr     (ID_instr)
);


assign pc_en = ID_in_allow ;
assign instrRam_hold_on = ID_in_allow ;

//registers input
wire W_en;
wire [4:0] registers_Rd;
wire [`datawidth-1:0] Wr_data;

wire WBR_pipe_ready_go;
//wire BIU_IDU_pipe_ready_go;


IDU u_IDU(
    .clk            ( clk            ),
    .rst_n          ( rst_n          ),
    .W_en           ( W_en           ),
    .registers_Rd   ( registers_Rd   ),
    .Wr_data        ( Wr_data        ),
    .instr          ( ID_instr       ),
    .PC_now         ( ID_PC_now         ),
    .WBR_pipe_ready_go (WBR_pipe_ready_go)       ,
    //.BIU_pipe_ready_go (BIU_IDU_pipe_ready_go)      ,
    .PC_add_imme    ( ID_PC_add_imme    ),
    .func3          ( ID_func3          ),
    .func7          ( ID_func7          ),
    .Rd             ( ID_Rd             ),
    .imme           ( ID_imme           ),
    .I_type         ( ID_I_type         ),
    .L_type         ( ID_L_type         ),
    .S_type         ( ID_S_type         ),
    .R_type         ( ID_R_type         ),
    .JAL_instr      ( ID_JAL_instr      ),
    .JALR_instr     ( ID_JALR_instr     ),
    .LUI_instr      ( ID_LUI_instr      ),
    .AUIPC_instr    ( ID_AUIPC_instr    ),
    .B_type         ( ID_B_type         ),
    .Rs1            ( ID_Rs1            ),
    .Rs2            ( ID_Rs2            ),
    .regs_rs1_data  ( ID_regs_rs1_data  ),
    .regs_rs2_data  ( ID_regs_rs2_data  ),
    .pipe_ready_go  (IDU_pipe_ready_go)
);


wire [31:0] ID_Rd_data1;
wire [31:0] ID_Rd_data2;
WBR u_WBR(
    .clk              ( clk              ),
    .rst_n            ( rst_n            ),
    .Rs1              ( ID_Rs1              ),
    .Rs2              ( ID_Rs2              ),
    .regs_rs1_data    ( ID_regs_rs1_data    ),
    .regs_rs2_data    ( ID_regs_rs2_data    ),
    //.registers_Rd     ( registers_Rd     ),
    .Wr_data          ( Wr_data          ),
    .IDU_I_type       (ID_I_type),
    .IDU_L_type       (ID_L_type),
    .IDU_S_type       (ID_S_type),
    .IDU_R_type       (ID_R_type),
    .IDU_JALR_instr   (ID_JALR_instr),
    .IDU_B_type       (ID_B_type),
    .EXE_Rd           ( EXE_Rd           ),
    .EXE_I_type       ( EXE_I_type       ),
    .EXE_L_type       ( EXE_L_type       ),
    .EXE_R_type       ( EXE_R_type       ),
    .EXE_JAL_instr    ( EXE_JAL_instr    ),
    .EXE_JALR_instr   ( EXE_JALR_instr   ),
    .EXE_LUI_instr    ( EXE_LUI_instr    ),
    .EXE_AUIPC_instr  ( EXE_AUIPC_instr  ),
    .MEM_Rd           ( MEM_Rd           ),
    .MEM_I_type       ( MEM_I_type       ),
    .MEM_L_type       ( MEM_L_type       ),
    .MEM_R_type       ( MEM_R_type       ),
    .MEM_JAL_instr    ( MEM_JAL_instr    ),
    .MEM_JALR_instr   ( MEM_JALR_instr   ),
    .MEM_LUI_instr    ( MEM_LUI_instr    ),
    .MEM_AUIPC_instr  ( MEM_AUIPC_instr  ),
    .WBU_Rd           ( WBU_Rd           ),
    .WBU_I_type       ( WBU_I_type       ),
    .WBU_L_type       ( WBU_L_type       ),
    .WBU_R_type       ( WBU_R_type       ),
    .WBU_JAL_instr    ( WBU_JAL_instr    ),
    .WBU_JALR_instr   ( WBU_JALR_instr   ),
    .WBU_LUI_instr    ( WBU_LUI_instr    ),
    .WBU_AUIPC_instr  ( WBU_AUIPC_instr  ),
    .EXE_ALU_res      ( EXE_ALU_res      ),
    .MEM_ALU_res      ( MEM_ALU_res      ),
    .EXE_imme         ( EXE_imme         ),
    .MEM_imme         ( MEM_imme         ),
    .EXE_PC_add_imme  ( EXE_PC_add_imme  ),
    .MEM_PC_add_imme  ( MEM_PC_add_imme  ),
    .EXE_PC_add_4     ( EXE_PC_add_4     ),
    .MEM_PC_add_4     ( MEM_PC_add_4     ),
    .Rd_data1         ( ID_Rd_data1         ),
    .Rd_data2         ( ID_Rd_data2         ),
    .pipe_ready_go    ( WBR_pipe_ready_go )
);
wire taken_pipe_valid;
taken u_taken(
    .clk              ( clk              ),
    .rst_n            ( rst_n            ),
    .IDU_PC_add_imme  ( ID_PC_add_imme  ),
    .IDU_JAL_instr    ( ID_JAL_instr    ),
    .IDU_JALR_instr   ( ID_JALR_instr   ),
    .pipe_valid       ( taken_pipe_valid )
);

//////////////////////////////////////////////////////////////////////////////////////////
wire EXE_pipe_ready_go ;   
wire MEM_EX_out_allow ;
wire EXE_MEM_valid ;
//ALU_control 控制信号
wire [2:0]            EXE_func3               ;
wire                  EXE_func7               ;
wire [`datawidth-1:0] EXE_Rd_data1, EXE_Rd_data2;
ID_EX_regs u_ID_EX_regs (
    .clk              ( clk              ),
    .rst_n            ( rst_n            ),
    .validin          ( ID_EX_regs_valid          ),
    .pipe_ready_go    ( EXE_pipe_ready_go    ),
    .out_allow        ( MEM_EX_out_allow        ),
    .clear            (clear             ),
    .in_PC_add_4      ( ID_PC_add_4      ),
    .in_PC_add_imme   ( ID_PC_add_imme   ),
    .in_func3         ( ID_func3         ),
    .in_imme          ( ID_imme          ),
    .in_Rd            ( ID_Rd            ),
    .in_func7         ( ID_func7         ),
    .in_I_type        ( ID_I_type        ),
    .in_L_type        ( ID_L_type        ),
    .in_S_type        ( ID_S_type        ),
    .in_R_type        ( ID_R_type        ),
    .in_JAL_instr     ( ID_JAL_instr     ),
    .in_JALR_instr    ( ID_JALR_instr    ),
    .in_LUI_instr     ( ID_LUI_instr     ),
    .in_AUIPC_instr   ( ID_AUIPC_instr   ),
    .in_B_type        ( ID_B_type        ),
    .in_Rd_data1      ( ID_Rd_data1      ),
    .in_Rd_data2      ( ID_Rd_data2      ),
    .in_allow         ( EX_ID_out_allow         ),
    .validout         ( EXE_MEM_valid         ),
    .out_PC_add_4     ( EXE_PC_add_4     ),
    .out_PC_add_imme  ( EXE_PC_add_imme  ),
    .out_Rd           ( EXE_Rd           ),
    .out_Rd_data1     ( EXE_Rd_data1     ),
    .out_Rd_data2     ( EXE_Rd_data2     ),
    .out_imme         ( EXE_imme         ),
    .out_func3        ( EXE_func3        ),
    .out_func7        ( EXE_func7        ),
    .out_I_type       ( EXE_I_type       ),
    .out_L_type       ( EXE_L_type       ),
    .out_S_type       ( EXE_S_type       ),
    .out_R_type       ( EXE_R_type       ),
    .out_JAL_instr    ( EXE_JAL_instr    ),
    .out_JALR_instr   ( EXE_JALR_instr   ),
    .out_LUI_instr    ( EXE_LUI_instr    ),
    .out_AUIPC_instr  ( EXE_AUIPC_instr  ),
    .out_B_type       ( EXE_B_type       )
);
wire EXE_ALU_ZERO;
EXU u_EXU(
    .Rd_data1 ( EXE_Rd_data1 ),
    .Rd_data2 ( EXE_Rd_data2 ),
    .imme     ( EXE_imme     ),
    .func3    ( EXE_func3    ),
    .func7    ( EXE_func7    ),
    .I_type   ( EXE_I_type   ),
    .L_type   ( EXE_L_type   ),
    .S_type   ( EXE_S_type   ),
    .R_type   ( EXE_R_type   ),
    .JALR_instr(EXE_JALR_instr),
    .B_type   ( EXE_B_type   ),
    .ALU_ZERO ( EXE_ALU_ZERO ),
    .ALU_res  ( EXE_ALU_res  ),
    .pipe_ready_go  ( EXE_pipe_ready_go  )
);
/////////////////////////////////////////////////////////////////////////////////////////
Branch u_Branch(
    .clk           ( clk           ),
    .rst_n         ( rst_n         ),
    .EXE_ALU_res   ( EXE_ALU_res   ),
    .EXE_func3     ( EXE_func3     ),
    .EXE_B_type    ( EXE_B_type    ),
    .EXE_ALU_ZERO  ( EXE_ALU_ZERO  ),
    .clear         ( B_type_jump_flag )
);
assign clear = B_type_jump_flag ;
assign IF_ID_validin = taken_pipe_valid  ;

/////////////////////////////////////////////////////////////////////////////////////////
wire MEM_pipe_ready_go ;   
wire WB_MEM_out_allow ;
wire MEM_WB_valid ; 
wire [2:0] MEM_func3      ;
wire MEM_ALU_ZERO   ;
wire [`datawidth-1:0]MEM_Rd_data2   ;

EX_MEM_regs u_EX_MEM_regs(
    .clk              ( clk              ),
    .rst_n            ( rst_n            ),
    .validin          ( EXE_MEM_valid          ),
    .pipe_ready_go    ( MEM_pipe_ready_go    ),
    .out_allow        ( WB_MEM_out_allow        ),
    .in_PC_add_4      ( EXE_PC_add_4      ),
    .in_PC_add_imme   ( EXE_PC_add_imme   ),
    .in_Rd            ( EXE_Rd            ),
    .in_ALU_ZERO      ( EXE_ALU_ZERO      ),
    .in_ALU_res       ( EXE_ALU_res       ),
    .in_imme          ( EXE_imme          ),
    .in_func3         ( EXE_func3         ),
    .in_Rd_data2      ( EXE_Rd_data2      ),
    .in_I_type        ( EXE_I_type        ),
    .in_L_type        ( EXE_L_type        ),
    .in_S_type        ( EXE_S_type        ),
    .in_R_type        ( EXE_R_type        ),
    .in_JAL_instr     ( EXE_JAL_instr     ),
    .in_JALR_instr    ( EXE_JALR_instr    ),
    .in_LUI_instr     ( EXE_LUI_instr     ),
    .in_AUIPC_instr   ( EXE_AUIPC_instr   ),
    .in_B_type        ( EXE_B_type        ),
    .in_allow         ( MEM_EX_out_allow         ),
    .validout         ( MEM_WB_valid         ),
    .out_ALU_res      ( MEM_ALU_res      ),
    .out_ALU_ZERO     ( MEM_ALU_ZERO     ),
    .out_PC_add_4     ( MEM_PC_add_4     ),
    .out_PC_add_imme  ( MEM_PC_add_imme  ),
    .out_imme         ( MEM_imme         ),
    .out_Rd           ( MEM_Rd           ),
    .out_Rd_data2     ( MEM_Rd_data2     ),
    .out_func3        ( MEM_func3        ),
    .out_I_type       ( MEM_I_type       ),
    .out_L_type       ( MEM_L_type       ),
    .out_S_type       ( MEM_S_type       ),
    .out_R_type       ( MEM_R_type       ),
    .out_JAL_instr    ( MEM_JAL_instr    ),
    .out_JALR_instr   ( MEM_JALR_instr   ),
    .out_LUI_instr    ( MEM_LUI_instr    ),
    .out_AUIPC_instr  ( MEM_AUIPC_instr  ),
    .out_B_type       ( MEM_B_type       )
);

wire                        MEM_data_RAM_W_en        ;

MEM u_MEM(
    .L_type         ( MEM_L_type         ),
    .S_type         ( MEM_S_type         ),
    .addr           ( MEM_ALU_res           ),
    .data_RAM_W_en  ( MEM_data_RAM_W_en  ),
    .ram_adder      ( dataRAM_Read_adder      ),
    .data_RAM_R_en  ( data_RAM_R_en  ),
    .pipe_ready_go  ( MEM_pipe_ready_go  )
);


///////////////////////////////////////////////////////////////////////////////////////////////////
wire WBU_pipe_ready_go ;   
wire out_allow;
wire [`datawidth-1:0]    WBU_ALU_res          ; 
wire [`datawidth-1:0]    WBU_imme             ;
wire [`datawidth-1:0]    WBU_PC_add_4         ;
wire [`datawidth-1:0]    WBU_PC_add_imme      ;
wire [`datawidth-1:0]    WBU_Rd_data2         ;
wire                     WBU_data_RAM_W_en    ;
wire [2:0]               WBU_func3            ;

assign out_allow = 1'b1;

MEM_WB_regs u_MEM_WB_regs(
    .clk                ( clk                ),
    .rst_n              ( rst_n              ),
    .validin            ( MEM_WB_valid            ),
    .pipe_ready_go      ( WBU_pipe_ready_go      ),
    .out_allow          ( out_allow          ),
    .in_Rd              ( MEM_Rd              ),
    .in_Rd_data2        ( MEM_Rd_data2        ),
    .in_data_RAM_W_en   ( MEM_data_RAM_W_en   ),
    .in_imme            ( MEM_imme            ),
    .in_ALU_res         ( MEM_ALU_res         ),
    .in_PC_add_4        ( MEM_PC_add_4        ),
    .in_PC_add_imme     ( MEM_PC_add_imme     ),
    .in_func3           ( MEM_func3           ),
    .in_I_type          ( MEM_I_type          ),
    .in_L_type          ( MEM_L_type          ),
    .in_S_type          ( MEM_S_type          ),
    .in_R_type          ( MEM_R_type          ),
    .in_JAL_instr       ( MEM_JAL_instr       ),
    .in_JALR_instr      ( MEM_JALR_instr      ),
    .in_LUI_instr       ( MEM_LUI_instr       ),
    .in_AUIPC_instr     ( MEM_AUIPC_instr     ),
    .in_B_type          ( MEM_B_type          ),
    .in_allow           ( WB_MEM_out_allow           ),
    //.validout           ( validout           ),
    .out_Rd             ( WBU_Rd             ),
    .out_I_type         ( WBU_I_type         ),
    .out_L_type         ( WBU_L_type         ),
    .out_S_type         ( WBU_S_type         ),
    .out_R_type         ( WBU_R_type         ),
    .out_JAL_instr      ( WBU_JAL_instr      ),
    .out_JALR_instr     ( WBU_JALR_instr     ),
    .out_LUI_instr      ( WBU_LUI_instr      ),
    .out_AUIPC_instr    ( WBU_AUIPC_instr    ),
    .out_B_type         ( WBU_B_type         ),
    .out_ALU_res        ( WBU_ALU_res        ),
    .out_imme           ( WBU_imme           ),
    .out_PC_add_4       ( WBU_PC_add_4       ),
    .out_PC_add_imme    ( WBU_PC_add_imme    ),
    .out_Rd_data2       ( WBU_Rd_data2       ),
    .out_data_RAM_W_en  ( WBU_data_RAM_W_en  ),
    .out_func3          ( WBU_func3          )
);

WBU u_WBU(
    .I_type             ( WBU_I_type             ),
    .L_type             ( WBU_L_type             ),
    .S_type             ( WBU_S_type             ),
    .R_type             ( WBU_R_type             ),
    .JAL_instr          ( WBU_JAL_instr          ),
    .JALR_instr         ( WBU_JALR_instr         ),
    .LUI_instr          ( WBU_LUI_instr          ),
    .AUIPC_instr        ( WBU_AUIPC_instr        ),
    .B_type             ( WBU_B_type             ),
    .dataRAM_Read_data  ( dataRAM_data  ),
    .func3              ( WBU_func3              ),
    .Rd_data2           ( WBU_Rd_data2           ),
    .ALU_res            ( WBU_ALU_res            ),
    .imme               ( WBU_imme               ),
    .PC_add_4           ( WBU_PC_add_4           ),
    .PC_add_imme        ( WBU_PC_add_imme        ),
    .regs_WB_data       ( Wr_data       ),
    .registers_W_en     ( W_en     ),
    .dataRAM_Wr_data    ( dataRAM_Wr_data    ),
    .pipe_ready_go      ( WBU_pipe_ready_go      )
);


assign registers_Rd = WBU_Rd ;
assign data_RAM_W_en = WBU_data_RAM_W_en;
assign dataRAM_Wr_adder = WBU_ALU_res [9:2];
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule //datapath

