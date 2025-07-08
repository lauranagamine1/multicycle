`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2025 12:53:24 AM
// Module Name: fp_adder
// Description: IEEE-754 single-precision adder con round-to-nearest-even (sin NaN/Inf)
//////////////////////////////////////////////////////////////////////////////////

module fp_mul (

    input [31:0] a, 
    input [31:0] b,
	output [31:0] sum);
	
    wire sa, sb, sres;

    wire [7:0] expa, expb,expres;
    wire [22:0] mantA, mantB, mantRes;

    wire [45:0] mantissa;
    wire [47:0] bmantissa;
    
    assign {sa,expa,mantA} = a;
    assign {sb,expb,mantB} = b;
    wire [23:0] NMantA,NMantB;

    assign NMantA = {1'b1,mantA};
    assign NMantB = {1'b1,mantB};

    assign bmantissa = (NMantA) * (NMantB); 
    assign mantissa = (NMantA) * (NMantB);

    assign sres = sa*sb; // signo de suma final
    assign expres = bmantissa[47] ? expa + expb - 126 : expa + expb - 127;

    assign mantRes = mantissa[45:23];

    reg [22:0] mantreto;
    
    always @(*) begin
        if(bmantissa[47])
        begin
            mantreto=mantRes;
            mantreto=mantreto>>1;
        end
        else
            begin
                mantreto=mantRes;
            end
    end

    assign sum = {sres,expres,mantreto};

endmodule
