`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2019 10:58:25 PM
// Design Name: 
// Module Name: clockDiv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
