`timescale  1ns / 1ps
`include "saturating_counter_2bits.v"
module tb_saturating_counter_2bits;   

// saturating_counter_2bits Parameters
parameter PERIOD  = 10;


// saturating_counter_2bits Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   taken_flag                           = 0 ;

// saturating_counter_2bits Outputs
wire  predicted_taken                      ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

saturating_counter_2bits  u_saturating_counter_2bits (
    .clk                     ( clk               ),
    .rst_n                   ( rst_n             ),
    .taken_flag              ( taken_flag        ),

    .predicted_taken         ( predicted_taken   )
);

initial
begin
    $dumpfile("saturating_counter_2bits_.vcd");
    $dumpvars    ;
    # (1*PERIOD)
    taken_flag = 1;
    # (6*PERIOD)
    taken_flag = 0;
    # (5*PERIOD)
    taken_flag = 1;
    # (4*PERIOD)
    taken_flag = 0;
    # (2*PERIOD)
    taken_flag = 1;
    # (1*PERIOD)
    taken_flag = 0;
    # (1*PERIOD)
    $finish;
end

endmodule