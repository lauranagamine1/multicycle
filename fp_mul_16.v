`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2025 12:15:27 AM
// Design Name: 
// Module Name: fp_mul_16
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
    input  [15:0] a, 
    input  [15:0] b,
    output [15:0] product
);

    // 1) Desempaquetar signo, exponente y mantisa (sin bit implícito)
    wire        sa, sb, sres;
    wire [4:0]  expa, expb, expres;
    wire [9:0]  mantA, mantB;

    assign {sa, expa, mantA} = a;
    assign {sb, expb, mantB} = b;

    // 2) Restaurar bit implícito ("1.")
    wire [10:0] NMantA = {1'b1, mantA};
    wire [10:0] NMantB = {1'b1, mantB};

    // 3) Producto de las mantisas (11×11 → 22 bits)
    wire [21:0] bmant = NMantA * NMantB;

    // 4) Signo del resultado
    assign sres = sa ^ sb;

    // 5) Cálculo del exponente resultante
    //    bias_half = 15. Si hay "overflow" de mantisa (bit21=1), restamos bias-1=14;
    //    si no, restamos bias=15.
    assign expres = bmant[21]
                   ? (expa + expb - 14)
                   : (expa + expb - 15);

    // 6) Normalización / extracción de los 10 bits de fracción:
    //    - Si bmant[21]=1, las fracciones están en bmant[20:11]
    //    - Si bmant[21]=0, están en bmant[19:10]
    wire [9:0] frac_norm   = bmant[20:11];
    wire [9:0] frac_denorm = bmant[19:10];
    wire [9:0] mantRes     = bmant[21] ? frac_norm : frac_denorm;

    // 7) Empaquetar resultado
    assign product = { sres, expres, mantRes };

endmodule
