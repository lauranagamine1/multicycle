module HexTo7Segment (input[3:0] digit, output reg[7:0] catode);
    ....
endmodule

module CLKdivider(input clk, input reset, output reg t);
    ...
endmodule

module hFSM(input clk,input reset,input[15:0] data,output reg[3:0]
    digit,output reg[3:0] anode);↩→
    ...
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
