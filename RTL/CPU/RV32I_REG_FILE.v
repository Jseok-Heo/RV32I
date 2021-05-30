/* 
 * RV32I Register File
 * Copyright (C) 2020, Jaeseok Heo (jseok.heo@gmail.com)
 * 
 * Description: 32-bit x 32 GPRs
 *              The x0 register is hardwired to 0 (Read-only)
 * History:              
 *          2020.11.29 - Initial release
 */

module RV32I_REG_FILE
(
     input              I_CLK
    ,input      [4:0]   I_SRC1_ADDR
    ,input      [4:0]   I_SRC2_ADDR
    ,input      [4:0]   I_DST_ADDR
    ,input      [31:0]  I_DST_DATA
    ,input              I_WR_EN

    ,output reg [31:0]  O_SRC1_DATA
    ,output reg [31:0]  O_SRC2_DATA
);

    wire [31:0] w_x0;

    reg [31:0] r_x[1:31];

    assign w_x0 = 32'h0;

    always @(posedge I_CLK) begin
        if(I_WR_EN) begin
            case(I_DST_ADDR)
                5'd0:                         ; // NOP
                5'd1:    r_x[ 1] <= I_DST_DATA;
                5'd2:    r_x[ 2] <= I_DST_DATA;
                5'd3:    r_x[ 3] <= I_DST_DATA;
                5'd4:    r_x[ 4] <= I_DST_DATA;
                5'd5:    r_x[ 5] <= I_DST_DATA;
                5'd6:    r_x[ 6] <= I_DST_DATA;
                5'd7:    r_x[ 7] <= I_DST_DATA;
                5'd8:    r_x[ 8] <= I_DST_DATA;
                5'd9:    r_x[ 9] <= I_DST_DATA;
                5'd10:   r_x[10] <= I_DST_DATA;
                5'd11:   r_x[11] <= I_DST_DATA;
                5'd12:   r_x[12] <= I_DST_DATA;
                5'd13:   r_x[13] <= I_DST_DATA;
                5'd14:   r_x[14] <= I_DST_DATA;
                5'd15:   r_x[15] <= I_DST_DATA;
                5'd16:   r_x[16] <= I_DST_DATA;
                5'd17:   r_x[17] <= I_DST_DATA;
                5'd18:   r_x[18] <= I_DST_DATA;
                5'd19:   r_x[19] <= I_DST_DATA;
                5'd20:   r_x[20] <= I_DST_DATA;
                5'd21:   r_x[21] <= I_DST_DATA;
                5'd22:   r_x[22] <= I_DST_DATA;
                5'd23:   r_x[23] <= I_DST_DATA;
                5'd24:   r_x[24] <= I_DST_DATA;
                5'd25:   r_x[25] <= I_DST_DATA;
                5'd26:   r_x[26] <= I_DST_DATA;
                5'd27:   r_x[27] <= I_DST_DATA;
                5'd28:   r_x[28] <= I_DST_DATA;
                5'd29:   r_x[29] <= I_DST_DATA;
                5'd30:   r_x[30] <= I_DST_DATA;
                5'd31:   r_x[31] <= I_DST_DATA;
            endcase
        end
    end

    always @(*) begin
        case(I_SRC1_ADDR)
            5'd0:    O_SRC1_DATA = w_x0   ;
            5'd1:    O_SRC1_DATA = r_x[ 1];
            5'd2:    O_SRC1_DATA = r_x[ 2];
            5'd3:    O_SRC1_DATA = r_x[ 3];
            5'd4:    O_SRC1_DATA = r_x[ 4];
            5'd5:    O_SRC1_DATA = r_x[ 5];
            5'd6:    O_SRC1_DATA = r_x[ 6];
            5'd7:    O_SRC1_DATA = r_x[ 7];
            5'd8:    O_SRC1_DATA = r_x[ 8];
            5'd9:    O_SRC1_DATA = r_x[ 9];
            5'd10:   O_SRC1_DATA = r_x[10];
            5'd11:   O_SRC1_DATA = r_x[11];
            5'd12:   O_SRC1_DATA = r_x[12];
            5'd13:   O_SRC1_DATA = r_x[13];
            5'd14:   O_SRC1_DATA = r_x[14];
            5'd15:   O_SRC1_DATA = r_x[15];
            5'd16:   O_SRC1_DATA = r_x[16];
            5'd17:   O_SRC1_DATA = r_x[17];
            5'd18:   O_SRC1_DATA = r_x[18];
            5'd19:   O_SRC1_DATA = r_x[19];
            5'd20:   O_SRC1_DATA = r_x[20];
            5'd21:   O_SRC1_DATA = r_x[21];
            5'd22:   O_SRC1_DATA = r_x[22];
            5'd23:   O_SRC1_DATA = r_x[23];
            5'd24:   O_SRC1_DATA = r_x[24];
            5'd25:   O_SRC1_DATA = r_x[25];
            5'd26:   O_SRC1_DATA = r_x[26];
            5'd27:   O_SRC1_DATA = r_x[27];
            5'd28:   O_SRC1_DATA = r_x[28];
            5'd29:   O_SRC1_DATA = r_x[29];
            5'd30:   O_SRC1_DATA = r_x[30];
            5'd31:   O_SRC1_DATA = r_x[31];
        endcase
    end

    always @(*) begin
        case(I_SRC2_ADDR)
            5'd0:    O_SRC2_DATA = w_x0   ;
            5'd1:    O_SRC2_DATA = r_x[ 1];
            5'd2:    O_SRC2_DATA = r_x[ 2];
            5'd3:    O_SRC2_DATA = r_x[ 3];
            5'd4:    O_SRC2_DATA = r_x[ 4];
            5'd5:    O_SRC2_DATA = r_x[ 5];
            5'd6:    O_SRC2_DATA = r_x[ 6];
            5'd7:    O_SRC2_DATA = r_x[ 7];
            5'd8:    O_SRC2_DATA = r_x[ 8];
            5'd9:    O_SRC2_DATA = r_x[ 9];
            5'd10:   O_SRC2_DATA = r_x[10];
            5'd11:   O_SRC2_DATA = r_x[11];
            5'd12:   O_SRC2_DATA = r_x[12];
            5'd13:   O_SRC2_DATA = r_x[13];
            5'd14:   O_SRC2_DATA = r_x[14];
            5'd15:   O_SRC2_DATA = r_x[15];
            5'd16:   O_SRC2_DATA = r_x[16];
            5'd17:   O_SRC2_DATA = r_x[17];
            5'd18:   O_SRC2_DATA = r_x[18];
            5'd19:   O_SRC2_DATA = r_x[19];
            5'd20:   O_SRC2_DATA = r_x[20];
            5'd21:   O_SRC2_DATA = r_x[21];
            5'd22:   O_SRC2_DATA = r_x[22];
            5'd23:   O_SRC2_DATA = r_x[23];
            5'd24:   O_SRC2_DATA = r_x[24];
            5'd25:   O_SRC2_DATA = r_x[25];
            5'd26:   O_SRC2_DATA = r_x[26];
            5'd27:   O_SRC2_DATA = r_x[27];
            5'd28:   O_SRC2_DATA = r_x[28];
            5'd29:   O_SRC2_DATA = r_x[29];
            5'd30:   O_SRC2_DATA = r_x[30];
            5'd31:   O_SRC2_DATA = r_x[31];
        endcase
    end

endmodule
