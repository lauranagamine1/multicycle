`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2025 02:37:07 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(input [31:0] SrcA, SrcB,
    input [2:0] ALUControl,
    output reg [31:0] Result,
    output wire [3:0] ALUFlags);
    
    wire neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;
    
    assign condinvb = ALUControl[0] ? ~SrcB : SrcB;
    assign sum = SrcA + condinvb + ALUControl[0];
    always @(*)
    begin
    casex (ALUControl[2:0]) // 3 bits
    3'b00?: Result = sum;
    3'b010: Result = SrcA & SrcB;
    3'b011: Result = SrcA | SrcB;
    3'b100: Result = SrcA * SrcB; // MUL
    3'b101: Result = SrcB; // MOV
    endcase
    end
    
    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = (ALUControl[1] ==
    1'b0)
    & sum[32];
    assign overflow = (ALUControl[1] ==
    1'b0)
    & ~(SrcA[31] ^ SrcB[31] ^
    ALUControl[0]) &
    (SrcA[31]
    ^ sum[31]);
    assign ALUFlags = {neg, zero, carry,
    overflow};
    
    
endmodule