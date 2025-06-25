

module regcounter(rstn,clk,en,ldin,ldout);
parameter DATA_WIDTH   = 8;
input [DATA_WIDTH -1:0] ldin;

output reg [DATA_WIDTH -1:0] ldout;
input rstn,en,clk;

always@(posedge clk or negedge rstn)
begin
if(!rstn)
begin
ldout<=0;
end
else if(en)
begin
ldout<=ldin;
end
end
endmodule

