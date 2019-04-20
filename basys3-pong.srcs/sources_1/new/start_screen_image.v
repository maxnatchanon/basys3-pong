`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : image_generator.v
// Purpose      : 
// Developers   : Natchanon A.
//-------------------------------------------------------

module start_screen_image(
	output reg out,			// Output pixel value at (x,y)
	input wire x,			// Input x position
	input wire y,			// Input y position
	input wire animate			// Animate signal
	);

	reg [319:0] image0 [239:0];
	reg [319:0] image1 [239:0];
	reg state = 0;
    reg [3:0] count = 0;

	wire image0_pixel, image1_pixel;
	image_scaler #(2) IMG_SCALER0(image0_pixel,image0,x,y);
	image_scaler #(2) IMG_SCALER1(image1_pixel,image1,x,y);

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
		if (state == 0) out = image0_pixel;
		else out = image1_pixel;
	end

endmodule