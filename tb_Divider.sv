// Code your testbench here
// or browse Examples

module top;
  
  parameter N=16;
  
  bit clk, rstn, req, ready;
  bit [N-1:0] D, d, Q, R;
  
  //assign clk = #5 ~clk; 
  initial begin
    forever begin
      clk = 0;
      #5;
      clk = 1;
      #5;
    end
  end
  
  Divider#(N) Div(
    .clk(clk),
    .rstn(rstn),
    .req(req),
    .Dividend(D),
    .Divisor(d),
    .Q(Q),
    .R(R),
    .ready(ready),
    .exception()
  );
  
  initial begin
    $monitor("%b, %d",ready, Q);
    rstn = 0;
    @(negedge clk);
    @(negedge clk);
    rstn = 1;
    req = 1;
    D = 16'hFFFF;
    d = 2;
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
  
  
  initial
    begin
      $dumpfile("abc.vcd");
      $dumpvars();
    end
endmodule
