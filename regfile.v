//////////////////////////////////////////////////////////////////////////////////
// Engineer: Or Golan 
// 
// Create Date: 12/13/2023 12:02:00 AM
// Design Name: RISC_TA (RV32I implementation)
// Module Name: REGFILE  
// Description: RISC-V REGFILE  
// 
// Revision: 
// 1.01 : expose reg_mem to the gtkwave
//
//////////////////////////////////////////////////////////////////////////////////

module regfile(
    /* Inputs  */
    input clk, rst , chip_en ,  // Clock & Reset 
    input write_enable,        // 1: write / 0: Read 

    // RD-Port-0: Read (Slave-Port)
    input [4:0]        rs1_address,  // Port0-Read address
    output wire [31:0] rs1_data,

    // RD-Port-1: Read (Slave-Port)
    input [4:0]        rs2_address,
    output wire [31:0] rs2_data,
    
    // WR-Port  Write  (Slave-Port)
    input [4:0]  wr_port_add,
    input [31:0] wr_port_data
    );

reg [31:0] reg_mem[0:31] ;

integer i = 0;

initial 
    begin
      for (i=0; i<32; i=i+1) reg_mem[i] = 0;
    end
    

always@ (posedge clk)
  begin
    if (!rst && chip_en)
      begin
        if (write_enable)
          reg_mem[wr_port_add] = wr_port_data;           
      end 
  end   

assign rs1_data = reg_mem[rs1_address];
assign rs2_data = reg_mem[rs2_address];

// Only for simulation expose the registers
generate
  genvar idx;
  for(idx = 0; idx < 32; idx = idx+1) begin: register
    wire [31:0] tmp;
    assign tmp = reg_mem[idx];
  end
endgenerate

endmodule
