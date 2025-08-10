module DSP48A1 (A,B,C,D,OPMODE,BCIN,CEA,CEB,CEC,CED,CEM,CEP,CECARRYIN,CEOPMODE,PCIN,CLK,RSTA,RSTB,RSTC,RSTD,RSTM,RSTP,RSTCARRYIN,RSTOPMODE,
CARRYIN,M, P, CARRYOUT, CARRYOUTF, PCOUT, BCOUT);
input CEA,CEB,CEC,CED,CEM,CEP,CECARRYIN,CEOPMODE;
input CLK,RSTA,RSTB,RSTC,RSTD,RSTM,RSTP,RSTCARRYIN,RSTOPMODE;
input CARRYIN;
input [17:0] A,B,D,BCIN;
input [47:0] C,PCIN;
input [7:0] OPMODE;
output reg CARRYOUT,CARRYOUTF;
output reg [47:0] P,PCOUT;
output reg [35:0] M;
output reg [17:0] BCOUT;
wire [17:0] D_REG_OUT,B0_REG_OUT,A0_REG_OUT,B1_REG_OUT,A1_REG_OUT;
wire [47:0] C_REG_OUT,P_REG_OUT;
wire [35:0] M_REG_OUT;
wire [7:0]  OPMODE_REG_OUT;
wire CYI_OUT, CYO_OUT;
reg [17:0] B0_REG_inp,PRE_OUT,B1_reg_inp;
reg [47:0] POST_OUT,Z_OUT,X_OUT;
reg [35:0] multipler_out;
reg CYI_inp;
parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG  = 1;
parameter DREG  = 1;
parameter MREG  = 1;
parameter PREG  = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";
REG_MUX_pair #(.WIDTH(8),.SELECT(OPMODEREG))  OPMODE_REG(CLK,RSTOPMODE,OPMODE,CEOPMODE,OPMODE_REG_OUT);
REG_MUX_pair #(.WIDTH(18),.SELECT(DREG))     D_REG(CLK,RSTD,D,CED,D_REG_OUT);
REG_MUX_pair #(.WIDTH(18),.SELECT(B0REG))    B0_REG(CLK,RSTB,B0_REG_inp,CEB,B0_REG_OUT);
REG_MUX_pair #(.WIDTH(18),.SELECT(A0REG))    A0_REG(CLK,RSTA,A,CEA,A0_REG_OUT);
REG_MUX_pair #(.WIDTH(48),.SELECT(CREG))     C_REG(CLK,RSTC,C,CEC,C_REG_OUT);
REG_MUX_pair #(.WIDTH(18),.SELECT(B1REG))    B1_REG(CLK,RSTB,B1_reg_inp,CEB,B1_REG_OUT);
REG_MUX_pair #(.WIDTH(18),.SELECT(A1REG))    A1_REG(CLK,RSTA,A0_REG_OUT,CEA,A1_REG_OUT);
REG_MUX_pair #(.WIDTH(36),.SELECT(MREG))     M_REG(CLK,RSTM,multipler_out,CEM,M_REG_OUT);
REG_MUX_pair #(.WIDTH(1),.SELECT(CARRYINREG)) CYI(CLK,RSTCARRYIN,CYI_inp,CECARRYIN,CYI_OUT);
REG_MUX_pair #(.WIDTH(1),.SELECT(CARRYOUTREG)) CYO(CLK,RSTCARRYIN,POST_OUT[47],CECARRYIN,CYO_OUT);
REG_MUX_pair #(.WIDTH(48),.SELECT(PREG))       P_REG(CLK,RSTP,POST_OUT,CEP,P_REG_OUT);
always @(*) begin
    case (B_INPUT)
        "DIRECT" : B0_REG_inp = B;
        "CASCADE": B0_REG_inp = BCIN;
        default  : B0_REG_inp = 0;
    endcase
    if (OPMODE_REG_OUT[6])
        PRE_OUT = D_REG_OUT - B0_REG_OUT;
    else
        PRE_OUT = D_REG_OUT + B0_REG_OUT;
    case (OPMODE_REG_OUT[4])
        0       : B1_reg_inp = B0_REG_OUT;
        default : B1_reg_inp = PRE_OUT;
    endcase
    BCOUT = B1_REG_OUT;
    multipler_out = B1_REG_OUT * A1_REG_OUT;
    // X input selection
    case (OPMODE_REG_OUT[1:0])
        2'b00   : X_OUT = 0;
        2'b01   : X_OUT = {12'b0, M_REG_OUT}; // zero-extend 36 bits to 48
        2'b10   : X_OUT = P;
        default : X_OUT = {D_REG_OUT[11:0], A0_REG_OUT, B0_REG_OUT}; // build custom 48-bit value
    endcase
    // Z input selection
    case (OPMODE_REG_OUT[3:2])
        2'b00   : Z_OUT = 0;
        2'b01   : Z_OUT = PCIN;
        2'b10   : Z_OUT = P;
        default : Z_OUT = C_REG_OUT;
    endcase
    if (OPMODE_REG_OUT[7])
        POST_OUT = Z_OUT - (X_OUT + CYI_OUT);
    else
        POST_OUT = Z_OUT + X_OUT + CYI_OUT;
    case (CARRYINSEL)
        "OPMODE5": CYI_inp = OPMODE_REG_OUT[5];
        "CARRYIN": CYI_inp = CARRYIN;
        default  : CYI_inp = 0;
    endcase
    PCOUT       = P_REG_OUT;
    P           = P_REG_OUT;
    M           = M_REG_OUT;
    CARRYOUT    = CYO_OUT;
    CARRYOUTF   = CYO_OUT;
end
endmodule