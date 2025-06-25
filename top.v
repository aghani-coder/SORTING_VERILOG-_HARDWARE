
module top(clk,rstn,s,done,Radd,datain,wrin,rd,DOUT);

parameter DATA_WIDTH   = 8;
parameter ADDR_WIDTH=3; 
input [ADDR_WIDTH -1:0] Radd;
input  [DATA_WIDTH -1:0] datain;
output  [DATA_WIDTH -1:0] DOUT;
input clk,rstn, s,wrin,rd;

reg [2:0] nstate;
reg [2:0] pstate;
output reg done;
reg eni,enj; // enable button for regcounter
reg ena,enb; // enable button for register  that are input of comparator
reg [ADDR_WIDTH -1:0] Li,Lj;
wire zi,zj;  //is flags  0 when they fulfill condition
wire [ADDR_WIDTH -1:0] Liout,Ljout,addrin,addrout; // address
wire  [DATA_WIDTH -1:0] Areg,Breg,dataout,AbMux,Din; // data
wire Agtb;// is aflag when A>B
reg csel,we,Bout;  // is based of input
regcounter  #(ADDR_WIDTH) m1(.rstn(rstn),.clk(clk),.en(eni),.ldin(Li),.ldout(Liout));
regcounter  #(ADDR_WIDTH) m2(.rstn(rstn),.clk(clk),.en(enj),.ldin(Lj),.ldout(Ljout));
checka #(ADDR_WIDTH) m3(
    .in(Liout),
     .zi(zi)
);
checkb #(ADDR_WIDTH) m4(
    .in(Ljout),
     .zj(zj)
);
  assign addrin=csel?Ljout:Liout;
  assign addrout=(s)?addrin:Radd;
  assign AbMux=Bout?Breg:Areg;
  assign Din=(s)?AbMux:datain;
  
  
 RAM#(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) m5(.we((we|wrin)),.clk(clk),.din(Din),.addr(addrout),.dout(dataout));
 register#(DATA_WIDTH) m6(.clk(clk),.en(ena),.rstn(rstn),.din(dataout),.dout(Areg));
 register#(DATA_WIDTH) m7(.clk(clk),.en(enb),.rstn(rstn),.din(dataout),.dout(Breg));
 comparator #(DATA_WIDTH) m8( .A(Areg),.B(Breg),.Agtb(Agtb));
 assign  DOUT=rd?dataout:0;
always @ (posedge clk ) begin
    pstate <= nstate;
end
always@(*)
begin
case(pstate)
3'b000:begin // inital state will not got to next state if s=1
done=1'b0;
we=1'b0;
if(s==0)begin
nstate=3'b000;
Li=0;
eni=1'b1;
end
else if(s==1)
nstate=3'b001;
 end
 
3'b001:begin  // in this state Li will have a value 
nstate=3'b010;
Lj=Liout+1'b1;
enj=1'b1;
csel=0;
ena=1;
     end
3'b010:begin //Lj
csel=1;
ena=0;
enb=1;
nstate=3'b011;
end
3'b011:begin // compare

ena=0;enb=0;
if(Agtb)
begin
nstate=3'b100;
csel=1'b0;
we=1;
Bout=1;

end
else
nstate=3'b110;
     end
3'b100:// value changed if Agtb=1
begin 
nstate=3'b101;
we=1'b1;
csel=1;
Bout=1'b0;
    end
3'b101:begin nstate=3'b110;
we=0;
csel=0;

ena=1;    end
3'b110:begin // check based on flags
ena=0;
if(zj)  
begin
Lj=Ljout+1'b1;
enj=1;
nstate=3'b010;
end
else if(zi)
begin
Li=Liout+1'b1;
eni=1;
nstate=3'b001;
end
else
nstate=3'b111;
	end
3'b111:begin // will be end state until s=0
done=1;
if(s==1)
begin
nstate=3'b111; 
end 
else 
begin
nstate=3'b000;
done =0;
end
end
default:
begin
	nstate=3'b000;
   ena=1'b0;
	enb=1'b0;
	eni=1'b0;
	enj=1'b0;
	Bout=1'b0;
	we=1'b0;
	done=1'b0;
	Li=0;
	Lj=0;
	end
endcase
end

 
endmodule