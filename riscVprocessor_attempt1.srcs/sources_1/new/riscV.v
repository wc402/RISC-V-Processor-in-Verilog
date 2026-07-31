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

module register_file (clk, reset, rs1, rs2, rd, write_data, read_data1, read_data2, regwrite);

input clk, reset, regwrite;
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
end else if(regwrite) begin
    Registers[rd] <= write_data;
    end 
end

assign read_data1 = Registers[rs1];
assign read_data2 = Registers[rs2];

endmodule

// Immediate Generator - for immediate instruction (specify a number rather than variable)
module ImmGen(Opcode, instruction, ImmExt);

input [6:0] Opcode;
input [31:0] instruction;
output reg [31:0] ImmExt;

always @(*) begin
// case examines each OpCode to determine whether it is a R-format, lw, sw, or beq instruction
    case(Opcode)
    7'b0000011 : ImmExt = {{20{instruction[31]}}, instruction[31:20]};
    // Load type = 20 copies of MSB and concatinates with immediate value from bits 31 to 20
    7'b0100011 : ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
    // Store type
    7'b1100011 : ImmExt = {{19{instruction[31]}}, instruction[31], instruction[30:25], instruction[11:8],1'b0};
    // Branch type
    endcase

end    
endmodule

// Control Unit gives outputs determining behaviour of different components of our processor
module control_unit(instruction, branch, memread, memtoreg, ALUop, memwrite, ALUsrc, regwrite);

input [6:0] instruction;
output reg branch, memread, memtoreg, memwrite, ALUsrc, regwrite;
output reg [1:0] ALUop;

always @(*) begin
    case(instruction)
    7'b0110011 : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} <= 8'b001000_10;
    // R-format (instructions involving operation performed on values in both rs1 and rs2) rather than Imm
    7'b0000011 : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} <= 8'b111100_00;
    // Load type
    7'b0100011 : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} <= 8'b100010_00;
    // Store type
    7'b1100011 : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} <= 8'b000001_01;
    // Immediate type
    endcase
end
endmodule


// ALU module where the operations actually take place, add sub OR AND etc.
module ALU(A, B, Control_in, ALU_result, zero);

input [31:0] A, B;
input [3:0] Control_in;
output reg zero;
output reg [31:0] ALU_result;

always @(Control_in or A or B) begin
    case(Control_in)
    4'b0000 : begin zero <= 0; 
                    ALU_result <= A&B; end
    4'b0001 : begin zero <= 0;
                    ALU_result <= A | B; end                    
    4'b0010 : begin zero <= 0; 
                    ALU_result <= A + B; end
    4'b0110 : begin if(A==B) 
                        zero <= 1; 
                    else 
                        zero <= 0; ALU_result <= A - B; end
    endcase
end                 
endmodule

// ALU control determines the function that the ALU will carry out depending on instruction
module ALU_control (ALUop, fun7, fun3, Control_out);

input fun7;
input [2:0] fun3;
input [1:0] ALUop;
output reg [3:0] Control_out;

always @(*) begin
    case({ALUop, fun7, fun3})
    6'b00_0_000 : Control_out <= 4'b0010;
    6'b01_0_000 : Control_out <= 4'b0110;
    6'b10_0_000 : Control_out <= 4'b0010;
    6'b10_0_000 : Control_out <= 4'b0110;
    6'b10_0_111 : Control_out <= 4'b0000;
    6'b10_0_110 : Control_out <= 4'b0001;
    endcase

end
endmodule 










