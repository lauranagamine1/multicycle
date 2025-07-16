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
  input  [31:0] a,
  input  [31:0] b,
  output wire [31:0] sum
);

  // extraer signos, exponentes y fracciones
  wire signA, signB;
  wire [7:0] expA, expB;
  wire [23:0] manA, manB;  // con bit oculto
  
  assign {signA, expA, manA[22:0]} = a;
  assign {signB, expB, manB[22:0]} = b;
  
  // colocar el bit oculto segun sea el caso
  assign manA[23] = |expA;
  assign manB[23] = |expB;

  // exponentes
  wire [7:0] expDiff = (expA > expB) ? (expA - expB) : (expB - expA);
  wire [23:0] manA_shifted = (expA > expB) ? manA : (manA >> expDiff);
  wire [23:0] manB_shifted = (expB > expA) ? manB : (manB >> expDiff);
  wire [7:0] expAligned = (expA > expB) ? expA : expB;

  // sumar/restar mantisas segun signo
  reg [24:0] mantissaSum;  // 1 bit extra por si hay carry
  reg resultSign;

  always @(*) begin
    if (signA == signB) begin
      mantissaSum = manA_shifted + manB_shifted;
      resultSign = signA;
    end else begin
      if (manA_shifted > manB_shifted) begin
        mantissaSum = manA_shifted - manB_shifted;
        resultSign = signA;
      end else begin
        mantissaSum = manB_shifted - manA_shifted;
        resultSign = signB;
      end
    end
  end

  // 6. Normalización
  reg [7:0] finalExp;
  reg [23:0] finalMan;

  always @(*) begin
    finalExp = expAligned;
    if (mantissaSum[24]) begin
      // Overflow, desplazar y aumentar exponente
      finalMan = mantissaSum[24:1];
      finalExp = finalExp + 1;
    end else begin
      // Normalizar hacia la izquierda si hay ceros a la izquierda
      finalMan = mantissaSum[23:0];
      while (finalMan[23] == 0 && finalExp > 0) begin
        finalMan = finalMan << 1;
        finalExp = finalExp - 1;
      end
    end
  end

  // 8. Armar el resultado
  wire [22:0] finalFrac = finalMan[22:0];  // ignoramos bit oculto
  assign sum = (mantissaSum == 0) ? 32'b0 :
                  {resultSign, finalExp, finalFrac};

endmodule