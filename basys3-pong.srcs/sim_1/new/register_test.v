`timescale 1ns/1ps

module register_test();

    wire [7:0] regA, regB;
    reg [7:0] din;
    reg [4:0] addrA, addrB;
    reg wr, clk;

    register REG(regA,regB,addrA,addrB,wr,din,clk);

    always
    begin
        #5 clk = ~clk;
    end

    initial
    begin
        #0
        clk = 0;
        wr = 0;
        addrA = 0;
        addrB = 1;
        din = 0;

        #10
        din = 9;
        wr = 1;

        #10
        wr = 0;
        addrA = 1;
        addrB = 0;

        #10
        din = 15;
        wr = 1;

        #10
        wr = 0;
        addrA = 0;
        addrB = 1;

        #10 $finish;
    end

endmodule