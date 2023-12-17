`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2023 10:59:48 AM
// Design Name: 
// Module Name: reg_file_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_file_tb(

    );
  integer i,j;

  reg           clk   = 0;
  reg           reset = 0;

  wire  [31:0]  dataOut0;
  wire  [31:0]  dataOut1;
  reg   [4:0]   regNum0;
  reg   [4:0]   regNum1;

  reg   [4:0]   wRegNum;
  reg   [31:0]  wDataIn;
  reg           writeEnable;     // 1 => WRITE, 0 => READ
  reg           chip_en; 

  // Our device under test
  decode DUT(clk, reset, chip_en , writeEnable ,
              regNum0  , dataOut0, 
              regNum1  , dataOut1,
              wRegNum  , wDataIn);
  initial begin
    // Set Reset conditions
    clk        = 0;
    reset      = 1;

    wRegNum    = 0;
    wDataIn    = 0;
    regNum0    = 0;
    regNum1    = 0;
    chip_en    = 0;    
    writeEnable = 0;

    for (i=1;i<32;i=i+1)
      DUT.reg_mem[i]=0;

    // Pulse Clock
    #10 clk = 1;
    #10 clk = 0;
 
    for (i=1;i<32;i=i+1)
      begin
        // Reset
        //clk         = 0;
        //reset       = 1;

        //wDataIn     = 0;
        //wRegNum     = 0;
        //writeEnable = 0;

        for (j=1;j<32;j=j+1)
          DUT.reg_mem[j] = 0;  
        reset       = 0;
        chip_en     = 1;    
        wDataIn     = i;
        writeEnable = 1;
        wRegNum     = i;
        #10 clk = 1;
        #10 clk = 0; 
        for (j=1;j<32;j=j+1)
          begin
            if  ( (j==i) && (DUT.reg_mem[j] != i)) $error("1) Expected registers[%d] to be %x but got %x.", j, i, DUT.reg_mem[j]);
            if  ( (j!=i) && (DUT.reg_mem[j] != 0)) $error("2) Expected registers[%d] to be %x but got %x.", j, 0, DUT.reg_mem[j]);
          end        
        
        writeEnable = 0;             // Test Read Only
        wDataIn     = 32'hF0F0F0F0;
        regNum0     = i;      
        regNum1     = i;
        
      // Pulse Clock
      #10 clk = 1;
      #10 clk = 0;

      if (dataOut0      != i) $error("Expected dataOut0 to be %d but got %d."      , i, dataOut0);
      if (DUT.reg_mem[i]!= i) $error("Expected registers[%d] to be %d but got %d." , i, i, DUT.reg_mem[i]);
    end

    #100

    $finish;
  end
endmodule
               
               

    
    
    
    

