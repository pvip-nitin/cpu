//Divider
// https://edaplayground.com/x/nR3r
module Divider#(parameter N=16)(
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
  
  
  reg [N-1:0] D, d, Counter, RefCounter, refD, refd, Num_cycles;
  bit [N-1:0] Dr, temp1, temp2, temp3; 
  
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
      Counter <= 0;
      exception <= 0;
      ready <= 0;
      Num_cycles <= 0;
    end else begin
      if(s === START) begin
        //
        
        if(req)begin
          if(Divisor == 0)begin
            exception <= 1'b1;
            ready <= 1'b1;
            s <= START;  
            Num_cycles <= 1;
          end else if(Divisor == 1) begin
            exception <= 1'b0;
            ready <= 1'b1;
            s <= START;
            Q <= Dividend;
            Num_cycles <= 1;
          end else begin
            s <= COMPARE;
            //Data
            refD <= Dividend;
            refd <= Divisor;
            D <= Dividend;
            d <= Divisor;
            Num_cycles <= 1;
          end
        end else begin
          s <= START;
          ready <= 1'b0;
          Num_cycles <= 0;
        end
     end else if(s == COMPARE) begin
       	Num_cycles <= Num_cycles + 1;
        if(e || g)begin
          // Divisor =< Dividend
          D <= Dr;
          Counter <= (Counter == 0) ? 1 : Counter << 1;//Bug: Counter << 1;
        end else begin
          // Divisor > Dividend          
          if(Counter != 0) begin
            //RefCounter <= RefCounter + Counter;
            RefCounter <= temp3;
            Counter <= 1'b0;
            //D <= refD - refd*Counter;
            D <= temp2;
            refD <= temp2;        
          end else begin 
            /// Sum of Counter values will be output.
             Q <= RefCounter;
             ready <= 1'b1;
             s <= START;
          end
        end
      end
    end
  end
  
  
  
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
  
  
  Rshift Rs(
    .i(D),
    .o(Dr)
  );
    
 endmodule

module Add#(parameter N=16)(
  input [N-1] A,
  input [N-1] B,
  output reg [N-1] O
);
  assign O = A+B;
endmodule

module Sub#(parameter N=16)(
  input [N-1] A,
  input [N-1] B,
  output reg [N-1] O
);
  assign O = A-B;
endmodule

module Mul#(parameter N=16)(
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

module Rshift#(parameter N=16)(
  input [N-1:0] i,
  output [N-1:0] o
);
  
  assign o[N-1] = 1'b0;
  assign o[N-2:0] = i[N-1:1];
  
endmodule
  
  
