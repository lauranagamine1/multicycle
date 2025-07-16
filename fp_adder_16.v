`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2025 04:30:16 PM
// Design Name: 
// Module Name: fp_adder_16
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

module fp_adder16 (
    // 16 bits
    input  wire [15:0] a,
    input  wire [15:0] b,
    output reg  [15:0] sum
);
    // FORMATO: sign (1 bit), exponent (5 bits), mantissa (10 bits)
    // separar signo, exponente y mantisa de A
    wire sign_a = a[15];
    wire [4:0] exponent_a = a[14:10];
    wire [9:0] mantissa_a = a[9:0];
    // separar signo, exponente y mantisa de B
    wire sign_b = b[15];
    wire [4:0] exponent_b = b[14:10];
    wire [9:0] mantissa_b = b[9:0];

    // agregar bit implícito a mantisa (normalizada)
    wire [10:0] mantissa_a_norm = {1'b1, mantissa_a};
    wire [10:0] mantissa_b_norm = {1'b1, mantissa_b};

    // calcular diferencia de exponentes y elegir mayor/menor
    wire [4:0] exp_diff = (exponent_a > exponent_b) ?
        (exponent_a - exponent_b) : (exponent_b - exponent_a);
    wire [10:0] mantissa_larger  = (exponent_a > exponent_b) ? mantissa_a_norm : mantissa_b_norm;
    wire [10:0] mantissa_smaller = (exponent_a > exponent_b) ? mantissa_b_norm : mantissa_a_norm;
    wire [4:0]  exponent_larger  = (exponent_a > exponent_b) ? exponent_a : exponent_b;
    wire sign_large = (exponent_a > exponent_b) ? sign_a : sign_b;
    wire sign_small = (exponent_a > exponent_b) ? sign_b : sign_a;

    // alinear mantisa menor
    wire [10:0] mantissa_smaller_aligned = mantissa_smaller >> exp_diff;

    // sumar o restar según signos
    wire [11:0] mantissa_sum = (sign_large == sign_small)
        ? (mantissa_larger + mantissa_smaller_aligned)
        : (mantissa_larger - mantissa_smaller_aligned);

    // variables para normalización
    reg [11:0] mantissa_temp;
    reg [10:0] mantissa_normalized;
    reg [4:0] exponent_normalized;
    reg exit;
    integer i;

    // normalización y empaquetado en un solo bloque
    always @(*) begin
        if (mantissa_sum == 12'd0) begin
            // resultado cero
            sum = 16'b0;
        end else begin
            // preparar normalización
            mantissa_temp     = mantissa_sum;
            exponent_normalized = exponent_larger;
            exit = 1'b0;
            // caso overflow en suma de mantisas
            if (mantissa_temp[11]) begin
                // desplazar a la derecha
                mantissa_normalized = mantissa_temp[11:1];
                exponent_normalized = exponent_normalized + 1;
            end else begin
                // desplazar hasta MSB en bit 10
                for (i = 0; i < 10; i = i + 1) begin
                    if (mantissa_temp[10] || exit) begin
                        mantissa_normalized = mantissa_temp[10:0];
                        exit = 1'b1;
                    end else begin
                        mantissa_temp = mantissa_temp << 1;
                        exponent_normalized = exponent_normalized - 1;
                    end
                end
                if (!exit)
                    mantissa_normalized = mantissa_temp[10:0];
            end
            // empaquetar signo, exponente y mantisa
            
        end
        sum <= { sign_large, exponent_normalized, mantissa_normalized[9:0] };
    end
    
endmodule

