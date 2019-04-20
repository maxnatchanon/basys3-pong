`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : game_image_generator.v
// Purpose      : 
// Developers   : Natchanon A.
//-------------------------------------------------------

module game_image_generator(
    output reg [79:0] game_area [59:0],
    input wire [4:0] paddle_1,
	input wire [4:0] paddle_2,
	input wire [6:0] ball_x,
	input wire [4:0] ball_y,
	input wire [2:0] score_1,
	input wire [2:0] score_2,
    input wire animate
    );

    // Score position - row:[44:56] col:[16:23]&[56:63]
    // Game position - row:[15:39]
    // Player position - col:[3]&[79]

    reg [79:0] template [59:0];
    wire [8:0] score_pixel_1 [12:0];
    wire [8:0] score_pixel_2 [12:0];

    initial
    begin
        $readmem("gameTemplate.mem",template);
    end

    number_generator NUM1(score_pixel_1,score_1);
    number_generator NUM2(score_pixel_2,score_2);

    always @(posedge animate)
    begin
        // Load template
        game_area = template;
        // Insert score
        game_area[56:44][23:16] = score_pixel_1;
        game_area[56:44][63:56] = score_pixel_2;
        // Insert ball
        game_area[ball_y+15][ball_x] = 1;
        // Insert paddle
        game_area[paddle_1+19:paddle_1+15][3] = 1;
        game_area[paddle_2+19:paddle_2+15][79] = 1;
    end

module