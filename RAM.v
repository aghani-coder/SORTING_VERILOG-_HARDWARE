


module RAM(we,clk,din,addr,dout);
parameter DATA_WIDTH   = 8;
parameter ADDR_WIDTH   = 4;
input we,clk;
input [DATA_WIDTH-1:0] din;
input [ADDR_WIDTH -1:0] addr;
output  [DATA_WIDTH-1:0] dout;
reg [DATA_WIDTH-1:0]  predefined_values [0:(1<<(ADDR_WIDTH))-1];
initial
begin
 predefined_values[0] = 8'd90;
 predefined_values[1] = 8'd25;
 predefined_values[2] = 8'd60;
 predefined_values[3] = 8'd15;
 predefined_values[4] = 8'd30;
 predefined_values[5] = 8'd75;
 predefined_values[6] = 8'd45;
 predefined_values[7] = 8'd10;
 
// for(int i=8;i<((1<<ADDR_WIDTH)-1);i=i+1)
//   predefined_values[i]=0;
end 

always@(posedge clk)
begin
if(we)
  begin
  predefined_values[addr]=din;
  
 
 end
 end
 assign dout= predefined_values[addr];
 endmodule
  