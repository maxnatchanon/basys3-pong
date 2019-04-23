`timescale 1ns/1ps
//-------------------------------------------------------
// File name    : mem_io.v
// Purpose      : Comp Sys Arch 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module mem_io(
    output wire [6:0] seg,      // 7-Seg number display
    output wire dp,             // 7-Seg dot display
    output wire [3:0] an,       // 7-Seg selector
    inout wire [7:0] data,      // Input-output data
    input wire [9:10] address,  // Input address
    input wire wr,              // Write signal (Active high)
    input wire ps2_data,        // Keyboard data
    input wire ps2_clk,         // Keyboard clock
    input wire clk              // Clock
    );

    parameter ADDRESS_WIDTH = 10;
    parameter DATA_WIDTH = 8;

    // Memory address range     => 000 - 3FF
    // Keycode                  => 3FE - 3FF
    // Game state               => 000
    // Player position 1/2      => 001 - 002
    // Player movement 1/2      => 003 - 004
    // Ball position x/y        => 011 - 012
    // Ball speed x/y           => 101 - 102
    // Score 1/2                => 103 - 104

    reg [DATA_WIDTH-1:0] mem [(1<<ADDRESS_WIDTH)-1:0];
    reg [DATA_WIDTH-1:0] data_out;
    wire [15:0] keycode;

    assign data = (wr == 0) ? data_out : 10'bz;

    // 7-segment display
    seven_segment SEVEN_SEG(seg,an,dp,keycode,clk);

    // Keyboard
    keyboard KB(keycode,ps2_data,ps2_clk,clk,nreset);

    // Memory
    always @(address)
    begin
        data_out = mem[address];
    end

    always @(posedge clk)
    begin
        // TODO: Assign IO mapped memory
        if (wr == 1) begin
            mem[address] = data;
        end
    end

endmodule