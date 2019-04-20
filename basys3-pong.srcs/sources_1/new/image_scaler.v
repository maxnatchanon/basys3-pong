`timescale 1ns/1ps

//-------------------------------------------------------
// File name    : image_scaler.v
// Purpose      : 
// Developers   : Natchanon A.
//-------------------------------------------------------

module image_scaler #(parameter SCALE = 2) (
	output reg out,				// Output pixel value at (x,y)
	input wire [640/SCALE:0] in [480/SCALE:0],	// Input image
	input wire [9:0] x,				// Input x position
	input wire [8:0] y				// Input y position
	);

	// Scale image by parameter SCALE
	// Input is (x,y) position in the scaled image
	// Output pixel value in the scaled image
    always @(x or y)
    begin
        out = in[y/SCALE][x/SCALE];
    end

endmodule