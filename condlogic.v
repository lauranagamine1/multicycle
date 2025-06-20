`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2025 05:15:11 PM
// Design Name: 
// Module Name: condlogic
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


// ADD CODE BELOW
// Add code for the condlogic and condcheck modules. Remember, you may
// reuse code from prior labs.
module condlogic (
	input wire clk,
	input wire reset,
	input wire [3:0] Cond,
	input wire [3:0] ALUFlags,
	input wire [1:0] FlagW,
	input wire PCS,
	input wire NextPC,
	input wire RegW,
	input wire MemW,
	output wire PCWrite,
	output wire RegWrite,
	output wire MemWrite
);
	wire [1:0] FlagWrite;
	wire [3:0] Flags;
	wire CondEx;
	reg CondEx_d;  // registra el CondEx

	// Evaluar CondEx desde flags actuales
	condcheck cc(
		.Cond(Cond),
		.Flags(Flags),
		.CondEx(CondEx)
	);

	// Registro de write enable para banderas
	flopr #(2) flagwritereg(
		.clk(clk),
		.reset(reset),
		.d(FlagW & {2{CondEx}}),
		.q(FlagWrite)
	);

	// Registro de banderas de ALU
	flopenr #(4) flagreg(
		.clk(clk),
		.reset(reset),
		.en(|FlagWrite),
		.d(ALUFlags),
		.q(Flags)
	);

	// Registro de CondEx (se usa un ciclo después)
	always @(posedge clk or posedge reset)
		if (reset)
			CondEx_d <= 0;
		else
			CondEx_d <= CondEx;

	// Control de señales condicionales
	assign RegWrite  = RegW  & CondEx_d;
	assign MemWrite  = MemW  & CondEx_d;
	assign PCWrite   = PCS   & CondEx_d;
endmodule
