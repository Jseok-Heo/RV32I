/* 
 * MUX 2 to 1
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description:
 * History:              
 *          2020.11.29 - Initial release
 */

module MUX_2
#(
    parameter DW = 32   // Data Width
)
(
     input [DW-1:0] I_0
    ,input [DW-1:0] I_1
    ,input          I_SEL

    ,output [DW-1:0] O_DO    // Data Out
);
					
    assign O_DO = (I_SEL) ? I_1 : I_0;

endmodule
