`timescale 1ns / 1ps

module IFU(
    input IFU_clk,
    input IFU_rst,
    input [31:0] IFU_PC, //input from PC
    input [31:0] IFU_RAM, //input from RAM
    output reg [5:0] IFU_fetch_ins, //output to RAM, request instruction
    output [31:0] IFU_send_ins //output to decoder, send instruction
    );

   
always @(posedge IFU_clk) IFU_fetch_ins <= IFU_PC;
        
assign IFU_send_ins = IFU_RAM;
      
endmodule
