`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2025 12:53:24 AM
// Module Name: fp_adder
// Description: IEEE-754 single-precision adder con round-to-nearest-even (sin NaN/Inf)
//////////////////////////////////////////////////////////////////////////////////

    
module fp_mul_32 (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] sum
);
    reg[47:0] manT;
    reg[23:0] manR;
    reg[7:0] expR;
    
    wire signA = a[31], signB = b[31];
    wire [7:0] expA = a[30:23], expB = b[30:23];
    wire [22:0] fracA = a[22:0], fracB = b[22:0];
    
    wire [23:0] manA = (expA != 0) ? {1'b1, fracA} : {1'b0, fracA};
    wire [23:0] manB = (expB != 0) ? {1'b1, fracB} : {1'b0, fracB};
        
    parameter N = 45;
    integer i;
    
    always @(*) begin
        if (expA == 8'd0 || expB == 8'd0)
            sum = 32'd0;
        else  begin
            //nuevo exponente menos bias
            expR = expA + expB - 127;
            // multiplicar mantisa
            manT = manA * manB;
            
            // 3. Normalizacon
            if(manT[47] == 0) begin
                for (i = 0; i < N; i = i + 1) begin
                    if (manT[47] == 0) begin
                        manT = manT << 1;
                    end 
                end
                manR = manT[46:24];
            end 
            else begin 
                manR = manT[46:24];
                if(manT[23] == 1) begin
                    manR = manR + 1;
                end
                expR = expR + 1;
            end
    
        sum = {a[31] ^ b[31], expR, manR[22:0]};

        end
    end    
endmodule