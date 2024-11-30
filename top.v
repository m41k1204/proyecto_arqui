`include "arm.v"
`include "imem.v"
`include "dmem.v"

module top (
	clk,
	reset,
	WriteData,
	DataAdr,
	MemWriteM,
	ResultW,
	PC,
	Result2W,
	BranchTakenE,
	ForwardA,
	ForwardB
);
	input wire clk;
	input wire reset;
	output wire [31:0] WriteData;
	output wire [31:0] DataAdr;
	output wire MemWriteM;
	output wire [31:0] PC;
	wire [31:0] Instr;
	wire [31:0] ReadData;
	output wire [31:0] ResultW;
	output wire [31:0] Result2W;
	output wire BranchTakenE;
	output wire ForwardA;
	output wire ForwardB;
	arm arm(
		.clk(clk),
		.reset(reset),
		.PC(PC),
		.Instr(Instr),
		.MemWriteM(MemWriteM),
		.ALUResult(DataAdr),
		.WriteData(WriteData),
		.ReadData(ReadData),
		.ResultW(ResultW),
		.Result2W(Result2W),
		.BranchTakenE(BranchTakenE),
		.ForwardA(ForwardA),
		.ForwardB(ForwardB)
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
