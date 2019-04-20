`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : start_screen_image.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module start_screen_image(
	output reg out,			// Output pixel value at (x,y)
	input wire x,			// Input x position
	input wire y,			// Input y position
	input wire animate		// Animate signal
	);

	reg [319:0] image0 [239:0];
	reg [319:0] image1 [239:0];
	reg state = 0;
    reg [3:0] count = 0;

	initial
	begin
		$readmemb("startImg0.mem",image0);
		$readmemb("startImg1.mem",image1);
	end

	always @(posedge animate)
	begin
		count = count + 1;
        if (count == 0) state = ~state;
	end

	always @(x or y)
	begin
	   if (state == 0)
	   begin
           if (x == 0) out = image0[y/2][319];
           else if (y == 480) out = image0[239][(640-x)/2];
           else out = image0[y/2][(640-x)/2];
	   end
	   else
	   begin
           if (x == 0) out = image1[y/2][319];
           else if (y == 480) out = image1[239][(640-x)/2];
           else out = image1[y/2][(640-x)/2];
	   end
	end

endmodule