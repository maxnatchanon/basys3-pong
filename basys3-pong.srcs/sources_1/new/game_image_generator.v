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
    input wire [8:0] y,
    input wire video_on
    );

    // Score position - row:[44:56] col:[17:23]&[56:62]
    // Game position - row:[15:39]
    // Player position - col:[3]&[79]

    reg [79:0] game_area [59:0];
    wire [90:0] score_pixel_1;
    wire [90:0] score_pixel_2;
    integer i;

    initial
    begin
        for (i=0; i<60; i=i+1)
        begin
            game_area[i] = 80'h0;
        end
        
        game_area[3]  = 80'h7e7e427e000000;
        game_area[4]  = 80'h42426240000000;
        game_area[5]  = 80'h42426240000000;
        game_area[6]  = 80'h42425240000000;
        game_area[7]  = 80'h7e424a4e000000;
        game_area[8]  = 80'h40424a42000000;
        game_area[9]  = 80'h40424642000000;
        game_area[10] = 80'h40424642000000;
        game_area[11] = 80'h407e427e000000;
        game_area[14] = 80'hffffffffffffffffffff;
        game_area[40] = 80'hffffffffffffffffffff;
        game_area[19] = 80'h18000000000;
        game_area[23] = 80'h18000000000;
        game_area[27] = 80'h18000000000;
        game_area[31] = 80'h18000000000;
        game_area[35] = 80'h18000000000;    
    end

    number_generator NUM1(score_pixel_1,score_1);
    number_generator NUM2(score_pixel_2,score_2);

    // Pixel flags
    wire on_paddle_1, on_paddle_2, on_template, on_ball, on_score_1, on_score_2;
    assign on_paddle_1 = ((639-x)/8 == 76) & ((paddle_1 <= (y/8)-15) & (paddle_1+5 > (y/8)-15));
    assign on_paddle_2 = ((639-x)/8 == 3) & ((paddle_2 <= (y/8)-15) & (paddle_2+5 > (y/8)-15));
    assign on_template = game_area[y/8][(639-x)/8];
    assign on_ball = ((639-x)/8 == ball_x & y/8 == ball_y+15);
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