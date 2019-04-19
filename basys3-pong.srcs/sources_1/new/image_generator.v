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

	reg [79:0] game_area [59:0]; 	// Store 80*25 grid game area
	wire [9:0] x;  					// Current pixel x position
    wire [8:0] y;  					// Current pixel y position
    wire game_color;				// Game screen pixel color
    wire start_color;				// Start screen pixel color
    wire current_color;				// Current screen pixel color

    // VGA sync
    vga_sync(hsync,vsync,x,y,clk,p_clk,nreset);

    // Output pixel color
    assign current_color = (game_state == 1) ? game_color : start_color;
    assign rgb = (current_color) ? BLACK : WHITE;

	// Generate game area image
	game_image_generator(game_area,game_state,paddle_1,paddle_2,ball_x,ball_y);

	// Scale game to 640*480
	image_scaler(game_color,game_area,x,y);

	// Load start screen image
	start_screen_image(start_color,x,y);

endmodule