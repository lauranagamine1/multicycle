`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2025
// Design Name: Multicycle Testbench
// Module Name: testbench
// Project Name: ARM Multicycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Verifica que el procesador escribe correctamente en memoria
// 
//////////////////////////////////////////////////////////////////////////////////

module testbench;
    reg clk;
    reg reset;
    wire [31:0] WriteData;
    wire [31:0] Adr;
    wire MemWrite;


    top dut (
        .clk(clk),
        .reset(reset),
        .WriteData(WriteData),
        .Adr(Adr),
        .MemWrite(MemWrite)
    );


    initial begin
        clk = 0;
        reset = 1;
        #10;      
        reset = 0;
    end

    // Reloj de 10ns (100MHz)
    always #5 clk = ~clk;


    always @(negedge clk) begin
        if (MemWrite) begin
            if ((Adr === 100) && (WriteData === 7)) begin
                $display("✅ Simulation succeeded at time %t", $time);
                $stop;
            end else if (Adr !== 96) begin
                $display("❌ Simulation failed at time %t", $time);
                $display("MemWrite = %b, Addr = %d, Data = %d", MemWrite, Adr, WriteData);
                $stop;
            end
        end
    end
endmodule