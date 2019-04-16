`timescale 1ns/1ps

module alu_test();

wire [7:0] out;
wire cout;
reg [7:0] in0, in1;
reg cin, alu_op;

alu ALU(out,cout,in0,in1,cin,alu_op);

initial
begin
    #0
    in0 = 5;
    in1 = 4;
    cin = 0;
    alu_op = 0;

    #10
    alu_op = 1;

    #10
    cin = 1;
    alu_op = 0;

    #10
    in0 = 200;
    in1 = 55;

    #10 $finish;
end

endmodule