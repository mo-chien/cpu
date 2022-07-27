`timescale  1ns / 1ps   
`include "int_driver.v"
module tb_int_driver;   

// int_driver Parameters
parameter PERIOD  = 10;


// int_driver Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   diver_en                             = 0 ;
reg   sign_flag                            = 0 ;
reg   [`datawidth-1:0]  dividend           = 0 ;
reg   [`datawidth-1:0]  divisor            = 0 ;

// int_driver Outputs
wire  [`datawidth-1:0]  remainder          ;
wire  [`datawidth-1:0]  result             ;
wire  end_flag                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

// initial
// begin
//     #(PERIOD*2) rst_n  =  1;
// end

int_driver  u_int_driver (
    .clk                     ( clk                         ),
    //.rst_n                   ( rst_n                       ),
    .diver_en                ( diver_en                    ),
    .sign_flag               ( sign_flag                   ),
    .dividend                ( dividend   [`datawidth-1:0] ),
    .divisor                 ( divisor    [`datawidth-1:0] ),

    .remainder               ( remainder  [`datawidth-1:0] ),
    .result                  ( result     [`datawidth-1:0] ),
    .end_flag                ( end_flag                    )
);

initial
begin
    $dumpfile("int_diver_wave.vcd");
    $dumpvars    ;
    diver_en=1;
    sign_flag=0;
    dividend = 32'b1111_1111_1111_1111_1111_1111_1111_1001;
    divisor  = 32'b1111_1111_1111_1111_1111_1111_1111_1100;
    #330
    diver_en=0;
    #10
    diver_en=1;
    sign_flag=1;
    #330
    diver_en=0;
    #10
    diver_en=1;
    sign_flag=0;
    dividend = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
    divisor  = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
    #330
    diver_en=0;
    #10
    diver_en=1;
    sign_flag=1;
    #330
    diver_en=0;
    #100
    $finish;
end

endmodule