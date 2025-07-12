`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2025 05:10:42 PM
// Design Name: 
// Module Name: arm
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


module arm (
	clk,
	reset,
	MemWrite,
	Adr,
	WriteData,
	ReadData,
	Result
);
	input wire clk;
	input wire reset;
	output wire MemWrite;
	output wire [31:0] Adr;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	output wire [31:0] Result;
	wire [31:0] Instr;
	wire [3:0] ALUFlags;
	wire [3:0] FPUFlags;
	wire PCWrite;
	wire RegWrite;
	wire IRWrite;
	wire AdrSrc;
	wire [1:0] RegSrc;
	wire [1:0] ALUSrcA;
	wire [1:0] ALUSrcB;
	wire [1:0] ImmSrc;
	wire [3:0] ALUControl; //modificación del ALUControl a 3 bits
	wire [1:0] ResultSrc;
	
	wire is_mul;
	
	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr),
		.ALUFlags(ALUFlags),
		.FPUFlags(FPUFlags),
		.PCWrite(PCWrite),
		.MemWrite(MemWrite),
		.RegWrite(RegWrite),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.RegSrc(RegSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.ImmSrc(ImmSrc),
		.ALUControl(ALUControl),
	    .is_mul(is_mul)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.Adr(Adr),
		.WriteData(WriteData),
		.ReadData(ReadData),
		.Instr(Instr),
		.ALUFlags(ALUFlags),
		.FPUFlags(FPUFlags),
		.PCWrite(PCWrite),
		.RegWrite(RegWrite),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.RegSrc(RegSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.ImmSrc(ImmSrc),
		.ALUControl(ALUControl),
		.is_mul(is_mul),
		.Result(Result)
	);
endmodule