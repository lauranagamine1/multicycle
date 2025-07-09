`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2025 05:10:07 PM
// Design Name: 
// Module Name: fpu
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

// segundo control unit para fadd y fmull
module fpu(
    input [31:0] a, 
    input [31:0] b, 
    input [1:0] sel, // Instr[22:21]
    output reg [31:0] result
    );
    
    wire [31:0] sum32, prod32;
    wire [15:0] sum16, prod16;
    wire [31:0] sum16_ext  = {16'b0, sum16};
    wire [31:0] prod16_ext = {16'b0, prod16};

    
    fp_adder_32 u_fadd32(.a(a), .b(b), .sum(sum32));
    fp_mul_32   u_fmul32(.a(a), .b(b), .sum(prod32));
    fp_adder16  u_fadd16(.a(a[15:0]), .b(b[15:0]), .sum(sum16));
    fp_mul_16   u_fmul16(.a(a[15:0]), .b(b[15:0]), .product(prod16));
        
    
    always @(*) begin
        case(sel)
            2'b00: result = sum32;
            2'b01: result = prod32;
            2'b10: result = sum16_ext;
            2'b11: result = prod16_ext;
            default: result = 32'b0;
        endcase
    end
    

endmodule
