`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : game_image_generator.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module game_image_generator(
    output reg game_color,
    input wire [4:0] paddle_1,
	input wire [4:0] paddle_2,
	input wire [6:0] ball_x,
	input wire [4:0] ball_y,
	input wire [2:0] score_1,
	input wire [2:0] score_2,
    input wire animate,
    input wire [9:0] x,
    input wire [8:0] y
    );

    // Score position - row:[44:56] col:[17:23]&[56:62]
    // Game position - row:[15:39]
    // Player position - col:[3]&[79]

    reg [79:0] game_area [59:0];
    reg [2:0] c_score_1 = 7, c_score_2 = 7;
    reg [4:0] c_paddle_1 = 31, c_paddle_2 = 31;
    reg [6:0] c_ball_x = 0;
    reg [4:0] c_ball_y = 0;
    wire [90:0] score_pixel_1;
    wire [90:0] score_pixel_2;
    integer i;

    initial
    begin
        // $readmemb("gameTemplate.mem",game_area);
        game_area[3][54:25]  = 25'b111111001111110010000100111111;
        game_area[4][54:25]  = 25'b100001001000010011000100100000;
        game_area[5][54:25]  = 25'b100001001000010011000100100000;
        game_area[6][54:25]  = 25'b100001001000010010100100100000;
        game_area[7][54:25]  = 25'b111111001000010010010100100111;
        game_area[8][54:25]  = 25'b100000001000010010010100100001;
        game_area[9][54:25]  = 25'b100000001000010010001100100001;
        game_area[10][54:25] = 25'b100000001000010010001100100001;
        game_area[11][54:25] = 25'b100000001111110010000100111111;
        game_area[14] = 80'hffffffffffffffffffff;
        game_area[40] = 80'hffffffffffffffffffff;
        game_area[19][40:39] = 2'b11;
        game_area[23][40:39] = 2'b11;
        game_area[27][40:39] = 2'b11;
        game_area[31][40:39] = 2'b11;
        game_area[35][40:39] = 2'b11;
    end

    number_generator NUM1(score_pixel_1,score_1);
    number_generator NUM2(score_pixel_2,score_2);

    // Pixel flags
    wire on_paddle_1, on_paddle_2, on_template, on_ball, on_score_1, on_score_2;
    assign on_paddle_1 = ((639-x)/8 == 76) & ((c_paddle_1 <= (y/8)-15) & (c_paddle_1+5 > (y/8)-15));
    assign on_paddle_2 = ((639-x)/8 == 3) & ((c_paddle_2 <= (y/8)-15) & (c_paddle_2+5 > (y/8)-15));
    assign on_template = game_area[y/8][(639-x)/8];
    assign on_ball = ((639-x)/8 == c_ball_x & y/8 == c_ball_y+15);
    assign on_score_1 = ((639-x)/8 >= 56 & (639-x)/8 < 63) & (y/8 >= 44 & y/8 < 57) & score_pixel_1[(7*((y/8)-44)+((639-x)/8)-56)];
    assign on_score_2 = ((639-x)/8 >= 17 & (639-x)/8 < 24) & (y/8 >= 44 & y/8 < 57) & score_pixel_2[(7*((y/8)-44)+((639-x)/8)-17)];

    // Return pixel color at (x,y) in scaled image
    always @(x, y)
    begin
        if (video_on)
        begin
            game_color <= (on_template | on_paddle_1 | on_paddle_2 | on_ball | on_score_1 | on_score_2);
	    end
	    else game_color = 12'h0;
	end

endmodule