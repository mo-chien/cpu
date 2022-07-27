`include "defines.v"
module MEM (
    //input I_type                               ,
    input L_type                               ,
    input S_type                               ,
    //input R_type                               ,
    //input JAL_instr                            ,
    //input JALR_instr                           ,
    //input LUI_instr                            ,
    //input AUIPC_instr                          ,
    //input B_type                               ,
    input   [`datawidth-1:0]      addr                 ,
    output                        data_RAM_W_en        ,
    output  [`addrwidth-1:0]      ram_adder            ,
    output                        data_RAM_R_en        ,
    output                     pipe_ready_go
     

);
    assign data_RAM_W_en = S_type;
    //由于有字拼接操作，在向数据RAM写数数据时，需要向数据RAM发起读请求，通过数据RAM返回的读数据，确定最终的写数据
    assign data_RAM_R_en = S_type | L_type;
    assign ram_adder = addr [9:2] ;
    assign pipe_ready_go=1'b1; 
endmodule //MEM