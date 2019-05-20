`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : game_image_generator.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module game_image_generator(
    output reg reset_game,
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
    input wire video_on,
    input wire game_state
    );

    // Score position - row:[44:56] col:[17:23]&[56:62]
    // Game position - row:[15:39]
    // Player position - col:[3]&[76]

    reg [79:0] game_area_1 [59:0];
    reg [2:0] c_score_1 = 0, c_score_2 = 0;
    reg [1:0] c_paddle_1 = 0, c_paddle_2 = 0;
    reg [4:0] paddle_pos_1 = 10, paddle_pos_2 = 10;
    reg [7:0] c_ball_x = 40, c_ball_y = 12;
    reg ball_sx = 0, ball_sy = 0;
    wire [90:0] score_pixel_1;
    wire [90:0] score_pixel_2;
    integer i;
    reg [2:0] ball_count = 0;

    initial
    begin
        for (i=0; i<60; i=i+1)
        begin
            game_area_1[i] = 80'h0;
        end
        
        game_area_1[3]  = 80'h7e7e427e000000;
        game_area_1[4]  = 80'h42426240000000;
        game_area_1[5]  = 80'h42426240000000;
        game_area_1[6]  = 80'h42425240000000;
        game_area_1[7]  = 80'h7e424a4e000000;
        game_area_1[8]  = 80'h40424a42000000;
        game_area_1[9]  = 80'h40424642000000;
        game_area_1[10] = 80'h40424642000000;
        game_area_1[11] = 80'h407e427e000000;
        game_area_1[14] = 80'hffffffffffffffffffff;
        game_area_1[40] = 80'hffffffffffffffffffff;
        game_area_1[19] = 80'h18000000000;
        game_area_1[23] = 80'h18000000000;
        game_area_1[27] = 80'h18000000000;
        game_area_1[31] = 80'h18000000000;
        game_area_1[35] = 80'h18000000000;
        
    end

    number_generator NUM1(score_pixel_1,c_score_1);
    number_generator NUM2(score_pixel_2,c_score_2);
    
    wire on_paddle_1, on_paddle_2, on_template, on_ball, on_score_1, on_score_2;
    assign on_paddle_1 = ((639-x)/8 == 76) & ((paddle_pos_1 <= (y/8)-15) & (paddle_pos_1+5 > (y/8)-15));
    assign on_paddle_2 = ((639-x)/8 == 3) & ((paddle_pos_2 <= (y/8)-15) & (paddle_pos_2+5 > (y/8)-15));
    assign on_template = game_area_1[y/8][(639-x)/8];
    assign on_ball = ((639-x)/8 == c_ball_x & y/8 == c_ball_y+15);
    assign on_score_1 = ((639-x)/8 >= 56 & (639-x)/8 < 63) & (y/8 >= 44 & y/8 < 57) & score_pixel_1[(7*((y/8)-44)+((639-x)/8)-56)];
    assign on_score_2 = ((639-x)/8 >= 17 & (639-x)/8 < 24) & (y/8 >= 44 & y/8 < 57) & score_pixel_2[(7*((y/8)-44)+((639-x)/8)-17)];
    
    wire u1, u2, d1, d2, ru1, ru2, rd1, rd2;
    assign u1 = (paddle_1 == 1);
    assign d1 = (paddle_1 == 2);
    assign u2 = (paddle_2 == 1);
    assign d2 = (paddle_2 == 2);
    
    singlePulser sp1(ru1,u1,animate);
    singlePulser sp2(ru2,u2,animate);
    singlePulser sp3(rd1,d1,animate);
    singlePulser sp4(rd2,d2,animate);
    
    always @(posedge animate)
    begin
        if (game_state == 1)
        begin
            if (ru1 & paddle_pos_1 > 0)         paddle_pos_1 <= paddle_pos_1 - 1;
            else if (rd1 & paddle_pos_1 < 20)   paddle_pos_1 <= paddle_pos_1 + 1;
            else if (ru2 & paddle_pos_2 > 0)    paddle_pos_2 <= paddle_pos_2 - 1;
            else if (rd2 & paddle_pos_2 < 20)   paddle_pos_2 <= paddle_pos_2 + 1;
            
            ball_count <= ball_count + 1;
            if (ball_count == 5)
            begin
                ball_count <= 0;
            
                if (ball_sx == 0) c_ball_x <= c_ball_x + 1;
                else if (ball_sx == 1) c_ball_x <= c_ball_x - 1;
                if (ball_sy == 0) c_ball_y <= c_ball_y + 1;
                else if (ball_sy == 1) c_ball_y <= c_ball_y - 1;
                
                if (c_ball_y == 0) ball_sy <= 0;
                else if (c_ball_y == 24) ball_sy <= 1;
                if (c_ball_x == 4 & c_ball_y < paddle_pos_2+5 & c_ball_y >= paddle_pos_2) ball_sx <= 0;
                else if (c_ball_x == 75 & c_ball_y < paddle_pos_1+5 & c_ball_y >= paddle_pos_1) ball_sx <= 1;
                else if (c_ball_x == 0) 
                begin
                    c_ball_x <= 40;
                    c_ball_y <= 12;
                    c_score_1 <= c_score_1 + 1;
                    paddle_pos_1 <= 10;
                    paddle_pos_2 <= 10;
                    
                end
                else if (c_ball_x == 79) 
                begin
                    c_ball_x <= 40;
                    c_ball_y <= 12;
                    c_score_2 <= c_score_2 + 1;
                    paddle_pos_1 <= 10;
                    paddle_pos_2 <= 10;
                end
            end
            
            if (c_score_1 == 5 | c_score_2 == 5) reset_game <= 1;
        end
        else
        begin
            reset_game <= 0;
            c_score_1 <= 0;
            c_score_2 <= 0;
            c_ball_x <= 40;
            c_ball_y <= 12;
            paddle_pos_1 <= 10;
            paddle_pos_2 <= 10;
        end
    end

    always @(x, y)
    begin
        if (video_on)
        begin
            game_color <= (on_template | on_paddle_1 | on_paddle_2 | on_ball | on_score_1 | on_score_2);
	    end
	    else game_color = 12'h0;
	end

endmodule