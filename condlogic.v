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
	wire CondExNext;
	
    assign FlagWrite = FlagW & {2 {CondEx}};

	condcheck cc(
		.Cond(Cond),
		.Flags(Flags),
		.CondEx(CondEx)
	);
	
	flopr condexnext(
         .clk(clk),
		.reset(reset),
		.d(CondEx),
		.q(CondExNext)
	);
	// Registro de write enable para banderas
	flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.d(ALUFlags[3:2]),
		.q(Flags[3:2])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.d(ALUFlags[1:0]),
		.q(Flags[1:0])
	);


	// Control de señales condicionales
	assign RegWrite  = RegW  & CondExNext;
	assign MemWrite  = MemW  & CondExNext;
	assign PCWrite   = (PCS   & CondExNext)|NextPC;
endmodule
