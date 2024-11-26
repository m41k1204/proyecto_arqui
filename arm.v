`include "controller.v"
`include "datapath.v"

module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire RegWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [3:0] ALUControl;

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
		.MemWriteM(MemWrite),
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
		.RegWriteM(RegWriteM)
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
		.BranchTakenE(BranchTakenE)
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
