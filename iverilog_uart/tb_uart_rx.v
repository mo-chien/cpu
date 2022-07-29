`timescale  1ns / 1ps
`include "uart_rx.v"
module tb_uart_rx;   

// uart_rx Parameters
parameter PERIOD  = 10;


// uart_rx Inputs
reg   clk                                  = 0 ;
reg   rxd                                  = 1 ;
reg   rst_n                                = 0 ;

// uart_rx Outputs
wire  rx_valid                              ;
wire  [7:0]  data_out                       ;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

uart_rx#(
    .datawidth ( 8 ),
    .Baudrate   ( 9600 )
)u_uart_rx(
    .clk       ( clk       ),
    .rst_n     ( rst_n     ),
    .rxd       ( rxd       ),
    .data_out  ( data_out  ),
    .rx_valid  ( rx_valid  )
);


initial
begin
    $dumpfile("uart_rx.vcd");
    $dumpvars    ;
    #20
    rxd = 0;
    #50
    rxd= 1 ;
    #50
    rxd= 1 ;
    #50
    rxd= 1 ;
    #50
    rxd= 1 ;
    #50
    rxd= 0 ;
    #50
    rxd= 0 ;
    #50
    rxd= 0 ;
    #50
    rxd= 0 ;
    #50
    rxd= 1 ;
    #100
    $finish;
end

endmodule