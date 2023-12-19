`timescale 1ns / 1ps

module PC(
    input PC_rst,
    input PC_clk,
    input PC_jump_enb,
    input [31:0] PC_jump_add,
    output reg [31:0] PC_counter 
    );
       
always @(posedge PC_clk) 
    begin
    
        if (PC_rst)
            PC_counter = 0; //counter reset
            
        else if (PC_jump_enb)
            PC_counter = PC_jump_add; //jump
            
        else if (!PC_jump_enb)
            PC_counter = PC_counter + 4;
               
    end

endmodule
