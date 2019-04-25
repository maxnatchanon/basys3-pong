`timescale 1ns / 1ps

//-------------------------------------------------------
// File name    : vga_test.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module vga_test(
    output wire [6:0] seg,             // 7-Seg number display
    output wire dp,                    // 7-Seg dot display
    output wire [3:0] an,              // 7-Seg selector
    output wire [11:0] rgb,            // VGA color
    output wire hsync,                 // H-sync signal
    output wire vsync,                 // V-sync sugnal
    input wire ps2_data,               // Keyboard data
    input wire ps2_clk,                // Keyboard clock
    input wire clk,                    // Clock
    input wire nreset                  // Reset signal (Active low)
    );
    
    reg [7:0] game_state = 1;
    reg [7:0] paddle_1 = 0, paddle_2 = 19;
    reg [7:0] ball_x = 40, ball_y = 12;
    reg [7:0] score_1 = 3, score_2 = 4;
    wire [7:0] keycode;
    
    vga VGA(rgb,hsync,vsync,game_state,paddle_1,paddle_2,ball_x,ball_y,score_1,score_2,clk,nreset);
    keyboard KB(keycode,ps2_clk,ps2_data,clk,nreset);
    
    always @(keycode)
    begin
        case (keycode)
        16'h001C: if (paddle_1 > 0) paddle_1 = paddle_1 - 1;
        16'h001B: if (paddle_1 < 19) paddle_1 = paddle_1 + 1;
        16'h0042: if (paddle_2 > 0) paddle_2 = paddle_2 - 1;
        16'h004B: if (paddle_2 < 19) paddle_2 = paddle_2 + 1;
        16'h0029: score_1 = score_1 + 1;
        endcase
    end
    
    always @(score_1)
        if (score_1 == 5) game_state = 0;
    
//	parameter [11:0] BLACK = 12'b000000000000;
//	parameter [11:0] WHITE = 12'b111111111111;
    
//    wire [9:0] x;
//    wire [8:0] y;
//    reg p_clk;
//    reg [15:0] cnt = 0;
//    wire start_color;
//    wire video_on, p_tick,reset;
//    reg color_reg = 1'b0;
        
//    assign rgb = (video_on) ? ((color_reg) ? WHITE : BLACK) : 12'b0;
//    assign reset = ~nreset;
    
//    vga_sync VGA_SYNC(clk,reset,hsync,vsync,video_on,p_tick,x,y);
    
//    start_screen_image START_IMG(start_color,x,y,vsync,video_on);
    
//    always @(start_color)
//    begin
//        color_reg = start_color;
//    end         
    
endmodule
