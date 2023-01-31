module cpu_top
  #(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 16,
    parameter NUM_REG = 16,
    parameter REG_WIDTH = 16
    )
   (
     cr_if      crIf,
     read_if    instrIf,
     read_if    rdataIf,
     write_if   wdataIf
    );
  
  reg [DATA_WIDTH-1:0] reg_bank [NUM_REG];
  
  


endmodule
