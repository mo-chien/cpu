`timescale  1ns / 1ps
`include "counter.v"
module tb_counter;   

// counter Parameters
parameter PERIOD   = 10;
parameter cnt_max  = 32;

// counter Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   cnt_add                              = 0 ;

// counter Outputs
wire  cnt_end                              ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

counter #(
    .cnt_max ( cnt_max ))
 u_counter (
    .clk                     ( clk       ),
    .rst_n                   ( rst_n     ),
    .cnt_add                 ( cnt_add   ),

    .cnt_end                 ( cnt_end   )
);

initial
begin
    $dumpfile("counter.vcd");
    $dumpvars    ;
    #20
    cnt_add = 1;
    #320
    $finish;
end

endmodule