`include "defines.v"
module saturating_counter_2bits (
    input clk,
    input rst_n,
    input taken_flag,
    output reg predicted_taken
);
reg [1:0] cnt;
wire add_flag,sub_flag;

always @(posedge clk ) begin

       if (! rst_n)begin
           cnt<= `strong_not_taken;
           end
       else if ( add_flag && cnt != `strong_taken)
            begin
                 cnt<=cnt+1;
            end
       else if ( sub_flag && cnt != `strong_not_taken)
            begin
                 cnt<=cnt-1;
            end
        else begin
            
            cnt<=cnt ;
        end
end

always @(*) begin
    case(cnt) 
    `strong_not_taken:begin
        predicted_taken = 0;
    end
    `weakly_not_taken:begin
        predicted_taken = 0;
    end
    `weakly_taken:begin
        predicted_taken = 1;
    end
    `strong_taken:begin
        predicted_taken = 1;
    end  
    default : predicted_taken = 0;                
    endcase
end

assign add_flag = taken_flag;
assign sub_flag = ~taken_flag;

endmodule //saturating_counter_2bits