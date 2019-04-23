`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : ps2_test.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module ps2_test(
    output wire [6:0] seg,              // 7-Seg number display
    output wire dp,                     // 7-Seg dot display
    output wire [3:0] an,               // 7-Seg selector
    output wire [11:0] rgb,             // VGA color
    output wire hsync,                  // H-sync signal
    output wire vsync,                  // V-sync sugnal
    input wire ps2_data,                // Keyboard data
    input wire ps2_clk,                 // Keyboard clock
    input wire clk,                     // Clock
    input wire nreset                   // Reset signal (Active low)
    );
    
    wire [15:0] keycode;                // Output from ps2 module
    wire [15:0] rkeycode;               // Converted keycode
    wire flag;                          // PS2 flag
    wire [3:0] num0, num1, num2, num3;  // 7-Seg input numbers
    wire rclk;                          // Divided clock for 7-Seg
    wire [18:0] tclk;                   // Tempotary clock signals

    assign {num0,num1,num2,num3} = rkeycode;
    
    // PS2 receiver
    ps2_receiver KB(keycode,flag,clk,ps2_clk,ps2_data);
    keycode_converter KEY_CONV(rkeycode,keycode,flag,clk);
    
    // 7-Seg display
    quad7seg SEG(seg,dp,an[0],an[1],an[2],an[3],num0,num1,num2,num3,rclk);

    // Clock div for 7-Seg display
    assign tclk[0] = clk;
    genvar i;
    generate
    for (i = 0 ; i < 18 ; i = i+1)
    begin
        clockDiv c1(tclk[i+1],tclk[i]);
    end
    endgenerate
    clockDiv c2(rclk,tclk[18]);

endmodule