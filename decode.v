`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2025 05:12:01 PM
// Design Name: 
// Module Name: decode
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

// op mul
module decode (
	clk,
	reset,
	Op,
	Funct,
	Instr, // change
	Rd,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	IRWrite,
	AdrSrc,
	ResultSrc,
	ALUSrcA,
	ALUSrcB,
	ImmSrc,
	RegSrc,
	ALUControl
);
	input wire clk;
	input wire reset;
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW; // now reg
	output wire PCS;
	output wire NextPC;
	output wire RegW;
	output wire MemW;
	output wire IRWrite;
	output wire AdrSrc;
	output wire [1:0] ResultSrc;
	output wire [1:0] ALUSrcA;
	output wire [1:0] ALUSrcB;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [3:0] ALUControl; // change
	input  wire [31:0] Instr;  // new
	wire Branch;
	wire ALUOp;

	wire is_mul = (Instr[7:4] == 4'b1001); // te dice si es mul: umul o smul
    wire is_umull = is_mul && (Instr[22] == 1'b0);
    wire is_smull = is_mul && (Instr[22] == 1'b1);

	// Main FSM
	mainfsm fsm(
		.clk(clk),
		.reset(reset),
		.Op(Op),
		.Funct(Funct),
		.IRWrite(IRWrite),
		.AdrSrc(AdrSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ResultSrc(ResultSrc),
		.NextPC(NextPC),
		.RegW(RegW),
		.MemW(MemW),
		.Branch(Branch),
		.ALUOp(ALUOp)
	);

	// ALU Decoder

	// PC Logic
	// Add code for the Instruction Decoder (Instr Decoder) below.
	// Recall that the input to Instr Decoder is Op, and the outputs are
	// ImmSrc and RegSrc. We've completed the ImmSrc logic for you.

	// INSTR DECODER
	assign ImmSrc = Op;
	reg [9:0] controls;

	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 10'b0000101001;
				else
					controls = 10'b0000001001;
			2'b01:
				if (Funct[0])
					controls = 10'b0001111000;
				else
					controls = 10'b1001110100;
			2'b10: controls = 10'b0110100010;
			default: controls = 10'bxxxxxxxxxx;
		endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	
	// ALU DECODER
	always @(*)
	
		if (ALUOp) begin
		// umull
		  if (is_umull) begin
                ALUControl = 4'b0110;  // UMULL
                end
          else if (is_smull) begin
                 ALUControl = 4'b1000;  // SMULL
          end
                
    
            else begin
            
			casex (Funct[4:1])
				4'b0100: ALUControl = 4'b0000; // add
				4'b0010: ALUControl = 4'b0001; // SUB
				4'b0000: ALUControl = 4'b0010; // and
				4'b1100: ALUControl = 4'b0011;
				4'b1001: ALUControl = 4'b0100; // mul
				4'b1010: ALUControl = 4'b0101; // mov
				4'b1011: ALUControl = 4'b0111; // div
				default: ALUControl = 4'bxxxx;
			endcase
			end
			
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 4'b0000) | (ALUControl == 4'b0001));
		end
		else begin
			ALUControl = 4'b0000;
			FlagW = 2'b00;
		end
		
	assign ResultSrc = (ALUOp && is_umull)  ? 2'b10 :
                   (ALUOp && is_smull) ? 2'b11 : 2'b00;
		
	// CONDICIONES PC
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule