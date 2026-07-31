`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This is the code containing each module that makes up the RISC-V processor.
// Each module has a description outlining its purpose.
//////////////////////////////////////////////////////////////////////////////////


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

input clk,reset;
input [31:0] read_address;
output reg [31:0] instruction_out;

reg [31:0] I_Mem[63:0];
// 64 memory locations each of 32 bit size
integer k;

always @(posedge clk or posedge reset)
begin
if(reset) begin
    for(k=0; k<64; k=k+1) begin
    I_Mem[k] <= 32'b00;
    end
end else
    instruction_out <= I_Mem[read_address];
    end
endmodule

// Register File - file of registers that holds values currently being used

module register_file (clk, reset, rs1, rs2, rd, write_data, read_data1, read_data2, write);

input clk, reset, write;
input [4:0] rs1, rs2, rd;
input [31:0] write_data;
output [31:0] read_data1, read_data2;

integer k;
reg [31:0] Registers[31:0];
// 32 register locations of 32 bit size

always @(posedge clk or posedge reset)
begin
if(reset) begin
    for(k=0; k<32; k=k+1) begin
    Registers[k] <= 32'b00;
    end
end else if(write) begin
    Registers[rd] <= write_data;
    end 
end

assign read_data1 = Registers[rs1];
assign read_data2 = Registers[rs2];

endmodule

// Immediate Generator
module ImmGen(Opcode, instruction, ImmExt);

endmodule






