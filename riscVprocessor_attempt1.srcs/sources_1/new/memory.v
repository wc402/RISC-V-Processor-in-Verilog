`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Data memory - stores data
module data_memory (clk, reset, memwrite, memread, read_address, write_data, memdata_out);

input clk, reset, memwrite, memread;
input [31:0] read_address, write_data;
output [31:0] memdata_out;

integer k;
reg [31:0] D_memory[255:0];

always @(posedge clk or posedge reset) begin
if (reset) begin
    for(k = 0; k<256; k=k+1) begin
        D_memory[k] <= 32'b00;
        end
    end
else if(memwrite)
    D_memory[read_address] <= write_data;
end

assign memdata_out = (memread) ? D_memory[read_address] : 32'b00;

endmodule
