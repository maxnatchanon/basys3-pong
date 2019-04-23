`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : keyboard.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module keyboard(
    output reg rkeycode,                // Keycode
    input wire ps2_data,                // Keyboard data
    input wire ps2_clk,                 // Keyboard clock
    input wire clk,                     // Board clock
    input wire nreset                   // Reset signal (Active low)
    );

    wire [15:0] keycode;                // Output from ps2 module
    wire [15:0] rkeycode;               // Converted keycode
    wire flag;                          // PS2 flag
    wire rclk;                          // Divided clock for 7-Seg
    wire [18:0] tclk;                   // Tempotary clock signals

    // PS2 receiver / converter
    ps2_receiver KB(keycode,flag,clk,ps2_clk,ps2_data);
    keycode_converter KEY_CONV(rkeycode,keycode,flag,clk,nreset);

endmodule