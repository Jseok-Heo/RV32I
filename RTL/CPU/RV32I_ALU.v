/* 
 * RV32I Arithmetic Logic Unit (32 bits)
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description:
 * History:              
 *          2020.11.29 - Initial release
 */

module RV32I_ALU
(
     input      [31:0] I_OP_A
    ,input      [31:0] I_OP_B
    ,input      [ 2:0] I_OP_TYPE
    
    ,output reg [31:0] O_RESULT
    ,output            O_N
    ,output            O_Z
    ,output            O_C
    ,output            O_V
);

    localparam [2:0] ADD = 3'b000;
    localparam [2:0] SUB = 3'b001;
    localparam [2:0] AND = 3'b010;
    localparam [2:0] OR  = 3'b011;
    localparam [2:0] XOR = 3'b100;
    localparam [2:0] SLL = 3'b101;
    localparam [2:0] SRL = 3'b110;
    localparam [2:0] SRA = 3'b111;

    wire [31:0] w_adder_op_b;
    wire [31:0] w_sum;
    wire        w_is_sub;

    RCA_32 Inst_ADDER (
         .I_A    (I_OP_A)
        ,.I_B    (w_adder_op_b)
        ,.I_CI   (w_is_sub)
        ,.O_SUM  (w_sum)
        ,.O_CO   (O_C)
        ,.O_V    (O_V)
    );

    assign O_N = w_sum[31];
    assign O_Z = w_sum == 32'h0 ? 1'b1 : 1'b0;
    assign w_is_sub = I_OP_TYPE == SUB ? 1'b1 : 1'b0;
    assign w_adder_op_b = w_is_sub ? ~I_OP_B : I_OP_B;

    always @(*) begin
        case(I_OP_TYPE)
            ADD : O_RESULT = w_sum;
            SUB : O_RESULT = w_sum;
            AND : O_RESULT = I_OP_A &   I_OP_B;
            OR  : O_RESULT = I_OP_A |   I_OP_B;
            XOR : O_RESULT = I_OP_A ^   I_OP_B;
            SLL : O_RESULT = I_OP_A <<  I_OP_B[4:0];
            SRL : O_RESULT = I_OP_A >>  I_OP_B[4:0];
            SRA : O_RESULT = I_OP_A >>> I_OP_B[4:0];
        endcase
    end

endmodule
