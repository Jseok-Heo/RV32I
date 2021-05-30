/* 
 * RV32I Central Processing Unit
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description: 
 * History:              
 *          2020.11.29 - Initial release
 */

module RV32I_CPU (
     input         I_CLK
    ,input         I_RST_N
    ,input  [31:0] I_INSTR
    ,input  [31:0] I_MEM_RD_DATA
    ,output [31:0] O_PC
    ,output        O_MEM_WR
    ,output [ 3:0] O_MEM_WR_STRB
    ,output [31:0] O_MEM_ADDR
    ,output [31:0] O_MEM_WR_DATA
);
    
    wire        w_brnc_taken;    
    wire        w_jal;
    wire        w_jalr;
    wire [31:0] w_src1_data; 
    wire [31:0] w_src2_data; 
    wire [31:0] w_pc;
    wire [31:0] w_result;


    wire        w_lui;
    wire        w_auipc;
    wire        w_beq;
    wire        w_bne;
    wire        w_blt;
    wire        w_bge;
    wire        w_bltu;
    wire        w_bgeu;
    wire        w_ld;
    wire        w_st;
    wire        w_slt;
    wire        w_sltu;
    wire        w_slti;
    wire        w_sltiu;
    wire        w_al_imm;

    wire [ 4:0] w_src1_addr;
    wire [ 4:0] w_src2_addr;
    wire [ 4:0] w_dst_addr;
    wire [31:0] w_dst_data;
    wire [ 3:0] w_mem_wr_strb;
    wire [ 3:0] w_mem_rd_strb;
    wire [ 2:0] w_alu_op_type;
    wire        w_reg_wr_en;
    wire        w_mem_wr_en;
    wire [31:0] w_imm_i_se;
    wire [31:0] w_imm_i_ze;
    wire [31:0] w_imm_s_se;
    wire [31:0] w_imm_b_se;
    wire [31:0] w_imm_u;
    wire [31:0] w_imm_j_se;

    RV32I_PC
    #(
        .RST_VAL(0)
    )
    Inst_PC
    (
         .I_CLK             (I_CLK          ) // input          I_CLK
        ,.I_RST_N           (I_RST_N        ) // input          I_RST_N
        ,.I_IS_BRNC_TAKEN   (w_brnc_taken   ) // input          I_IS_BRNC_TAKEN
        ,.I_IS_JAL          (w_jal          ) // input          I_IS_JAL
        ,.I_IS_JALR         (w_jalr         ) // input          I_IS_JALR
        ,.I_SRC1_DATA       (w_src1_data    ) // input [31:0]   I_SRC1_DATA
        ,.I_BRNC_IMM        (w_imm_b_se     ) // input [31:0]   I_BRNC_IMM
        ,.I_JAL_IMM         (w_imm_j_se     ) // input [31:0]   I_JAL_IMM
        ,.I_JALR_IMM        (w_imm_i_se     ) // input [31:0]   I_JALR_IMM
        ,.O_PC              (w_pc           ) // output [31:0]  O_PC
    );
    
    RV32I_INSTR_DEC Inst_INSTR_DEC
    (
    	 .I_INSTR       (I_INSTR        ) // input      [31:0]  I_INSTR
        ,.O_LUI         (w_lui          ) // output reg         O_LUI
        ,.O_AUIPC       (w_auipc        ) // output reg         O_AUIPC
        ,.O_JAL         (w_jal          ) // output reg         O_JAL
        ,.O_JALR        (w_jalr         ) // output reg         O_JALR
        ,.O_BEQ         (w_beq          ) // output reg         O_BEQ
        ,.O_BNE         (w_bne          ) // output reg         O_BNE
        ,.O_BLT         (w_blt          ) // output reg         O_BLT
        ,.O_BGE         (w_bge          ) // output reg         O_BGE
        ,.O_BLTU        (w_bltu         ) // output reg         O_BLTU
        ,.O_BGEU        (w_bgeu         ) // output reg         O_BGEU
        ,.O_LD          (w_ld           ) // output reg         O_LD
        ,.O_ST          (w_st           ) // output reg         O_ST
        ,.O_SLT         (w_slt          ) // output reg         O_SLT
        ,.O_SLTU        (w_sltu         ) // output reg         O_SLTU
        ,.O_SLTI        (w_slti         ) // output reg         O_SLTI
        ,.O_SLTIU       (w_sltiu        ) // output reg         O_SLTIU
        ,.O_AL_IMM      (w_al_imm       ) // output reg         O_AL_IMM
        ,.O_SRC1_ADDR   (w_src1_addr    ) // output     [ 4:0]  O_SRC1_ADDR
        ,.O_SRC2_ADDR   (w_src2_addr    ) // output     [ 4:0]  O_SRC2_ADDR
        ,.O_DST_ADDR    (w_dst_addr     ) // output     [ 4:0]  O_DST_ADDR
        ,.O_MEM_WR_STRB (w_mem_wr_strb  ) // output reg [ 3:0]  O_MEM_WR_STRB
        ,.O_MEM_RD_STRB (w_mem_rd_strb  ) // output reg [ 3:0]  O_MEM_RD_STRB
        ,.O_ALU_OP_TYPE (w_alu_op_type  ) // output reg [ 2:0]  O_ALU_OP_TYPE
        ,.O_REG_WR_EN   (w_reg_wr_en    ) // output reg         O_REG_WR_EN
        ,.O_MEM_WR_EN   (w_mem_wr_en    ) // output reg         O_MEM_WR_EN
        ,.O_IMM_I_SE    (w_imm_i_se     ) // output     [31:0]  O_IMM_I_SE
        ,.O_IMM_I_ZE    (w_imm_i_ze     ) // output     [31:0]  O_IMM_I_ZE
        ,.O_IMM_S_SE    (w_imm_s_se     ) // output     [31:0]  O_IMM_S_SE
        ,.O_IMM_B_SE    (w_imm_b_se     ) // output     [31:0]  O_IMM_B_SE
        ,.O_IMM_U       (w_imm_u        ) // output     [31:0]  O_IMM_U
        ,.O_IMM_J_SE    (w_imm_j_se     ) // output     [31:0]  O_IMM_J_SE
//    	,.O_UNDEF_INSTR (w_undef_instr  ) // output reg         O_UNDEF_INSTR
    );

    RV32I_REG_FILE Inst_REG_FILE
    (
         .I_CLK         (I_CLK      )  // input              I_CLK
        ,.I_SRC1_ADDR   (w_src1_addr)  // input      [4:0]   I_SRC1_ADDR
        ,.I_SRC2_ADDR   (w_src2_addr)  // input      [4:0]   I_SRC2_ADDR
        ,.I_DST_ADDR    (w_dst_addr )  // input      [4:0]   I_DST_ADDR
        ,.I_DST_DATA    (w_dst_data )  // input      [31:0]  I_DST_DATA
        ,.I_WR_EN       (w_reg_wr_en)  // input              I_WR_EN
        ,.O_SRC1_DATA   (w_src1_data)  // output reg [31:0]  O_SRC1_DATA
        ,.O_SRC2_DATA   (w_src2_data)  // output reg [31:0]  O_SRC2_DATA
    );
    
    RV32I_ALU_TOP Inst_ALU_TOP
    (
         .I_SRC1_DATA       (w_src1_data    )   // input [31:0]  I_SRC1_DATA
        ,.I_SRC2_DATA       (w_src2_data    )   // input [31:0]  I_SRC2_DATA
        ,.I_PC              (w_pc           )   // input [31:0]  I_PC
        ,.I_IMM_I_SE        (w_imm_i_se     )   // input [31:0]  I_IMM_I_SE
        ,.I_IMM_I_ZE        (w_imm_i_ze     )   // input [31:0]  I_IMM_I_ZE
        ,.I_IMM_S_SE        (w_imm_s_se     )   // input [31:0]  I_IMM_S_SE
        ,.I_IMM_B_SE        (w_imm_b_se     )   // input [31:0]  I_IMM_B_SE
        ,.I_IMM_U           (w_imm_u        )   // input [31:0]  I_IMM_U
        ,.I_IMM_J_SE        (w_imm_j_se     )   // input [31:0]  I_IMM_J_SE
        ,.I_ALU_CTRL        (w_alu_op_type  )   // input [ 2:0]  I_ALU_CTRL
        ,.I_IS_LUI          (w_lui          )   // input         I_IS_LUI
        ,.I_IS_AUIPC        (w_auipc        )   // input         I_IS_AUIPC
        ,.I_IS_JAL          (w_jal          )   // input         I_IS_JAL
        ,.I_IS_JALR         (w_jalr         )   // input         I_IS_JALR
        ,.I_IS_BEQ          (w_beq          )   // input         I_IS_BEQ
        ,.I_IS_BNE          (w_bne          )   // input         I_IS_BNE
        ,.I_IS_BLT          (w_blt          )   // input         I_IS_BLT
        ,.I_IS_BGE          (w_bge          )   // input         I_IS_BGE
        ,.I_IS_BLTU         (w_bltu         )   // input         I_IS_BLTU
        ,.I_IS_BGEU         (w_bgeu         )   // input         I_IS_BGEU
        ,.I_IS_LD           (w_ld           )   // input         I_IS_LD
        ,.I_IS_ST           (w_st           )   // input         I_IS_ST
        ,.I_IS_SLT          (w_slt          )   // input         I_IS_SLT
        ,.I_IS_SLTU         (w_sltu         )   // input         I_IS_SLTU
        ,.I_IS_SLTI         (w_slti         )   // input         I_IS_SLTI
        ,.I_IS_SLTIU        (w_sltiu        )   // input         I_IS_SLTIU
        ,.I_IS_AL_IMM       (w_al_imm       )   // input         I_IS_AL_IMM
        ,.O_RESULT          (w_result       )   // output [31:0] O_RESULT
        ,.O_IS_BRNC_TAKEN   (w_brnc_taken   )   // output        O_IS_BRNC_TAKEN
//        ,.O_N               (               )   // output        O_N
//        ,.O_Z               (               )   // output        O_Z
//        ,.O_C               (               )   // output        O_C
//        ,.O_V               (               )   // output        O_V
    
    );

    assign w_dst_data = w_ld ? w_mem_rd_strb == 4'b0001 ? I_MEM_RD_DATA[ 7:0] :
                               w_mem_rd_strb == 4'b0011 ? I_MEM_RD_DATA[15:0] : I_MEM_RD_DATA[31:0] :
                               w_result;

    assign O_PC = w_pc;
    assign O_MEM_WR = w_mem_wr_en;
    assign O_MEM_WR_STRB = w_mem_wr_strb;
    assign O_MEM_ADDR = w_result;
    assign O_MEM_WR_DATA = w_src2_data;

endmodule
