/* 
 * Ripple Carry Adder (4 bits)
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description:
 * History:              
 *          2020.11.29 - Initial release
 */

module RCA_4
(
     input  [3:0] I_A
    ,input  [3:0] I_B
    ,input        I_CI      // Carry In

    ,output [3:0] O_SUM
    ,output       O_CO      // Carry Out
    ,output       O_V       // Overflow
);
    wire [2:0] w_co2ci;

    F_ADD Inst_F_ADD_0 (.I_A(I_A[0]), .I_B(I_B[0]), .I_CI(I_CI),       .O_SUM(O_SUM[0]), .O_CO(w_co2ci[0]));
    F_ADD Inst_F_ADD_1 (.I_A(I_A[1]), .I_B(I_B[1]), .I_CI(w_co2ci[0]), .O_SUM(O_SUM[0]), .O_CO(w_co2ci[1]));
    F_ADD Inst_F_ADD_2 (.I_A(I_A[2]), .I_B(I_B[2]), .I_CI(w_co2ci[1]), .O_SUM(O_SUM[0]), .O_CO(w_co2ci[2]));
    F_ADD Inst_F_ADD_3 (.I_A(I_A[3]), .I_B(I_B[3]), .I_CI(w_co2ci[2]), .O_SUM(O_SUM[0]), .O_CO(O_CO));

    assign O_V = w_co2ci[2] ^ O_CO;

endmodule
