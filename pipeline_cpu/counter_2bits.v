module counter_2bits (
    input clk,
    input rst_n,
    input [1:0] cnt_max,
    input counter_en,
    output countend_flag  
);
reg [1:0] cnt;
wire cnt_end;
always @(posedge clk ) begin

       if (! rst_n)
            cnt<= 0;
       else if ( counter_en )
            cnt<=cnt+1 ;
       else 
            cnt<= 0;
end
assign countend_flag = cnt == cnt_max ; 
 
endmodule //counter_2bits