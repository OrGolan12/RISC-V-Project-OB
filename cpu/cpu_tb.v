`timescale 1ns / 1ps
`include "cpu.v"
`include "decode.v"
`include "regfile.v"
`include "alu.v"
`include "PC.v"
//`include "IFU.v"
//////////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2023 10:48:32 AM
// Design Name: 
// Module Name: cpu_tb
// Project Name: RISC-V Implementation OB
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - I_type_cmd added
// Revision 0.03 - R_type_cmd added
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
reg [31:0] test;
integer i;


parameter R_TYPE_OP = 7'b0110011;
parameter I_TYPE_OP = 7'b0010011;
parameter J_TYPE_OP = 7'b1101111;
parameter JALR_TYPE_OP = 7'b1100111;
parameter B_TYPE_OP = 7'b1100011;
parameter S_TYPE_OP = 7'b0100011;
parameter L_TYPE_OP = 7'b0000011;

parameter [2:0] ADD = 3'b000;  //ADD performs the addition of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.
parameter [2:0] SUB = 3'b000; //SUB performs the subtraction of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.
parameter [2:0] AND = 3'b111;
parameter [2:0] OR = 3'b110;
parameter [2:0] SLL = 3'b001; //SLL perform logical (aka unsigned) left shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.
parameter [2:0] SLT = 3'b010; //SLT performs signed compare between rs1 and rs2, writing 1 to rd if rs1 < rs2, 0 otherwise.
parameter [2:0] SLTU = 3'b011;
parameter [2:0] SRA = 3'b101; //SRA perform arithmetic (aka signed) right shift on the value in reg rs1 by the shift amount held in the lower 5 bits of reg rs2.
parameter [2:0] SRL = 3'b101; //SRL perform logical (aka unsigned) right shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.
parameter [2:0] XOR = 3'b100; //XOR performs bitwise exclusive or on rs1 and 'rs2' and the result is written to 'rd'. 
integer idx;

parameter BEQ = 3'b000;
parameter BNE = 3'b001;
parameter BLT = 3'b100;
parameter BGE = 3'b101;
parameter BLTU = 3'b110;
parameter BGEU = 3'b111;

cpu DUT(cpu_instruction, cpu_clk, cpu_rst, cpu_instruction_RDY_BSY);

function [31:0] itype_cmd;
    
    input [2:0] command; 
    input [11:0] imm;
    input [4:0] rs1;
    input [4:0] rd;

   /* parameter I_TYPE_OP = 7'b0010011;
    parameter [2:0] ADD = 3'b000;  //ADD performs the addition of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.
    parameter [2:0] SUB = 3'b000; //SUB performs the subtraction of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.
    parameter [2:0] AND = 3'b111;
    parameter [2:0] OR = 3'b110;
    parameter [2:0] SLL = 3'b001; //SLL perform logical (aka unsigned) left shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.
    parameter [2:0] SLT = 3'b010; //SLT performs signed compare between rs1 and rs2, writing 1 to rd if rs1 < rs2, 0 otherwise.
    parameter [2:0] SLTU = 3'b011;
    parameter [2:0] SRA = 3'b101; //SRA perform arithmetic (aka signed) right shift on the value in reg rs1 by the shift amount held in the lower 5 bits of reg rs2.
    parameter [2:0] SRL = 3'b101; //SRL perform logical (aka unsigned) right shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.
    parameter [2:0] XOR = 3'b100; //XOR performs bitwise exclusive or on rs1 and 'rs2' and the result is written to 'rd'. */

    
    begin
      case(command)
      ADD : itype_cmd = I_TYPE_OP + (rd<<7) + (ADD<<12) + (rs1<<15) + (imm<<20) ;
      AND : itype_cmd = I_TYPE_OP + (rd<<7) + (AND<<12) + (rs1<<15) + (imm<<20) ;
      OR : itype_cmd = I_TYPE_OP + (rd<<7) + (OR<<12) + (rs1<<15) + (imm<<20) ;
      SLL : itype_cmd = I_TYPE_OP + (rd<<7) + (SLL<<12) + (rs1<<15) + (imm<<20) ;
      SLT : itype_cmd = I_TYPE_OP + (rd<<7) + (SLT<<12) + (rs1<<15) + (imm<<20) ;
      SLTU : itype_cmd = I_TYPE_OP + (rd<<7) + (SLTU<<12) + (rs1<<15) + (imm<<20) ;
      SRA : itype_cmd = I_TYPE_OP + (rd<<7) + (SRA<<12) + (rs1<<15) + (imm<<20) ;
      SRL : itype_cmd = I_TYPE_OP + (rd<<7) + (SRL<<12) + (rs1<<15) + (imm<<20) ;
      XOR : itype_cmd = I_TYPE_OP + (rd<<7) + (XOR<<12) + (rs1<<15) + (imm<<20) ;
      endcase          
      cpu_instruction_RDY_BSY = 1;     
    end                                              
endfunction

function [31:0] rtype_cmd;
    
    input [2:0] command; 
    input [4:0] rs1;
    input [4:0] rs2;
    input [4:0] rd;

    parameter R_TYPE_OP = 7'b0110011;
    parameter [2:0] ADD = 3'b000;  //ADD performs the addition of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.
    parameter [2:0] SUB = 3'b000; //SUB performs the subtraction of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.
    parameter [2:0] AND = 3'b111;
    parameter [2:0] OR = 3'b110;
    parameter [2:0] SLL = 3'b001; //SLL perform logical (aka unsigned) left shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.
    parameter [2:0] SLT = 3'b010; //SLT performs signed compare between rs1 and rs2, writing 1 to rd if rs1 < rs2, 0 otherwise.
    parameter [2:0] SLTU = 3'b011;
    parameter [2:0] SRA = 3'b101; //SRA perform arithmetic (aka signed) right shift on the value in reg rs1 by the shift amount held in the lower 5 bits of reg rs2.
    parameter [2:0] SRL = 3'b101; //SRL perform logical (aka unsigned) right shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.
    parameter [2:0] XOR = 3'b100; //XOR performs bitwise exclusive or on rs1 and 'rs2' and the result is written to 'rd'. 

    
    begin
      case(command)
      ADD : rtype_cmd = R_TYPE_OP + (rd<<7) + (ADD<<12) + (rs1<<15) + (rs2<<20) + (7'b0000000<<25);
      AND : rtype_cmd = R_TYPE_OP + (rd<<7) + (AND<<12) + (rs1<<15) + (rs2<<20) + (7'b0100000<<25);
      OR : rtype_cmd = R_TYPE_OP + (rd<<7) + (OR<<12) + (rs1<<15) + (rs2<<20) + (7'b0000000<<25);
      SLL : rtype_cmd = R_TYPE_OP + (rd<<7) + (SLL<<12) + (rs1<<15) + (rs2<<20) + (7'b0000000<<25);
      SLT : rtype_cmd = R_TYPE_OP + (rd<<7) + (SLT<<12) + (rs1<<15) + (rs2<<20) + (7'b0000000<<25);
      SLTU : rtype_cmd = R_TYPE_OP + (rd<<7) + (SLTU<<12) + (rs1<<15) + (rs2<<20) + (7'b0000000<<25);
      SRA : rtype_cmd = R_TYPE_OP + (rd<<7) + (SRA<<12) + (rs1<<15) + (rs2<<20) + (7'b0000000<<25);
      SRL : rtype_cmd = R_TYPE_OP + (rd<<7) + (SRL<<12) + (rs1<<15) + (rs2<<20) + (7'b0000000<<25);
      XOR : rtype_cmd = R_TYPE_OP + (rd<<7) + (XOR<<12) + (rs1<<15) + (rs2<<20) + (7'b0000000<<25);
      endcase          
      cpu_instruction_RDY_BSY = 1;     
    end                                              
endfunction

function [31:0] btype_cmd;
  input [2:0] command;
  input [4:0] rs1;
  input [4:0] rs2;
  input [11:0] immediate;
  begin
  case(command)
    BEQ : btype_cmd = B_TYPE_OP + (immediate[10]<<7) + (immediate[3:0]<<8) + (BEQ<<12) + (rs1<<15) + (rs2<<20) + (immediate[11]<<25) + (immediate[9:4]<<26);
    BNE : btype_cmd = B_TYPE_OP + (immediate[10]<<7) + (immediate[3:0]<<8) + (BNE<<12) + (rs1<<15) + (rs2<<20) + (immediate[11]<<25) + (immediate[9:4]<<26);
    BLT : btype_cmd = B_TYPE_OP + (immediate[10]<<7) + (immediate[3:0]<<8) + (BLT<<12) + (rs1<<15) + (rs2<<20) + (immediate[11]<<25) + (immediate[9:4]<<26);
    BGE : btype_cmd = B_TYPE_OP + (immediate[10]<<7) + (immediate[3:0]<<8) + (BGE<<12) + (rs1<<15) + (rs2<<20) + (immediate[11]<<25) + (immediate[9:4]<<26);
    BLTU : btype_cmd = B_TYPE_OP + (immediate[10]<<7) + (immediate[3:0]<<8) + (BLTU<<12) + (rs1<<15) + (rs2<<20) + (immediate[11]<<25) + (immediate[9:4]<<26);
    BGEU : btype_cmd = B_TYPE_OP + (immediate[10]<<7) + (immediate[3:0]<<8) + (BGEU<<12) + (rs1<<15) + (rs2<<20) + (immediate[11]<<25) + (immediate[9:4]<<26);
  endcase
  cpu_instruction_RDY_BSY = 1;  
  end 
endfunction



  initial 
    begin

        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);
        $display("riscv_cpu_tb: Start");

        //togggle reset
        cpu_clk = 0;
        cpu_rst = 1;
        cpu_instruction = 0;
        cpu_instruction_RDY_BSY = 0;
        
        #10 cpu_clk = 1;
        #10 cpu_clk = 0;
        cpu_rst = 0;

    end
     //create clock for simulation
    always #10 cpu_clk = ~cpu_clk;

    initial begin
        //OPCODE : ADD
        cpu_instruction = itype_cmd(ADD,12'h5,5'b00000,5'b00001);//add (imm = 5 + reg0) to reg1. --> reg1 should be 5.
        #80
        cpu_instruction = itype_cmd(ADD,12'h5,5'b00001,5'b00010);//add (imm = 5) + reg1 to reg2 --> reg2 should be 10.
        #80
        cpu_instruction = rtype_cmd(ADD,5'b00001,5'b00010,5'b00011);//add reg1(10) + reg 2(5) --> reg3 should be 15.
        #80
        //OPCODE : AND
        cpu_instruction = rtype_cmd(AND,5'b00010,5'b00011,5'b00100);//bitwise and (reg2(10) & reg 3(15)) --> reg 4 should be 10.
        #80
        //OPCODE : BEQ
        cpu_instruction = btype_cmd(BEQ,5'b00010,5'b00100,12'b1);//PC should be pc += 2. overall : 18 
        #100
        //TESTING THE REGISTERS  -----ADD FUNCTION-----   
        if (DUT.r.reg_mem[0] != 32'b000) $error("Expected REG%02d to be %0d but got %08x", 0, 32'b101, DUT.r.reg_mem[0]);//CHECK IF REG0 == 0
        if (DUT.r.reg_mem[1] != 32'b101) $error("Expected REG%02d to be %0d but got %08x", 1, 32'b101, DUT.r.reg_mem[1]);//CHECK IF REG1 == 5
        if (DUT.r.reg_mem[2] != 32'b1010) $error("Expected REG%02d to be %0d but got %08x", 2, 32'b1010, DUT.r.reg_mem[2]);//CHECK IF REG2 == 10
        if (DUT.r.reg_mem[3] != 32'b1111) $error("Expected REG%02d to be %0d but got %08x", 3, 32'b1111, DUT.r.reg_mem[3]);//CHECK IF REG3 == 15

        //TESTING THE REGISTERS  -----AND FUNCTION-----  
        if (DUT.r.reg_mem[4] != (DUT.r.reg_mem[2] & DUT.r.reg_mem[3])) $error("Expected REG%04d to be %0d but got %08x", 4, (DUT.r.reg_mem[2] & DUT.r.reg_mem[3]), DUT.r.reg_mem[4]);//CHECK IF REG4 == REG2 AND REG3
        //TESTING PC  -----BEQ FUNCTION-----  
        if (DUT.p.pc_counter != 32'd18) $error("Expected REG%02d to be %0d but got %08x", 3'b101 , 5'd14, DUT.p.pc_counter);//CHECK IF PC == 18;
        //can add more tests
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);
        $display("riscv_cpu_tb: End");     
        #300 $finish ;  
    end
      /*for (i=0;i<100;i=i+1) 
        begin

          #10
          if ((i>=10) && (i<=19))
            begin                                                    
              cpu_instruction = itype_cmd(ADD,12'h5,5'b00000,5'b00001); //add (imm = 5 + reg0) to reg1.
              
            end
                      
          else if ((i>=20) && (i<=30))
            begin 
              cpu_instruction = itype_cmd(ADD,12'h5,5'b00001,5'b00010); //add (imm = 5) + reg1 to reg2 --> reg2 should be 10.

            end           
          else if ((i>=31) && (i<=40))
            begin                                                    
              cpu_instruction = rtype_cmd(ADD,5'b00001,5'b00010,5'b00011);  //add reg1(10) + reg 2(5) --> reg 3 should be 15.
            end           
          else   
            begin
              cpu_instruction_RDY_BSY = 0;                 
              cpu_instruction = 0 ; // [RG]: Add real instruction value 
            end                     
        cpu_clk = ~cpu_clk;        */


       
    

      //TESTING THE REGISTERS  -----ADD FUNCTION-----   
      //if (DUT.r.reg_mem[0] != 32'b000) $error("Expected REG%02d to be %0d but got %08x", 0, 32'b101, DUT.r.reg_mem[1]);//CHECK IF REG1 == 5
      //if (DUT.r.reg_mem[1] != 32'b101) $error("Expected REG%02d to be %0d but got %08x", 1, 32'b101, DUT.r.reg_mem[1]);//CHECK IF REG1 == 5
      //if (DUT.r.reg_mem[2] != 32'b1010) $error("Expected REG%02d to be %0d but got %08x", 2, 32'b1010, DUT.r.reg_mem[1]);//CHECK IF REG2 == 10
      //if (DUT.r.reg_mem[3] != 32'b1111) $error("Expected REG%02d to be %0d but got %08x", 3, 32'b1111, DUT.r.reg_mem[1]);//CHECK IF REG3 == 15
endmodule
