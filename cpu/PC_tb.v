`timescale 1ns / 1ps



module PC_tb(
    );
    
reg PC_rst;
reg PC_clk;
reg PC_jump_enb;
reg [31:0] PC_jump_add;
wire [31:0] PC_counter; 

PC DUT(PC_rst, PC_clk, PC_jump_enb, PC_jump_add, PC_counter);
always #10 PC_clk = ~PC_clk;

initial begin
     
         
    PC_rst = 1;
    PC_clk = 0;
    PC_jump_enb = 0;
    PC_jump_add = 0;
    
    #10
    
    PC_clk = 1;
    PC_rst = 0;
    
    #10
     
    PC_clk = 0;
    PC_rst = 1;
    
    #20
    
    PC_rst = 0;
    
    #500
    
    PC_jump_enb = 1;
    PC_jump_add = 32'd500;
    
    #20
    PC_jump_enb = 0;
    
    end
    
 
    
    
    

endmodule
