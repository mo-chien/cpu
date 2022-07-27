module taken_counter_2bits (
    input clk,
    input rst_n,
    input counter_en,
    input [1:0]cnt_max,
    output countend_flag  
);
reg [1:0] cnt;
wire cnt_end;
always @(posedge clk ) begin

       if (! rst_n)
            cnt<= 0;
       else if ( counter_en )
          begin
             if (countend_flag)  
                    cnt<= 0;
             else
                    cnt<=cnt+1 ;
          end
       else cnt<= 0;
            
 
            
end
assign countend_flag = counter_en & (cnt == cnt_max) ; 
 
endmodule //taken_counter_2bits