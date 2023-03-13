// Code your testbench here
// or browse Examples

//`include "multi_right_shift.sv"

module top;
  
  parameter N=16;
  
  bit clk, rstn;
  //bit req, ready;
  bit [N-1:0] x, s, o;
  
  multi_shift#(N)(
    .x(x),
    .s(s),
    .o(o)
  );
    
  //assign clk = #5 ~clk; 
  initial begin
    forever begin
      clk = 0;
      #5;
      clk = 1;
      #5;
    end
  end
  
  initial begin
    rstn = 0;
    @(negedge clk);
    @(negedge clk);
    x = 16'hFFFF;
    s = 16'h8;
  	#100;      
    $finish;
  end
  
  
  initial
    begin
      $dumpfile("abc.vcd");
      $dumpvars();
    end
  
endmodule
