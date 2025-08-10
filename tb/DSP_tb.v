module DSP48A1_tb();
reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
reg [7:0] OPMODE;
reg CLK,CEA,CEB,CEC,CED,CEM,CEP,CECARRYIN,CEOPMODE,RSTA,RSTB,RSTC,RSTD,RSTM,RSTP,RSTCARRYIN,RSTOPMODE,CARRYIN;
wire [47:0] PCOUT_DUT,P_DUT;
wire [17:0] BCOUT_DUT;
wire [35:0] M_DUT;
wire CARRYOUT_DUT,CARRYOUTF_DUT;
reg [47:0] PCOUT_expected,P_expected;
reg [17:0] BCOUT_expected;
reg [35:0] M_expected;
reg CARRYOUT_expected,CARRYOUTF_expected;
DSP48A1 DUT(A,B,C,D,OPMODE,BCIN,CEA,CEB,CEC,CED,CEM,CEP,CECARRYIN,CEOPMODE,PCIN,CLK,RSTA,RSTB,RSTC,RSTD,RSTM,RSTP,RSTCARRYIN,RSTOPMODE,CARRYIN,M_DUT,P_DUT,CARRYOUT_DUT,CARRYOUTF_DUT,PCOUT_DUT,BCOUT_DUT);
initial begin
    CLK=0;
    forever
    #1 CLK=~CLK;
end
initial begin
    // verify reset operation
    RSTA=1;RSTB=1;RSTC=1;RSTD=1;RSTM=1;RSTP=1;RSTCARRYIN=1;RSTOPMODE=1;
    A=$random;B=$random;D=$random;BCIN=$random;
    C=$random;PCIN=$random;OPMODE=$random;CEA=$random;CEB=$random;CEC=$random;
    CED=$random;CEM=$random;CEP=$random;CECARRYIN=$random;CEOPMODE=$random;CARRYIN=$random;
    @(negedge CLK);
    PCOUT_expected=0;P_expected=0;BCOUT_expected=0;
    M_expected=0;CARRYOUT_expected=0;CARRYOUTF_expected=0;
    if (PCOUT_expected!=PCOUT_DUT) begin
      $display("Error in rst operation");
      $stop;
    end
    if (P_expected!=P_DUT) begin
      $display("Error in rst operation");
      $stop;
    end
    if (CARRYOUTF_expected!=CARRYOUTF_DUT) begin
      $display("Error in rst operation");
      $stop;
    end
    if (BCOUT_expected!=BCOUT_DUT) begin
      $display("Error in rst operation");
      $stop;
    end
    if (M_expected!=M_DUT) begin
      $display("Error in rst operation");
      $stop;
    end
    if (CARRYOUT_expected!=CARRYOUT_DUT) begin
      $display("Error in rst operation");
      $stop;
    end
    RSTA=0;RSTB=0;RSTC=0;RSTD=0;RSTM=0;RSTP=0;RSTCARRYIN=0;RSTOPMODE=0;
    CEA=1;CEB=1;CEC=1;CED=1;CEM=1;CEP=1;CECARRYIN=1;CEOPMODE=1;
    // verify DSP path1
    OPMODE=8'b11011101;
    A=20;B=10;C=350;D=25;
    PCIN=$random;BCIN=$random;CARRYIN=$random;
    repeat (4) @(negedge CLK);
    PCOUT_expected=48'h32;P_expected=48'h32;BCOUT_expected=18'hf;
    M_expected=36'h12c;CARRYOUT_expected=0;CARRYOUTF_expected=0;
    if (PCOUT_expected!=PCOUT_DUT) begin
      $display("Error in DSP path 1");
      $stop;
    end
    if (P_expected!=P_DUT) begin
      $display("Error in DSP path 1");
      $stop;
    end
    if (CARRYOUTF_expected!=CARRYOUTF_DUT) begin
      $display("Error in DSP path 1");
      $stop;
    end
    if (BCOUT_expected!=BCOUT_DUT) begin
      $display("Error in DSP path 1");
      $stop;
    end
    if (M_expected!=M_DUT) begin
      $display("Error in DSP path 1");
      $stop;
    end
    if (CARRYOUT_expected!=CARRYOUT_DUT) begin
      $display("Error in DSP path 1");
      $stop;
    end
    // verify DSP path2
    OPMODE=8'b00010000;
    A=20;B=10;C=350;D=25;
    PCIN=$random;BCIN=$random;CARRYIN=$random;
    repeat (3) @(negedge CLK);
    PCOUT_expected=0;P_expected=0;BCOUT_expected=18'h23;
    M_expected=36'h2bc;CARRYOUT_expected=0;CARRYOUTF_expected=0;
    if (PCOUT_expected!=PCOUT_DUT) begin
      $display("Error in DSP path 2");
      $stop;
    end
    if (P_expected!=P_DUT) begin
      $display("Error in DSP path 2");
      $stop;
    end
    if (CARRYOUTF_expected!=CARRYOUTF_DUT) begin
      $display("Error in DSP path 2");
      $stop;
    end
    if (BCOUT_expected!=BCOUT_DUT) begin
      $display("Error in DSP path 2");
      $stop;
    end
    if (M_expected!=M_DUT) begin
      $display("Error in DSP path 2");
      $stop;
    end
    if (CARRYOUT_expected!=CARRYOUT_DUT) begin
      $display("Error in DSP path 2");
      $stop;
    end  
    // verify DSP path3
    OPMODE=8'b00001010;
    A=20;B=10;C=350;D=25;
    PCIN=$random;BCIN=$random;CARRYIN=$random;
    repeat (3) @(negedge CLK);
    PCOUT_expected=0;P_expected=0;BCOUT_expected=18'ha;
    M_expected=36'hc8;CARRYOUT_expected=0;CARRYOUTF_expected=0;
    if (PCOUT_expected!=PCOUT_DUT) begin
      $display("Error in DSP path 3");
      $stop;
    end
    if (P_expected!=P_DUT) begin
      $display("Error in DSP path 3");
      $stop;
    end
    if (CARRYOUTF_expected!=CARRYOUTF_DUT) begin
      $display("Error in DSP path 3");
      $stop;
    end
    if (BCOUT_expected!=BCOUT_DUT) begin
      $display("Error in DSP path 3");
      $stop;
    end
    if (M_expected!=M_DUT) begin
      $display("Error in DSP path 3");
      $stop;
    end
    if (CARRYOUT_expected!=CARRYOUT_DUT) begin
      $display("Error in DSP path 3");
      $stop;
    end  
    // verify DSP path4
    OPMODE=8'b10100111;
    A=5;B=6;C=350;D=25;
    PCIN=3000;BCIN=$random;CARRYIN=$random;
    repeat (3) @(negedge CLK);
    PCOUT_expected=48'hfe6fffec0bb1;P_expected=48'hfe6fffec0bb1;BCOUT_expected=18'h6;
    M_expected=36'h1e;CARRYOUT_expected=1;CARRYOUTF_expected=1;
    if (PCOUT_expected!=PCOUT_DUT) begin
      $display("Error in DSP path 4");
      $stop;
    end
    if (P_expected!=P_DUT) begin
      $display("Error in DSP path 4");
      $stop;
    end
    if (CARRYOUTF_expected!=CARRYOUTF_DUT) begin
      $display("Error in DSP path 4");
      $stop;
    end
    if (BCOUT_expected!=BCOUT_DUT) begin
      $display("Error in DSP path 4");
      $stop;
    end
    if (M_expected!=M_DUT) begin
      $display("Error in DSP path 4");
      $stop;
    end
    if (CARRYOUT_expected!=CARRYOUT_DUT) begin
      $display("Error in DSP path 4");
      $stop;
    end    
    $display("function is correct");
    $stop;        
end
endmodule