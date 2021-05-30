/* 
 * Carry Select Adder (4 bits)
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description:
 * History:              
 *          2020.11.29 - Initial release
 */

module CSA_4
(
     input  [3:0] I_A
    ,input  [3:0] I_B
    ,input        I_CI      // Carry In

    ,output [3:0] O_SUM
    ,output       O_CO      // Carry Out
    ,output       O_V       // Overflow
);
				
    wire [3:0]	w_sum_ci_0, w_sum_ci_1;
    wire        w_co_ci_0, w_co_ci_1;
    wire        w_v_ci_0, w_v_ci_1;


    /* When Carry In == 0, use Inst_RCA_CI_0 result */
    RCA_4 Inst_RCA_CI_0 ( .I_A(I_A), .I_B(I_B), .I_CI(1'b0), .O_SUM(w_sum_ci_0), .O_CO(w_co_ci_0), .O_V(w_v_ci_0) );

    /* When Carry In == 1, use Inst_RCA_CI_1 result */
    RCA_4 Inst_RCA_CI_1 ( .I_A(I_A), .I_B(I_B), .I_CI(1'b1), .s(w_sum_ci_1), .co(w_co_ci_1), .v(w_v_ci_1) );

    /* Select Sum */
    MUX_2 #( .DW(1) ) Inst_MUX2_SUM_U0 ( .I_0(w_sum_ci_0[0]), .I_1(w_sum_ci_1[0]), .I_SEL(I_CI), .O_DO(O_SUM[0]) );
    MUX_2 #( .DW(1) ) Inst_MUX2_SUM_U1 ( .I_0(w_sum_ci_0[1]), .I_1(w_sum_ci_1[1]), .I_SEL(I_CI), .O_DO(O_SUM[1]) );
    MUX_2 #( .DW(1) ) Inst_MUX2_SUM_U2 ( .I_0(w_sum_ci_0[2]), .I_1(w_sum_ci_1[2]), .I_SEL(I_CI), .O_DO(O_SUM[2]) );
    MUX_2 #( .DW(1) ) Inst_MUX2_SUM_U3 ( .I_0(w_sum_ci_0[3]), .I_1(w_sum_ci_1[3]), .I_SEL(I_CI), .O_DO(O_SUM[3]) );

    /* Select Carry Out */
    MUX_2 #( .DW(1) ) Inst_MUX2_CO ( .I_0(w_co_ci_0), .I_1(w_co_ci_1), .I_SEL(I_CI), .O_DO(O_CO) );

    /* Select Overflow */
    MUX_2 #( .DW(1) ) Inst_MUX2_V ( .I_0(w_v_ci_0), .I_1(w_v_ci_1),  .I_SEL(I_CI), .O_DO(O_V) );

endmodule
