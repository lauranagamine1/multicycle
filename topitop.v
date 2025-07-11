`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2025 16:27:28
// Design Name: 
// Module Name: topitop
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


module topitop(
    input clk,
    input reset,
    output
 wire[3:0]anode,
    output wire[6:0]catode
    );
    wire [31:0] WriteData;
	wire [31:0] Adr;
	wire MemWrite;
  
    
    top top(
    .clk(clk),
    .reset(reset),
    .WriteData(WriteData),
    .Adr(Adr),
    .MemWrite(MemWrite)
    );
    
    hex_display hd(
    .clk(clk),
    .reset(reset),
    .data(WriteData[15:0]),
    .anode(anode),
    .catode(catode)
    );
    
endmodule
