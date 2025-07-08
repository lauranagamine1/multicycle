`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2025 09:55:32 AM
// Design Name: 
// Module Name: fp_adder_tb
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


module tb_fp_adder;

  // Señales de prueba
  reg  [31:0] a;
  reg  [31:0] b;
  wire [31:0] sum;

  // Instanciación del UUT (Unit Under Test)
  fp_adder uut (
    .a(a),
    .b(b),
    .sum(sum)
  );

  initial begin
    // Generación de fichero VCD para trazas

    // Casos de prueba (IEEE-754 simple):
    // 1.0 + 1.0 = 2.0
    a = 32'h3F800000;  //  1.0
    b = 32'h3F800000;  //  1.0
    #10;

    // 1.5 + 2.25 = 3.75
    a = 32'h3FC00000;  //  1.5
    b = 32'h40100000;  //  2.25
    #10;

    // 1.0 + 0.5 = 1.5
    a = 32'h3F800000;  //  1.0
    b = 32'h3F000000;  //  0.5
    #10;

    // -1.0 + 1.0 = 0.0
    a = 32'hBF800000;  // -1.0
    b = 32'h3F800000;  //  1.0
    #10;

    // 0.0 + 0.0 = 0.0
    a = 32'h00000000;  //  0.0
    b = 32'h00000000;  //  0.0
    #10;

  end

endmodule

