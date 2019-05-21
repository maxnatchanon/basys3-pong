`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : vga.v
// Purpose      : Comp Sys Arch 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module vga(
    output wire [11:0] rgb,         // VGA color
    output wire hsync,              // H-sync signal
    output wire vsync,              // V-sync sugnal
    input wire [7:0] game_state,    // Game state
    input wire [7:0] paddle_1,      // Player 1 position
	input wire [7:0] paddle_2,      // Player 2 position
	input wire [7:0] ball_x,        // Ball X position
	input wire [7:0] ball_y,        // Ball Y position
	input wire [7:0] score_1,       // Player 1 score
	input wire [7:0] score_2,       // Player 2 score
    input wire clk,                 // Board clock (100MHz)
    input wire nreset               // Reset signal (Active low)
    );

    parameter [11:0] BLACK = 12'h000;
    parameter [11:0] WHITE = 12'hfff;
    
    wire [9:0] x;
    wire [8:0] y;
    reg p_clk;
    reg [15:0] cnt = 0;
    wire start_color, game_color;
    wire video_on, p_tick;
    reg [11:0] color_reg;
    wire reset;
        
    assign rgb = (video_on) ? ((color_reg) ? WHITE : BLACK) : 12'h000;
    assign reset = ~nreset;

    always @(posedge p_tick)
    begin
        color_reg = (game_state == 0) ? start_color : game_color;
    end
    
    vga_sync VGA_SYNC(clk,reset,hsync,vsync,video_on,p_tick,x,y);
    start_screen_image START_IMG(start_color,x,y,vsync,video_on);
    game_image_generator GAME_IMG(game_color,paddle_1,paddle_2,ball_x,ball_y,score_1,score_2,vsync,x,y,video_on);

endmodule