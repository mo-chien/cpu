`include "defines.v"
module IF_ID_regs (
    input clk,
    input rst_n,
    input clear,
    input validin,
    input pipe_ready_go,
    input  out_allow,
    input [`datawidth-1:0] in_PC_add_4   ,    
    input [`datawidth-1:0] in_PC_now     ,
    input [`datawidth-1:0] in_instr      ,
    output in_allow,
    output validout,
    //PC_next和通用寄存器的写回数据  
    output reg [`datawidth-1:0] out_PC_add_4   , 
    //作为PC+imme的输入
    output reg [`datawidth-1:0] out_PC_now     ,
    output reg [`datawidth-1:0] out_instr
    );
reg pipe_valid;
always @(posedge clk ) begin

    if(!rst_n )
    begin
        pipe_valid <= 1'b0;
        out_PC_add_4   <=   0     ;
        out_PC_now     <=   0     ; 
        out_instr      <=   0     ;       
    end 
    else if (clear)
    begin
        out_PC_add_4   <=   0     ;
        out_PC_now     <=   0     ; 
        out_instr      <=   0     ;   
    end 
    else if (validin && in_allow)
    begin
        out_PC_add_4   <=   in_PC_add_4     ;
        out_PC_now     <=   in_PC_now       ; 
        out_instr      <=   in_instr        ; 
    end
    if  (in_allow)
        pipe_valid <= validin;
end
assign in_allow = !pipe_valid || pipe_ready_go && out_allow ;//当前级允许数据输入的情况：1：上条指令为接受数据；2：本级数据处理完成且下级发起读数据请求
assign validout = pipe_valid && pipe_ready_go;//上级有数据要输入且本级数据处理完成，向下一级发起数据传输请求。

endmodule //IF_ID_regs 
    
