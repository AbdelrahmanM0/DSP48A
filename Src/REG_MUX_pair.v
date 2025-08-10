module REG_MUX_pair(clk,rst,inp,CE,out);
parameter RESETTYPE="SYNC";
parameter SELECT=0;
parameter WIDTH=18;
input clk,rst,CE;
input [WIDTH-1:0] inp;
output  [WIDTH-1:0] out;
reg [WIDTH-1:0] out_comb;
reg [WIDTH-1:0] out_reg;
assign out = out_comb;
generate
    if(RESETTYPE=="ASYNC") begin
      always @(posedge clk or posedge rst) begin
        if(rst)
           out_reg<=0;
        else begin
            if(CE)
              out_reg<=inp;
        end        
      end
    end
    else begin
      always @(posedge clk) begin
        if(rst)
           out_reg<=0;
        else begin
            if(CE)
              out_reg<=inp;
        end
        end  
    end
endgenerate
always @(*) begin
    case (SELECT)
        0: out_comb=inp;
        default: out_comb=out_reg;            
    endcase
end
endmodule