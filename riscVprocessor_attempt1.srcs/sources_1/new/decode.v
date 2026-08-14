`timescale 1ns / 1ps

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
    7'b1100011 : ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8],1'b0};
    // Branch type
    7'b0010011 : ImmExt = {{20{instruction[31]}},instruction[31:20]};
    // Imm type
    default    : ImmExt = 32'b0;
    endcase

end    
endmodule

// Control Unit gives outputs determining behaviour of different components of our processor
module control_unit(instruction, branch, memread, memtoreg, ALUop, memwrite, ALUsrc, regwrite, Rtype);

input [6:0] instruction;
output reg branch, memread, memtoreg, memwrite, ALUsrc, regwrite;
output reg [1:0] ALUop;
output Rtype;

assign Rtype = (instruction == 7'b0110011);   

always @(*) begin
    case(instruction)
    7'b0110011 : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} = 8'b001000_10;
    // R-format (instructions involving operation performed on values in both rs1 and rs2) rather than Imm
    7'b0000011 : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} = 8'b111100_00;
    // Load type
    7'b0100011 : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} = 8'b100010_00;
    // Store type
    7'b1100011 : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} = 8'b000001_01;
    // Branch type
    7'b0010011 : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} = 8'b101000_10;
    // I-type
    default    : {ALUsrc, memtoreg, regwrite, memread, memwrite, branch, ALUop} = 8'b0;
    endcase
end
endmodule