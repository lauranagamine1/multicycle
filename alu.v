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

module alu(input [31:0] SrcA, input [31:0] SrcB,
            input [3:0] ALUControl, // change
            output reg [31:0] Result,
            output reg [31:0] Result2,
            output wire [3:0] ALUFlags
            );

    wire neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;
    //wire [63:0] mul_res;

    assign condinvb = ALUControl[0] ? ~SrcB : SrcB;
    assign sum = SrcA + condinvb + ALUControl[0];

    always @(*)
    begin
        casex (ALUControl[3:0])
            4'b000?: Result = sum;  // ADD, SUB
            4'b0010: Result = SrcA & SrcB; // AND
            4'b0011: Result = SrcA | SrcB; // OR
            4'b0100: Result = SrcA * SrcB; // MUL
            4'b0101: Result = SrcB;   // MOV
            //4'b0101: {Result2, Result} = SrcA * SrcB; // UMULL (unsigned)
            //4'b0110: {Result2, Result} = $signed(SrcA) * $signed(SrcB); // SMULL (signed)
            4'b0111: Result = SrcA / SrcB; // DIV
            
            default: begin
                //Result = 32'b0;
                Result2 = 32'b0;
            end
        endcase
    end
    
    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = (ALUControl[1] ==1'b0)& sum[32];
    assign overflow = (ALUControl[1] ==1'b0)& ~(SrcA[31] ^ SrcB[31] ^ALUControl[0]) & (SrcA[31]^ sum[31]);
    assign ALUFlags = {neg, zero, carry,overflow};

endmodule