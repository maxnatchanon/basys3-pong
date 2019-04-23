`timescale 1ns / 1ps

module vga_sync_test();

    reg clk = 0, nreset = 0;
    wire hsync, vsync;
    wire [9:0] x;
    wire [8:0] y;
    wire video_on, p_tick;
    
    vga_sync VGA_SYNC(clk,nreset,hsync,vsync,video_on,p_tick,x,y);
    
    always #1 clk = ~clk;
    
    initial
    begin
        #5 nreset = 1;
    end

endmodule
