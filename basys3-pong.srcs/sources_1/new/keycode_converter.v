`timescale 1ns / 1ps

//-------------------------------------------------------
// File name    : ps2_test.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module keycode_converter(
    output reg [15:0] keycodev,
    input wire [15:0] keycode,
    input wire flag,
    input wire clk
    );
    
    reg cn = 0;
    reg [2:0] bcount = 0;
    reg start = 0;
    
    always@(keycode)
    if (keycode[7:0] == 8'hf0) begin
        cn <= 1'b0;
        bcount <= 3'd0;
    end else if (keycode[15:8] == 8'hf0) begin
        cn <= keycode != keycodev;
        bcount <= 3'd5;
    end else begin
        cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0;
        bcount <= 3'd2;
    end
    
    always@(posedge clk)
        if (flag == 1'b1 && cn == 1'b1) begin
            start <= 1'b1;
            keycodev <= keycode;
        end else
            start <= 1'b0;
    
endmodule
