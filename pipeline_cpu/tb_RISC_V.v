`timescale  1ns / 1ps
`include "RISC_V.v"
module tb_RISC_V;    

// RISC_V Parameters
parameter PERIOD  = 10;

// RISC_V Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

// RISC_V Outputs



initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

RISC_V  u_RISC_V (
    .clk                     ( clk     ),
    .rst_n                   ( rst_n   )
);

initial
begin
    $dumpfile("RISC_V.vcd");
    $dumpvars    ;
  #600
    $finish;
end

endmodule