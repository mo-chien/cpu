module stallable_pipeline #(parameter WIDTH = 32)(
    input clk,
    input rst_n,
    input validin,
    input [WIDTH-1:0] datain,
    input out_allow,
    input pipe1_ready_go,
    output validout,
    output [WIDTH-1:0] dataout
);
reg pipe1_valid;
reg pipe2_valid;
reg pipe3_valid;
reg [WIDTH-1:0] pipe1_data;
reg [WIDTH-1:0] pipe2_data;
reg [WIDTH-1:0] pipe3_data;

wire pipe1_allowin;
wire pipe1_ready_go;
wire pipe1_to_pipe2_vaild;

wire pipe2_allowin;
wire pipe2_ready_go;
wire pipe2_to_pipe3_vaild;

wire pipe3_allowin;
wire pipe3_ready_go;

//assign pipe1_ready_go=1;
assign pipe1_allowin = !pipe1_valid || (pipe1_ready_go && pipe2_allowin);//当前级允许数据输入的情况：1：上级数据未准备好；2：本级数据处理完成且下级发起读数据请求
assign pipe1_to_pipe2_vaild = pipe1_valid && pipe1_ready_go;//上级有数据要输入且本级数据处理完成，向下一级发起数据传输请求。

always @(posedge clk ) begin

    if(!rst_n)
        pipe1_valid <= 1'b0;
    else if (pipe1_allowin)
        pipe1_valid <= validin;
    if (validin && pipe1_allowin)//validin由0变1时，pipe1完成对上级数据的接收，并且在数据处理完成后向下一级发起发送数据请求。
        pipe1_data <= datain;
end

assign pipe2_ready_go=1;
assign pipe2_allowin = !pipe2_valid || pipe2_ready_go && pipe3_allowin;
assign pipe2_to_pipe3_vaild = pipe2_valid && pipe2_ready_go;

always @(posedge clk ) begin

    if(!rst_n)
        pipe2_valid <= 1'b0;
    else if (pipe2_allowin)
        pipe2_valid <= pipe1_to_pipe2_vaild;
    if (pipe1_to_pipe2_vaild && pipe2_allowin)
        pipe2_data <= pipe1_data;
end

assign pipe3_ready_go=1;
assign pipe3_allowin = !pipe3_valid || pipe3_ready_go && out_allow;
assign validout = pipe3_valid && pipe3_ready_go;
 
always @(posedge clk ) begin

    if(!rst_n)
        pipe3_valid <= 1'b0;
    else if (pipe3_allowin)
        pipe3_valid <= pipe2_to_pipe3_vaild;
    if (pipe2_to_pipe3_vaild && pipe3_allowin)
        pipe3_data <= pipe2_data;
end

assign dataout = pipe3_data ;
endmodule //stallable_pipeline