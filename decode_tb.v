`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2023 11:42:53 AM
// Design Name: 
// Module Name: decode_tb
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


module decode_tb(

    );

reg rst, clk, instruction_RDY_BSY;
reg [31:0] instruction;

//alu
reg [31:0]  alu_result;
wire [7:0]  alu_opcode;
wire [31:0] alu_imm1;
wire [31:0] alu_imm2;

//rf
wire RF_chip_enable;
wire RF_write_enable;   // 1: write / 0: Read 
reg [31:0]      RF_reg1_data;
reg [31:0]      RF_reg2_data;   

wire [4:0]  RF_rs1_address;
wire [4:0]  RF_rs2_address;
wire [4:0]  RF_WR_add;
wire [31:0] RF_WriteData;

decode DUT(rst, clk, instruction_RDY_BSY, instruction, alu_result, alu_opcode, alu_imm1, alu_imm2, RF_chip_enable, RF_write_enable, RF_reg1_data,
RF_reg2_data, RF_rs1_address, RF_rs2_address, RF_WR_add, RF_WriteData);

initial 
begin
#10 clk = 0;
#10 clk = 1;
rst = 1; //trigger reset
#10 clk = 0;
#10 clk = 1;
rst = 0;
instruction_RDY_BSY = 1;
instruction = 32'b00000000001100001000000100010011;
#10 clk = 0;
#10 clk = 1;
#10 clk = 0;
#10 clk = 1;

end







endmodule
