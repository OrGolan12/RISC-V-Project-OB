module decode (

    // Clock & Reset 
    input rst, clk,

    // Instructions decoder input-port  
    input [31:0] instruction_data,
    input instruction_RDY_BSY , // 1: Ready , 0:Busy
    output reg decoder_rdy_bsy,
    
    // ALU input-port 
    input [31:0] alu_result,
    output reg [7:0] alu_opcode,
    output reg [31:0] alu_imm1,
    output reg [31:0] alu_imm2,
        
    // REG-FILE
    output reg        RF_chip_enable,
    output reg        RF_write_enable,   // 1: write / 0: Read 
    input [31:0]      RF_reg1_data,
    input [31:0]      RF_reg2_data,   

    output reg [4:0]  RF_rs1_address,
    output reg [4:0]  RF_rs2_address,
    output reg [4:0]  RF_WR_add,
    output reg [31:0] RF_WriteData 
);

parameter IDLE_STATE                  = 3'b000;
parameter DECODE_STATE                = 3'b001;
parameter REGFILE_READ_SRC_REGS_STATE = 3'b010;
parameter ALU_GET_RESULT              = 3'b011;

reg [2:0] state ;

parameter R_TYPE_OP = 7'b0110011;
parameter I_TYPE_OP = 7'b0010011;

parameter ADD = 3'b000;  //ADD performs the addition of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.
parameter SUB = 3'b000; //SUB performs the subtraction of rs1 and rs2. Overflows are ignored and the low XLEN bits of results are written to rd.
parameter AND = 3'b111;
parameter OR = 3'b110;
parameter SLL = 3'b001; //SLL perform logical (aka unsigned) left shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.
parameter SLT = 3'b010; //SLT performs signed compare between rs1 and rs2, writing 1 to rd if rs1 < rs2, 0 otherwise.
parameter SLTU = 3'b011;
parameter SRA = 3'b101; //SRA perform arithmetic (aka signed) right shift on the value in reg rs1 by the shift amount held in the lower 5 bits of reg rs2.
parameter SRL = 3'b101; //SRL perform logical (aka unsigned) right shift on the value in rs1 by the shift amount held in the lower 5 bits of rs2.
parameter XOR = 3'b100; //XOR performs bitwise exclusive or on rs1 and 'rs2' and the result is written to 'rd'.

reg [7:0] opcode_alu;
reg [6:0] rd_add_rf;
reg [31:0] cycle_counter;
reg [31:0] instr_counter;
reg [31:0] instruction; 
reg [31:0] alu_result_latch;
 
always@ (posedge clk)
begin
    cycle_counter = cycle_counter + 1;
    if (rst == 1)
      begin 
        cycle_counter <= 0;
        alu_imm1    <= 0;
        alu_imm2    <= 0;
        alu_opcode  <= 0;
        RF_rs1_address <= 0;
        RF_rs2_address <= 0;
        RF_write_enable <= 0; 
        RF_WR_add <= 0;//?
        RF_WriteData <= 0;//?
        RF_chip_enable  <= 0; 
        
        cycle_counter <= 0 ;
        instr_counter <= 0 ;
        decoder_rdy_bsy<= 1 ; 
        
        state <= IDLE_STATE ; 
    end
    
    if (!rst)
      begin        
        case(state)
          IDLE_STATE:
            begin 
              if (instruction_RDY_BSY) //posedge RDY_BSY//
                state <= DECODE_STATE;
                instruction <= instruction_data;
                instr_counter <= instr_counter + 1 ;
                decoder_rdy_bsy  <= 0 ; 
                RF_chip_enable <= 0; 
            end
        
          DECODE_STATE:
            begin
              RF_chip_enable <= 1;              
              case(instruction[14:12])
                ADD:
                  begin
                    if (instruction[6:0] == I_TYPE_OP)      opcode_alu <= 7'b000;
                    else if (instruction[31:25] == 0)            opcode_alu <= 7'b000;
                    else if (instruction[31:25] == 7'b0100000)  opcode_alu <= 7'b001;
                  end
                AND:  opcode_alu <= 7'b010;
                OR:   opcode_alu <= 7'b011;                            
                XOR:  opcode_alu <= 7'b100; 
                SLL:  opcode_alu <= 7'b101;
                SLT:  opcode_alu <= 7'b110; 
                SLTU: opcode_alu <= 7'b111; 
                SRA:  opcode_alu <= 7'b1000;
                SRL:  opcode_alu <= 7'b1001;                                                        
             endcase                        
             
             if (instruction[6:0] == R_TYPE_OP)
               begin
                 rd_add_rf <= instruction[11:7];
                 RF_rs1_address <= instruction[19:15];
                 RF_rs2_address <= instruction[24:20];    
               end
             
             if (instruction[6:0] == I_TYPE_OP)
               begin
                 rd_add_rf <= instruction[11:7];
                 RF_rs1_address <= instruction[19:15];
                 //alu_imm2 <= instruction[31:20];
               end                           

              state <= REGFILE_READ_SRC_REGS_STATE;
               
            end

          REGFILE_READ_SRC_REGS_STATE:
            begin
            
              RF_write_enable = 0 ;  // Prepare for read 
              //RF_chip_enable <= 1;
              alu_imm1 <= RF_reg1_data;
              if (instruction[6:0] == I_TYPE_OP)
                begin
                    alu_imm2 <= instruction[31:20];
                    alu_opcode <= opcode_alu;
                end
              if (instruction[6:0] == R_TYPE_OP)
                begin
                    alu_imm2 <= RF_reg2_data;
                    alu_opcode <= opcode_alu;
                end
              state <= ALU_GET_RESULT;
              RF_write_enable <= 1 ;                                               
            end 
            
          ALU_GET_RESULT: 
            begin 
              RF_WriteData <= alu_result;
              RF_WR_add    <= rd_add_rf;
              //RF_write_enable <= 1 ;
              RF_chip_enable  <= 1;
              state <= IDLE_STATE ; 
            end
        endcase        
    end   
end
endmodule /* Module end */


