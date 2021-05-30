/* 
 * RV32I Program Counter
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description: 
 * History:              
 *          2020.11.29 - Initial release
 */

module RV32I_PC
#(
    parameter [31:0] RST_VAL = 32'h0
)
(
     input          I_CLK
    ,input          I_RST_N
    ,input          I_IS_BRNC_TAKEN
    ,input          I_IS_JAL
    ,input          I_IS_JALR
    ,input [31:0]   I_SRC1_DATA
    ,input [31:0]   I_BRNC_IMM
    ,input [31:0]   I_JAL_IMM
    ,input [31:0]   I_JALR_IMM

    ,output [31:0]  O_PC
);
    reg [31:0] r_pc;

    always @(posedge I_CLK, negedge I_RST_N)
        if      (!I_RST_N)          r_pc <= RST_VAL;
        else if (I_IS_JAL)          r_pc <= r_pc + I_JAL_IMM;
        else if (I_IS_JALR)         r_pc <= I_SRC1_DATA + I_JALR_IMM;
        else if (I_IS_BRNC_TAKEN)   r_pc <= r_pc + I_BRNC_IMM;
        else                        r_pc <= r_pc + 32'd4;

    assign O_PC = {r_pc[31:1],1'b0};
    
endmodule
