`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025
// Module Name: fp_mul_16
// Description: IEEE-754 half-precision (16 bits) multiplier (sin manejo de NaN/Inf,
//              y con truncamiento simple, no round-to-nearest-even)
//////////////////////////////////////////////////////////////////////////////////

    
module fp_mul_16 (
    input [15:0] a,
    input [15:0] b,
    output reg [15:0] product
);
    reg[21:0] manT;
    reg[9:0] manR;
    reg[4:0] expR;
    
    wire signA = a[15], signB = b[15];
    wire [4:0] expA = a[14:10], expB = b[14:10];
    wire [9:0] fracA = a[9:0], fracB = b[9:0];
    
    wire [10:0] manA = (expA != 0) ? {1'b1, fracA} : {1'b0, fracA};
    wire [10:0] manB = (expB != 0) ? {1'b1, fracB} : {1'b0, fracB};
        
    parameter N = 21;
    integer i;
    
    always @(*) begin
        if (expA == 5'd0 || expB == 5'd0)
            product = 16'd0;
        else  begin
            // 1. Getting new exp
            expR = expA + expB - 15;
            // 2. Multiply mants
            manT = manA * manB;
            
            // 3. Normalize if it's necessary
            if(manT[21] == 0) begin
                for (i = 0; i < N; i = i + 1) begin
                    if (manT[21] == 0) begin
                        manT = manT << 1;
                    end 
                end
                manR = manT[20:11];
            end 
            else begin 
                manR = manT[20:11];
                if(manT[10] == 1) begin
                    manR = manR + 1;
                end
                expR = expR + 1;
            end
    
        product = {a[15] ^ b[15], expR, manR[9:0]};

        end
    end    
endmodule