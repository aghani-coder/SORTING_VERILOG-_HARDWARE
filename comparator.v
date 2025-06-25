
module comparator #(parameter DATA_WIDTH = 8)(
 input  [DATA_WIDTH-1:0] A,B,
 output  Agtb);
assign Agtb=(A>B)?  1'b1 : 1'b0;
endmodule