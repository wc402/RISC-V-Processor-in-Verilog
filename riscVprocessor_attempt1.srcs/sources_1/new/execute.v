`timescale 1ns / 1ps

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
module ALU_control (ALUop, fun7, fun3, Control_out, Rtype);

input fun7, Rtype;
input [2:0] fun3;
input [1:0] ALUop;
output reg [3:0] Control_out;

always @(*) begin
    case(ALUop)
    2'b00 : Control_out = 4'b0010;                  
    2'b01 : Control_out = 4'b0110;                     
    2'b10 : begin
        case(fun3)
        3'b000 : Control_out = (Rtype && fun7) ? 4'b0110 : 4'b0010; 
        3'b111 : Control_out = 4'b0000;                
        3'b110 : Control_out = 4'b0001;                
        default: Control_out = 4'b0010;
        endcase
    end
    default : Control_out = 4'b0010;
endcase

end
endmodule 

// AND logic
module AND_logic(branch, zero, and_out);

input branch, zero;
output and_out;

assign and_out = branch & zero;

endmodule

// Adder
module Adder(in_1, in_2, sum_out);

input [31:0] in_1, in_2;
output [31:0] sum_out;

assign sum_out = in_1 + in_2;

endmodule