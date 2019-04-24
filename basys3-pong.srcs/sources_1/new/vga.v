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

    parameter [11:0] BLACK = 12'000;
    parameter [11:0] WHITE = 12'fff;
    
    wire [9:0] x;
    wire [8:0] y;
    reg p_clk;
    reg [15:0] cnt = 0;
    wire start_color, game_color;
    wire video_on, p_tick;
    reg [11:0] rbg_reg;
        
    assign rgb = (video_on) ? ((rgb_reg) ? BLACK : WHITE) : 12'h000;

    always @(posedge p_tick)
    begin
        rgb_reg = (game_state == 0) ? start_color : game_color;
    end
    
    vga_sync VGA_SYNC(clk,nreset,hsync,vsync,video_on,p_tick,x,y);
    start_screen_image START_IMG(start_color,x,y,vsync,video_on);
    game_image_generator GAME_IMG(game_color,paddle_1,paddle_2,ball_x,ball_y,score_1,score_2,vsync,x,y);

endmodule