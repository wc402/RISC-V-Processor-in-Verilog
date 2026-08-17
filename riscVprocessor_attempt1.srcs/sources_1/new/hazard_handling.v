`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module forwarding_unit(rs1, rs2, rd_EXMEM, regwrite_EXMEM, rd_MEMWB, regwrite_MEMWB, ForwardA, ForwardB);

input [4:0] rs1, rs2, rd_EXMEM, rd_MEMWB;
input regwrite_EXMEM, regwrite_MEMWB;
output reg [1:0] ForwardA, ForwardB;

always @(*) begin
    // for rs1 - checks is rs1 is stored in rd from exmem first and then memwb and whether it should be forwarded
    if (regwrite_EXMEM && (rd_EXMEM != 5'b0) && (rd_EXMEM == rs1))
        ForwardA = 2'b10;
    else if (regwrite_MEMWB && (rd_MEMWB != 5'b0) && (rd_MEMWB == rs1))
        ForwardA = 2'b01;
    else
        ForwardA = 2'b00;

    // for rs2 (same principle as rs1)
    if (regwrite_EXMEM && (rd_EXMEM != 5'b0) && (rd_EXMEM == rs2))
        ForwardB = 2'b10;
    else if (regwrite_MEMWB && (rd_MEMWB != 5'b0) && (rd_MEMWB == rs2))
        ForwardB = 2'b01;
    else
        ForwardB = 2'b00;
end

endmodule



module mux_forwading(select, original_val, memex_val, memwb_val, out_val);

input [1:0] select;
input [31:0] original_val, memex_val, memwb_val;
output reg [31:0] out_val;

always @(*) begin
    case(select)
    2'b00 : out_val = original_val;
    2'b01 : out_val = memwb_val;
    2'b10 : out_val = memex_val;
    default : out_val = original_val;
    endcase
end
    
endmodule

module load_hazard_detect(memread_IDEX, rd_IDEX, rs1_IFID, rs2_IFID, stall);

input memread_IDEX;
input [4:0] rd_IDEX, rs1_IFID, rs2_IFID;
output reg stall;

always @(*) begin
if (memread_IDEX && ((rd_IDEX == rs1_IFID) || (rd_IDEX == rs2_IFID)) && (rd_IDEX != 5'b0)) 
    stall = 1'b1;
else 
    stall = 1'b0;
end
endmodule

module bubble_mux(stall, controlsig_in, controlsig_out);

input stall;
input [8:0] controlsig_in;
output [8:0] controlsig_out;

assign controlsig_out = stall ? 9'b0 : controlsig_in;
endmodule