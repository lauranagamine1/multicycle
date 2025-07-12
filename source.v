`timescale 1ns / 1ps

module hexto7seg (input[3:0] digit, output reg[7:0] catode);
    always @(*) begin
        case (digit)        //   ABCDEFGdp
            4'b0000: catode = 8'b00000011; // 0
            4'b0001: catode = 8'b10011111; // 1
            4'b0010: catode = 8'b00100101; // 2
            4'b0011: catode = 8'b00001101; // 3
            4'b0100: catode = 8'b10011001; // 4
            4'b0101: catode = 8'b01001001; // 5
            4'b0110: catode = 8'b01000001; // 6
            4'b0111: catode = 8'b00011111; // 7
            4'b1000: catode = 8'b00000001; // 8
            4'b1001: catode = 8'b00001001; // 9
            4'b1010: catode = 8'b00010001; // A
            4'b1011: catode = 8'b11000001; // B
            4'b1100: catode = 8'b01100011; // C
            4'b1101: catode = 8'b10000101; // D
            4'b1110: catode = 8'b01100001; // E
            4'b1111: catode = 8'b01110001; // F
            default: catode = 8'b11111111;
        endcase
    end
endmodule


module clkdivider #(parameter DIVIDE_BY = 2)(input clk, input reset, output reg t);
    localparam WIDTH = $clog2(DIVIDE_BY);
    reg [WIDTH-1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            t <= 0;
        end else begin
            if (counter == (DIVIDE_BY/2 - 1)) begin
                t <= ~t;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

module hFSM(
    input clk,
    input reset,
    input [15:0] data,
    output reg [3:0] digit,
    output reg [3:0] anode);
    
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 2'd0;
        else
            state <= state + 1'b1;
    end

    always @(*) begin
        case (state)
            2'd0: begin
                digit <= data[15:12];  // nibble más significativo
                anode <= 4'b0111;      // activa físicamente el dígito 3
            end
            2'd1: begin
                digit <= data[11: 8];
                anode <= 4'b1011;      // activa el dígito 2
            end
            2'd2: begin
                digit <= data[ 7: 4];
                anode <= 4'b1101;      // dígito 1
            end
            2'd3: begin
                digit <= data[ 3: 0];  // nibble menos significativo
                anode <= 4'b1110;      // dígito 0
            end
            default: begin
                digit <= 4'd0;
                anode <= 4'b1111;      // todos apagados
            end
        endcase
    end

endmodule

// Main module
module hexdisplay(
    input clk,
    input reset,
    input[15:0] data,
    output wire[3:0] anode,
    output wire[7:0] catode
);
    wire[3:0] digit;

    hFSM m(
        .clk(clk),
        .reset(reset),
        .data(data),
        .digit(digit),
        .anode(anode)
    );

    hexto7seg decoder (
        .digit(digit),
        .catode(catode)
    );
endmodule