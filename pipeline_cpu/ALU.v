`timescale 1ns / 1ps
`include "shifter.v"
`include "add_suber.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:26:32
// Design Name: 
// Module Name: ALU
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


module ALU(
    ALU_DA,
    ALU_DB,
    ALUop,
    ALU_ZERO,
    ALU_OverFlow,
    ALU_res   
    );
    input [`datawidth-1:0]    ALU_DA;
    input [`datawidth-1:0]    ALU_DB;
    input [`ALU_CLT]     ALUop;//{funct7,funct3}
    output          ALU_ZERO;
    output          ALU_OverFlow;
    output reg [`datawidth-1:0]   ALU_res;
    //********************generate ctr***********************
    wire SUBctr;
    wire SIGctr;
    wire [1:0] Op;//将操作分类，00：加减；01：逻辑运算；10：比较；11：移位
    wire [1:0] Logicctr;
    wire [1:0] Shiftctr;

    assign SUBctr = ~ALUop[1]&ALUop[3]|ALUop[1];//比较和减法用到减操作，为1，加法操作必为0，其余为无关项
    //用2位的Op对ALU结果进行分类，根据真值表获得Op与ALUop的逻辑关系
    assign Op[1] = (~ALUop[1])&ALUop[0]|((~ALUop[3])&(~ALUop[2])&ALUop[1]);
    assign Op[0] = (~ALUop[1])&ALUop[0]|((~ALUop[3])&ALUop[2]);

    assign Logicctr = ALUop[1:0]; 
    assign Shiftctr = {ALUop[2],ALUop[7]}; 
    assign SIGctr = ALUop[0];


    //********************************************************
    //*********************logic op***************************
    reg [`datawidth-1:0] logic_result;

    always@(*) begin
        case(Logicctr)
        2'b00:logic_result = ALU_DA ^ ALU_DB;
        //2'b01:logic_result = ALU_DA | ALU_DB;
        2'b10:logic_result = ALU_DA | ALU_DB;
        2'b11:logic_result = ALU_DA & ALU_DB;
        default : logic_result=32'bx;       
        endcase
    end 

    //********************************************************
    //************************shift op************************
    wire [`SHIFT_NUM_width]     ALU_SHIFT;
    wire [`datawidth-1:0] shift_result;
    assign ALU_SHIFT=ALU_DB[ `SHIFT_NUM_width];
    shifter u_shifter(
        .Indata    ( ALU_DA    ),
        .SHIFT_NUM ( ALU_SHIFT ),
        .Shiftctr  ( Shiftctr  ),
        .shift_result ( shift_result )
    );


    //********************************************************
    //************************add sub op**********************
    wire ADD_carry,result_sign,overflow;
    wire [`datawidth-1:0] ADD_result;
    add_suber u_add_suber(
        .data_A      ( ALU_DA      ),
        .data_B      ( ALU_DB      ),
        .sub_flag    ( SUBctr    ),
        .result      ( ADD_result   ),
        .co          ( ADD_carry    ),
        .zero        ( ALU_ZERO     ),
        .result_sign ( result_sign ),
        .overflow    ( overflow    )
    );
    //********************************************************
    //**************************slt op************************
    //无符号数比较，即无符号数减法，加法器进位取反为1时表示发生溢出，即被减数小于减数发生借位
    //溢出发生在相同符号数相加的情况。即正数-负数和负数-正数两种情况。
    //正数-负数：正数>负数，结果为0。发生溢出，溢出标志为1，结果符号位为1；不发生溢出：溢出标志为0，结果符号位为0
    //负数-正数：负数<正数，结果为1。发生溢出，溢出标志为1，结果符号位为0；不发生溢出：溢出标志为0，结果符号位为1
    //其他情况：溢出标志为0，结果符号位为0时结果为0，结果符号位为1时结果为1。
    //有符号数比较结果=结果符号^溢出标志
    wire [`datawidth-1:0] SLT_result;
    assign SLT_result = SIGctr? {31'd0,~ADD_carry} : {31'd0,result_sign^overflow};
    assign ALU_OverFlow = overflow;

    //********************************************************
    //**************************ALU result********************
    always @(*) 
    begin
    case(Op)
        2'b00:ALU_res=ADD_result;
        2'b01:ALU_res=logic_result;
        2'b10:ALU_res=SLT_result;
        2'b11:ALU_res=shift_result; 
        default : ALU_res=32'b0; 
    endcase
    end

//********************************************************
endmodule


