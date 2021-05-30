/* 
 * Half Adder
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description: 1-bit Half Adder
 * History:              
 *          2020.11.29 - Initial release
 */

module H_ADD
(
     input  I_A
    ,input  I_B

    ,output O_SUM
    ,output O_CO    // Carry Out
);

    assign O_SUM = I_A ^ I_B;
    assign O_CO = I_A & I_B;

endmodule
