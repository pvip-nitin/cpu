//Divider

module divider#(parameter N=16)(
  input clk,
  input rstn,
  input req,
  input [N-1:0] Dividend,
  input [N-1:0] Divisor,
  output reg [N-1:0] Q,
  output reg [N-1:0] R,
  output reg ready,
  output reg exception
);
  
  
  reg [N-1:0] D, d, Counter;
  bit [N-1:0] Dr; 
  
  typedef enum {START, COMPARE} state;
  
  state s;
  
  bit g, e;
  
  GE ge(
    .A(D),
    .B(d),
    .G(g),
    .E(e)
  );
  
  
  always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
      s <= START;
      RefCounter <= 0;
      Counter <= 1;
    end else begin
      if(state == START)begin
        //
        if(req)begin
          if(Divisor == 0)begin
            exception <= 1'b1;
            ready <= 1'b1;
            state <= START;  
          end else 
            state <= COMPARE;
            //Data
            refD <= Dividend;
            refd <= Divisor;
            D <= Dividend;
            d <= Divisor;
          end
        end else begin
          state <= START;
          ready <= 1'b0;
        end
      end else if(state == COMPARE) begin
        if(e || g)begin
          // Divisor =< Dividend
          D <= Dr;
          Counter <= Counter << 1;
        end else begin
          // Divisor > Dividend          
          if(Counter != 1) begin
            //RefCounter <= RefCounter + Counter;
            RefCounter <= temp3;
            Counter <= 1'b1;
            //D <= refD - refd*Counter;
            D <= temp2;
            refD <= temp2;        
           else begin 
            /// Sum of Counter values will be output.
             Q <= RefCounter;
             ready <= 1'b1;
             state <= START;
           end
        end
      end
    end
  end
  
  bit [N-1:0] temp1, temp2, temp3;
  
  Mul M(
    .A(refd),
    .B(Counter),
    .O(temp1)
  );
  
  Sub S(
    .A(refD),
    .B(temp1),
    .O(temp2)
  );
  
  Add A(
    .A(RefCounter),
    .B(Counter),
    .O(temp3)
  );
  
  
  Rshift R(
    .i(D),
    .o(Dr)
  );
    
 endmodule

module Add#(parameter N=16)(
  input [N-1] A,
  input [N-1] B,
  output reg [N-1] O
);
  O = A+B;
endmodule

module Sub#(parameter N=16)(
  input [N-1] A,
  input [N-1] B,
  output reg [N-1] O
);
  O = A-B;
endmodule

module Mul#(paramter N=16)(
  input [N-1] A,
  input [N-1] B,
  output reg [N-1] O
);
  
  assign O = A*B;
  
endmodule
  
module GE#(parameter N=16)(
  //A>B
  input [N-1:0] A,
  input [N-1:0] B,
  output G,
  output E
);
  
  assign E = (A==B);
  assign G = A > B;
  
endmodule

module RShift#(parameter N=16)(
  input [N-1:0] i,
  output [N-1:0] o
);
  
  assign o[N-1] = 1'b0;
  assign o[N-2:0] = i[N-1:1];
  
endmodule
  
  
