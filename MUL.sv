// Code your design here
//Full Adder
// https://edaplayground.com/x/aFya
module full_adder #(parameter N=16)
  (
    input [N-1:0] A,
    input [N-1:0] B,
    output [N-1:0] O,
    output of
);
  
  
  assign  O = A+B;
  
endmodule

module MUL#(parameter N=16)( 
  input [N-1:0] A,
  input [N-1:0] B,
  output [2*N-1:0] O
);
  
  wire [N][2*N-1:0] temp1;// [N];
  wire [N][2*N-1:0] temp2;// [N];
  wire [N][2*N-1:0] temp3;// [N];
  
  zExtend#(N) zE(
    .i(A),
    .o(temp[0])
  );
  //Left shift;
  assign	temp1[0] = A;
  //if valid
  assign	temp2[0] = B[0] ? temp1[0] : 0;
  //Add
  assign	temp3[0] = temp2[0];
  
  genvar i;
  
  generate
    for(i=1; i<=N-1; i++)begin
      
      Lshift#(2*N) Ls(
        .i(temp1[i-1]),
        .o(temp1[i])
      );
  
      assign temp2[i] = B[i] ? temp1[i] : 0;
      
      full_adder#(2*N) fa(
        .A(temp2[i]),
        .B(temp3[i-1]),
        .O(temp3[i])
      );
    end
  endgenerate

  assign O = temp3[N-1];
  
endmodule


module Lshift#(parameter N=16)(
  input [N-1:0] i,
  output [N-1:0] o
);
  
  assign o[0] = 1'b0;
  assign o[N-1:1] = i[N-2:0];
  
endmodule
  
module zExtend#(parameter N=16)(
  input [N-1:0] i,
  output [2*N-1:0] o
);
  
  assign o[N-1:0] = i;
  assign o[2*N-1:N] = 0;
    
endmodule
