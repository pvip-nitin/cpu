module memtop
#(
  /*as in number of bits*/
  parameter ADDR_WIDTH=16, 
  parameter DATA_WIDTH=16 
  /*Total Size = ADDR_WIDTH*DATA_WIDTH */
)
(
  cr_if     crIf,
  read_if#(ADDR_WIDTH, DATA_WIDTH)    r0If,
  read_if#(ADDR_WIDTH, DATA_WIDTH)    r1If,
  write_if#(ADDR_WIDTH, DATA_WIDTH)   wIf,
  perm_if#(ADDR_WIDTH)    pIf
);


reg [DATA_WIDTH-1:0] mem[2^ADDR_WIDTH];

initial begin
  @(posedge rstn);
  @(negedge clk);
  $readmemh("tools/test.hex", mem);
  `include "tools/test.data.sv"
end

reg [ADDR_WIDTH-1:0] wa_ro_start;
reg [ADDR_WIDTH-1:0] wa_ro_end;

wire is_wa_ro;
assign is_wa_ro = (wIf.waddr >= pIf.addr_start) && (wIf.waddr <= pIf.addr_end); 

always_ff@(posedge crIf.clk or negedge crIf.rstn)begin
  if(~crIf.rstn)begin
    pIf.error <= 1'b0;
    wIf.ack <= 1'b0;
    r0If.ack <= 1'b0;
    r0If.data <= '0;
    r1If.ack <= 1'b0;
    r1If.data <= '0;
    //Address 0x0 is always RO.
    wa_ro_start <= '0;
    wa_ro_end <= '0;
    foreach(mem[i])begin
        mem[i] <= '0;
    end
  end else begin
    if(pIf.perm_req)begin
        wa_ro_start <= pIf.addr_start;
        wa_ro_end   <= pIf.addr_end;
    end
    if(wIf.req)begin
        wIf.ack  <= 1'b1;
        if(~is_wa_ro)begin
          mem[wIf.addr] <= wIf.data;
          pIf.error <= 1'b0;
        end else begin
          pIf.error <= 1'b1;
        end
    end else begin
        wIf.ack  <= 1'b0;
        pIf.error <= 1'b0;
    end
    if(r1If.req)begin
      r1If.data <= mem[r1If.addr];
      r1If.ack  <= 1'b1;
    end else begin
      r1If.ack  <= 1'b0;
    end
    if(r0If.req)begin
      r0If.data <= mem[r0If.addr];
      r0If.ack  <= 1'b1;
    end else begin
      r0If.ack  <= 1'b0;
    end
  end
end

endmodule
