`timescale 1ns/1ps
//-------------------------------------------------------
// File name    : register.v
// Purpose      : Comp Sys Arch 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module register(
    output reg [7:0] regA,
    output reg [7:0] regB,
    input wire [4:0] addrA,
    input wire [4:0] addrB,
    input wire wr,
    input wire [7:0] din,
    input wire clk
);

reg [7:0] mem [31:0];

integer i;
initial begin
    for (i=0;i<32;i=i+1) begin
        mem[i] = 0;
    end
end

always @(posedge clk) 
begin
    regA = mem[addrA];
    regB = mem[addrB];
    if (wr) mem[addrA] = din;
end

endmodule