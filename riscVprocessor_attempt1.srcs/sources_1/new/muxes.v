`timescale 1ns / 1ps


// Mulitplexers (3 needed) - a mux takes multiple inputs and selects one depending on some logic
module mux1(sel1, A1, B1, mux1_out);

input sel1;
input [31:0] A1, B1;
output [31:0] mux1_out;

assign mux1_out = (sel1==1'b0) ? A1 : B1;

endmodule

module mux2(sel2, A2, B2, mux2_out);

input sel2;
input [31:0] A2, B2;
output [31:0] mux2_out;

assign mux2_out = (sel2==1'b0) ? A2 : B2;

endmodule

module mux3(sel3, A3, B3, mux3_out);

input sel3;
input [31:0] A3, B3;
output [31:0] mux3_out;

assign mux3_out = (sel3==1'b0) ? A3 : B3;

endmodule