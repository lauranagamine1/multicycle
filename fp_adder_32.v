`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2025 12:53:24 AM
// Design Name: 
// Module Name: fp_adder
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

module fp_adder_32 (
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] sum
);
    // FORMATO
    // separa signo, exponente y mantisa de A
    wire sign_a = a[31];
    wire [7:0]  exponent_a = a[30:23];
    wire [22:0] mantissa_a = a[22:0];

    // separar signo, exponente y mantisa de B
    wire sign_b = b[31];
    wire [7:0]  exponent_b = b[30:23];
    wire [22:0] mantissa_b = b[22:0];

    // add 1 bit a la mantisa
    wire [23:0] mantissa_a_norm = {1'b1, mantissa_a};
    wire [23:0] mantissa_b_norm = {1'b1, mantissa_b};

    // calcular diferencia de exponentes y seleccionar mayor/menor
    wire [7:0] exp_diff = (exponent_a > exponent_b) ? (exponent_a - exponent_b) : (exponent_b - exponent_a);
    
    wire [23:0] mantissa_larger  = (exponent_a > exponent_b) ? mantissa_a_norm : mantissa_b_norm;
    wire [23:0] mantissa_smaller = (exponent_a > exponent_b) ? mantissa_b_norm : mantissa_a_norm;
    wire [7:0]  exponent_larger  = (exponent_a > exponent_b) ? exponent_a : exponent_b;
    wire sign_large = (exponent_a > exponent_b) ? sign_a : sign_b;
    wire sign_small = (exponent_a > exponent_b) ? sign_b : sign_a;

    // mantisa menor
    wire [23:0] mantissa_smaller_aligned = mantissa_smaller >> exp_diff;

    // sumar o restar segin signos
    wire [24:0] mantissa_sum = (sign_large == sign_small)
        ? (mantissa_larger + mantissa_smaller_aligned)
        : (mantissa_larger - mantissa_smaller_aligned);
    
    // variables para normalización
    reg [24:0] mantissa_temp;
    reg [23:0] mantissa_normalized;
    reg [7:0] exponent_normalized;
    reg exit;
    integer i; // para el for

    // normalizacion
    always @(*) begin
    // si la suma de mantisas es 0, suma es 0
        if (mantissa_sum == 25'd0) begin
            sum = 32'b00000000;
        end 
        else begin
            
            mantissa_temp = mantissa_sum;
            exponent_normalized = exponent_larger;
            exit = 1'b0;
    
            // caso de overflow en la suma de mantisas
            if (mantissa_temp[24]) begin
                mantissa_normalized = mantissa_temp[24:1];
                exponent_normalized = exponent_normalized + 1;
            end else begin
                // shifting hasta que aparezca un 1 en el bit 23
                for (i = 0; i < 23; i=i+1) begin
                    if (mantissa_temp[23] || exit) begin
                        mantissa_normalized = mantissa_temp[23:0];
                        exit = 1'b1;
                    end else begin
                        mantissa_temp = mantissa_temp << 1;
                        exponent_normalized = exponent_normalized - 1;
                    end
                end
                if (!exit)
                    mantissa_normalized = mantissa_temp[23:0];
            end
        end
    end

    // empaquetar signo, exponente y mantisa en la salida
    always @(*) begin
        sum = { sign_large, exponent_normalized, mantissa_normalized[22:0] };
    end

endmodule