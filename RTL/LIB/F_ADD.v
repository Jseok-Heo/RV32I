/* 
 * Full Adder
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description: 1-bit Full Adder
 * History:              
 *          2020.11.29 - Initial release
 */

module F_ADD
(
     input I_A
    ,input I_B
    ,input I_CI     // Carry In

    ,output O_SUM
    ,output O_CO    // Carry Out
);

    wire w_a_xor_b = I_A ^ I_B;
			
    assign O_SUM = w_a_xor_b ^ I_CI;
    assign O_CO = (w_a_xor_b & I_CI) | (I_A & I_B); 

endmodule
