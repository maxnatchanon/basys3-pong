`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2019 01:32:52 AM
// Design Name: 
// Module Name: start_test
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


module start_test();

    parameter WHITE = 12'b111111111111;
    parameter BLACK = 12'b000000000000;

    wire start_color;
    reg [9:0] x;
    reg [8:0] y;
    reg vsync = 0;
    reg video_on = 0;
    
    wire [11:0] rgb;
    
    assign rgb = (start_color) ? BLACK : WHITE;

	start_screen_image START_IMG(start_color,x,y,vsync,video_on);
    
    always #1 x = x + 1;
    
    always @(x)
    begin
        if (x == 639)
        begin
            x = 0;
            y = y + 1;
        end
    end
    
    initial begin
        #0
        video_on = 1;
        x=0;
        y=50;
        vsync = 0;
    end
    
endmodule
