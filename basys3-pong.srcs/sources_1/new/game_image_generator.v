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

    wire [8:0] score_pixel_1 [12:0];
    wire [8:0] score_pixel_2 [12:0];

    number_generator NUM1(score_pixel_1,score_1);
    number_generator NUM2(score_pixel_2,score_2);

    always @(posedge animate)
    begin
        
    end

module