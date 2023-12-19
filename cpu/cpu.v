`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2023 10:50:44 AM
// Design Name: 
// Module Name: cpu
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


module cpu(
    input [31:0] cpu_instruction,
    input cpu_clk, cpu_rst, instruction_RDY_BSY
    );

//alu wires    
wire  [7:0]   alu_opcode;  // ALU opcode   
wire  [31:0]  alu_imm1;    // ALU immediacls
  
wire  [31:0]  alu_imm2;     // ALU immediate-2
wire [31:0]  alu_result;       // ALU Result    

//regfile wires
wire RF_chip_enable;
wire RF_write_enable;   // 1: write / 0: Read 
wire write_enable;
wire [31:0] RF_reg1_data;
wire [31:0] RF_reg2_data;   
wire [4:0] RF_rs1_address;
wire [4:0] RF_rs2_address;
wire [4:0] RF_WR_add;
wire [31:0] RF_WriteData; 


//decoder_wires            
wire [31:0] instruction_data;
wire decoder_rdy_bsy;
    
ALU a(alu_opcode, alu_imm1, alu_imm2, alu_result);

regfile r(cpu_clk, cpu_rst, RF_chip_enable, RF_write_enable ,RF_rs1_address, RF_reg1_data,
RF_rs2_address, RF_reg2_data, RF_WR_add, RF_WriteData);

decode d(cpu_rst, cpu_clk, cpu_instruction, instruction_RDY_BSY, decoder_rdy_bsy, alu_result, alu_opcode, 
alu_imm1, alu_imm2, RF_chip_enable, RF_write_enable, RF_reg1_data, RF_reg2_data, 
RF_rs1_address, RF_rs2_address, RF_WR_add, RF_WriteData);
        
    
endmodule



