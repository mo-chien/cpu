`timescale  1ns / 1ps        
`include "stallable_pipeline.v"
module tb_stallable_pipeline;

// stallable_pipeline Parameters
parameter PERIOD  = 10;


// stallable_pipeline Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   validin                              = 0 ;
reg   [31:0]  datain                  = 0 ;
reg   out_allow                            = 0 ;
reg   pipe1_ready_go                       = 0 ;

// stallable_pipeline Outputs
wire  validout                             ;
wire  [31:0]  dataout                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

stallable_pipeline  u_stallable_pipeline (
    .clk                     ( clk                         ),
    .rst_n                   ( rst_n                       ),
    .validin                 ( validin                     ),
    .datain                  ( datain           ),
    .out_allow               ( out_allow                   ),
    .pipe1_ready_go          ( pipe1_ready_go              ),

    .validout                ( validout                    ),
    .dataout                 ( dataout          )
);

initial
begin
    $dumpfile("stallable_pipeline.vcd");
    $dumpvars    ;
    #20
    datain=32'd4;
    validin=1;
    pipe1_ready_go = 1;
    out_allow=1;
    #20
    datain=32'd18;
    validin=1;
    pipe1_ready_go = 0;
    out_allow=1;
    #10
    datain=32'd24;
    validin=1;
    pipe1_ready_go = 1;
    out_allow=1;
    #10
    datain=32'd28;
    validin=1;
    pipe1_ready_go = 1;
    out_allow=0;
    #10
    datain=32'd32;
    validin=1;
    pipe1_ready_go = 1;
    out_allow=1;
    #10

    $finish;
end

endmodule
