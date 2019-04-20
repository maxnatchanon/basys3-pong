`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2019 01:48:38 AM
// Design Name: 
// Module Name: vga_sync_test
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


module vga_sync_test();

    reg clk = 0, nreset = 0;
    reg p_clk;
    wire hsync, vsync, animate;
    wire [9:0] x;
    wire [8:0] y;
    wire [9:0] hc;
    
    
    reg [15:0] cnt = 0;
    always @(posedge clk)
        {p_clk,cnt} = cnt + 16'h4000;
    
    vga_sync VGA_SYNC(hsync,vsync,animate,x,y,clk,p_clk,nreset,hc);
    
    always #1 clk = ~clk;
    
    initial
    begin
        #5 nreset = 1;
       //#2000 $finish;
    end

endmodule
