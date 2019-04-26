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

    always @(posedge animate)
    begin

        // Insert paddle
        if (paddle_1 != c_paddle_1)
        begin
            game_area[c_paddle_1+15][76] = 0;
            game_area[c_paddle_1+16][76] = 0;
            game_area[c_paddle_1+17][76] = 0;
            game_area[c_paddle_1+18][76] = 0;
            game_area[c_paddle_1+19][76] = 0;
            c_paddle_1 = paddle_1;
            game_area[c_paddle_1+15][76] = 1;
            game_area[c_paddle_1+16][76] = 1;
            game_area[c_paddle_1+17][76] = 1;
            game_area[c_paddle_1+18][76] = 1;
            game_area[c_paddle_1+19][76] = 1;
        end

        if (paddle_2 != c_paddle_2)
        begin
            game_area[c_paddle_2+15][3] = 0;
            game_area[c_paddle_2+16][3] = 0;
            game_area[c_paddle_2+17][3] = 0;
            game_area[c_paddle_2+18][3] = 0;
            game_area[c_paddle_2+19][3] = 0;
            c_paddle_2 = paddle_2;
            game_area[c_paddle_2+15][3] = 1;
            game_area[c_paddle_2+16][3] = 1;
            game_area[c_paddle_2+17][3] = 1;
            game_area[c_paddle_2+18][3] = 1;
            game_area[c_paddle_2+19][3] = 1;
        end

        // Insert ball
        if (ball_x != c_ball_x | ball_y != c_ball_y)
        begin
            game_area[c_ball_y+15][c_ball_x] = 0;
            game_area[ball_y+15][ball_x] = 1;
            c_ball_x = ball_x;
            c_ball_y = ball_y;
        end

        // Insert score
        if (score_1 != c_score_1)
        begin
            c_score_1 = score_1;
            game_area[44][62:56] <= score_pixel_1[6:0];
            game_area[45][62:56] <= score_pixel_1[13:7];
            game_area[46][62:56] <= score_pixel_1[20:14];
            game_area[47][62:56] <= score_pixel_1[27:21];
            game_area[48][62:56] <= score_pixel_1[34:28];
            game_area[49][62:56] <= score_pixel_1[41:35];
            game_area[50][62:56] <= score_pixel_1[48:42];
            game_area[51][62:56] <= score_pixel_1[55:49];
            game_area[52][62:56] <= score_pixel_1[62:56];
            game_area[53][62:56] <= score_pixel_1[69:63];
            game_area[54][62:56] <= score_pixel_1[76:70];
            game_area[55][62:56] <= score_pixel_1[83:77];
            game_area[56][62:56] <= score_pixel_1[90:84];
        end

        if (score_2 != c_score_2)
        begin
            c_score_2 = score_1;
            game_area[44][23:17] <= score_pixel_2[6:0];
            game_area[45][23:17] <= score_pixel_2[13:7];
            game_area[46][23:17] <= score_pixel_2[20:14];
            game_area[47][23:17] <= score_pixel_2[27:21];
            game_area[48][23:17] <= score_pixel_2[34:28];
            game_area[49][23:17] <= score_pixel_2[41:35];
            game_area[50][23:17] <= score_pixel_2[48:42];
            game_area[51][23:17] <= score_pixel_2[55:49];
            game_area[52][23:17] <= score_pixel_2[62:56];
            game_area[53][23:17] <= score_pixel_2[69:63];
            game_area[54][23:17] <= score_pixel_2[76:70];
            game_area[55][23:17] <= score_pixel_2[83:77];
            game_area[56][23:17] <= score_pixel_2[90:84];
        end

    end

    // Return pixel color at (x,y) in scaled image
    // Scale factor: 8
    always @(x or y)
    begin
        if (x == 0) game_color = game_area[y/8][79];
        else if (y == 480) game_color = game_area[59][(640-x)/8];
        else game_color = game_area[y/8][(640-x)/8];
    end

endmodule