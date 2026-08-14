`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module IFID_reg(clk, reset, PC_in, instruction_in, PC_out, instruction_out);

input clk, reset;
input [31:0] PC_in, instruction_in;
output reg [31:0] PC_out, instruction_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        PC_out <= 32'b0;
        instruction_out <= 32'b0;
    end else begin
        PC_out <= PC_in;
        instruction_out <= instruction_in;
    end
end

endmodule

module IDEX_reg(clk, reset, 
    PC_in, readdata1_in, readdata2_in, imm_in, instruction_in, ALUsrc_in, branch_in, memread_in, memtoreg_in, memwrite_in, regwrite_in, ALUop_in, Rtype_in,
    PC_out, readdata1_out, readdata2_out, imm_out, instruction_out,
    ALUsrc_out, branch_out, memread_out, memtoreg_out, memwrite_out, regwrite_out, ALUop_out, Rtype_out);

input clk, reset;
input [31:0] PC_in, readdata1_in, readdata2_in, imm_in, instruction_in;
input ALUsrc_in, branch_in, memread_in, memtoreg_in, memwrite_in, regwrite_in, Rtype_in;
input [1:0] ALUop_in;

output reg [31:0] PC_out, readdata1_out, readdata2_out, imm_out, instruction_out;
output reg ALUsrc_out, branch_out, memread_out, memtoreg_out, memwrite_out, regwrite_out, Rtype_out;
output reg [1:0] ALUop_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        PC_out <= 32'b0; readdata1_out <= 32'b0; readdata2_out <= 32'b0; imm_out <= 32'b0; instruction_out <= 32'b0;
        ALUsrc_out <= 0; branch_out <= 0; memread_out <= 0; memtoreg_out <= 0;
        memwrite_out <= 0; regwrite_out <= 0; Rtype_out <= 0; ALUop_out <= 2'b0;
    end else begin
        PC_out <= PC_in; readdata1_out <= readdata1_in; readdata2_out <= readdata2_in; imm_out <= imm_in; instruction_out <= instruction_in;
        ALUsrc_out <= ALUsrc_in; branch_out <= branch_in; memread_out <= memread_in; memtoreg_out <= memtoreg_in;
        memwrite_out <= memwrite_in; regwrite_out <= regwrite_in; Rtype_out <= Rtype_in; ALUop_out <= ALUop_in;
    end
end

endmodule

module EXMEM_reg(clk, reset,
    address_in, readdata2_in, instruction_in,
    memread_in, memwrite_in, memtoreg_in, regwrite_in,
    address_out, readdata2_out, instruction_out,
    memread_out, memwrite_out, memtoreg_out, regwrite_out);

input clk, reset;
input [31:0] address_in, readdata2_in, instruction_in;
input memread_in, memwrite_in, memtoreg_in, regwrite_in;

output reg [31:0] address_out, readdata2_out, instruction_out;
output reg memread_out, memwrite_out, memtoreg_out, regwrite_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        address_out <= 32'b0;
        readdata2_out <= 32'b0;
        instruction_out <= 32'b0;
        memread_out <= 0;
        memwrite_out <= 0;
        memtoreg_out <= 0;
        regwrite_out <= 0;
    end else begin
        address_out <= address_in;
        readdata2_out <= readdata2_in;
        instruction_out <= instruction_in;
        memread_out <= memread_in;
        memwrite_out <= memwrite_in;
        memtoreg_out <= memtoreg_in;
        regwrite_out <= regwrite_in;
    end
end

endmodule


module MEMWB_reg(clk, reset,
    address_in, memdata_in, instruction_in, memtoreg_in, regwrite_in,
    address_out, memdata_out, instruction_out, memtoreg_out, regwrite_out);

input clk, reset;
input [31:0] address_in, memdata_in, instruction_in;
input memtoreg_in, regwrite_in;

output reg [31:0] address_out, memdata_out, instruction_out;
output reg memtoreg_out, regwrite_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        address_out <= 32'b0;
        memdata_out <= 32'b0;
        instruction_out <= 32'b0;
        memtoreg_out <= 0;
        regwrite_out <= 0;
    end else begin
        address_out <= address_in;
        memdata_out <= memdata_in;
        instruction_out <= instruction_in;
        memtoreg_out <= memtoreg_in;
        regwrite_out <= regwrite_in;
    end
end

endmodule