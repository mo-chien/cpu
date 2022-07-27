`timescale 1ns / 1ps
`include "defines.v"
`include "adder.v"
module uint_diver (
input diver_en,
input clk,
input  [`datawidth-1:0] dividend,divisor,
output [`datawidth-1:0] remainder,
output [`datawidth-1:0] result,
output end_flag
);
reg diver_en_temp;
always @(posedge clk ) begin
    diver_en_temp <= diver_en;
end
//count
reg [`DIV_STEPS_Log2-1:0] cnt;
wire cnt_start,cnt_end;
// diver
reg  [`datawidth-1:0]  data_B;
reg [`datawidth*2-1:0] temp_A;
reg  [`datawidth-1:0]  remainder_reg, result_ci ;
wire [`datawidth-1:0]  add_result,data_A,n_data_B;
wire [`datawidth*2-1:0] temp_A_shift;
wire co;

always @(posedge clk ) begin

       if (!diver_en_temp)begin
           cnt<=0;
           end
        else if (cnt_start)
            begin
                 if (cnt_end)
                     cnt<=0;
                 else
                     cnt<=cnt+1;
            end
        else   cnt<=0 ;
end
assign cnt_start = diver_en_temp ;
assign cnt_end = cnt_start& (cnt == `DIV_STEPS);//计算需要32个时钟,数据加载1个时钟，总共33个时钟

assign temp_A_shift = temp_A << 1 ;
assign n_data_B = ~ data_B;
assign data_A = temp_A_shift[63:32];
// always @ ( posedge clk  )begin
//     if (diver_en) begin
//         if (cnt == 0) begin
//             data_B <= divisor ;
//             temp_A <= {32'd0,dividend};
//         end
//         else if ( co )begin
//             temp_A <= {add_result,temp_A_shift[31:1],1'b1};
//         end
//         else temp_A <= temp_A_shift;
//     end
//     else temp_A<=temp_A;
        

// end
always @ ( posedge clk  )begin
    if (diver_en_temp) begin
        if ( co )begin
            temp_A <= {add_result,temp_A_shift[31:1],1'b1};
        end
        else temp_A <= temp_A_shift;
        
    end       
    else begin
        data_B <= divisor ;
        temp_A <= {32'd0,dividend};
    end
        
    end
        


assign remainder      =  temp_A[63:32];
assign result      =  temp_A[31:0];


//加法器只执行减法操作，即对数据B进行取反，进位输入置1，从而达到加上补码的功能。
adder u_adder(.data_A      ( data_A      ),.data_B      ( n_data_B    ),.ci          ( 1'b1        ),.result      ( add_result  ),.co          ( co          )//无符号减法，进位输出为0时发生借位
);
//wire end_flag_temp;
assign end_flag = cnt_end ; 
// always @(posedge clk ) begin
//     end_flag <= end_flag_temp;
// end

endmodule //u_diver