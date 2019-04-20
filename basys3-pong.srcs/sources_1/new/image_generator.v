`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : image_generator.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module image_generator(
	output wire hsync,
	output wire vsync,
	output wire [11:0] rgb,
	input wire game_state,
	input wire [4:0] paddle_1,
	input wire [4:0] paddle_2,
	input wire [6:0] ball_x,
	input wire [4:0] ball_y,
	input wire [2:0] score_1,
	input wire [2:0] score_2,
	input wire clk,
	input wire nreset
	);

	parameter [11:0] BLACK = 0;
	parameter [11:0] WHITE = 4096;

	reg [79:0] game_area [59:0]; 	// Store 80*60 grid game area
	wire p_clk;						// Pixel scan clock
	wire [9:0] x;  					// Current pixel x position
    wire [8:0] y;  					// Current pixel y position
    wire game_color;				// Game screen pixel color
    wire start_color;				// Start screen pixel color
    wire current_color;				// Current screen pixel color
	wire animate;					// Animate signal for image generator

	// Divide clock
	wire tclk;
	clockDiv CD1(tclk,clk);
	clockDiv CD2(p_clk,tclk);

    // VGA sync
    vga_sync VGA_SYNC(hsync,vsync,animate,x,y,clk,p_clk,nreset);

    // Output pixel color
    assign current_color = (game_state == 1) ? game_color : start_color;
    assign rgb = (current_color) ? BLACK : WHITE;

	// Generate game area image
	game_image_generator GAME_IMG_GEN(game_color,paddle_1,paddle_2,ball_x,ball_y,score_1,score_2,animate);

	// Load start screen image
	start_screen_image START_IMG_GEN(start_color,x,y,animate);

endmodule