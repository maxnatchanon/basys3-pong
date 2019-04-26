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

    // Score position - row:[44:56] col:[16:24]&[55:63]
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
        $readmemb("gameTemplate.mem",game_area);
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
            game_area[44][63:55] <= score_pixel_1[8:0];
            game_area[45][63:55] <= score_pixel_1[17:9];
            game_area[46][63:55] <= score_pixel_1[26:18];
            game_area[47][63:55] <= score_pixel_1[35:27];
            game_area[48][63:55] <= score_pixel_1[44:36];
            game_area[49][63:55] <= score_pixel_1[53:45];
            game_area[50][63:55] <= score_pixel_1[62:54];
            game_area[51][63:55] <= score_pixel_1[71:63];
            game_area[52][63:55] <= score_pixel_1[80:72];
            game_area[53][63:55] <= score_pixel_1[89:81];
            game_area[54][63:55] <= score_pixel_1[98:90];
            game_area[55][63:55] <= score_pixel_1[107:99];
            game_area[56][63:55] <= score_pixel_1[116:108];
        end

        if (score_2 != c_score_2)
        begin
            c_score_2 = score_1;
            game_area[44][24:16] <= score_pixel_2[8:0];
            game_area[45][24:16] <= score_pixel_2[17:9];
            game_area[46][24:16] <= score_pixel_2[26:18];
            game_area[47][24:16] <= score_pixel_2[35:27];
            game_area[48][24:16] <= score_pixel_2[44:36];
            game_area[49][24:16] <= score_pixel_2[53:45];
            game_area[50][24:16] <= score_pixel_2[62:54];
            game_area[51][24:16] <= score_pixel_2[71:63];
            game_area[52][24:16] <= score_pixel_2[80:72];
            game_area[53][24:16] <= score_pixel_2[89:81];
            game_area[54][24:16] <= score_pixel_2[98:90];
            game_area[55][24:16] <= score_pixel_2[107:99];
            game_area[56][24:16] <= score_pixel_2[116:108];
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