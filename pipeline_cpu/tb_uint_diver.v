`timescale  1ns / 1ps
`include "uint_diver.v"
module tb_uint_diver;   

// uint_diver Parameters
parameter PERIOD  = 10;


// uint_diver Inputs
reg   diver_en                             = 0 ;
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [`datawidth-1:0]  dividend           = 0 ;
reg   [`datawidth-1:0]  divisor            = 0 ;

// uint_diver Outputs
wire  [`datawidth-1:0]  remainder          ;
wire  [`datawidth-1:0]  result             ;
wire  end_flag                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

uint_diver  u_uint_diver (
    .diver_en                ( diver_en                    ),
    .clk                     ( clk                         ),
    .rst_n                   ( rst_n                       ),
    .dividend                ( dividend   [`datawidth-1:0] ),
    .divisor                 ( divisor    [`datawidth-1:0] ),

    .remainder               ( remainder  [`datawidth-1:0] ),
    .result                  ( result     [`datawidth-1:0] ),
    .end_flag                ( end_flag                    )
);

initial
begin
    $dumpfile("uint_diver_wave.vcd");
    $dumpvars    ;
    diver_en=1;
    dividend = 32'b0000_0000_0000_0000_0000_0000_0000_1100;
    divisor  = 32'b0000_0000_0000_0000_0000_0000_0000_1001;
    #350
    diver_en=0;
    #10
    diver_en=1;
    dividend = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
    divisor  = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
    #330
    diver_en=0;
    #100
    $finish;
end
endmodule