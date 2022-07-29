`include "counter.v"
module uart_tx #(parameter datawidth = 5 , Baudrate = 9600  )(
   input clk,
   input rst_n,
   input [datawidth-1:0] data_in,
   input tx_triger_flag,
   output txd

);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
localparam  cnt_max1 = 50000000/Baudrate;
localparam  cnt_max2 = datawidth+2;
function integer clogb2 (
    input           integer depth
    );
begin
    if(depth == 0)
        clogb2  = 1;
    else if(depth != 0)
        for(clogb2  = 0; depth > 0;clogb2  = clogb2  + 1)
            depth = depth >> 1;
end
endfunction
localparam cnt_width1 = clogb2 (cnt_max1);
localparam cnt_width2 = clogb2 (cnt_max2);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
reg tx_start_flag;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        tx_start_flag<=0;
    end
    else if (cnt_end2) begin
        tx_start_flag<=0;
    end
    else if (tx_triger_flag)begin
        tx_start_flag<=1;
    end
end
wire cnt_end1,cnt_end2;
wire [cnt_width1-1:0] cnt1;
wire [cnt_width2-1:0] cnt2;

counter #(
    .cnt_max ( cnt_max1 ))
 bitlenth_counter(
    .clk         ( clk         ),
    .rst_n       ( rst_n       ),
    .cnt_add     ( tx_start_flag ),
    .cnt         ( cnt1        ),
    .cnt_end     ( cnt_end1    )
);

counter #(
    .cnt_max ( cnt_max2 ))
 bitnum_counter(
    .clk         ( clk         ),
    .rst_n       ( rst_n       ),
    .cnt_add     ( cnt_end1    ),
    .cnt         ( cnt2        ),
    .cnt_end     ( cnt_end2    )
);

reg txd_reg;
always @(posedge clk ) begin
    if (tx_start_flag == 1)begin
        if (cnt2==0)
            txd_reg<=0;
        else if (cnt2==9)
            txd_reg<=1;
        else 
            txd_reg<=data_in[cnt2-1];
    end
    else begin
        txd_reg<=1;
    end
end
assign txd = txd_reg;
endmodule //uart_tx