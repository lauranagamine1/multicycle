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

module alu(input [31:0] SrcA, 
            input [31:0] SrcB,
            input [3:0] ALUControl,
            output reg [31:0] Result,
            output wire [3:0] ALUFlags,
            output reg [31:0] Result2
            );

    wire neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;
    reg [63:0] mul_res; 

    assign condinvb = ALUControl[0] ? ~SrcB : SrcB;
    assign sum = SrcA + condinvb + ALUControl[0];

    always @(*) begin
        // valores por defecto para evitar latches
        casex (ALUControl[3:0])
            4'b000?: Result = sum;      // ADD, SUB
            4'b0010: Result = SrcA & SrcB;   // AND
            4'b0011: Result = SrcA | SrcB;   // OR
            4'b0100: Result = SrcA * SrcB;    // MUL
            4'b0101: Result = SrcB;  // MOV
            4'b0111: Result  = SrcA / SrcB;   // div
            
            // Result2 = 32 bits mas sig, Result = 32 bits menos significativos
            4'b0110: begin
                mul_res = SrcA * SrcB; // UMULL (unsigned)
                Result = mul_res[31:0];
                Result2 = mul_res[63:32];
                end
            4'b1000: begin
                mul_res = $signed(SrcA)*$signed(SrcB); // SMULL (signed)
                Result = mul_res[31:0];
                Result2 = mul_res[63:32];
                end
        endcase
    end
    
    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = (ALUControl[1] ==1'b0)& sum[32];
    assign overflow = (ALUControl[1] ==1'b0)& ~(SrcA[31] ^ SrcB[31] ^ALUControl[0]) & (SrcA[31]^ sum[31]);
    assign ALUFlags = {neg, zero, carry,overflow};
    
endmodule