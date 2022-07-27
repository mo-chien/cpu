`timescale  1ns / 1ps
`include "defines.v"
`include "ID_EX_regs.v"
module tb_ID_EX_regs;

// ID_EX_regs Parameters
parameter PERIOD  = 10;


// ID_EX_regs Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   validin                              = 0 ;
reg   pipe_ready_go                        = 0 ;
reg   out_allow                            = 0 ;
reg   clear                                = 0 ;
reg   [`datawidth-1:0]  in_PC_add_4        = 0 ;
reg   [`datawidth-1:0]  in_PC_add_imme     = 0 ;
reg   [2:0]  in_func3                      = 0 ;
reg   [`datawidth-1:0]  in_imme            = 0 ;
reg   [4:0]  in_Rd                         = 0 ;
reg   in_func7                             = 0 ;
reg   in_I_type                            = 0 ;
reg   in_L_type                            = 0 ;
reg   in_S_type                            = 0 ;
reg   in_R_type                            = 0 ;
reg   in_JAL_instr                         = 0 ;
reg   in_JALR_instr                        = 0 ;
reg   in_LUI_instr                         = 0 ;
reg   in_AUIPC_instr                       = 0 ;
reg   in_B_type                            = 0 ;
reg   [`datawidth-1:0]  in_Rd_data1        = 0 ;
reg   [`datawidth-1:0]  in_Rd_data2        = 0 ;

// ID_EX_regs Outputs
wire  in_allow                             ;
wire  validout                             ;
wire  [`datawidth-1:0]  out_PC_add_4       ;
wire  [`datawidth-1:0]  out_PC_add_imme    ;
wire  [4:0]  out_Rd                        ;
wire  [`datawidth-1:0]  out_Rd_data1       ;
wire  [`datawidth-1:0]  out_Rd_data2       ;
wire  [`datawidth-1:0]  out_imme           ;
wire  [2:0]  out_func3                     ;
wire  out_func7                            ;
wire  out_I_type                           ;
wire  out_L_type                           ;
wire  out_S_type                           ;
wire  out_R_type                           ;
wire  out_JAL_instr                        ;
wire  out_JALR_instr                       ;
wire  out_LUI_instr                        ;
wire  out_AUIPC_instr                      ;
wire  out_B_type                           ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

ID_EX_regs  u_ID_EX_regs (
    .clk                     ( clk                               ),
    .rst_n                   ( rst_n                             ),
    .validin                 ( validin                           ),
    .pipe_ready_go           ( pipe_ready_go                     ),
    .out_allow               ( out_allow                         ),
    .clear                   (clear                              ),
    .in_PC_add_4             ( in_PC_add_4      [`datawidth-1:0] ),
    .in_PC_add_imme          ( in_PC_add_imme   [`datawidth-1:0] ),
    .in_func3                ( in_func3         [2:0]            ),
    .in_imme                 ( in_imme          [`datawidth-1:0] ),
    .in_Rd                   ( in_Rd            [4:0]            ),
    .in_func7                ( in_func7                          ),
    .in_I_type               ( in_I_type                         ),
    .in_L_type               ( in_L_type                         ),
    .in_S_type               ( in_S_type                         ),
    .in_R_type               ( in_R_type                         ),
    .in_JAL_instr            ( in_JAL_instr                      ),
    .in_JALR_instr           ( in_JALR_instr                     ),
    .in_LUI_instr            ( in_LUI_instr                      ),
    .in_AUIPC_instr          ( in_AUIPC_instr                    ),
    .in_B_type               ( in_B_type                         ),
    .in_Rd_data1             ( in_Rd_data1      [`datawidth-1:0] ),
    .in_Rd_data2             ( in_Rd_data2      [`datawidth-1:0] ),

    .in_allow                ( in_allow                          ),
    .validout                ( validout                          ),
    .out_PC_add_4            ( out_PC_add_4     [`datawidth-1:0] ),
    .out_PC_add_imme         ( out_PC_add_imme  [`datawidth-1:0] ),
    .out_Rd                  ( out_Rd           [4:0]            ),
    .out_Rd_data1            ( out_Rd_data1     [`datawidth-1:0] ),
    .out_Rd_data2            ( out_Rd_data2     [`datawidth-1:0] ),
    .out_imme                ( out_imme         [`datawidth-1:0] ),
    .out_func3               ( out_func3        [2:0]            ),
    .out_func7               ( out_func7                         ),
    .out_I_type              ( out_I_type                        ),
    .out_L_type              ( out_L_type                        ),
    .out_S_type              ( out_S_type                        ),
    .out_R_type              ( out_R_type                        ),
    .out_JAL_instr           ( out_JAL_instr                     ),
    .out_JALR_instr          ( out_JALR_instr                    ),
    .out_LUI_instr           ( out_LUI_instr                     ),
    .out_AUIPC_instr         ( out_AUIPC_instr                   ),
    .out_B_type              ( out_B_type                        )
);

initial
begin
    $dumpfile("ID_EX_regs.vcd");
    $dumpvars    ;

    #20
    validin = 1;
    out_allow = 1;
    clear = 1;
    #10
    clear = 1'bx;
    #10
    $finish;
end

endmodule