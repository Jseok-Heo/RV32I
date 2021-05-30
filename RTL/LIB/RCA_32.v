/* 
 * Ripple Carry Adder (32 bits)
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description:
 * History:              
 *          2020.11.29 - Initial release
 */

module RCA_32
(
     input  [31:0] I_A
    ,input  [31:0] I_B
    ,input         I_CI      // Carry In

    ,output [31:0] O_SUM
    ,output        O_CO      // Carry Out
    ,output        O_V       // Overflow
);

    wire [30:0] w_co2ci;

    F_ADD Inst_F_ADD_U00 ( .I_A(I_A[ 0]), .I_B(I_B[ 0]), .I_CI(I_CI       ), .O_SUM(O_SUM[ 0]), .O_CO(w_co2ci [0]) );
    F_ADD Inst_F_ADD_U01 ( .I_A(I_A[ 1]), .I_B(I_B[ 1]), .I_CI(w_co2ci[ 0]), .O_SUM(O_SUM[ 1]), .O_CO(w_co2ci[ 1]) );
    F_ADD Inst_F_ADD_U02 ( .I_A(I_A[ 2]), .I_B(I_B[ 2]), .I_CI(w_co2ci[ 1]), .O_SUM(O_SUM[ 2]), .O_CO(w_co2ci[ 2]) );
    F_ADD Inst_F_ADD_U03 ( .I_A(I_A[ 3]), .I_B(I_B[ 3]), .I_CI(w_co2ci[ 2]), .O_SUM(O_SUM[ 3]), .O_CO(w_co2ci[ 3]) );
    F_ADD Inst_F_ADD_U04 ( .I_A(I_A[ 4]), .I_B(I_B[ 4]), .I_CI(w_co2ci[ 3]), .O_SUM(O_SUM[ 4]), .O_CO(w_co2ci[ 4]) );
    F_ADD Inst_F_ADD_U05 ( .I_A(I_A[ 5]), .I_B(I_B[ 5]), .I_CI(w_co2ci[ 4]), .O_SUM(O_SUM[ 5]), .O_CO(w_co2ci[ 5]) );
    F_ADD Inst_F_ADD_U06 ( .I_A(I_A[ 6]), .I_B(I_B[ 6]), .I_CI(w_co2ci[ 5]), .O_SUM(O_SUM[ 6]), .O_CO(w_co2ci[ 6]) );
    F_ADD Inst_F_ADD_U07 ( .I_A(I_A[ 7]), .I_B(I_B[ 7]), .I_CI(w_co2ci[ 6]), .O_SUM(O_SUM[ 7]), .O_CO(w_co2ci[ 7]) );
    F_ADD Inst_F_ADD_U08 ( .I_A(I_A[ 8]), .I_B(I_B[ 8]), .I_CI(w_co2ci[ 7]), .O_SUM(O_SUM[ 8]), .O_CO(w_co2ci[ 8]) );
    F_ADD Inst_F_ADD_U09 ( .I_A(I_A[ 9]), .I_B(I_B[ 9]), .I_CI(w_co2ci[ 8]), .O_SUM(O_SUM[ 9]), .O_CO(w_co2ci[ 9]) );
    F_ADD Inst_F_ADD_U10 ( .I_A(I_A[10]), .I_B(I_B[10]), .I_CI(w_co2ci[ 9]), .O_SUM(O_SUM[10]), .O_CO(w_co2ci[10]) );
    F_ADD Inst_F_ADD_U11 ( .I_A(I_A[11]), .I_B(I_B[11]), .I_CI(w_co2ci[10]), .O_SUM(O_SUM[11]), .O_CO(w_co2ci[11]) );
    F_ADD Inst_F_ADD_U12 ( .I_A(I_A[12]), .I_B(I_B[12]), .I_CI(w_co2ci[11]), .O_SUM(O_SUM[12]), .O_CO(w_co2ci[12]) );
    F_ADD Inst_F_ADD_U13 ( .I_A(I_A[13]), .I_B(I_B[13]), .I_CI(w_co2ci[12]), .O_SUM(O_SUM[13]), .O_CO(w_co2ci[13]) );
    F_ADD Inst_F_ADD_U14 ( .I_A(I_A[14]), .I_B(I_B[14]), .I_CI(w_co2ci[13]), .O_SUM(O_SUM[14]), .O_CO(w_co2ci[14]) );
    F_ADD Inst_F_ADD_U15 ( .I_A(I_A[15]), .I_B(I_B[15]), .I_CI(w_co2ci[14]), .O_SUM(O_SUM[15]), .O_CO(w_co2ci[15]) );
    F_ADD Inst_F_ADD_U16 ( .I_A(I_A[16]), .I_B(I_B[16]), .I_CI(w_co2ci[15]), .O_SUM(O_SUM[16]), .O_CO(w_co2ci[16]) );
    F_ADD Inst_F_ADD_U17 ( .I_A(I_A[17]), .I_B(I_B[17]), .I_CI(w_co2ci[16]), .O_SUM(O_SUM[17]), .O_CO(w_co2ci[17]) );
    F_ADD Inst_F_ADD_U18 ( .I_A(I_A[18]), .I_B(I_B[18]), .I_CI(w_co2ci[17]), .O_SUM(O_SUM[18]), .O_CO(w_co2ci[18]) );
    F_ADD Inst_F_ADD_U19 ( .I_A(I_A[19]), .I_B(I_B[19]), .I_CI(w_co2ci[18]), .O_SUM(O_SUM[19]), .O_CO(w_co2ci[19]) );
    F_ADD Inst_F_ADD_U20 ( .I_A(I_A[20]), .I_B(I_B[20]), .I_CI(w_co2ci[19]), .O_SUM(O_SUM[20]), .O_CO(w_co2ci[20]) );
    F_ADD Inst_F_ADD_U21 ( .I_A(I_A[21]), .I_B(I_B[21]), .I_CI(w_co2ci[20]), .O_SUM(O_SUM[21]), .O_CO(w_co2ci[21]) );
    F_ADD Inst_F_ADD_U22 ( .I_A(I_A[22]), .I_B(I_B[22]), .I_CI(w_co2ci[21]), .O_SUM(O_SUM[22]), .O_CO(w_co2ci[22]) );
    F_ADD Inst_F_ADD_U23 ( .I_A(I_A[23]), .I_B(I_B[23]), .I_CI(w_co2ci[22]), .O_SUM(O_SUM[23]), .O_CO(w_co2ci[23]) );
    F_ADD Inst_F_ADD_U24 ( .I_A(I_A[24]), .I_B(I_B[24]), .I_CI(w_co2ci[23]), .O_SUM(O_SUM[24]), .O_CO(w_co2ci[24]) );
    F_ADD Inst_F_ADD_U25 ( .I_A(I_A[25]), .I_B(I_B[25]), .I_CI(w_co2ci[24]), .O_SUM(O_SUM[25]), .O_CO(w_co2ci[25]) );
    F_ADD Inst_F_ADD_U26 ( .I_A(I_A[26]), .I_B(I_B[26]), .I_CI(w_co2ci[25]), .O_SUM(O_SUM[26]), .O_CO(w_co2ci[26]) );
    F_ADD Inst_F_ADD_U27 ( .I_A(I_A[27]), .I_B(I_B[27]), .I_CI(w_co2ci[26]), .O_SUM(O_SUM[27]), .O_CO(w_co2ci[27]) );
    F_ADD Inst_F_ADD_U28 ( .I_A(I_A[28]), .I_B(I_B[28]), .I_CI(w_co2ci[27]), .O_SUM(O_SUM[28]), .O_CO(w_co2ci[28]) );
    F_ADD Inst_F_ADD_U29 ( .I_A(I_A[29]), .I_B(I_B[29]), .I_CI(w_co2ci[28]), .O_SUM(O_SUM[29]), .O_CO(w_co2ci[29]) );
    F_ADD Inst_F_ADD_U30 ( .I_A(I_A[30]), .I_B(I_B[30]), .I_CI(w_co2ci[29]), .O_SUM(O_SUM[30]), .O_CO(w_co2ci[30]) );
    F_ADD Inst_F_ADD_U31 ( .I_A(I_A[31]), .I_B(I_B[31]), .I_CI(w_co2ci[30]), .O_SUM(O_SUM[31]), .O_CO(O_CO       ) );

    assign O_V = O_CO ^ w_co2ci[30];

endmodule
