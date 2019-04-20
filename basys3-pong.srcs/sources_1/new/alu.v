`timescale 1ns/1ps
//-------------------------------------------------------
// File name    : alu.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module alu(
    output wire [7:0] S,
    output wire Cout,
    input wire [7:0] A,
    input wire [7:0] B,
    input wire Cin,
    input wire alu_op         // 0 - Add, 1 - Sub
    );

    assign {Cout,S} = (alu_op == 0) ? A + B + Cin : A - B;

endmodule