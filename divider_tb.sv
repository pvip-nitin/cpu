#include "Divider.sv"

module top;
  
  parameter N=16;
  
  bit clk, rstn, req, ready;
  bit [N-1:0] D, d, Q, R;
  
  assign clk = #5 ~clk; 
  
  Divider Div#(N)(
    .clk(clk),
    .rstn(rstn),
    .req(req),
    .Dividend(D),
    .Divisor(d),
    .Q(Q),
    .R(R),
    .ready(ready)
  );
  
  initial begin
    $monitor("%b, %d",ready, Q);
    rst = 0;
    @(negedge clk);
    @(negedge clk);
    rst = 1;
    req = 1;
    D = 65000;
    d = 6700;
    fork 
      @(posedge ready);
      repeat(10000) begin
        @(posedge clk);
      end
    join_any
    $display("%fns: %d/%d = %d", $realtime, D, d, Q);
    #100;      
    $finish;
  end
  
  
endmodule
