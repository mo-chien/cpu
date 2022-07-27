`include "datapath.v"
`include "instr_RAM.v"
`include "dataRAM.v"
module RISC_V (
    input clk,
    input rst_n
);
wire [`datawidth-1:0] instr;

wire  [`addrwidth-1:0] instr_addr                    ;
wire  [`datawidth-1:0] dataRAM_data                  ;
wire  [`addrwidth-1:0]      dataRAM_Read_adder       ;
wire                        data_RAM_R_en            ;    
wire  [`datawidth-1:0]      dataRAM_Wr_data          ;
wire  [`addrwidth-1:0]      dataRAM_Wr_adder         ;
wire                        data_RAM_W_en            ;   
wire                        instrRam_hold_on         ;
datapath u_datapath(
    .clk                 ( clk                 ),
    .rst_n               ( rst_n               ),
    .instr               ( instr               ),
    .dataRAM_data        ( dataRAM_data        ),
    .instr_addr          ( instr_addr          ),
    .dataRAM_Read_adder  ( dataRAM_Read_adder  ),
    .data_RAM_R_en       ( data_RAM_R_en       ),
    .dataRAM_Wr_data     ( dataRAM_Wr_data     ),
    .dataRAM_Wr_adder    ( dataRAM_Wr_adder    ),
    .data_RAM_W_en       ( data_RAM_W_en       ),
    .instrRam_hold_on    (instrRam_hold_on     )
);


instr_RAM u_instr_RAM(
    .clk   ( clk   ),
    .rst_n ( rst_n ),
    .addr  ( instr_addr  ),
    .hold_on (instrRam_hold_on),
    .instr  ( instr  )
);
dataRAM u_dataRAM(
    .clk       ( clk       ),
    .W_en      ( data_RAM_W_en      ),
    .R_en      ( data_RAM_R_en      ),
    .Wr_addr   ( dataRAM_Wr_adder   ),
    .Read_addr ( dataRAM_Read_adder ),
    .din       ( dataRAM_Wr_data       ),
    .dout      ( dataRAM_data      )
);

endmodule //RISC_V