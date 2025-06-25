
module register(clk,en,rstn,din,dout);
parameter DATA_WIDTH   = 8;
input [DATA_WIDTH -1:0] din;
output reg [DATA_WIDTH -1:0] dout;
input en,clk,rstn;
always@(posedge clk or negedge rstn)
begin
if(!rstn)
begin
dout<=0;
end
else if(en)
begin
dout<=din;
end
end
endmodule