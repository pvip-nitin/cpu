// Code your testbench here
// or browse Examples
module top;
  
  parameter N = 4;
  
  bit [N-1:0] a, b;
  bit [2*N-1:0] c; 
  
  MUL#(N)  M(
    .A(a),
    .B(b),
    .O(c)
  );
  
  initial begin
    $monitor("%d * %d = %d",a,b,c);
    #4;
    a = 8;//$urandom_range(1,5);
    b = 7;//$urandom_range(1,5);
    #4;
    a = 10;
    b=3;
    #4;
    a = 15;
    b = 15;
    #4;
    
    #100;
    $finish;
  end
  
    
  initial begin
     $dumpfile("abc.vcd");
    $dumpvars();
  end
endmodule
