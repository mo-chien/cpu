`timescale  1ns / 1ps
`include "uart_rx.v"
module tb_uart_rx;   

// uart_rx Parameters
parameter PERIOD  = 10;


// uart_rx Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   cnt_add                              = 0 ;

// uart_rx Outputs
wire  cnt_end                              ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

uart_rx#(
    .datawidth ( 5 ),
    .Baudrate  ( 9600 )
)u_uart_rx(
    .clk       ( clk       ),
    .rst_n     ( rst_n     ),
    .cnt_add   ( cnt_add   ),
    .cnt_end   ( cnt_end   )
);

initial
begin
    $dumpfile("uart_rx.vcd");
    $dumpvars    ;
    #20

    cnt_add = 1;
    #100
    $finish;
end

endmodule