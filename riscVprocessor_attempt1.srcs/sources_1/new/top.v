`timescale 1ns / 1ps

// Instantiate all modules (link them together)
module top(clk,reset);
input clk, reset;

wire [31:0] PC_top, instruction_top, readdata1_top, readdata2_top, IMMext_top, mux1out_top, sum_top, nexttopc_out, PCin_top, address_top, memdata_top, writeback_top;
wire regwrite_top, ALUsrc_top, branch_top, zero_top, sel2_top, memtoreg_top, memwrite_top, memread_top, Rtype_top;
wire [1:0] ALUop_top;
wire [3:0] ALUcontrol_top;

// Program Counter
program_counter PC(.clk(clk), .reset(reset), .PC_in(PCin_top), .PC_out(PC_top));
// PC adder
PCplus4 PCadd(.fromPC(PC_top), .NextoPC(nexttopc_out));
// Instruction memory
Instruction_Memory Instructmem(.clk(clk), .reset(reset), .read_address(PC_top), .instruction_out(instruction_top));
// Register File
register_file REGfile(.clk(clk), .reset(reset), .rs1(instruction_top[19:15]), .rs2(instruction_top[24:20]), .rd(instruction_top[11:7]), .write_data(writeback_top), .read_data1(readdata1_top), .read_data2(readdata2_top), .regwrite(regwrite_top));
//Immediate generator
ImmGen IMMgen(.Opcode(instruction_top[6:0]), .instruction(instruction_top), .ImmExt(IMMext_top));
// Control Unit
control_unit CONTROLunit(.instruction(instruction_top[6:0]), .branch(branch_top), .memread(memread_top), .memtoreg(memtoreg_top), .ALUop(ALUop_top), .memwrite(memwrite_top), .ALUsrc(ALUsrc_top), .regwrite(regwrite_top), .Rtype(Rtype_top));
// ALU control
ALU_control ALUcontrol(.ALUop(ALUop_top), .fun7(instruction_top[30]), .fun3(instruction_top[14:12]), .Control_out(ALUcontrol_top), .Rtype(Rtype_top));
//ALU
ALU ALunit(.A(readdata1_top), .B(mux1out_top), .Control_in(ALUcontrol_top), .ALU_result(address_top), .zero(zero_top));
//ALU mux1
mux1 ALUmux(.sel1(ALUsrc_top), .A1(readdata2_top), .B1(IMMext_top), .mux1_out(mux1out_top));
// Adder
Adder Adder(.in_1(PC_top), .in_2(IMMext_top), .sum_out(sum_top));
// AND gate
AND_logic ANDlogic(.branch(branch_top), .zero(zero_top), .and_out(sel2_top));
// Mux2 for Adder
mux2 ADDmux(.sel2(sel2_top), .A2(nexttopc_out), .B2(sum_top), .mux2_out(PCin_top));
// Data memory
data_memory DATAmem(.clk(clk), .reset(reset), .memwrite(memwrite_top), .memread(memread_top), .read_address(address_top), .write_data(readdata2_top), .memdata_out(memdata_top));
// mux3 for data mem output
mux3 MEMmux(.sel3(memtoreg_top), .A3(address_top), .B3(memdata_top), .mux3_out(writeback_top));


endmodule