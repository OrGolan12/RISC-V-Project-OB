`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2023 10:48:32 AM
// Design Name: 
// Module Name: cpu_tb
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


module cpu_tb();

reg [31:0] cpu_instruction;
reg cpu_clk, cpu_rst, cpu_instruction_RDY_BSY;
reg [6:0]  opcode_addi;   // ITYPE instruction 
reg [2:0] opcode_funct3;       // ADDI 
reg [4:0]  opcode_rd;    // RD:RS1 
reg [4:0] opcode_rs1;    // RS1:RS2 (Always 0)
reg [11:0] opcode_imm1;       // IMM:5 
reg [31:0] instr; 
integer i;

cpu DUT(cpu_instruction, cpu_clk, cpu_rst, cpu_instruction_RDY_BSY);

function [31:0] itype_cmd;
    input [7:0] Opcode;
    input [2:0] funct3;
    input [5:0] rs1;
    input [5:0] rd;
    input [11:0] imm;
    
    begin
        itype_cmd = Opcode + (rd<<7) + (funct3<<12) + (rs1<<15) + (imm<<20) ;
    end
    //cpu_instruction        = instr ; // [RG]: Add real instruction value 
    //cpu_instruction_RDY_BSY = 1;                                                
endfunction

initial 
    begin
        cpu_clk = 0;
        cpu_rst = 1;
        cpu_instruction = 0;
        cpu_instruction_RDY_BSY = 0;
        
        #10 cpu_clk = 1;
        #10 cpu_clk = 0;
        cpu_rst = 0;

      for (i=0;i<100;i=i+1) 
        begin

          #10
          if ((i>=10) && (i<=20))
            begin           //RG: This is spagetty-code , Add function itype_cmd (Opcode,rs1,rs2,rd,imm)
              opcode_addi   = 7'b0010011;   // ITYPE instruction 
              opcode_funct3 = 3'b000;       // ADDI 
              opcode_rd     = 5'b00001 ;    // RD:RS1 
              opcode_rs1    = 5'b00010 ;    // RS1:RS2 (Always 0)
              opcode_imm1   = 12'h5 ;       // IMM:5
              instr = opcode_addi + (opcode_rd<<7) + (opcode_funct3<<12) + (opcode_rs1<<15) + (opcode_imm1<<20) ; 
              cpu_instruction        = instr ; // [RG]: Add real instruction value ;              
              cpu_instruction_RDY_BSY = 1;   
                                       
              //cpu_instruction = itype_cmd(7'b0010011,3'b000,5'b00010,5'b00001,12'h5);                
            end 
          else   
            begin
              cpu_instruction_RDY_BSY = 0;                 
              cpu_instruction = 0 ; // [RG]: Add real instruction value 
            end                     
        cpu_clk = ~cpu_clk;        
      end        
    end
   
    
endmodule
