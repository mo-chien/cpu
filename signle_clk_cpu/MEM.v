`include "signle_clk_cpu/defines.v"
`include "signle_clk_cpu/dataRAM_control.v"
module MEM (
    input                         L_type               ,
    input                         S_type               ,
    input   [2:0]                 data_type            ,
    input   [`datawidth-1:0]      data_in              ,
    input   [`datawidth-1:0]      dataRAM_Read_data    ,
    input   [`datawidth-1:0]      addr                 ,
    output  [`datawidth-1:0]      dataRAM_Wr_data              ,
    output  [`datawidth-1:0]      Read_data            ,
    output                        data_RAM_W_en        ,
    output  [`addrwidth-1:0]      ram_adder            
           
     

);
assign data_RAM_W_en = S_type;
assign ram_adder = addr [9:2] ;
dataRAM_control u_dataRAM_control(
    .data_type         ( data_type         ),
    .bytes             ( addr[1:0]         ),
    .data_in           ( data_in           ),
    .dataRAM_Read_data ( dataRAM_Read_data ),
    .dataRAM_Wr_data   ( dataRAM_Wr_data           ),
    .Read_data         ( Read_data         )
);

endmodule //MEM