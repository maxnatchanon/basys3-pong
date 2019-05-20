`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2019 02:53:28 AM
// Design Name: 
// Module Name: game_test
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


module game_test();

    // 80 * 60
    // 80 * 25
    wire game_color;
    reg [4:0] p1, p2, by;
    reg [6:0] bx;
    reg [2:0] s1, s2;
    reg animate;
    reg [9:0] x;
    reg [8:0] y;
    reg video_on = 1;
    
    game_image_generator GAME_GEN(game_color,p1,p2,bx,by,s1,s2,animate,x,y,video_on);
    
    initial
    begin
        #0
        p1 = 0; p2 = 0;
        bx = 20; by = 10;
        s1 = 0; s2 = 1;
        
        #10
        animate = 1;
        
        #10
        animate = 0;
        x = 31; y = 120;
        
        #10
        p1 = 10;
        
        #10
        animate = 1;
        
        #10
        animate = 0;
        x = 32;
        
        #10
        x = 31;
        
        #10
        x = 247;
        y = 40;
        
        #20
        $finish;
    end

endmodule
