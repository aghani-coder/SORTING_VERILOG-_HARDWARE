
module top(clk,rstn,s,done,Radd,datain,wrin,rd,DOUT);

parameter DATA_WIDTH   = 8;
parameter ADDR_WIDTH=3; 
input [ADDR_WIDTH -1:0] Radd;
input  [DATA_WIDTH -1:0] datain;
output  [DATA_WIDTH -1:0] DOUT;
output  done;

input clk,rstn, s,wrin,rd;



wire eni,enj; // enable button for regcounter
wire ena,enb; // enable button for register  that are input of comparator
wire [ADDR_WIDTH -1:0] Li,Lj;
wire zi,zj;  //is flags  0 when they fulfill condition
wire [ADDR_WIDTH -1:0] Liout,Ljout,addrin,addrout; // address
wire  [DATA_WIDTH -1:0] Areg,Breg,dataout,AbMux,Din; // data
wire Agtb;// is aflag when A>B
wire csel,we,Bout;  // is based of input
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

 
 fsm #(ADDR_WIDTH) m9(.clk(clk),.s(s),.eni(eni),.enj(enj),.ena(ena),.enb(enb),.Li(Li),.Lj(Lj),.Liout(Liout),.Ljout(Ljout),.done(done),.zi(zi),.zj(zj),.csel(csel),.we(we),.Bout(Bout),.Agtb(Agtb));
 
endmodule



