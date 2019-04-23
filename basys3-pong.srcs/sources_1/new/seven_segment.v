`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : seven_segment.v
// Purpose      : 
// Developers   : Diligent Corporation
//-------------------------------------------------------

module seven_segment(
    output wire [6:0] seg,      // 7-Seg number display
    output wire dp,             // 7-Seg dot display
    output wire [3:0] an,       // 7-Seg selector
    input wire [15:0] number,   // Input number (1,2,3,4) 4 bits each
    input wire clk              // Board clock (100MHz)
    );

    wire rclk;
    wire [18:0] tclk;
    wire [3:0] num0, num1, num2, num3;

    assign {num0,num1,num2,num3} = number;

    // Display module
    quad7seg SEG(seg,dp,an[0],an[1],an[2],an[3],num0,num1,num2,num3,rclk);

    // Clock div for 7-Seg display
    assign tclk[0] = clk;x
    genvar i;
    generate
    for (i = 0 ; i < 18 ; i = i+1)
    begin
        clockDiv c1(tclk[i+1],tclk[i]);
    end
    endgenerate
    clockDiv c2(rclk,tclk[18]);

endmodule