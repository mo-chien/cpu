`timescale  1ns / 1ps
`include "IFU.v"
module tb_IFU;       

// IFU Parameters
parameter PERIOD  = 10;


// IFU Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   jump_flag                            = 0 ;
reg   pc_en                                = 0 ;
reg   [`datawidth-1:0]  PC_next            = 0 ;

// IFU Outputs
wire  [`addrwidth-1:0]  instr_addr         ;
wire  [`datawidth-1:0]  PC_add_4           ;
wire  [`datawidth-1:0]  PC_now             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

IFU  u_IFU (
    .clk                     ( clk                          ),
    .rst_n                   ( rst_n                        ),
    .jump_flag               ( jump_flag                    ),
    .pc_en                   ( pc_en                        ),
    .PC_next                 ( PC_next     [`datawidth-1:0] ),

    .instr_addr              ( instr_addr  [`addrwidth-1:0] ),
    .PC_add_4                ( PC_add_4    [`datawidth-1:0] ),
    .PC_now                  ( PC_now      [`datawidth-1:0] )
);

initial
begin
    $dumpfile("IFU.vcd");
    $dumpvars    ; 
    jump_flag = 1;   
    $finish;
end

endmodule