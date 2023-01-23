interface perm_if.sv
#(
  parameter ADDR_WIDTH=16
)();
         /*Setting permissions*/
  logic  [ADDR_WIDTH-1:0] addr_start;
  logic  [ADDR_WIDTH-1:0] addr_end;
  logic                   perm_req;
  logic                   error;

endinterface
