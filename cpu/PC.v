`timescale 1ns / 1ps

module PC(
    input pc_rst,
    input pc_clk,
    input pc_jump_enb,
    input [31:0] pc_offset,
    output reg [31:0] pc_counter 
    );
       
always @(posedge pc_clk) 
    begin
    
        if (pc_rst)
            pc_counter = 0; //counter reset
            
        else if (pc_jump_enb)
            pc_counter = pc_counter + pc_offset ; //jump
            
        else if (!pc_jump_enb)
            pc_counter = pc_counter + 4;
               
    end

endmodule
