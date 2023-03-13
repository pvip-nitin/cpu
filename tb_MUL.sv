// Code your testbench here
// or browse Examples
module top;
  
  parameter N = 8;
  
  bit [N-1:0] a, b;
  bit [2*N-1:0] c; 
  
  MUL#(N)  M(
    .A(a),
    .B(b),
    .O(c)
  );
  
  initial begin
    $monitor("%d * %d = %d",a,b,c);
    #1;
    a = $urandom_range(1,5);
    b = $urandom_range(1,5);
    #1
    $display("%d, %d",a,b);
    #10;
    $finish;
  end
  
    
  initial begin
     $dumpfile("abc.vcd");
    $dumpvars(0);
  end
endmodule
