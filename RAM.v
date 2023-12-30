`timescale 1ns / 1ps

///64*8
module RAM(
    input RAM_clk,
    input RAM_rst,
    input WE,
    input [5:0] RAM_add,
    input [7:0] RAM_in,
    output [31:0] RAM_out
    );
    
reg [7:0] mem [8191:0];
reg [31:0] temp;

integer i;

always @(posedge RAM_clk)
    
    begin
    
        if (RAM_rst == 1) begin
    
            for (i=0; i < 64; i = i + 1) begin
    
                mem[i] <= 0;
    
            end
            
            temp <= 0;
    
        end
    
        else begin
    
            if (WE == 0) begin
        
                temp <= (mem[RAM_add]) + (mem[RAM_add + 1] << 8) + (mem[RAM_add + 2] << 16) + (mem[RAM_add + 3] << 24);
    
            end
    
            else if (WE == 1) begin
            
                mem[RAM_add] <= RAM_in;
        
            end
    
         end
    
    end    
       
assign RAM_out = temp;    
endmodule
