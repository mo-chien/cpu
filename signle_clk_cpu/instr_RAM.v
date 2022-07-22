`include "signle_clk_cpu/defines.v"
module instr_RAM (   
    input [`addrwidth-1:0] addr,
	output [`datawidth-1:0] instr
);
localparam  MEMDEPTH = 1<<`addrwidth;
reg [`datawidth-1:0] ROM [0:MEMDEPTH-1];
//rom进行初始化
    initial begin
        $readmemb("./file/RV32I.txt", ROM);
    end
assign instr = ROM [addr] ;
endmodule //instr_RAM