`timescale 1ns/1ps

module top_test();

wire [6:0] seg,             // 7-Seg number display
wire dp,                    // 7-Seg dot display
wire [3:0] an,              // 7-Seg selector
reg ps2_data,               // Keyboard data
reg ps2_clk,                // Keyboard clock
reg clk = 0,                // Clock
reg nreset                  // Reset signal (Active low)

// Instruction fetch
reg [9:0] pc = 0;
reg [9:0] pc_new;
wire [9:0] pc_b;
wire [7:0] imm;
wire n_pc, pc_sel, b_ok;
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
always @(pc)
begin
    case (pc)
    0: p_data = 24'b001001_00001_000_0011111111; // LOAD $R1 FF
    1: p_data = 24'b001001_00010_000_0000001111; // LOAD $R2 0F
    2: p_data = 24'b010000_00001_000_0000000000; // STOR $R1 m[00]
    3: p_data = 24'b010000_00010_000_0000000001; // STOR $R2 m[01]
    4: p_data = 24'b001000_00011_000_0000000000; // LOAD $R3 m[00]
    5: p_data = 24'b010000_00011_000_0000000010; // STOR $R3 m[02]
    endcase
end

// Instruction decode
wire [23:0] instruction;
wire [5:0] opcode, reg0, reg1;
wire [9:0] addr;
assign instruction = p_data;
assign {opcode,reg0,reg1,imm} = instruction;
assign addr = instruction[9:0];

// Register
reg [7:0] reg_in;
reg [7:0] regA, regB;
wire reg_wr;
register REG(regA,regB,reg0,reg1,reg_wr,reg_in,clk);

// Signal
wire alu_op, mem_wr;
wire mem_mux_sel, reg_mux_sel, imm_mux_sel;
assign reg_wr = (opcode[1:1] == 1 | opcode[3:3] == 1) ? 1 : 0;
assign alu_op = opcode[0:0];
assign mem_wr = (opcode[4:4] == 1) ? 1 : 0;
assign pc_sel = (opcode[2:2] == 1 | opcode[5:5] == 1) ? 1 : 0;
assign b_ok = ((opcode == 6'b000100 & regA == regB) | (opcode == 6'b000101 & regA == reg1) | (opcode == 6'b100000)) ? 1 : 0;
assign mem_mux_sel = (opcode[1:1] == 1) ? 1 : 0;
assign reg_mux_sel = (opcode[3:3] == 1) ? 1 : 0;
assign imm_mux_sel = (opcode == 6'b001001) ? 1 : 0;

// ALU
reg [7:0] S;
reg cout, cin = 0;
alu ALU(S,cout,regB,imm,cin,alu_op);

// Memory-IO
wire [7:0] mem_data;
assign mem_data = (mem_wr == 1) ? regA : 10'bz;
mem_io MEM_IO(seg,dp,an,mem_data,addr,mem_wr,ps2_data,ps2_clk,clk);

always
begin
    #5 clk = ~clk;
end

initial
begin
    #0
    ps2_clk = 0;
    ps2_data = 0;
    nreset = 1;
end

endmodule