`timescale 1ns / 1ps
`include "defines.v"
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
	output [6:0]opcode,
	output [2:0]func3,
	output func7_30,
	output func7_25,
	output [4:0]Rs1_Zimme,
	output [4:0]Rs2,
	output [4:0]Rd,
	output [31:0]imme_csr

    );
    wire I_J_CSR_TYPE_JAR;
	wire U_TYPE_AUIPC;
	wire J_TYPE;
	wire B_TYPE;
	wire S_TYPE;
	
	wire [31:0]I_imme;
	wire [31:0]U_imme;
	wire [31:0]J_imme;
	wire [31:0]B_imme;
	wire [31:0]S_imme;

    assign opcode=instr[6:0];
	assign func3=instr[14:12];
	assign func7_30=instr[30];
	assign func7_25=instr[25];
	assign Rs1_Zimme=instr[19:15];
	assign Rs2=instr[24:20];
	assign Rd =instr[11:7];
	
	assign I_J_CSR_TYPE_JAR=(instr[6:2]==`INST_JALR) | (instr[6:2]==`L_TYPE) | (instr[6:2]==`I_TYPE)|(instr[6:2]==`CSR_TYPE);
	assign U_TYPE_AUIPC=(instr[6:2]==`INST_LUI) |  (instr[6:2]==`INST_AUIPC);
	assign J_TYPE=(instr[6:2]==`INST_JAL);
	assign B_TYPE=(instr[6:2]==`B_TYPE);
	assign S_TYPE=(instr[6:2]==`S_TYPE);
	
	
	assign I_imme={{20{instr[31]}},instr[31:20]}; 
	assign U_imme={instr[31:12],{12{1'b0}}};
	assign J_imme={{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};   
	assign B_imme={{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
	assign S_imme={{20{instr[31]}},instr[31:25],instr[11:7]}; 

	assign imme_csr= I_J_CSR_TYPE_JAR?I_imme :
				 U_TYPE_AUIPC?U_imme :
				 J_TYPE?J_imme :
				 B_TYPE?B_imme :
				 S_TYPE?S_imme : 32'd0;
endmodule
