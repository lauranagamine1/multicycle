`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2025 11:18:33
// Design Name: 
// Module Name: mux4
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


module mux4 (
    d0,
    d1,
    d2,
    d3,
    s,
    y
);
    parameter WIDTH = 8;
    input wire [WIDTH - 1:0] d0;
    input wire [WIDTH - 1:0] d1;
    input wire [WIDTH - 1:0] d2;
    input wire [WIDTH - 1:0] d3;
    input wire [1:0] s;
    output wire [WIDTH - 1:0] y;

    assign y = s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0);
endmodule

