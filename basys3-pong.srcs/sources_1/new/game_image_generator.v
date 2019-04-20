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

    // Score position - row:[44:56] col:[16:23]&[56:63]
    // Game position - row:[15:39]
    // Player position - col:[3]&[79]

    reg [79:0] game_area [59:0];
    reg [79:0] template [59:0];
    wire [116:0] score_pixel_1;
    wire [116:0] score_pixel_2;
    integer i;

    initial
    begin
        $readmem("gameTemplate.mem",template);
    end

    number_generator NUM1(score_pixel_1,score_1);
    number_generator NUM2(score_pixel_2,score_2);

    always @(posedge animate)
    begin
        // Load template
        for (i=0;i<60;i=i+1)
        begin
            game_area[i] = template[i];
        end
        // Insert score
        for (i=0;i<13;i=i+1)
        begin
            game_area[44+i][23:16] = score_pixel_1[(8*i)+8:8*i];
            game_area[44+i][63:56] = score_pixel_2[(8*i)+8:8*i];
        end
        // Insert ball
        game_area[ball_y+15][ball_x] = 1;
        // Insert paddle
        for (i=15;i<20;i=i+1)
        begin
            game_area[paddle_1+i][3] = 1;
            game_area[paddle_2+i][79] = 1;
        end
    end

    // Return pixel color at (x,y) in scaled image
    // Scale factor: 8
    always @(x or y)
    begin
        game_color = game_area[y/8][x/8];
    end

endmodule