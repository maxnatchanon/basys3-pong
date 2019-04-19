`timescale 1ns / 1ps

module pc_test();

    reg clk = 0;
    reg nreset = 1;

    // Instruction fetch
    reg [9:0] pc = 0;
    wire [9:0] pc_new, n_pc;
    wire [9:0] pc_b;
    wire [7:0] imm;
    wire pc_sel;
    assign pc_sel = 0;
    assign n_pc = pc + 1;
    assign pc_b = 10'b1111111111;
    mux2_1 MUX1(pc_new,n_pc,pc_b,pc_sel);
    always @(posedge clk)
    begin
        if (nreset == 0) begin
            pc = 0;
        end
        else begin
            pc = pc_new;
        end
    end

    always
    begin
        #5 clk = ~clk;
    end

    initial
    begin
        #100 $finish;
    end

endmodule
