`include "defines.v"
module pipeline_unit (
    input clk,
    input rst_n,
    input validin,
    input pipe_ready_go,//该级流水线数据处理完成标志
    input [`datawidth-1:0] datain,
    input  out_allow,
    output in_allow,
    output validout,
    output reg [`datawidth-1:0] dataout
);
reg pipe_valid;
always @(posedge clk ) begin

    if(!rst_n)
        pipe_valid <= 1'b0;
    else if (in_allow)
        pipe_valid <= validin;
    if (validin && in_allow)
        dataout <= datain;
end
assign in_allow = !pipe_valid || pipe_ready_go && out_allow ;//当前级允许数据输入的情况：1：上条指令为接受数据；2：本级数据处理完成且下级发起读数据请求
assign validout = pipe_valid && pipe_ready_go;//上级有数据要输入且本级数据处理完成，向下一级发起数据传输请求。

endmodule //pipeline_unit