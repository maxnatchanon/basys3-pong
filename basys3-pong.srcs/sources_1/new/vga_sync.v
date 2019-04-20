`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : vga_sync.v
// Purpose      : 
// Developers   : Will Green, timetoexplore.net
//-------------------------------------------------------

module vga_sync(
    output wire hsync,
    output wire vsync,
    output wire animate,
    output wire [9:0] x,
    output wire [8:0] y,
    input wire clk,
    input wire p_clk,
    input wire nreset
    );

    // VGA timings https://timetoexplore.net/blog/video-timings-vga-720p-1080p
    localparam HS_STA = 16;              // horizontal sync start
    localparam HS_END = 16 + 96;         // horizontal sync end
    localparam HA_STA = 16 + 96 + 48;    // horizontal active pixel start
    localparam VS_STA = 480 + 10;        // vertical sync start
    localparam VS_END = 480 + 10 + 2;    // vertical sync end
    localparam VA_END = 480;             // vertical active pixel end
    localparam LINE   = 800;             // complete line (pixels)
    localparam SCREEN = 525;             // complete screen (lines)

    reg [9:0] h_count;  // line position
    reg [9:0] v_count;  // screen position

    // generate sync signals (active low for 640x480)
    assign hsync = ~((h_count >= HS_STA) & (h_count < HS_END));
    assign vsync = ~((v_count >= VS_STA) & (v_count < VS_END));

    // keep x and y bound within the active pixels
    assign x = (h_count < HA_STA) ? 0 : (h_count - HA_STA);
    assign y = (v_count >= VA_END) ? (VA_END - 1) : (v_count);

    // animate: high for one tick at the end of the final active pixel line
    assign animate = ((v_count == VA_END - 1) & (h_count == LINE));

    always @(posedge clk)
    begin
        if (nreset == 0)  // reset to start of frame
        begin
            h_count <= 0;
            v_count <= 0;
        end
        if (p_clk)  // once per pixel
        begin
            if (h_count == LINE)  // end of line
            begin
                h_count <= 0;
                v_count <= v_count + 1;
            end
            else 
                h_count <= h_count + 1;

            if (v_count == SCREEN)  // end of screen
                v_count <= 0;
        end
    end

endmodule