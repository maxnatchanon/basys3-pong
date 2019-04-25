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
    output wire [11:0] rgb,     // VGA color
    output wire hsync,          // H-sync signal
    output wire vsync,          // V-sync sugnal
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
    // Ball position x/y        => 011 - 012
    // Ball speed x/y           => 101 - 102    (1 - to left/up, 2 - to right/down)
    // Score 1/2                => 103 - 104

    reg [DATA_WIDTH-1:0] mem [(1<<ADDRESS_WIDTH)-1:0];
    reg [DATA_WIDTH-1:0] data_out;
    wire [15:0] keycode;

    assign data = (wr == 0) ? data_out : 10'bz;

    // 7-segment display
    seven_segment SEVEN_SEG(seg,an,dp,{mem[10'h3fe,mem[10'h3ff]]},clk);

    // Keyboard
    keyboard KB(keycode,ps2_data,ps2_clk,clk,nreset);

    // VGA
    vga VGA(rgb,hsync,vsync,mem[0],mem[1],mem[2],mem[17],mem[18],mem[259],mem[260],clk,nreset);

    // Memory
    always @(address)
    begin
        data_out = mem[address];
    end

    always @(posedge clk)
    begin
        if (wr == 1) begin
            mem[address] <= data;
        end
    end

    // Move paddle / Start game
    always @(keycode)
    begin
        {mem[16'h3FE],mem[16'h3FF]} <= keycode;
        case (keycode)
        16'h001C: if (mem[10'h001] > 0  & mem[10'h000] == 1) mem[10'h001] <= mem[10'h001] - 1;  // A
        16'h001B: if (mem[10'h001] < 20 & mem[10'h000] == 1) mem[10'h001] <= mem[10'h001] + 1;  // S
        16'h0042: if (mem[10'h002] > 0  & mem[10'h000] == 1) mem[10'h002] <= mem[10'h002] - 1;  // K
        16'h004B: if (mem[10'h002] < 20 & mem[10'h000] == 1) mem[10'h002] <= mem[10'h002] + 1;  // L
        16'h0029:                                                                               // SPACE
            if (mem[10'h000] == 0)
            begin 
                mem[10'h000] <= 1;      // Set game state to 1
                mem[10'h001] <= 10;     // Set paddle 1 position
                mem[10'h002] <= 10;     // Set paddle 2 position
                mem[10'h011] <= 40;     // Set ball x position
                mem[10'h012] <= 12;     // Set ball y position
                mem[10'h101] <= 1;      // Set ball x speed
                mem[10'h102] <= 1;      // Set ball y speed
            end
        endcase
    end

endmodule