`timescale 1ns / 1ps

// PROGRAM COUNTER - keeps track of which intruction is next to be executed
module program_counter(clk, reset,stall, PC_in, PC_out);

input clk, reset, stall;
input [31:0] PC_in;
output reg [31:0] PC_out;

always @(posedge clk or posedge reset)
begin
if(reset)
    PC_out <= 32'b00;
else if (!stall)
    PC_out <= PC_in;
end

endmodule

// PC + 4, this adder produces the next PC value (assuming no branch)
module PCplus4 (fromPC, NextoPC);

input [31:0] fromPC;
output [31:0] NextoPC;

assign NextoPC = 4 + fromPC;

endmodule

// Instruction Memory - stores the instructions for the program

module Instruction_Memory (clk, reset, read_address, instruction_out);

input clk, reset;
input [31:0] read_address;
output [31:0] instruction_out;
reg [31:0] I_Mem[255:0];
assign instruction_out = I_Mem[read_address];

integer k;

initial begin
    for(k=0; k<256; k=k+1) I_Mem[k] = 32'b0;
    // Fibonacci sequence to test the forwarding unit
    I_Mem[0]  = 32'h00000093;  // addi x1, x0, 0    
    I_Mem[4]  = 32'h00100113;  // addi x2, x0, 1     
    I_Mem[8]  = 32'h002081B3;  // add  x3, x1, x2    
    I_Mem[12] = 32'h00310233;  // add  x4, x2, x3     
    I_Mem[16] = 32'h004182B3;  // add  x5, x3, x4    
    I_Mem[20] = 32'h00520333;  // add  x6, x4, x5    
    I_Mem[24] = 32'h006283B3;  // add  x7, x5, x6    
    I_Mem[28] = 32'h00730433;  // add  x8, x6, x7    

    // Testing load hazard
    I_Mem[32] = 32'h00802023;  // sw   x8, 0(x0)  
    I_Mem[36] = 32'h00002483;  // lw   x9, 0(x0)    
    I_Mem[40] = 32'h00948533;  // add  x10, x9, x9   

    // Drain the pipeline
    I_Mem[44] = 32'h00000013;
    I_Mem[48] = 32'h00000013;
    I_Mem[52] = 32'h00000013;
    I_Mem[56] = 32'h00000013;
end

endmodule