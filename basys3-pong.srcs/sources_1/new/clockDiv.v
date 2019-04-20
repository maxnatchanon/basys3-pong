`timescale 1ns / 1ns
//-------------------------------------------------------
// File name    : alu.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------


module clockDiv(
    output outClk,
    input inClk
    );
    
    reg outClk;
    
    initial
    begin
        #0
        outClk = 0;
    end
    
    always @(posedge inClk)
    begin
        outClk = ~outClk;
    end
endmodule
