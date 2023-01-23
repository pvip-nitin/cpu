module tb_top;

  bit clk;
  bit rstn;

  always #10  clk = ~clk;

  cr_if     crIF(clk, rstn);
  read_if   instr_IF();
  read_if   rdata_IF();
  write_if  wdata_IF();
  perm_if   pIF();

  memtop_wif mem(crIF, instr_IF, rdata_IF, wdata_IF, pIF);

  cputop_wif cpu(crIF, instr_IF, rdata_IF, wdata_IF);

  initial begin
    repeat(4)
      @(posedge clk);
    rstn = 1;
    @(posedge clk);
    //RO by instruction starting sequence
    #10us;
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    $dumpvars(0, "cpu.vcd",	cpu.*);
    $dumpvars(0, "cpu.vcd",	mem.*);
  end

endmodule
