/* 
 * Carry Select Adder (32 bits)
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description:
 * History:              
 *          2020.11.29 - Initial release
 */

module CSA_32
(
     input  [31:0] I_A
    ,input  [31:0] I_B
    ,input         I_CI

    ,output [31:0] O_SUM
    ,output        O_CO
    ,output        O_V
);
				
    wire [6:0] w_co2ci;

    RCA_4 Inst_RCA_4 ( .I_A(I_A[3:0]), .I_B(I_B[3:0]), .I_CI(I_CI), .O_SUM(O_SUM[3:0]), .O_CO(w_co2ci[0]), .O_V() );

    CSA_4 Inst_CSA_4_U0 ( .I_A(I_A[ 7: 4]), .I_B(I_B[ 7: 4]), .I_CI(w_co2ci[0]), .O_SUM(O_SUM[ 7: 4]), .O_CO(w_co2ci[1]), .O_V(   ) );
    CSA_4 Inst_CSA_4_U1 ( .I_A(I_A[11: 8]), .I_B(I_B[11: 8]), .I_CI(w_co2ci[1]), .O_SUM(O_SUM[11: 8]), .O_CO(w_co2ci[2]), .O_V(   ) );
    CSA_4 Inst_CSA_4_U2 ( .I_A(I_A[15:12]), .I_B(I_B[15:12]), .I_CI(w_co2ci[2]), .O_SUM(O_SUM[15:12]), .O_CO(w_co2ci[3]), .O_V(   ) );
    CSA_4 Inst_CSA_4_U3 ( .I_A(I_A[19:16]), .I_B(I_B[19:16]), .I_CI(w_co2ci[3]), .O_SUM(O_SUM[19:16]), .O_CO(w_co2ci[4]), .O_V(   ) );
    CSA_4 Inst_CSA_4_U4 ( .I_A(I_A[23:20]), .I_B(I_B[23:20]), .I_CI(w_co2ci[4]), .O_SUM(O_SUM[23:20]), .O_CO(w_co2ci[5]), .O_V(   ) );
    CSA_4 Inst_CSA_4_U5 ( .I_A(I_A[27:24]), .I_B(I_B[27:24]), .I_CI(w_co2ci[5]), .O_SUM(O_SUM[27:24]), .O_CO(w_co2ci[6]), .O_V(   ) );
    CSA_4 Inst_CSA_4_U6 ( .I_A(I_A[31:28]), .I_B(I_B[31:28]), .I_CI(w_co2ci[6]), .O_SUM(O_SUM[31:28]), .O_CO(O_CO),       .O_V(O_V) );

endmodule
