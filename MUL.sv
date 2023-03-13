// Code your design here
//Full Adder
module full_adder #(parameter N=16)
  (
    input [N-1:0] A,
    input [N-1:0] B,
    output [N-1:0] O
);
  
  
  assign  O = A+B;
  
endmodule

module MUL#(parameter N=16)( 
  input [N-1:0] A,
  input [N-1:0] B,
  output [2*N-1:0] O
);
  
  wire [N][  N-1:0] temp1;// [N];
  wire [N][2*N-1:0] temp2;// [N];
  
  wire [N][2*N-1:0] temp3;// [N];
  
  //always_comb begin
  assign	temp1[0] = B[0] ? A : 0;//& {N{B[0]}};
  assign	temp2[0] = temp1[0] << 0;
  assign	temp3[0] = temp2[0];
  //end
  
  genvar i;
  
  generate
    for(i=1; i<=N-1; i++)begin
      assign temp1[i] = B[i] ? A : 0;
      assign temp2[i] = temp1[i] << i;
      full_adder#(2*N) fa(
        .A(temp3[i-1]),
        .B(temp2[i]),
        .O(temp3[i])
      );
    end
  endgenerate

  assign O = temp3[N-1];
  
endmodule
