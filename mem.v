`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2025 05:07:22 PM
// Design Name: 
// Module Name: mem
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

module mem (
	clk,
	we,
	a,
	wd,
	rd
);
	input wire clk;
	input wire we;
	input wire [31:0] a;
	input wire [31:0] wd;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
    initial $readmemh("memfile.mem", RAM);
    //initial begin //cambio para correr en la placa
      //  RAM[0] = 32'hE3400003;  // aquí cargas la instrucción en hex
    //end

    //assign RAM[1] = E3401002
    //assign RAM[2] = E2411004
    //assign RAM[3] = E0323091
    //assign RAM[4] = 00145091


	assign rd = RAM[a[31:2]]; // word aligned
	always @(posedge clk)
		if (we)
			RAM[a[31:2]] <= wd;
endmodule