//////////////////////////////////////////////////////////////////////////////////
// Engineer: Or Golan 
// 
// Create Date: 12/13/2023 12:02:00 AM
// Design Name: RISC_TA (RV32I implementation)
// Module Name: ALU 
// Description: RISC-V ALU 
// 
// Revision: 
//  - 0.1: ALU implementation (Not tested)
//
//////////////////////////////////////////////////////////////////////////////////

/* Module                                                                       */
module ALU (
  /* Inputs  */
  input  [7:0]   alu_opcode,     // ALU opcode   
  input  [31:0]  alu_imm1,       // ALU immediacls
  
  input  [31:0]  alu_imm2,       // ALU immediate-2
  output [31:0]  alu_result       // ALU Result
);

reg [31:0] result;

/* Parameters                                                                   */
parameter ADD = 7'b000;  //ADD performs the addition of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.
parameter SUB = 7'b001; //SUB performs the subtraction of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.

parameter AND = 7'b010;
parameter OR = 7'b011;
parameter XOR = 7'b100; //XOR performs bitwise exclusive or on rs1 and 'rs2' and the result is written to 'rd'.

parameter SLL = 7'b101; //SLL perform logical (aka unsigned) left shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.
parameter SLT = 7'b110; //SLT performs signed compare between rs1 and rs2, writing 1 to rd if rs1 < rs2, 0 otherwise.
parameter SLTU = 7'b111;

parameter SRA = 7'b1000; //SRA perform arithmetic (aka signed) right shift on the value in reg rs1 by the shift amount held in the lower 5 bits of reg rs2.
parameter SRL = 7'b1001; //SRL perform logical (aka unsigned) right shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.

always@(*)
begin
    case (alu_opcode)
        ADD:  result = alu_imm1 + alu_imm2 ;
        SUB:  result = alu_imm1 - alu_imm2 ;                
        AND:  result = alu_imm1 & alu_imm2 ;
        OR:   result = alu_imm1 | alu_imm2 ; 
        XOR:  result = alu_imm1 ^ alu_imm2 ;
        SLL:  result = alu_imm1 << (alu_imm2 & 32'b11111) ; 
        SRA:  result = alu_imm1 >>> alu_imm2;
        SRL:  result = alu_imm1 >> alu_imm2;
        SLTU: begin  
               if   (alu_imm1 < alu_imm2) result = 1;
               else                       result = 0;
              end           
        SLT: begin
                if   (({alu_imm1[31], alu_imm1}) < ({alu_imm2[31], alu_imm2})) result = 1;
                else                                                           result = 0;
             end
    endcase
end

assign alu_result = result;

endmodule
