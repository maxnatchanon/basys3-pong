`timescale 1ns/1ps
//-------------------------------------------------------
// File name    : rom.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module rom(
    input wire [9:0] address,
    input wire [32:0] data
    );

    reg	[31:0] mem [(1<<10)-1:0];
    assign data = mem[address];

    initial begin
        $readmemb("prog.mem",mem);
    end

endmodule