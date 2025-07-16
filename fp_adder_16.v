`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//
// Create Date: 07/08/2025 01:30:00 AM
// Design Name:
// Module Name: fp_adder16
// Project Name:
// Target Devices:
// Tool Versions:
// Description: 16-bit floating-point adder (half-precision)
//
//////////////////////////////////////////////////////////////////////////////////

module fp_adder16 (
  input  [15:0] a,
  input  [15:0] b,
  output wire [15:0] sum
);
  wire signA = a[15], signB = b[15];
  wire [4:0] expA = a[14:10], expB = b[14:10];
  wire [10:0] manA = (expA != 0) ? {1'b1, a[9:0]} : {1'b0, a[9:0]};
  wire [10:0] manB = (expB != 0) ? {1'b1, b[9:0]} : {1'b0, b[9:0]};

  wire [4:0] expDiff = (expA > expB) ? (expA - expB) : (expB - expA);
  wire [10:0] manA_shifted = (expA > expB) ? manA : (manA >> expDiff);
  wire [10:0] manB_shifted = (expB > expA) ? manB : (manB >> expDiff);
  wire [4:0] expAligned = (expA > expB) ? expA : expB;

  reg [11:0] mantissaSum;
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

  reg [4:0] finalExp;
  reg [10:0] finalMan;

  always @(*) begin
    finalExp = expAligned;
    if (mantissaSum[11]) begin
      finalMan = mantissaSum[11:1];  // Shift right (overflow)
      finalExp = finalExp + 1;
    end else begin
      finalMan = mantissaSum[10:0];
      while (finalMan[10] == 0 && finalExp > 1) begin
        finalMan = finalMan << 1;
        finalExp = finalExp - 1;
      end
    end
  end

  wire [9:0] finalFrac = finalMan[9:0];  // discard implicit bit
  assign sum = (mantissaSum == 0) ? 16'b0 :
                  {resultSign, finalExp, finalFrac};

endmodule