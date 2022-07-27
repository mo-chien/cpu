`include "defines.v"
`include "taken_counter_2bits.v"
module taken (
   input clk,
   input rst_n,
   input [`datawidth-1:0] IDU_PC_add_imme                          ,
   input                  IDU_JAL_instr                            ,
   input                  IDU_JALR_instr                           ,
   output pipe_valid                                               
   //output taken_jump_flag                                          
   
);
//JAL与JALR共用一个计数器，虽然JAL只需要将数据暂停1个时钟，但PC更新后ID数据没有立即更新，导致跳转标志还会保持一个时钟，而由于计数器的关系，流水线的数据暂停信号置1，从而ID数据可以更新
//在ID出由于无条件跳转引起流水线一个时钟的暂停，无条件跳转信号会保持两个时钟。
wire counter_en;
wire countend_flag ;
wire [1:0] cnt_max;
assign cnt_max = IDU_JAL_instr ? 2'b01 : IDU_JALR_instr ? 2'b10 : 2'b11;
assign counter_en = IDU_JAL_instr | IDU_JALR_instr ;
taken_counter_2bits u_taken_counter_2bits(
    .clk        ( clk        ),
    .rst_n      ( rst_n      ),
    .cnt_max    ( cnt_max    ),
    .counter_en ( counter_en ),
    .countend_flag  ( countend_flag  )
);
assign pipe_valid = ~(IDU_JAL_instr | IDU_JALR_instr) | countend_flag;
//assign taken_jump_flag = IDU_JAL_instr | IDU_JALR_instr;

endmodule //taken