`include "defines.v"
`include "counter_2bits.v"
module WBR (
    input clk ,
    input rst_n,
    //IDU output
    input [4:0] Rs1                                ,
    input [4:0] Rs2                                ,
    input [`datawidth-1:0] regs_rs1_data           ,
    input [`datawidth-1:0] regs_rs2_data           ,
    //regs WB_data
    //input [4:0] registers_Rd                       ,
    input [`datawidth-1:0] Wr_data                 ,
    // regs read instr type
    input IDU_I_type                               ,//rs1
    input IDU_L_type                               ,//rs1
    input IDU_S_type                               ,//rs1,rs2
    input IDU_R_type                               ,//rs1,rs2
    input IDU_JALR_instr                           ,//rs1
    input IDU_B_type                               ,//rs1,rs2
    //instr type pipe and rd
    //EXE
    input [4:0] EXE_Rd                             ,
    input EXE_I_type                               ,
    input EXE_L_type                               ,
    input EXE_R_type                               ,
    input EXE_JAL_instr                            ,
    input EXE_JALR_instr                           ,
    input EXE_LUI_instr                            ,
    input EXE_AUIPC_instr                          ,


    //MEM
    input [4:0] MEM_Rd                             ,
    input MEM_I_type                               ,
    input MEM_L_type                               ,
    input MEM_R_type                               ,
    input MEM_JAL_instr                            ,
    input MEM_JALR_instr                           ,
    input MEM_LUI_instr                            ,
    input MEM_AUIPC_instr                          ,

    //WB
    input [4:0] WBU_Rd                             ,
    input WBU_I_type                               ,
    input WBU_L_type                               ,
    input WBU_R_type                               ,
    input WBU_JAL_instr                            ,
    input WBU_JALR_instr                           ,
    input WBU_LUI_instr                            ,
    input WBU_AUIPC_instr                          ,

    //data feedforward
    input [`datawidth-1:0] EXE_ALU_res             ,
    input [`datawidth-1:0] MEM_ALU_res             ,
    input [`datawidth-1:0] EXE_imme                ,
    input [`datawidth-1:0] MEM_imme                ,
    input [`datawidth-1:0] EXE_PC_add_imme         ,
    input [`datawidth-1:0] MEM_PC_add_imme         ,
    input [`datawidth-1:0] EXE_PC_add_4            ,
    input [`datawidth-1:0] MEM_PC_add_4            ,
    output [`datawidth-1:0] Rd_data1               ,
    output [`datawidth-1:0] Rd_data2               ,
    output pipe_ready_go                           
);
//数据处于写回阶段，写回的数据已经由WBU处的数据选择器完成
wire [`datawidth-1:0] EXE_WBdata, MEM_WBdata;
assign EXE_WBdata = (EXE_I_type|EXE_R_type) ? EXE_ALU_res : (EXE_JAL_instr|EXE_JALR_instr)? 
                     EXE_PC_add_4 : EXE_LUI_instr ? EXE_imme : EXE_AUIPC_instr ? EXE_PC_add_imme : EXE_L_type ? Wr_data : 32'd0;
assign MEM_WBdata = (MEM_I_type|MEM_R_type) ? MEM_ALU_res : (MEM_JAL_instr|MEM_JALR_instr)? 
                     MEM_PC_add_4 : MEM_LUI_instr ? MEM_imme : MEM_AUIPC_instr ? MEM_PC_add_imme : MEM_L_type ? Wr_data : 32'd0;
//判断写后读在流水线的一级发生
wire EXE_WBR_flag_rs1, MEM_WBR_flag_rs1,WB_WBR_flag_rs1;
wire EXE_WBR_flag_rs2, MEM_WBR_flag_rs2,WB_WBR_flag_rs2;
//判断为需要访问寄存器数据的指令类型，判断访问地址是否为0，判断访问地址上是否有数据未写回，
//rs1
assign EXE_WBR_flag_rs1=(IDU_I_type|IDU_L_type|IDU_S_type|IDU_R_type|IDU_JALR_instr|IDU_B_type)&(Rs1!=0)&(Rs1 == EXE_Rd)&(EXE_LUI_instr|EXE_AUIPC_instr|EXE_I_type|EXE_R_type|EXE_JAL_instr|EXE_JALR_instr|EXE_L_type);
assign MEM_WBR_flag_rs1=(IDU_I_type|IDU_L_type|IDU_S_type|IDU_R_type|IDU_JALR_instr|IDU_B_type)&(Rs1!=0)&(Rs1 == MEM_Rd)&(MEM_LUI_instr|MEM_AUIPC_instr|MEM_I_type|MEM_R_type|MEM_JAL_instr|MEM_JALR_instr|MEM_L_type);
assign WBU_WBR_flag_rs1=(IDU_I_type|IDU_L_type|IDU_S_type|IDU_R_type|IDU_JALR_instr|IDU_B_type)&(Rs1!=0)&(Rs1 == WBU_Rd)&(WBU_LUI_instr|WBU_AUIPC_instr|WBU_I_type|WBU_R_type|WBU_JAL_instr|WBU_JALR_instr|WBU_L_type);
//rs2
assign EXE_WBR_flag_rs2=(IDU_S_type|IDU_R_type|IDU_B_type)&(Rs2!=0)&(Rs2 == EXE_Rd)&(EXE_LUI_instr|EXE_AUIPC_instr|EXE_I_type|EXE_R_type|EXE_JAL_instr|EXE_JALR_instr|EXE_L_type);
assign MEM_WBR_flag_rs2=(IDU_S_type|IDU_R_type|IDU_B_type)&(Rs2!=0)&(Rs2 == MEM_Rd)&(MEM_LUI_instr|MEM_AUIPC_instr|MEM_I_type|MEM_R_type|MEM_JAL_instr|MEM_JALR_instr|MEM_L_type);
assign WBU_WBR_flag_rs2=(IDU_S_type|IDU_R_type|IDU_B_type)&(Rs2!=0)&(Rs2 == WBU_Rd)&(WBU_LUI_instr|WBU_AUIPC_instr|WBU_I_type|WBU_R_type|WBU_JAL_instr|WBU_JALR_instr|WBU_L_type);
//写后读优先级，越晚写入的指令优先级越高，也就是流水线越靠前的数据优先级越高
assign Rd_data1 = EXE_WBR_flag_rs1 ? EXE_WBdata : MEM_WBR_flag_rs1 ? MEM_WBdata : WBU_WBR_flag_rs1 ? Wr_data : regs_rs1_data ;
assign Rd_data2 = EXE_WBR_flag_rs2 ? EXE_WBdata : MEM_WBR_flag_rs2 ? MEM_WBdata : WBU_WBR_flag_rs2 ? Wr_data : regs_rs2_data ;

//LOAD 指令 流水线阻塞
//LOAD 指令 的下一条指令读取LOAD的数据，此时LOAD 指令运行处于EXE阶段，需要等待2个时钟才能获得dataRAM的输出数据
//LOAD 指令 后的第条指令读取LOAD的数据，此时LOAD 指令运行处于MEM阶段，需要等待1个时钟才能获得dataRAM的输出数据
wire [1:0] cnt_max;
assign cnt_max = (EXE_WBR_flag_rs1 | EXE_WBR_flag_rs2)& EXE_L_type ? 2'b10 : (MEM_WBR_flag_rs1|MEM_WBR_flag_rs2)& MEM_L_type ? 2'b01 : 2'b11;

wire counter_en ;
assign counter_en = (EXE_WBR_flag_rs1 | EXE_WBR_flag_rs2) & EXE_L_type | (MEM_WBR_flag_rs1|MEM_WBR_flag_rs2) & MEM_L_type ;
wire countend_flag ;
counter_2bits u_counter_2bits(
    .clk        ( clk        ),
    .rst_n      ( rst_n      ),
    .cnt_max    ( cnt_max    ),
    .counter_en ( counter_en ),
    .countend_flag  ( countend_flag  )
);

assign pipe_ready_go  = ~ counter_en | countend_flag ;

endmodule //WBR