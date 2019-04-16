`timescale 1ns/1ps
//-------------------------------------------------------
// File name    : ps2_receiver.v
// Purpose      : 
// Developers   : Diligent Corporation
//-------------------------------------------------------

module quad7seg(
    output [6:0]seg,
    output dp,
    output an0,
    output an1,
    output an2,
    output an3,
    input [3:0]num0,
    input [3:0]num1,
    input [3:0]num2,
    input [3:0]num3,
    input clk
    );
    
    reg [1:0]currentState;
    reg [1:0]nextState;
    reg [3:0]hexIn;
    reg [3:0]disSel;
    wire [6:0]segment;
    
    decoder D(segment,hexIn);
    
    assign seg = segment;
    assign dp = 0;
    assign {an0,an1,an2,an3} = ~disSel;
    initial
    begin
        #0
        currentState = 0;
    end
    always @(posedge clk)
    begin
        currentState = nextState;
    end
    
    always @(currentState)
    begin
        nextState = currentState + 1;
    end
    
    always @(currentState)
    begin
        case(currentState)
            2'b00: hexIn = num0;
            2'b01: hexIn = num1;
            2'b10: hexIn = num2;
            2'b11: hexIn = num3;
        endcase
    end
    
    always @(currentState)
    begin
        case(currentState)
            2'b00: disSel = 4'b0001;
            2'b01: disSel = 4'b0010;
            2'b10: disSel = 4'b0100;
            2'b11: disSel = 4'b1000;
        endcase
    end
endmodule

