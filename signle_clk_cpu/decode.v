`timescale 1ns / 1ps
`include "signle_clk_cpu/defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 10:31:10
// Design Name: 
// Module Name: decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decode(
    input [31:0]instr,
	//output [4:0]opcode,
	output [2:0]func3,
	output func7,
	output [4:0]Rs1,
	output [4:0]Rs2,
	output [4:0]Rd,
	output [31:0]imme,
    output I_type ,
	output L_type,
	output S_type,
	output R_type,
	output JAL_instr,
	output JALR_instr,
	output LUI_instr,
	output AUIPC_instr,
	output B_type
    );

	
	wire [31:0]I_imme;
	wire [31:0]U_imme;
	wire [31:0]J_imme;
	wire [31:0]B_imme;
	wire [31:0]S_imme;
	//一条指令包含：操作码opcode，功能码func3、func7，寄存器读地址 Rs1、Rs2，寄存器写地址 Rd，立即数imme
	//操作码opcode，功能码func3、func7，寄存器读地址 Rs1、Rs2，寄存器写地址 Rd，在指令里的位置是固定的
    //assign opcode=instr[6:2];
	assign func3=instr[14:12];
	assign func7=instr[30];
	assign Rd =instr[11:7];
	

	assign I_type     = instr[6:0]==`I_TYPE                               ;
	assign L_type     = instr[6:0]==`L_TYPE                               ;
	assign S_type     = instr[6:0]==`S_TYPE   							  ;
	assign R_type     = instr[6:0]==`R_TYPE   							  ;
	assign JAL_instr  = instr[6:0]==`INST_JAL 							  ;
	assign JALR_instr = instr[6:0]==`INST_JALR 							  ;
	assign LUI_instr  = instr[6:0]==`INST_LUI                             ;
	assign AUIPC_instr= instr[6:0]==`INST_AUIPC                           ;
	assign B_type     = instr[6:0]==`B_TYPE   							  ;

	assign Rs1=(I_type|L_type|S_type|R_type|JALR_instr|B_type)? instr[19:15] : 0;
	assign Rs2=(S_type|R_type|B_type)?instr[24:20]:0;
	
	//根据立即数在指令中的不同位置，对立即数进行分类	
	assign I_imme={{20{instr[31]}},instr[31:20]}; 
	assign U_imme={instr[31:12],{12{1'b0}}};
	assign J_imme={{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};   
	assign B_imme={{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
	assign S_imme={{20{instr[31]}},instr[31:25],instr[11:7]}; 

	assign imme= (I_type|L_type|JALR_instr)?I_imme :
				 (LUI_instr|AUIPC_instr)?U_imme :
				 JAL_instr?J_imme :
				 B_type?B_imme :
				 S_type?S_imme : 32'd0;
	

endmodule
