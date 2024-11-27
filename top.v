`include "arm.v"
`include "imem.v"
`include "dmem.v"

module top (
	clk,
	reset,
	WriteData,
	DataAdr,
	MemWriteM
);
	input wire clk;
	input wire reset;
	output wire [31:0] WriteData;
	output wire [31:0] DataAdr;
	output wire MemWriteM;
	wire [31:0] PC;
	wire [31:0] Instr;
	wire [31:0] ReadData;
	arm arm(
		.clk(clk),
		.reset(reset),
		.PC(PC),
		.Instr(Instr),
		.MemWriteM(MemWriteM),
		.ALUResult(DataAdr),
		.WriteData(WriteData),
		.ReadData(ReadData)
	);
	imem imem(
		.a(PC),
		.rd(Instr)
	);
	dmem dmem(
		.clk(clk),
		.we(MemWriteM),
		.a(DataAdr),
		.wd(WriteData),
		.rd(ReadData)
	);
endmodule