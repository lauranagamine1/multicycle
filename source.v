module HexTo7Segment (input[3:0] digit, output reg[7:0] catode);
    casex(input[3:0])
        4'b0000: catode = 7'b0111111; //0
        4'b0001: catode = 7'b0000110; //1
        4'b0010: catode = 7'b1011011; //2
        4'b0011: catode = 7'b1001111; //3
        4'b0100: catode = 7'b1100110; //4
        4'b0101: catode = 7'b1101101; //5
        4'b0110: catode = 7'b1111101; //6
        4'b0111: catode = 7'b0000111; //7
        4'b1000: catode = 7'b1111111; //8
        4'b1001: catode = 7'b1100111; //9
        4'b1010: catode = 7'b1110111; //A 
        4'b1011: catode = 7'b1111100; //B 
        4'b1100: catode = 7'b0111001; //C 
        4'b1101: catode = 7'b1011110; //D 
        4'b1110: catode = 7'b1111001; //E 
        4'b1111: catode = 7'b1110001; //F
endmodule

module CLKdivider(input in_clk, input reset, output reg out_clk);
    parameter DIV_COUNT = 3;  
    reg [3:0] counter;
     
     // reinicio ascinrono
    always @(posedge in_clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            out_clk <= 0;
        end
        else if (counter == DIV_COUNT-1) begin
            counter <= 0;
            out_clk <= ~out_clk;
        end
        else begin
            counter <= counter + 1;
        end
    end
endmodule

module hFSM(input clk,input reset,input[15:0] data,output reg[3:0]
    digit,output reg[3:0] anode);↩→
    
endmodule

// Main module
module hex_display(input clk, input reset, input[15:0] data, output
    wire[3:0]anode, output wire[7:0]catode);↩→
    wire scl_clk;
    wire[3:0] digit;
    CLKdivider sc(
        .clk(clk),
        .reset(reset),
        .t(scl_clk)
    );
    hFSM m(
        .clk(scl_clk),
        .reset(reset),
        .data(data),
        .digit(digit),
        .anode(anode)
    );
    HexTo7Segment decoder (
        .digit(digit),
        .catode(catode)
    );
endmodule
