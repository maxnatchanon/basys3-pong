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
    output wire vsync,          // V-sync signal
    output wire [1:0] led,      // LED signal
    inout wire [7:0] data,      // Input-output data
    input wire [9:10] address,  // Input address
    input wire wr,              // Write signal (Active high)
    input wire ps2_data,        // Keyboard data
    input wire ps2_clk,         // Keyboard clock
    input wire clk,             // Clock
    input wire nreset           // Reset signal (Active low)
    );

    parameter ADDRESS_WIDTH = 10;
    parameter DATA_WIDTH = 8;

    // Memory address range     => 000 - 3FF
    // Keycode                  => 3FE - 3FF
    // Game state               => 000
    // Player position 1/2      => 001 - 002
    // Ball position x/y        => 011 - 012
    // Ball speed x/y           => 101 - 102
    // Score 1/2                => 103 - 104

    reg [DATA_WIDTH-1:0] mem [(1<<ADDRESS_WIDTH)-1:0];
    reg [DATA_WIDTH-1:0] data_out;
    wire [15:0] keycode;
    reg [15:0] c_keycode = 0;

    // Drive LED signal
    assign led[0] = (mem[10'h000] == 0);
    assign led[1] = (mem[10'h000] == 1);
    
    // Keyboard
    wire [15:0] tkeycode; 
    wire flag;
    ps2_receiver KB(tkeycode,flag,clk,ps2_clk,ps2_data);
    keycode_converter KEY_CONV(keycode,tkeycode,flag,clk,nreset);

    // 7-segment display
    // seven_segment SEVEN_SEG(seg,an,dp,keycode,clk);
    wire rclk;
    wire [18:0] tclk;
    wire [3:0] num0, num1, num2, num3;
    assign {num0,num1,num2,num3} = keycode;
    
    quad7seg SEG(seg,dp,an[0],an[1],an[2],an[3],num0,num1,num2,num3,rclk);
    
    assign tclk[0] = clk;
    genvar i;
    generate
    for (i = 0 ; i < 18 ; i = i+1)
    begin
        clockDiv c1(tclk[i+1],tclk[i]);
    end
    endgenerate
    clockDiv c2(rclk,tclk[18]);

    // Memory
    assign data = (wr == 0) ? data_out : 10'bz;
    
    always @(address)
    begin
        data_out = mem[address];
    end

    always @(posedge clk)
    begin
        if (wr == 1)
        begin
            mem[address] <= data;
        end

        // Move paddle / Start game
        if (keycode != c_keycode) 
        begin
            c_keycode <= keycode;
            {mem[16'h3FE],mem[16'h3FF]} <= keycode;
            if (keycode[15:8] != 8'hf0)
            begin
                case (keycode[7:0])
                8'h1c: if (mem[10'h001] > 0  & mem[10'h000] == 1) mem[10'h001] <= mem[10'h001] - 1;  // A
                8'h1b: if (mem[10'h001] < 20 & mem[10'h000] == 1) mem[10'h001] <= mem[10'h001] + 1;  // S
                8'h42: if (mem[10'h002] > 0  & mem[10'h000] == 1) mem[10'h002] <= mem[10'h002] - 1;  // K
                8'h4b: if (mem[10'h002] < 20 & mem[10'h000] == 1) mem[10'h002] <= mem[10'h002] + 1;  // L
                endcase
            end

            if (keycode[7:0] == 8'h29 & mem[10'h000] == 0) // SPACE
            begin 
                mem[10'h000] <= 1;      // Set game state to 1
                mem[10'h001] <= 10;     // Set paddle 1 position
                mem[10'h002] <= 10;     // Set paddle 2 position
                mem[10'h011] <= 40;     // Set ball x position
                mem[10'h012] <= 12;     // Set ball y position
                mem[10'h101] <= 1;      // Set ball x speed
                mem[10'h102] <= 1;      // Set ball y speed
            end
        end
    end

endmodule