`include "signle_clk_cpu/datapath.v"
`include "signle_clk_cpu/instr_RAM.v"
`include "signle_clk_cpu/dataRAM.v"
module RISC_V (
    input clk,
    input rst_n
);
wire [`datawidth-1:0] instr;

wire  [`addrwidth-1:0] instr_addr                    ;
wire  [`datawidth-1:0] dataRAM_data                  ;    
wire  [`datawidth-1:0]      dataRAM_Wr_data          ;
wire  [`addrwidth-1:0]      dataRAM_adder         ;
wire                        data_RAM_W_en            ;   
datapath u_datapath(
    .clk              ( clk              ),
    .rst_n            ( rst_n            ),
    .instr            ( instr            ),
    .dataRAM_data     ( dataRAM_data     ),
    .instr_addr       ( instr_addr       ),
    .dataRAM_Wr_data  ( dataRAM_Wr_data  ),
    .dataRAM_adder    ( dataRAM_adder    ),
    .data_RAM_W_en    ( data_RAM_W_en    )
);



instr_RAM u_instr_RAM(
    .addr ( instr_addr ),
    .instr  ( instr  )
);

dataRAM u_dataRAM(
    .clk  ( clk  ),
    .W_en ( data_RAM_W_en ),
    .addr ( dataRAM_adder ),
    .din  ( dataRAM_Wr_data  ),
    .dout  ( dataRAM_data  )
);


endmodule //RISC_V