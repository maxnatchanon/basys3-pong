`timescale 1ns / 1ps

//-------------------------------------------------------
// File name    : vga_test.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module vga_test(
    output wire [6:0] seg,             // 7-Seg number display
    output wire dp,                    // 7-Seg dot display
    output wire [3:0] an,              // 7-Seg selector
    output wire [11:0] rgb,            // VGA color
    output wire hsync,                 // H-sync signal
    output wire vsync,                 // V-sync sugnal
    input wire ps2_data,               // Keyboard data
    input wire ps2_clk,                // Keyboard clock
    input wire clk,                    // Clock
    input wire nreset                  // Reset signal (Active low)
    );
    
	parameter [11:0] BLACK = 12'b000000000000;
	parameter [11:0] WHITE = 12'b111111111111;
    
    wire [9:0] x;
    wire [8:0] y;
    reg p_clk;
    reg [15:0] cnt = 0;
    wire start_color;
    wire video_on, p_tick;
        
    assign rgb = 12'b1111_1111_0000;
    
    vga_sync VGA_SYNC(clk,nreset,hsync,vsync,video_on,p_tick,x,y);
    
    start_screen_image START_IMG(start_color,x,y,vsync,video_on);
    
endmodule
