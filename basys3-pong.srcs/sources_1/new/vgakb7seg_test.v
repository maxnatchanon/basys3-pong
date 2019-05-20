`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2019 12:38:22 AM
// Design Name: 
// Module Name: vgakb7seg_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vgakb7seg_test(
    output wire [6:0] seg,             // 7-Seg number display
    output wire dp,                    // 7-Seg dot display
    output wire [3:0] an,              // 7-Seg selector
    output wire [11:0] rgb,            // VGA color
    output wire hsync,                 // H-sync signal
    output wire vsync,                 // V-sync sugnal
    output wire [1:0] led,
    input wire ps2_data,               // Keyboard data
    input wire ps2_clk,                // Keyboard clock
    input wire clk,                    // Clock
    input wire nreset                  // Reset signal (Active low)
    );
    
    wire [15:0] keycode;
    reg [7:0] game_state = 0;
    reg [7:0] score0 = 0;
    reg [7:0] score1 = 0;
    reg [7:0] paddle0 = 0, tpaddle0 = 0;
    reg [7:0] paddle1 = 0, tpaddle1 = 0;
    reg [7:0] ballx = 0, bally = 0;
    reg ballsx = 0, ballsy = 0;
    reg movex = 0, movey = 0;
    wire reset_game;
    
    assign led[0] = ~game_state;
    assign led[1] = game_state;
    
    // KB PRESS
    always @(keycode, nreset)
    begin
        if (nreset == 0) 
        begin
            game_state <= 0;
        end
        else
        begin
            if (game_state == 0)
            begin
                if (keycode[7:0] == 8'h29)
                begin
                    game_state <= 1;      // Set game state to 1
                    paddle0 <= 0;         // Set paddle 1 position
                    paddle1 <= 0;         // Set paddle 2 position
                    ballx <= 40;          // Set ball x position
                    bally <= 12;          // Set ball y position
                    ballsx <= 0;
                    ballsy <= 0;
                    score0 <= 0;
                    score1 <= 0;
                end
            end
            else if (game_state == 1 & keycode[15:8] != 8'hf0)
            begin
                case (keycode[7:0])
                8'h1c: paddle0 <= 1;  // A
                8'h1b: paddle0 <= 2;  // S
                8'h42: paddle1 <= 1;  // K
                8'h4b: paddle1 <= 2;  // L
                endcase
            end
            else if (game_state == 1 & keycode[15:8] == 8'hf0)
            begin
                case (keycode[7:0])
                8'h1c: paddle0 <= 0;  // A
                8'h1b: paddle0 <= 0;  // S
                8'h42: paddle1 <= 0;  // K
                8'h4b: paddle1 <= 0;  // L
                endcase
            end
            if (reset_game)
            begin
                game_state <= 0;
            end
        end
    end 
    
    // Keyboard
    wire [15:0] tkeycode; 
    wire flag;
    ps2_receiver KB(tkeycode,flag,clk,ps2_clk,ps2_data);
    keycode_converter KEY_CONV(keycode,tkeycode,flag,clk,nreset);

    // VGA
    vga VGA(reset_game,rgb,hsync,vsync,game_state,paddle0,paddle1,ballx,bally,score0,score1,clk,nreset);
    
    // 7-segment display
    // seven_segment SEVEN_SEG(seg,an,dp,keycode,clk);
    wire rclk;
    wire [18:0] tclk;
    wire [3:0] num0, num1, num2, num3;
    assign {num0,num1,num2,num3} = keycode;
    
    quad7seg SEG(seg,dp,an[0],an[1],an[2],an[3],num0,num1,num2,num3,rclk);
    
    assign tclk[0] = clk;
    genvar i;
    generate
    for (i = 0 ; i < 18 ; i = i+1)
    begin
        clockDiv c1(tclk[i+1],tclk[i]);
    end
    endgenerate
    clockDiv c2(rclk,tclk[18]);
    
endmodule
