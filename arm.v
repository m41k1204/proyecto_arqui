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
	wire PCSrc;
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
    reg [1:0] ForwardAE;
    reg [1:0] ForwardBE;
    wire StallF;
    wire StallD;
    wire FlushE;

	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.RegSrc(RegSrc),
		.RegWriteW(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrcE(ALUSrc),
		.ALUControlE(ALUControl),
		.MemWriteM(MemWrite),
		.MemtoRegW(MemtoReg),
		.PCSrcW(PCSrc),
		.MemToRegE(MemToRegE)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ALUFlags(ALUFlags),
		.PC(PC),
		.InstrF(Instr),
		.ALUOutM(ALUResult),
		.WriteDataM(WriteData),
		.ReadData(ReadData)
	);

	hazardunit hz(
		.clk(clk),
		.RegWriteW(RegWriteW), 
    	.RegWriteM(RegWriteM),
    	.MemToRegE(MemToRegE),  
    	.Match_1E_M(Match_1E_M),
    	.Match_1E_W(Match_1E_W),
    	.Match_2E_M(Match_2E_M),
    	.Match_2E_W(Match_2E_W),
    	.Match_12D_E(Match_12D_E),
    	.ForwardAE(ForwardAE),
    	.ForwardBE(ForwardBE),
    	.StallF(StallF),
    	.StallD(StallD),
    	.FlushE(FlushE)
	);
endmodule
