/* 
 * RV32I Arithmetic Logic Unit Top module
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description: 
 * History:              
 *          2020.11.29 - Initial release
 *          2020.12.07 - Split O_SLT_U into O_SLT and O_SLTU
 */

module RV32I_ALU_TOP
(
     input [31:0]  I_SRC1_DATA
    ,input [31:0]  I_SRC2_DATA
    ,input [31:0]  I_PC
    ,input [31:0]  I_IMM_I_SE
    ,input [31:0]  I_IMM_I_ZE
    ,input [31:0]  I_IMM_S_SE
    ,input [31:0]  I_IMM_B_SE
    ,input [31:0]  I_IMM_U
    ,input [31:0]  I_IMM_J_SE

    ,input [ 2:0]  I_ALU_CTRL
    ,input         I_IS_LUI
    ,input         I_IS_AUIPC
    ,input         I_IS_JAL
    ,input         I_IS_JALR
    ,input         I_IS_BEQ
    ,input         I_IS_BNE
    ,input         I_IS_BLT
    ,input         I_IS_BGE
    ,input         I_IS_BLTU
    ,input         I_IS_BGEU
    ,input         I_IS_LD
    ,input         I_IS_ST
    ,input         I_IS_SLT
    ,input         I_IS_SLTU
    ,input         I_IS_SLTI
    ,input         I_IS_SLTIU
    ,input         I_IS_AL_IMM

    ,output [31:0] O_RESULT
    ,output        O_IS_BRNC_TAKEN
    ,output        O_N
    ,output        O_Z
    ,output        O_C
    ,output        O_V

);

    wire [31:0] w_op_a;
    wire [31:0] w_op_b;
    wire [31:0] w_result;
    wire        w_is_slt_type;
    wire        w_is_slt_taken;
    wire        w_is_sltu_taken;
    wire        w_is_beq_taken;
    wire        w_is_bne_taken;
    wire        w_is_blt_taken;
    wire        w_is_bge_taken;
    wire        w_is_bltu_taken;
    wire        w_is_bgeu_taken;

    assign w_op_a = I_IS_LUI                          ? 32'h0 :
                    I_IS_AUIPC | I_IS_JAL | I_IS_JALR ? I_PC  :
                    I_SRC1_DATA;

    assign w_op_b = I_IS_LUI | I_IS_AUIPC               ? I_IMM_U    :
                    I_IS_JAL | I_IS_JALR                ? 32'd4      :
                    I_IS_LD  | I_IS_AL_IMM | I_IS_SLTI  ? I_IMM_I_SE :
                    I_IS_ST                             ? I_IMM_S_SE :
                    I_IS_SLTIU                          ? I_IMM_I_ZE :
                    I_SRC2_DATA;

    RV32I_ALU Inst_ALU
    (
         .I_OP_A    (w_op_a)
        ,.I_OP_B    (w_op_b)
        ,.I_OP_TYPE (I_ALU_CTRL)
        ,.O_RESULT  (w_result)
        ,.O_N       (O_N)
        ,.O_Z       (O_Z)
        ,.O_C       (O_C)
        ,.O_V       (O_V)
    );

    assign w_is_slt_type   = I_IS_SLT | I_IS_SLTU | I_IS_SLTI | I_IS_SLTIU;
    assign w_is_slt_taken  = (I_IS_SLT  | I_IS_SLTI ) & (O_N ^ O_V); // (O_N != O_V)
    assign w_is_sltu_taken = (I_IS_SLTU | I_IS_SLTIU) & ~O_C;

    assign O_RESULT = w_is_slt_type ? ((w_is_slt_taken | w_is_sltu_taken) ? 32'd1 : 32'd0) : w_result;

    assign w_is_beq_taken  = I_IS_BEQ  & O_Z         ;
    assign w_is_bne_taken  = I_IS_BNE  & !O_Z        ;
    assign w_is_blt_taken  = I_IS_BLT  & (O_N != O_V);
    assign w_is_bge_taken  = I_IS_BGE  & (O_N == O_V);
    assign w_is_bltu_taken = I_IS_BLTU & !O_C        ;
    assign w_is_bgeu_taken = I_IS_BGEU & (O_C | O_Z) ;

    assign O_IS_BRNC_TAKEN = w_is_beq_taken 
                           | w_is_bne_taken 
                           | w_is_blt_taken 
                           | w_is_bge_taken
                           | w_is_bltu_taken
                           | w_is_bgeu_taken;

endmodule
