`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2019 10:41:09 AM
// Design Name: 
// Module Name: singlePulser
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


module singlePulser(
    output out,
    input in,
    input clk
    );
    
    reg state = 0;
    reg tmp_out = 0;
    
    assign out = tmp_out;
    
    always @(posedge clk)
        begin
            tmp_out = 0;
            case({state,in})
                2'b01:
                begin
                    tmp_out = 1;
                    state = 1;
                end
                2'b10:
                    state = 0;
                2'b11:
                    state = 1;
            endcase
        end
endmodule