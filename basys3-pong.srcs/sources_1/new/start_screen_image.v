`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : start_screen_image.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module start_screen_image(
	output reg out,			// Output pixel value at (x,y)
	input wire [9:0] x,     // Input x position
	input wire [8:0] y,		// Input y position
	input wire vsync,		// Vsync signal
	input wire video_on     // Pixel on display region
	);

	reg [319:0] image0 [239:0];
	reg [319:0] image1 [239:0];
	reg state = 0;
    reg [5:0] count = 0;

	initial
	begin
		$readmemb("startImg0.mem",image0);
		$readmemb("startImg1.mem",image1);
	end

	always @(posedge vsync)
	begin
		count = count + 1;
        if (count == 0) state = ~state;
	end

	always @(x, y)
    begin
        if (video_on)
        begin
           if (state == 0)
           begin
               out = image0[y/2][(639-x)/2];
           end
           else
           begin
               out = image1[y/2][(639-x)/2];
           end
	   end
	end

endmodule