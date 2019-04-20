`timescale 1ns/1ps
//-------------------------------------------------------
// File name    : mux2_1.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module mux2_1(
    output wire [9:0] dout,
    input wire [9:0] in0,
    input wire [9:0] in1,
    input wire sel
    );

    assign dout = (sel == 0) ? in0 : in1;

endmodule