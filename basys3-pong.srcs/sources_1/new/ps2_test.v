`timescale 1ns/1ps
//-------------------------------------------------------
// File name    : mux2_1.v
// Purpose      : Comp Sys Arch 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module ps2_test(
    output wire [6:0] seg,             // 7-Seg number display
    output wire dp,                    // 7-Seg dot display
    output wire [3:0] an,              // 7-Seg selector
    input wire ps2_data,               // Keyboard data
    input wire ps2_clk,                // Keyboard clock
    input wire clk,                    // Clock
    input wire nreset                  // Reset signal (Active low)
);

wire rClk;
wire [18:0] tclk;
assign tclk[0] = clk;
genvar i;
generate
for (i = 0 ; i < 18 ; i = i+1)
begin
    clockDiv c1(tclk[i+1],tclk[i]);
end
endgenerate
clockDiv c2(rClk,tclk[18]);

wire [15:0] keycode;
wire oflag;
wire [3:0] num0, num1, num2, num3;
assign {num0,num1,num2,num3} = keycode;
ps2_receiver KB(keycode,oflag,rClk,ps2_clk,ps2_data);
quad7seg SEG(seg,dp,an[0],an[1],an[2],an[3],num0,num1,num2,num3,rClk);

endmodule