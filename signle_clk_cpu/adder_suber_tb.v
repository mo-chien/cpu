`timescale  1ns / 1ps  
`include "signle_clk_cpu/add_suber.v"
module tb_add_suber;   

// add_suber Parameters
parameter PERIOD  = 10;


// add_suber Inputs
reg   [`datawidth-1:0]  data_A             = 0 ;
reg   [`datawidth-1:0]  data_B             = 0 ;
reg   sub_flag                             = 0 ;

// add_suber Outputs
wire  [`datawidth-1:0]  result             ;
wire  co                                   ;
wire  zero                                 ;
wire  result_sign                          ;
wire  overflow                             ;


add_suber  u_add_suber (
    .data_A                  ( data_A       [`datawidth-1:0] ),
    .data_B                  ( data_B       [`datawidth-1:0] ),
    .sub_flag                ( sub_flag                      ),

    .result                  ( result       [`datawidth-1:0] ),
    .co                      ( co                            ),
    .zero                    ( zero                          ),
    .result_sign             ( result_sign                   ),
    .overflow                ( overflow                      )
);

initial
begin
    $dumpfile("adder_suber_wave.vcd");
    $dumpvars; 
    data_A=32'b0000_0000_1110_1110_1110_0000_0000_0001;
    data_B=32'b0000_0000_0001_0001_0001_1111_0001_0000;
    #10
    sub_flag=1;
    #10
    $finish;
end

endmodule