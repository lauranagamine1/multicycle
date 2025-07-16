`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2025 02:33:01 PM
// Design Name: 
// Module Name: extend
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

module extend (
	input wire [23:0] Instr,
	input wire [1:0] ImmSrc,
	output wire [31:0] ExtImm_rot, // 
	input wire [3:0] Instr_rot // new Instr[11:8]
);
	reg [31:0] ExtImm;
	
	always @(*)
		case (ImmSrc)
			2'b00: 
			 ExtImm = {24'b000000000000000000000000, Instr[7:0]};
			 //ExtImm = ror32({24'b0, Instr[7:0]}, Instr[11:8]*2);
			2'b01: ExtImm = {20'b00000000000000000000, Instr[11:0]};
			2'b10: ExtImm = {{6 {Instr[23]}}, Instr[23:0], 2'b00};
			// new
			
			default: ExtImm = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
		
	wire is_rot= (ImmSrc == 2'b00) ? 1 : 0;
	assign ExtImm_rot = (is_rot) ? ExtImm << 4 * Instr_rot : ExtImm;
	//assign ExtImm_rot = ExtImm << 4 * Instr_rot; // shift izquierda
	//assign ExtImm_rot = ExtImm;
	
endmodule