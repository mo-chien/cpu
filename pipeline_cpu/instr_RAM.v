`include "defines.v"
module instr_RAM (
    input clk,rst_n,
    input [`addrwidth-1:0] addr,
    input hold_on,
	output [`datawidth-1:0] instr
);
localparam  MEMDEPTH = 1<<`addrwidth;
reg [`datawidth-1:0] RAM [0:MEMDEPTH-1];
initial begin
    $readmemb("file/RV32I.txt", RAM);
end
reg [`addrwidth-1:0] read_addr;
always @(posedge clk) begin
    if (!rst_n)
        read_addr<=`ZeroWord;
    else if (hold_on)
        read_addr<=addr;
    else 
        read_addr<=read_addr;
end
assign instr = RAM [read_addr] ;
endmodule //instr_RAM