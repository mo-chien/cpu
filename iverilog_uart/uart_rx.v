`include "counter.v"
module uart_rx #(parameter datawidth = 5 , Baudrate = 9600  )(
   input clk,
   input rst_n,
   input rx,
   output reg [datawidth-1:0] data
);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
localparam  cnt_max1 = 50000000/Baudrate;
localparam  cnt_max2 = datawidth +1;
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
reg bitlenth_counter_add_reg1;
reg bitlenth_counter_add_reg2;
reg bitlenth_counter_add_reg3;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n)
   begin
      bitlenth_counter_add_reg1<=1; 
      bitlenth_counter_add_reg2<=1;
      bitlenth_counter_add_reg3<=1;
   end
   else
      begin
         //异步信号同步化
         bitlenth_counter_add_reg1<=rx;
         bitlenth_counter_add_reg2<=bitlenth_counter_add_reg1;
         //边沿检测
         bitlenth_counter_add_reg3<=bitlenth_counter_add_reg2;         
      end
end
wire rx_neg_edge,rx_pos_edge;
assign rx_neg_edge = bitlenth_counter_add_reg2 == 0 && bitlenth_counter_add_reg3 == 1;
//assign rx_pos_edge = bitlenth_counter_add_reg2 == 1 && bitlenth_counter_add_reg3 == 1;

reg add_flag;
wire cnt_end1,cnt_end2;
wire [cnt_width1-1:0] cnt1;
wire [cnt_width2-1:0] cnt2;
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)begin
      add_flag <= 0;
   end
   else if (rx_neg_edge) begin
      add_flag<=1 ;
   end
   else if (cnt_end2) begin
      add_flag <=0;
   end

end
counter #(
    .cnt_max ( cnt_max1 ))
 bitlenth_counter(
    .clk         ( clk         ),
    .rst_n       ( rst_n       ),
    .cnt_add     ( add_flag    ),
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

always @(posedge clk or negedge rst_n) begin
   if (!rst_n)begin
      data<=0;
   end
   else if (add_flag && cnt1 == cnt_max1 /2 && cnt_end2 > 0)begin
      data [cnt_end2 - 1] <= bitlenth_counter_add_reg2; 
   end
end

endmodule //uart_rx