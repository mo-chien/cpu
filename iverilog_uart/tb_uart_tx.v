`timescale  1ns / 1ps
`include "uart_tx.v"
module tb_uart_tx;   

// uart_tx Parameters
parameter PERIOD  = 10;
parameter datawidth = 8;
parameter Baudrate =9600;

// uart_tx Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [datawidth-1:0]  data_in             = 0 ;
reg   tx_triger_flag                       = 0 ;

// uart_tx Outputs
wire  txd                                  ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

uart_tx#(
    .datawidth      ( datawidth ),
    .Baudrate   (Baudrate  )
)u_uart_tx(
    .clk            ( clk            ),
    .rst_n          ( rst_n          ),
    .data_in        ( data_in        ),
    .tx_triger_flag ( tx_triger_flag ),
    .txd            ( txd            )
);


initial
begin
    $dumpfile("uart_tx.vcd");
    $dumpvars    ;
    #20
    data_in=8'h70;
    tx_triger_flag=1;
    #10
    tx_triger_flag=0;
    #1000
    $finish;
end

endmodule