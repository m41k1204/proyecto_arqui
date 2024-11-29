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
	ResultW
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
	
	output wire [31:0] ResultW;

	wire RegWriteW;
    wire RegWriteM;
    wire MemToRegE;  
    wire Match_1E_M;
    wire Match_1E_W;
    wire Match_2E_M;
    wire Match_2E_W;
    wire Match_12D_E;
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
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
	wire Long;

	wire PCSrcD;
	wire PCSrcE;
	wire PCSrcM;
	wire PCSrcW;

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
		.LongE(Long),
		.CarryFlag(CarryFlag)
	);

	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWriteW),
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
		.Match_1E_M(Match_1E_M),
		.Match_1E_W(Match_1E_W),
		.Match_2E_M(Match_2E_M),
		.Match_2E_W(Match_2E_W),
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
		.Long(Long),
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
    	.MemToRegE(MemToRegE),  
    	.Match_1E_M(Match_1E_M),
    	.Match_1E_W(Match_1E_W),
    	.Match_2E_M(Match_2E_M),
    	.Match_2E_W(Match_2E_W),
    	.Match_12D_E(Match_12D_E),
    	.PCSrcD(PCSrcD),
		.PCSrcE(PCSrcE),
		.PCSrcM(PCSrcM),
		.PCSrcW(PCSrcW),
		.BranchTakenE(BranchTakenE),
		.ForwardAE(ForwardAE),
    	.ForwardBE(ForwardBE),
    	.StallF(StallF),
    	.StallD(StallD),
    	.FlushE(FlushE),
		.FlushD(FlushD)
	);
endmodule
