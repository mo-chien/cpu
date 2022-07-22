`timescale 1ns / 1ps
`include "signle_clk_cpu/defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/24 16:57:32
// Design Name: 
// Module Name: data_memory
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


module dataRAM_control(
    input  [2:0]data_type,
    input  [1:0]bytes,
    input  [`datawidth-1:0] data_in,//通用寄存器rd2读出的数据
    input  [`datawidth-1:0] dataRAM_Read_data,//数据寄存器读会的数据
    output [`datawidth-1:0] dataRAM_Wr_data,
    output [`datawidth-1:0] Read_data
    );
    reg [`datawidth-1:0] dataRAM_Wr_data_B;//字节拼接
    wire [`datawidth-1:0] dataRAM_Wr_data_H;//半字拼接

    always@(*)
        begin
            case(bytes)
                2'b00:dataRAM_Wr_data_B={dataRAM_Read_data[31:8],data_in[7:0]};
                2'b01:dataRAM_Wr_data_B={dataRAM_Read_data[31:16],data_in[7:0],dataRAM_Read_data[7:0]};
                2'b10:dataRAM_Wr_data_B={dataRAM_Read_data[31:24],data_in[7:0],dataRAM_Read_data[15:0]};
                2'b11:dataRAM_Wr_data_B={data_in[7:0],dataRAM_Read_data[23:0]};
            endcase
        end
    assign dataRAM_Wr_data_H = (bytes[1]) ? {data_in[15:0],dataRAM_Read_data[15:0]} : {dataRAM_Read_data[31:16],data_in[15:0]} ;
    assign dataRAM_Wr_data=(data_type[2:1]!=2'b00) ? data_in : data_type[0] ? dataRAM_Wr_data_H : dataRAM_Wr_data_B  ;    

    reg [7:0]Rd_data_B;
    wire [15:0]Rd_data_H;
    always@(*)
    begin
        case(bytes[1:0])
            2'b00:Rd_data_B=dataRAM_Read_data[7:0];
            2'b01:Rd_data_B=dataRAM_Read_data[15:8];
            2'b10:Rd_data_B=dataRAM_Read_data[23:16];
            2'b11:Rd_data_B=dataRAM_Read_data[31:24];
        endcase
    end
    assign Rd_data_H = bytes [0] ? dataRAM_Read_data[31:16] : dataRAM_Read_data[15:0];

    wire [31:0] Rd_data_B_ext;
    wire [31:0] Rd_data_H_ext;
    assign Rd_data_B_ext = data_type [2] ? {24'd0,Rd_data_B} : {{24{Rd_data_B[7]}},Rd_data_B};
    assign Rd_data_H_ext=  data_type [2] ? {16'd0,Rd_data_H} : {{16{Rd_data_H[15]}},Rd_data_H};
    assign Read_data = data_type [1] ? dataRAM_Read_data : data_type[0]? Rd_data_H_ext : Rd_data_B_ext;
endmodule
