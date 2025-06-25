module checka #(parameter i = 8) (
    input  [i-1:0] in,
    output        zi
);

localparam MAX_VAL  = (1 << (i)) - 2;     
assign zi = (in != MAX_VAL)  ? 1'b1 : 1'b0; // Check if not equal to max

endmodule
module checkb #(parameter i = 8) (
    input  [i-1:0] in,
    output        zj
);

localparam MAX_VAL = (1 << (i)) -1;    

assign zj = (in != MAX_VAL) ? 1'b1 : 1'b0; // Check if not equal to max-1

endmodule