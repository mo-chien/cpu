module counter
#(parameter cnt_max=32)(
    clk,
    rst_n,
    cnt_add,
    cnt,
    cnt_end
);

/////////////////////////////////////////////////////////////////////////////////////
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
localparam cnt_width = clogb2 (cnt_max);
////////////////////////////////////////////////////////////////////////////////////
    input clk     ;
    input rst_n   ;
    input cnt_add ;
    output reg [cnt_width-1:0] cnt ;
    output cnt_end;

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0)
        cnt<=0;
    else if (cnt_add) 
                begin
                    if (cnt_end)
                        cnt<=0;
                    else
                        cnt<=cnt+1;
                end
end
assign cnt_end = cnt_add && cnt ==  cnt_max -1;
endmodule //counter