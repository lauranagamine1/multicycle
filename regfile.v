`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2025 02:32:33 PM
// Design Name: 
// Module Name: regfile
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

module regfile (
	clk,
	we3,
	ra1,
	ra2,
	wa3,
	wa4, // new
	wd3,
	wd4, // new
	r15,
	rd1,
	rd2,
	is_mul
);

	input wire clk;
	input wire we3;
	input wire [3:0] ra1;
	input wire [3:0] ra2;
	input wire [3:0] wa3;
	input wire [3:0] wa4;
	
	input wire [31:0] wd3;
	input wire [31:0] wd4; // new
	
	
	input wire [31:0] r15;
	output wire [31:0] rd1;
	output wire [31:0] rd2;
	reg [31:0] rf [14:0];
	
	input wire is_mul;
	
	
	always @(posedge clk) begin
		if (we3)
			rf[wa3] <= wd3;
			if(is_mul)
			     rf[wa4] <= wd4;
    end
    
	assign rd1 = (ra1 == 4'b1111 ? r15 : rf[ra1]);
	assign rd2 = (ra2 == 4'b1111 ? r15 : rf[ra2]);
endmodule