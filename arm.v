`include "controller.v"
`include "datapath.v"

module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWriteM,
	ALUResult,
	WriteData,
	ReadData,
	ResultW,
	Result2W,
	BranchTakenE,
	ForwardA,
	ForwardB
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWriteM;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [4:0] ALUFlags;
	wire RegWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [3:0] ALUControl;
	output wire BranchTakenE;
	
	output wire [31:0] ResultW;
	output wire [31:0] Result2W;
	output wire ForwardA;
	output wire ForwardB;

	wire RegWriteW;
    wire RegWriteM;
    wire MemToRegE;  
    wire Match_1E_M;
    wire Match_1E_W;
    wire Match_1E_M0;
	wire Match_1E_W0;
	wire Match_2E_M;
    wire Match_2E_W;
	wire Match_2E_M0;
	wire Match_2E_W0;
	wire Match_3E_M;
    wire Match_3E_W;
	wire Match_3E_M0;
	wire Match_3E_W0;
	wire Match_0E_M;
    wire Match_0E_W;
	wire Match_0E_M0;
	wire Match_0E_W0;
    wire Match_12D_E;
    wire [2:0] ForwardAE;
    wire [2:0] ForwardBE;
	wire [2:0] ForwardCE;
	wire [2:0] ForwardDE;
	
    wire StallF;
    wire StallD;
    wire FlushE;
	wire BranchTakenE;
	wire FlushD;

	wire CarryFlag;

	wire Carry;
	wire NoWrite;
	wire Shift;
	wire Saturated;
	wire Negate;
	wire Unsigned;
	wire NoShift;

	wire PCSrcD;
	wire PCSrcE;
	wire PCSrcM;
	wire PCSrcW;

	wire RegWrite2M;
	wire RegWrite2W;

	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.RegSrc(RegSrc),
		.RegWriteW(RegWriteW),
		.ImmSrc(ImmSrc),
		.ALUSrcE(ALUSrc),
		.ALUControlE(ALUControl),
		.MemWriteM(MemWriteM),
		.MemtoRegW(MemtoReg),
		.PCSrcW(PCSrcW),
		.MemToRegE(MemToRegE),
		.BranchTakenE(BranchTakenE),
		.StallD(StallD), 
		.FlushE(FlushE),
		.FlushD(FlushD),
		.PCSrcD(PCSrcD),
		.PCSrcE(PCSrcE),
		.PCSrcM(PCSrcM),
		.RegWriteM(RegWriteM),
		.CarryE(Carry),
		.NoWriteE(NoWrite),
		.ShiftE(Shift),
		.SaturatedE(Saturated),
		.NegateE(Negate),
		.UnsignedE(Unsigned),
		.NoShiftE(NoShift),
		.RegWrite2W(RegWrite2W),
		.RegWrite2M(RegWrite2M),
		.CarryFlag(CarryFlag)
	);

	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWriteW),
		.RegWrite2W(RegWrite2W),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrcW),
		.CarryFlag(CarryFlag),
		.ALUFlags(ALUFlags),
		.PC(PC),
		.InstrF(Instr),
		.ALUOutM(ALUResult),
		.WriteDataM(WriteData),
		.ReadData(ReadData),
		.ForwardAE(ForwardAE), 
		.ForwardBE(ForwardBE),
		.ForwardCE(ForwardCE),
		.ForwardDE(ForwardDE),
		.Match_1E_M(Match_1E_M),
		.Match_1E_W(Match_1E_W),
		.Match_1E_M0(Match_1E_M0),
		.Match_1E_W0(Match_1E_W0),
		.Match_2E_M(Match_2E_M),
		.Match_2E_W(Match_2E_W),
		.Match_2E_M0(Match_2E_M0),
		.Match_2E_W0(Match_2E_W0),
		.Match_3E_M(Match_3E_M),
		.Match_3E_W(Match_3E_W),
		.Match_3E_M0(Match_3E_M0),
		.Match_3E_W0(Match_3E_W0),
		.Match_0E_M(Match_0E_M),
		.Match_0E_W(Match_0E_W),
		.Match_0E_M0(Match_0E_M0),
		.Match_0E_W0(Match_0E_W0),
		.Match_12D_E(Match_12D_E),
		.StallF(StallF),
		.StallD(StallD), 
		.FlushE(FlushE),
		.FlushD(FlushD),
		.BranchTakenE(BranchTakenE),
		.ResultW(ResultW),
		.Carry(Carry),
		.NoWrite(NoWrite),
		.Shift(Shift),
		.Saturated(Saturated),
		.Negate(Negate),
		.Unsigned(Unsigned),
		.NoShift(NoShift),
		.MImmediateD(Instr[25]),
		.MPreindexD(Instr[24]),
		.MUpD(Instr[23]),
		.MByteD(Instr[22]),
		.MWriteBackD(Instr[21]),
		.MLoadD(Instr[20])
	);

	hazardunit hz(
		.clk(clk),
		.reset(reset),
		.RegWriteW(RegWriteW),
    	.RegWriteM(RegWriteM),
		.RegWrite2W(RegWrite2W),
		.RegWrite2M(RegWrite2M),
    	.MemToRegE(MemToRegE),
    	.Match_1E_M(Match_1E_M),
		.Match_1E_W(Match_1E_W),
		.Match_1E_M0(Match_1E_M0),
		.Match_1E_W0(Match_1E_W0),
		.Match_2E_M(Match_2E_M),
		.Match_2E_W(Match_2E_W),
		.Match_2E_M0(Match_2E_M0),
		.Match_2E_W0(Match_2E_W0),
		.Match_3E_M(Match_3E_M),
		.Match_3E_W(Match_3E_W),
		.Match_3E_M0(Match_3E_M0),
		.Match_3E_W0(Match_3E_W0),
		.Match_0E_M(Match_0E_M),
		.Match_0E_W(Match_0E_W),
		.Match_0E_M0(Match_0E_M0),
		.Match_0E_W0(Match_0E_W0),
    	.Match_12D_E(Match_12D_E),
    	.PCSrcD(PCSrcD),
		.PCSrcE(PCSrcE),
		.PCSrcM(PCSrcM),
		.PCSrcW(PCSrcW),
		.BranchTakenE(BranchTakenE),
		.ForwardAE(ForwardAE),
    	.ForwardBE(ForwardBE),
		.ForwardCE(ForwardCE),
		.ForwardDE(ForwardDE),
    	.StallF(StallF),
    	.StallD(StallD),
    	.FlushE(FlushE),
		.FlushD(FlushD),
		.ForwardA(ForwardA),
		.ForwardB(ForwardB)
	);
endmodule
