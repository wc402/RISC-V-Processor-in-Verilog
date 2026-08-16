`timescale 1ns / 1ps

// Instantiate all modules (link them together)
module top(clk,reset);
input clk, reset;

wire [31:0] PC_top, instruction_top, readdata1_top, readdata2_top, IMMext_top, mux1out_top, sum_top, nexttopc_out, PCin_top, address_top, memdata_top, writeback_top;
wire regwrite_top, ALUsrc_top, branch_top, zero_top, sel2_top, memtoreg_top, memwrite_top, memread_top, Rtype_top;
wire [1:0] ALUop_top;
wire [3:0] ALUcontrol_top;
// IF/ID pipeline register wires
wire [31:0] PC_top_IFID, instruction_top_IFID;
// ID/EX pipeline register wires
wire [31:0] PC_top_IDEX, readdata1_top_IDEX, readdata2_top_IDEX, IMMext_top_IDEX, instruction_top_IDEX;
wire ALUsrc_top_IDEX, branch_top_IDEX, memread_top_IDEX, memtoreg_top_IDEX, memwrite_top_IDEX, regwrite_top_IDEX, Rtype_top_IDEX;
wire [1:0] ALUop_top_IDEX;
// EX/MEM pipeline register wires
wire [31:0] address_top_EXMEM, readdata2_top_EXMEM, instruction_top_EXMEM;
wire memread_top_EXMEM, memwrite_top_EXMEM, memtoreg_top_EXMEM, regwrite_top_EXMEM;
// MEM/WB pipeline register wires
wire [31:0] address_top_MEMWB, memdata_top_MEMWB, instruction_top_MEMWB;
wire memtoreg_top_MEMWB, regwrite_top_MEMWB;
// Forwarding wires
wire [1:0] ForwardA, ForwardB;
wire [31:0] ALU_inputA, mux1in_B;


/////// IF
// Program Counter
program_counter PC(.clk(clk), .reset(reset), .PC_in(PCin_top), .PC_out(PC_top));
// PC adder
PCplus4 PCadd(.fromPC(PC_top), .NextoPC(nexttopc_out));
// Instruction memory
Instruction_Memory Instructmem(.clk(clk), .reset(reset), .read_address(PC_top), .instruction_out(instruction_top));

// IF/ID pipeline register
IFID_reg IFIDreg(.clk(clk), .reset(reset), .PC_in(PC_top), .instruction_in(instruction_top), .PC_out(PC_top_IFID), .instruction_out(instruction_top_IFID));

///////// ID
// Register File
register_file REGfile(.clk(clk), .reset(reset), .rs1(instruction_top_IFID[19:15]), .rs2(instruction_top_IFID[24:20]), .rd(instruction_top_MEMWB[11:7]), .write_data(writeback_top), .read_data1(readdata1_top), .read_data2(readdata2_top), .regwrite(regwrite_top_MEMWB));
//Immediate generator
ImmGen IMMgen(.Opcode(instruction_top_IFID[6:0]), .instruction(instruction_top_IFID), .ImmExt(IMMext_top));
// Control Unit
control_unit CONTROLunit(.instruction(instruction_top_IFID[6:0]), .branch(branch_top), .memread(memread_top), .memtoreg(memtoreg_top), .ALUop(ALUop_top), .memwrite(memwrite_top), .ALUsrc(ALUsrc_top), .regwrite(regwrite_top), .Rtype(Rtype_top));

// ID/EX register
IDEX_reg IDEXreg(.clk(clk), .reset(reset), 
    .PC_in(PC_top_IFID), .readdata1_in(readdata1_top), .readdata2_in(readdata2_top), .imm_in(IMMext_top), .instruction_in(instruction_top_IFID), .ALUsrc_in(ALUsrc_top), .branch_in(branch_top), .memread_in(memread_top), .memtoreg_in(memtoreg_top), .memwrite_in(memwrite_top), .regwrite_in(regwrite_top), .ALUop_in(ALUop_top), .Rtype_in(Rtype_top),
    .PC_out(PC_top_IDEX), .readdata1_out(readdata1_top_IDEX), .readdata2_out(readdata2_top_IDEX), 
    .imm_out(IMMext_top_IDEX), .instruction_out(instruction_top_IDEX),
    .ALUsrc_out(ALUsrc_top_IDEX), .branch_out(branch_top_IDEX), .memread_out(memread_top_IDEX), .memtoreg_out(memtoreg_top_IDEX),
    .memwrite_out(memwrite_top_IDEX), .regwrite_out(regwrite_top_IDEX), .ALUop_out(ALUop_top_IDEX), .Rtype_out(Rtype_top_IDEX));
// Forwarding unit and mux
forwarding_unit FWDunit(.rs1(instruction_top_IDEX[19:15]), .rs2(instruction_top_IDEX[24:20]), .rd_EXMEM(instruction_top_EXMEM[11:7]), .regwrite_EXMEM(regwrite_top_EXMEM),.rd_MEMWB(instruction_top_MEMWB[11:7]), .regwrite_MEMWB(regwrite_top_MEMWB), .ForwardA(ForwardA), .ForwardB(ForwardB));
mux_forwading MUXfwdA(.select(ForwardA), .original_val(readdata1_top_IDEX), .memex_val(address_top_EXMEM), .memwb_val(writeback_top), .out_val(ALU_inputA));
mux_forwading MUXfwdB(.select(ForwardB), .original_val(readdata2_top_IDEX), .memex_val(address_top_EXMEM), .memwb_val(writeback_top), .out_val(mux1in_B));


//////// EX
// ALU control
ALU_control ALUcontrol(.ALUop(ALUop_top_IDEX), .fun7(instruction_top_IDEX[30]), .fun3(instruction_top_IDEX[14:12]), .Control_out(ALUcontrol_top), .Rtype(Rtype_top_IDEX));
//ALU
ALU ALunit(.A(ALU_inputA), .B(mux1out_top), .Control_in(ALUcontrol_top), .ALU_result(address_top), .zero(zero_top));
//ALU mux1
mux1 ALUmux(.sel1(ALUsrc_top_IDEX), .A1(mux1in_B), .B1(IMMext_top_IDEX), .mux1_out(mux1out_top));
// Adder
Adder Adder(.in_1(PC_top_IDEX), .in_2(IMMext_top_IDEX), .sum_out(sum_top));
// AND gate
AND_logic ANDlogic(.branch(branch_top_IDEX), .zero(zero_top), .and_out(sel2_top));
// Mux2 for Adder
mux2 ADDmux(.sel2(sel2_top), .A2(nexttopc_out), .B2(sum_top), .mux2_out(PCin_top));

// EXMEM register
EXMEM_reg EXMEMreg(.clk(clk), .reset(reset),
    .address_in(address_top), .readdata2_in(mux1in_B), .instruction_in(instruction_top_IDEX),
    .memread_in(memread_top_IDEX), .memwrite_in(memwrite_top_IDEX), .memtoreg_in(memtoreg_top_IDEX), .regwrite_in(regwrite_top_IDEX),
    .address_out(address_top_EXMEM), .readdata2_out(readdata2_top_EXMEM), .instruction_out(instruction_top_EXMEM),
    .memread_out(memread_top_EXMEM), .memwrite_out(memwrite_top_EXMEM), .memtoreg_out(memtoreg_top_EXMEM), .regwrite_out(regwrite_top_EXMEM));

////////// MEM
// Data memory
data_memory DATAmem(.clk(clk), .reset(reset), .memwrite(memwrite_top_EXMEM), .memread(memread_top_EXMEM), .read_address(address_top_EXMEM), .write_data(readdata2_top_EXMEM), .memdata_out(memdata_top));
// mux3 for data mem output
mux3 MEMmux(.sel3(memtoreg_top_MEMWB), .A3(address_top_MEMWB), .B3(memdata_top_MEMWB), .mux3_out(writeback_top));


// MEMWB register
MEMWB_reg MEMWBreg(.clk(clk), .reset(reset),
    .address_in(address_top_EXMEM), .memdata_in(memdata_top), .instruction_in(instruction_top_EXMEM), 
    .memtoreg_in(memtoreg_top_EXMEM), .regwrite_in(regwrite_top_EXMEM),
    .address_out(address_top_MEMWB), .memdata_out(memdata_top_MEMWB), .instruction_out(instruction_top_MEMWB), 
    .memtoreg_out(memtoreg_top_MEMWB), .regwrite_out(regwrite_top_MEMWB));

endmodule