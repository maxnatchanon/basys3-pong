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

	reg [319:0] image0 [239:0];
	reg [319:0] image1 [239:0];
	wire out0, out1;
	reg [9:0] x = 0, y = 0;
	
	assign out0 = image0[y][x];
	assign out1 = image1[y][x];
    
    initial
    begin
        $readmemb("startImg0.mem",image0);
        $readmemb("startImg1.mem",image1);
    end
    
    initial
    begin
        #0
        x = 320-72;
        y = 37;
        #10
        x = 320-111;
        y = 208;
        #10 $finish;
    end
    

endmodule
