/* 
 * RV32I Instruction Decoder
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description: 
 * History:              
 *          2020.11.29 - Initial release
 *          2020.12.07 - Split O_SLT_U into O_SLT and O_SLTU
 */
                 
module RV32I_INSTR_DEC
(
	 input      [31:0]  I_INSTR

    ,output reg         O_LUI
    ,output reg         O_AUIPC
    ,output reg         O_JAL
    ,output reg         O_JALR
    ,output reg         O_BEQ
    ,output reg         O_BNE
    ,output reg         O_BLT
    ,output reg         O_BGE
    ,output reg         O_BLTU
    ,output reg         O_BGEU
    ,output reg         O_LD
    ,output reg         O_ST
    ,output reg         O_SLT
    ,output reg         O_SLTU
    ,output reg         O_SLTI
    ,output reg         O_SLTIU
    ,output reg         O_AL_IMM    // is instr Arithmetic Logic operation with immediate ?
    ,output     [ 4:0]  O_SRC1_ADDR
    ,output     [ 4:0]  O_SRC2_ADDR
    ,output     [ 4:0]  O_DST_ADDR
    ,output reg [ 3:0]  O_MEM_WR_STRB
    ,output reg [ 3:0]  O_MEM_RD_STRB
    ,output reg [ 2:0]  O_ALU_OP_TYPE
    ,output reg         O_REG_WR_EN
    ,output reg         O_MEM_WR_EN
    ,output     [31:0]  O_IMM_I_SE
    ,output     [31:0]  O_IMM_I_ZE
    ,output     [31:0]  O_IMM_S_SE
    ,output     [31:0]  O_IMM_B_SE
    ,output     [31:0]  O_IMM_U
    ,output     [31:0]  O_IMM_J_SE
	,output reg         O_UNDEF_INSTR
);

    localparam [31:0] LUI_INSTR     = 32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0111;
    localparam [31:0] AUIPC_INSTR   = 32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0111;
    localparam [31:0] JAL_INSTR     = 32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_1111;
    localparam [31:0] JALR_INSTR    = 32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x110_0111;
    localparam [31:0] BEQ_INSTR     = 32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x110_0011;
    localparam [31:0] BNE_INSTR     = 32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x110_0011;
    localparam [31:0] BLT_INSTR     = 32'bxxxx_xxxx_xxxx_xxxx_x100_xxxx_x110_0011;
    localparam [31:0] BGE_INSTR     = 32'bxxxx_xxxx_xxxx_xxxx_x101_xxxx_x110_0011;
    localparam [31:0] BLTU_INSTR    = 32'bxxxx_xxxx_xxxx_xxxx_x110_xxxx_x110_0011;
    localparam [31:0] BGEU_INSTR    = 32'bxxxx_xxxx_xxxx_xxxx_x111_xxxx_x110_0011;
    localparam [31:0] LB_INSTR      = 32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x000_0011;
    localparam [31:0] LH_INSTR      = 32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x000_0011;
    localparam [31:0] LW_INSTR      = 32'bxxxx_xxxx_xxxx_xxxx_x010_xxxx_x000_0011;
    localparam [31:0] LBU_INSTR     = 32'bxxxx_xxxx_xxxx_xxxx_x100_xxxx_x000_0011;
    localparam [31:0] LHU_INSTR     = 32'bxxxx_xxxx_xxxx_xxxx_x101_xxxx_x000_0011;
    localparam [31:0] SB_INSTR      = 32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x010_0011;
    localparam [31:0] SH_INSTR      = 32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x010_0011;
    localparam [31:0] SW_INSTR      = 32'bxxxx_xxxx_xxxx_xxxx_x010_xxxx_x010_0011;
    localparam [31:0] ADDI_INSTR    = 32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x001_0011;
    localparam [31:0] SLTI_INSTR    = 32'bxxxx_xxxx_xxxx_xxxx_x010_xxxx_x001_0011;
    localparam [31:0] SLTIU_INSTR   = 32'bxxxx_xxxx_xxxx_xxxx_x011_xxxx_x001_0011;
    localparam [31:0] XORI_INSTR    = 32'bxxxx_xxxx_xxxx_xxxx_x100_xxxx_x001_0011;
    localparam [31:0] ORI_INSTR     = 32'bxxxx_xxxx_xxxx_xxxx_x110_xxxx_x001_0011;
    localparam [31:0] ANDI_INSTR    = 32'bxxxx_xxxx_xxxx_xxxx_x111_xxxx_x001_0011;
    localparam [31:0] SLLI_INSTR    = 32'b0000_000x_xxxx_xxxx_x001_xxxx_x001_0011;
    localparam [31:0] SRLI_INSTR    = 32'b0000_000x_xxxx_xxxx_x101_xxxx_x001_0011;
    localparam [31:0] SRAI_INSTR    = 32'b0100_000x_xxxx_xxxx_x101_xxxx_x001_0011;
    localparam [31:0] ADD_INSTR     = 32'b0000_000x_xxxx_xxxx_x000_xxxx_x011_0011;
    localparam [31:0] SUB_INSTR     = 32'b0100_000x_xxxx_xxxx_x000_xxxx_x011_0011;
    localparam [31:0] SLL_INSTR     = 32'b0000_000x_xxxx_xxxx_x001_xxxx_x011_0011;
    localparam [31:0] SLT_INSTR     = 32'b0000_000x_xxxx_xxxx_x010_xxxx_x011_0011;
    localparam [31:0] SLTU_INSTR    = 32'b0000_000x_xxxx_xxxx_x011_xxxx_x011_0011;
    localparam [31:0] XOR_INSTR     = 32'b0000_000x_xxxx_xxxx_x100_xxxx_x011_0011;
    localparam [31:0] SRL_INSTR     = 32'b0000_000x_xxxx_xxxx_x101_xxxx_x011_0011;
    localparam [31:0] SRA_INSTR     = 32'b0100_000x_xxxx_xxxx_x101_xxxx_x011_0011;
    localparam [31:0] OR_INSTR      = 32'b0000_000x_xxxx_xxxx_x110_xxxx_x011_0011;
    localparam [31:0] AND_INSTR     = 32'b0000_000x_xxxx_xxxx_x111_xxxx_x011_0011;
//    localparam [31:0] FENCE_INSTR   = 32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x000_1111;
//    localparam [31:0] ECALL_INSTR   = 32'b0000_0000_0000_0000_0000_0000_0111_0011;
//    localparam [31:0] EBREAK_INSTR  = 32'b0000_0000_0001_0000_0000_0000_0111_0011;

    localparam T = 1'b1;    // True
    localparam F = 1'b0;    // False
    localparam D = 1'bx;    // Dont Care

    localparam [3:0] BYTE_STRB = 4'b0001;
    localparam [3:0] HALF_STRB = 4'b0011;
    localparam [3:0] WORD_STRB = 4'b1111;
    localparam [3:0] DONT_CARE = 4'bxxxx;

    localparam [2:0] ADD = 3'b000;
    localparam [2:0] SUB = 3'b001;
    localparam [2:0] AND = 3'b010;
    localparam [2:0] OR  = 3'b011;
    localparam [2:0] XOR = 3'b100;
    localparam [2:0] SLL = 3'b101;
    localparam [2:0] SRL = 3'b110;
    localparam [2:0] SRA = 3'b111;

    reg [2:0] r_imm_type;

    localparam [2:0] IMM_I_SE = 3'b000; // JALR, LB, LH, LW, LBU, LHU, ADDI, SLTI, XORI, ORI, ANDI, (SLLI, SRLI, SRAI) : Sign Extension
    wire [11:0] w_imm_i = I_INSTR[31:20];
    wire [31:0] w_imm_i_se = {{20{w_imm_i[11]}}, w_imm_i};

    localparam [2:0] IMM_I_ZE = 3'b001; // SLTIU : Zero Extension
    wire [31:0] w_imm_i_ze = {20'h0, w_imm_i};

    localparam [2:0] IMM_S_SE = 3'b010; // SB, SH, SW
    wire [11:0] w_imm_s = {I_INSTR[31:25], I_INSTR[11:7]};
    wire [31:0] w_imm_s_se = {{20{w_imm_s[11]}},w_imm_s}; 

    localparam [2:0] IMM_B_SE = 3'b011; // BEQ, BNE, BLT, BGE, BLTU, BGEU
    wire [12:1] w_imm_b = {I_INSTR[31],I_INSTR[7],I_INSTR[30:25],I_INSTR[11:8]}; // B-type
    wire [31:0] w_imm_b_se = {{19{w_imm_b[12]}},w_imm_b,1'b0};

    localparam [2:0] IMM_U = 3'b100; // LUI, AUIPC
    wire [31:0] w_imm_u = {I_INSTR[31:12], 12'h0};

    localparam [2:0] IMM_J_SE = 3'b101; // JAL
    wire [20:1] w_imm_j = {I_INSTR[31],I_INSTR[19:12],I_INSTR[20],I_INSTR[30:21]};
    wire [31:0] w_imm_j_se = {{11{w_imm_j[20]}}, w_imm_j, 1'b0};

    localparam [2:0] IMM_DONC = 3'b101; // Dont Care
    wire [31:0] w_imm_donc = 32'hx;

    reg [33:0] r_ctrls;

    `define CTRLS {O_LUI, O_AUIPC, O_JAL, O_JALR, O_BEQ, O_BNE, O_BLT, O_BGE, O_BLTU, O_BGEU, O_LD, O_ST, O_SLT, O_SLTU, O_SLTI, O_SLTIU, O_AL_IMM, r_imm_type, O_MEM_WR_STRB, O_MEM_RD_STRB, O_ALU_OP_TYPE, O_REG_WR_EN, O_MEM_WR_EN, O_UNDEF_INSTR}

    always @(*) begin
        casex(I_INSTR)
//      +---------------+----------+-----+-------+-----+------+-----+-----+-----+-----+------+------+----+----+-----+-------+------+-------+--------+-----------+--------------+--------------+-------------+-----------+-----------+--------------+
//      |  Instruction  | Controls | LUI | AUIPC | JAL | JALR | BEQ | BNE | BLT | BGE | BLTU | BGEU | LD | ST | SLT | SLTU | SLTI | SLTIU | AL_IMM |  IMM_TYPE |  MEM_WR_STRB |  MEM_RD_STRB | ALU_OP_TYPE | REG_WR_EN | MEM_WR_EN |  UNDEF_INSTR |
//      +---------------+----------+-----+-------+-----+------+-----+-----+-----+-----+------+------+----+----+-----+-------+------+-------+--------+-----------+--------------+--------------+-------------+-----------------------+--------------+
            LUI_INSTR   : `CTRLS = {  T  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_U    ,   DONT_CARE  ,   DONT_CARE  ,     ADD     ,     T     ,     F     ,       F     };
            AUIPC_INSTR : `CTRLS = {  F  ,   T   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_U    ,   DONT_CARE  ,   DONT_CARE  ,     ADD     ,     T     ,     F     ,       F     };
            JAL_INSTR   : `CTRLS = {  F  ,   F   ,  T  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_J_SE ,   DONT_CARE  ,   DONT_CARE  ,     ADD     ,     T     ,     F     ,       F     };
            JALR_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   T  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     ADD     ,     T     ,     F     ,       F     };
            BEQ_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  T  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_B_SE ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     F     ,     F     ,       F     };
            BNE_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  T  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_B_SE ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     F     ,     F     ,       F     };
            BLT_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  T  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_B_SE ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     F     ,     F     ,       F     };
            BGE_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  T  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_B_SE ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     F     ,     F     ,       F     };
            BLTU_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   T  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_B_SE ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     F     ,     F     ,       F     };
            BGEU_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   T  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_B_SE ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     F     ,     F     ,       F     };
            LB_INSTR    : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  T ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_I_SE ,   DONT_CARE  ,   BYTE_STRB  ,     ADD     ,     T     ,     F     ,       F     };
            LH_INSTR    : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  T ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_I_SE ,   DONT_CARE  ,   HALF_STRB  ,     ADD     ,     T     ,     F     ,       F     };
            LW_INSTR    : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  T ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_I_SE ,   DONT_CARE  ,   WORD_STRB  ,     ADD     ,     T     ,     F     ,       F     };
            LBU_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  T ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     ADD     ,     T     ,     F     ,       F     };
            LHU_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  T ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     ADD     ,     T     ,     F     ,       F     };
            SB_INSTR    : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  T ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_S_SE ,   BYTE_STRB  ,   DONT_CARE  ,     ADD     ,     F     ,     T     ,       F     };
            SH_INSTR    : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  T ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_S_SE ,   HALF_STRB  ,   DONT_CARE  ,     ADD     ,     F     ,     T     ,       F     };
            SW_INSTR    : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  T ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_S_SE ,   WORD_STRB  ,   DONT_CARE  ,     ADD     ,     F     ,     T     ,       F     };
            ADDI_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    T   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     ADD     ,     T     ,     F     ,       F     };
            SLTI_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   T  ,   F   ,    F   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     T     ,     F     ,       F     };
            SLTIU_INSTR : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   T   ,    F   ,  IMM_I_ZE ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     T     ,     F     ,       F     };
            XORI_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    T   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     XOR     ,     T     ,     F     ,       F     };
            ORI_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    T   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     OR      ,     T     ,     F     ,       F     };
            ANDI_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    T   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     AND     ,     T     ,     F     ,       F     };
            SLLI_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    T   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     SLL     ,     T     ,     F     ,       F     };
            SRLI_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    T   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     SRL     ,     T     ,     F     ,       F     };
            SRAI_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    T   ,  IMM_I_SE ,   DONT_CARE  ,   DONT_CARE  ,     SRA     ,     T     ,     F     ,       F     };
            ADD_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     ADD     ,     T     ,     F     ,       F     };
            SUB_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     T     ,     F     ,       F     };
            SLL_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     SLL     ,     T     ,     F     ,       F     };
            SLT_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  T  ,   F   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     T     ,     F     ,       F     };
            SLTU_INSTR  : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   T   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     SUB     ,     T     ,     F     ,       F     };
            XOR_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     XOR     ,     T     ,     F     ,       F     };
            SRL_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     SRL     ,     T     ,     F     ,       F     };
            SRA_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     SRA     ,     T     ,     F     ,       F     };
            OR_INSTR    : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     OR      ,     T     ,     F     ,       F     };
            AND_INSTR   : `CTRLS = {  F  ,   F   ,  F  ,   F  ,  F  ,  F  ,  F  ,  F  ,   F  ,   F  ,  F ,  F ,  F  ,   F   ,   F  ,   F   ,    F   ,  IMM_DONC ,   DONT_CARE  ,   DONT_CARE  ,     AND     ,     T     ,     F     ,       F     };
            default     : `CTRLS = {                                                                                        33'hx                                                                                                   ,       T     };
        endcase
	end

    assign O_SRC1_ADDR = I_INSTR[19:15];
    assign O_SRC2_ADDR = I_INSTR[24:20];
    assign O_DST_ADDR  = I_INSTR[11: 7];

    assign O_IMM_I_SE = r_imm_type == IMM_I_SE ? w_imm_i_se : w_imm_donc; 
    assign O_IMM_I_ZE = r_imm_type == IMM_I_ZE ? w_imm_i_ze : w_imm_donc; 
    assign O_IMM_S_SE = r_imm_type == IMM_S_SE ? w_imm_s_se : w_imm_donc; 
    assign O_IMM_B_SE = r_imm_type == IMM_B_SE ? w_imm_b_se : w_imm_donc; 
    assign O_IMM_U    = r_imm_type == IMM_U    ? w_imm_u    : w_imm_donc; 
    assign O_IMM_J_SE = r_imm_type == IMM_J_SE ? w_imm_j_se : w_imm_donc; 

endmodule
