`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2025 09:57:09 AM
// Design Name: 
// Module Name: tb_fp_mul
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


module tb_fp_mul;

  // Señales de prueba
  reg  [31:0] a;
  reg  [31:0] b;
  wire [31:0] product;

  // Instanciación del UUT (Unit Under Test)
  fp_mul uut (
    .flp_a(a),
    .flp_b(b),
    .sum(product)
  );

  initial begin
    // Generar fichero VCD para trazas
    $dumpfile("fp_mul.vcd");
    $dumpvars(0, tb_fp_mul);

    // Encabezado de consola
    $display("   Time     a (hex)    b (hex)    product (hex)");
    $monitor("%0t   %h   %h   %h", $time, a, b, product);

    // -------------------------------------------------
    // Casos de prueba (IEEE-754 simple precisión)
    // -------------------------------------------------

    // 1.0 * 1.0 = 1.0
    a = 32'h3F800000;  //  1.0
    b = 32'h3F800000;  //  1.0
    #10;

    // 1.5 * 2.0 = 3.0
    a = 32'h3FC00000;  //  1.5
    b = 32'h40000000;  //  2.0
    #10;

    // 3.0 * 0.5 = 1.5
    a = 32'h40400000;  //  3.0
    b = 32'h3F000000;  //  0.5
    #10;

    // -1.0 * 1.0 = -1.0
    a = 32'hBF800000;  // -1.0
    b = 32'h3F800000;  //  1.0
    #10;

    // -1.5 * -2.5 = 3.75
    a = 32'hBFC00000;  // -1.5
    b = 32'hC0200000;  // -2.5
    #10;

    // 0.0 * 5.0 = 0.0
    a = 32'h00000000;  //  0.0
    b = 32'h40A00000;  //  5.0
    #10;

    // Overflow: max_float * 2.0
    a = 32'h7F7FFFFF;  // ≈ 3.4028235e38 (float max)
    b = 32'h40000000;  //  2.0
    #10;

    // Underflow: smallest normalized * smallest normalized
    a = 32'h00800000;  // ≈ 1.1754944e-38 (menor normalizado)
    b = 32'h00800000;  // mismo
    #10;

    // Fin de simulación
    #10;
    $finish;
  end

endmodule

