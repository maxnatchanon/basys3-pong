`timescale 1ns/1ps
//-------------------------------------------------------
// File name    : top.v
// Purpose      : Hw Syn Lab 2/2018
// Developers   : Natchanon A.
//-------------------------------------------------------

module top(
    output wire [6:0] seg,             // 7-Seg number display
    output wire dp,                    // 7-Seg dot display
    output wire [3:0] an,              // 7-Seg selector
    input wire ps2_data,               // Keyboard data
    input wire ps2_clk,                // Keyboard clock
    input wire clk,                    // Clock
    input wire nreset                  // Reset signal (Active low)
    );

    // Instruction fetch
    reg [9:0] pc = 0;
    reg [9:0] pc_new;
    wire [9:0] pc_b, n_pc;
    wire [7:0] imm;
    wire pc_sel, b_ok;
    assign n_pc = pc + 1;
    assign pc_b = (b_ok) ? imm : pc + 1;
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

    reg [23:0] p_data;
    rom PROG_ROM(pc,p_data);

    // Instruction decode
    wire [23:0] instruction;
    wire [5:0] opcode, reg0, reg1;
    wire [9:0] addr;
    assign instruction = p_data;
    assign {opcode,reg0,reg1,imm} = instruction;
    assign addr = instruction[9:0];

    // Memory-IO
    wire mem_wr;
    wire [7:0] regA, regB;
    wire [7:0] mem_data;
    assign mem_data = (mem_wr == 1) ? regA : 10'bz;
    mem_io MEM_IO(seg,dp,an,mem_data,addr,mem_wr,ps2_data,ps2_clk,clk);

    // Register
    wire [7:0] reg_in;
    wire reg_wr;
    register REG(regA,regB,reg0,reg1,reg_wr,reg_in,clk);
    assign reg_in = (opcode == 6'b001000) ? mem_data : imm;

    // ALU
    wire alu_op;
    wire [7:0] S;
    wire cout, cin;
    alu ALU(S,cout,regB,imm,cin,alu_op);

    // Signal
    wire mem_mux_sel, reg_mux_sel, imm_mux_sel;
    assign reg_wr = (opcode[1:1] == 1 | opcode[3:3] == 1) ? 1 : 0;
    assign alu_op = opcode[0:0];
    assign mem_wr = (opcode[4:4] == 1) ? 1 : 0;
    assign pc_sel = (opcode[2:2] == 1 | opcode[5:5] == 1) ? 1 : 0;
    assign b_ok = ((opcode == 6'b000100 & regA == regB) | (opcode == 6'b000101 & regA == reg1) | (opcode == 6'b100000)) ? 1 : 0;
    assign mem_mux_sel = (opcode[1:1] == 1) ? 1 : 0;
    assign reg_mux_sel = (opcode[3:3] == 1) ? 1 : 0;
    assign imm_mux_sel = (opcode == 6'b001001) ? 1 : 0;

endmodule