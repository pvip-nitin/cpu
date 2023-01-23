interface read_if
#(
  /*as in number of bits*/
  parameter ADDR_WIDTH=16,
  parameter DATA_WIDTH=16,
  /*Total Size = ADDR_WIDTH*DATA_WIDTH */
)();
  logic                   req;
  logic  [ADDR_WIDTH-1:0] addr;
  logic                   ack;
  logic  [DATA_WIDTH-1:0] data;

endinterface
