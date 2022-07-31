`include "uart_rx.v"
`include "uart_tx.v"
module uart #(parameter datawidth = 8 , Baudrate = 9600  )(
    input clk,
    input rst_n,
    input rxd,
    output txd
);
wire [datawidth-1:0] data_out;
wire rx_valid;
uart_rx#(
    .datawidth ( datawidth ),
    .Baudrate  ( Baudrate )
)u_uart_rx(
    .clk       ( clk       ),
    .rst_n     ( rst_n     ),
    .rxd       ( rxd       ),
    .data_out  ( data_out  ),
    .rx_valid  ( rx_valid  )
);
uart_tx#(
    .datawidth      (datawidth ),
    .Baudrate       ( Baudrate )
)u_uart_tx(
    .clk            ( clk            ),
    .rst_n          ( rst_n          ),
    .data_in        ( data_out        ),
    .tx_triger_flag ( rx_valid        ),
    .txd            ( txd            )
);


endmodule //uart