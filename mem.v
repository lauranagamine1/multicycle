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
    //initial $readmemh("memfile.mem", RAM);
    
    // instr for basys
    
    initial begin //cambio para correr en la placa
        RAM[0] = 32'hE340023F;  // aquí cargas la instrucción en hex
        RAM[1] = 32'hE340110C;
        RAM[2] = 32'hE1802001;
        RAM[3] = 32'HE3403240;
        RAM[4] = 32'HE3404102;
        RAM[5] = 32'HE1835004;
        RAM[6] = 32'HEC657002;
        RAM[7] = 32'HEC458002;
        RAM[8] = 32'HE3400005;
        RAM[9] = 32'hE3401006;
        RAM[10] = 32'HE0809001;
        
    end
    
    
	assign rd = RAM[a[31:2]]; // word aligned
	always @(posedge clk)
		if (we)
			RAM[a[31:2]] <= wd;
endmodule