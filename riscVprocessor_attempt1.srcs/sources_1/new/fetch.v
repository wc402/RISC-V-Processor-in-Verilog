`timescale 1ns / 1ps

// PROGRAM COUNTER - keeps track of which intruction is next to be executed
module program_counter(clk, reset, PC_in, PC_out);

input clk, reset;
input [31:0] PC_in;
output reg [31:0] PC_out;

always @(posedge clk or posedge reset)
begin
if(reset)
    PC_out <= 32'b00;
else
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
    I_Mem[0]  = 32'h00500293;  // addi x5, x0, 5 
    I_Mem[4]  = 32'h00000013;  // nop
    I_Mem[8]  = 32'h00000013;  // nop
    I_Mem[12] = 32'h00000013;  // nop
    I_Mem[16] = 32'h00A00313;  // addi x6, x0, 10
    I_Mem[20] = 32'h00000013;  // nop
    I_Mem[24] = 32'h00000013;  // nop
    I_Mem[28] = 32'h00000013;  // nop
    I_Mem[32] = 32'h006283B3;  // add x7, x5, x6
    I_Mem[36] = 32'h00000013;  // nop
    I_Mem[40] = 32'h00000013;  // nop
    I_Mem[44] = 32'h00000013;  // nop
    I_Mem[48] = 32'h00702023;  // sw x7, 0(x0)
    I_Mem[52] = 32'h00000013;  // nop (drain)
    I_Mem[56] = 32'h00000013;  // nop
    I_Mem[60] = 32'h00000013;  // nop
end

endmodule