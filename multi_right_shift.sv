// Code your design here
// https://edaplayground.com/x/rDbk
module multi_shift#(parameter N=16)(
  input [N-1:0] x,
  input [N-1:0] s,
  output [N-1:0] o,
  output [N-1:0][N-1:0] otemp
);
  
  genvar i, j;
  
  bit [N-1:0] temp [N];
  bit [N-1:0] temp1 [N+1];
  
  assign temp[0] = x;
  assign temp1[0] = s[0] ? temp[0] : temp1[1];
  assign temp1[N] = 0;
  assign otemp[0] = temp[0];
  
  generate 
    for(i=1; i <= N-1; i++)begin
      Rshift#(N) R(
        .i(temp[i-1]),
        .o(temp[i])
      );
      assign temp1[i] = s[i] ? temp[i] : temp1[i+1];
      assign otemp[i] = temp[i];
    end
  endgenerate
  assign o = temp1[0];
  
endmodule
  
  

module Rshift#(parameter N=16)(
  input [N-1:0] i,
  output [N-1:0] o
);
  
  assign o[N-1] = 1'b0;
  assign o[N-2:0] = i[N-1:1];
  
endmodule
  
  
