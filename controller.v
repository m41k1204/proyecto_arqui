`include "ff1to1.v"
`include "decode.v"
`include "condlogic.v"

module controller (
	clk,
	reset,
	Instr,
	ALUFlags,
	RegSrc,
	RegWriteW,
	RegWriteM,
	ImmSrc,
	ALUSrcE,
	ALUControlE,
	MemWriteM,
	MemtoRegW,
	PCSrcW,
	MemToRegE,
	BranchTakenE,
	StallD, 
	FlushD,
	FlushE,
	PCSrcD,
	PCSrcE,
	PCSrcM

);
	input wire clk;
	input wire reset;
	input wire [31:12] Instr;
	input wire [3:0] ALUFlags;
	input wire StallD;
	input wire FlushD;
	input wire FlushE;
	output wire [1:0] RegSrc;
	output wire [1:0] ImmSrc;
	wire ALUSrc;
	wire [3:0] ALUControl;
	wire MemWriteD;
	wire MemtoReg;
	wire [1:0] FlagWrite;
	output wire PCSrcD;
	wire RegWriteD;
	wire MemW;

	wire CondExE;
	wire Branch;
	wire [3:0] Flags;

	output wire PCSrcE;
	wire RegWriteE;
	output wire MemToRegE;
	wire MemWriteE;
	output wire [3:0] ALUControlE;
	wire BranchE;
	output wire ALUSrcE;
	wire [1:0] FlagWriteE;
	wire [3:0] CondE;
	wire [3:0] FlagsE;

	output wire PCSrcM;
	output wire RegWriteM;
	wire MemToRegM;

	output wire BranchTakenE;
	output wire MemWriteM;

	output wire PCSrcW;
	output wire RegWriteW;
	output wire MemtoRegW;

	wire [20:0] OutputDecode;
	wire [20:0] InputExecute;
	wire [3:0] OutputExecute;
	wire [3:0] InputMemory;
	wire [2:0] OutputMemory;
	wire [2:0] InputWriteBack;
	
	wire [31:12] InstrD;
	
	ff1to1 #(20) FetchToDecode(
	   .i(Instr),
	   .j(InstrD),
	   .clk(clk),
	   .reset(reset),
	   .enable(StallD),
	   .clear(FlushD)
	);
	
	decode dec(
		.Op(InstrD[27:26]),
		.Funct(InstrD[25:20]),
		.Rd(InstrD[15:12]),
		.FlagW(FlagWrite),
		.PCS(PCSrcD),
		.RegW(RegWriteD),
		.MemW(MemWriteD),
		.MemtoReg(MemtoReg),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl),
		.Branch(Branch)
	);

	assign OutputDecode [0] = PCSrcD;
	assign OutputDecode [1] = RegWriteD;
	assign OutputDecode [2] = MemtoReg;
	assign OutputDecode [3] = MemWriteD;
	assign OutputDecode [7:4] = ALUControl;
	assign OutputDecode [8] = Branch;
	assign OutputDecode [9] = ALUSrc;
	assign OutputDecode [11:10] = FlagWrite;
	assign OutputDecode [15:12] = InstrD[31:28];
	assign OutputDecode [19:16] = Flags;
	
	ff1to1 #(21) DecodeToExecuteReg(
		.i(OutputDecode),
		.j(InputExecute),
		.clk(clk),
        .reset(reset),
		.enable(1'b1),
		.clear(FlushE)
	);

	assign PCSrcE = InputExecute[0];
	assign RegWriteE = InputExecute[1];
	assign MemToRegE = InputExecute[2];
	assign MemWriteE = InputExecute[3];
	assign ALUControlE = InputExecute[7:4];
	assign BranchE = InputExecute[8];
	assign ALUSrcE = InputExecute[9];
	assign FlagWriteE = InputExecute[11:10];
	assign CondE = InputExecute[15:12];
	assign FlagsE = InputExecute[19:16];

	assign BranchTakenE = (BranchE & CondExE);
	assign OutputExecute[0] = (PCSrcE & CondExE) ;
	assign OutputExecute[1] = RegWriteE & CondExE;
	assign OutputExecute[2] = MemToRegE;
	assign OutputExecute[3] = MemWriteE & CondExE;

	ff1to1 #(4) ExecuteToMemoryReg(
		.i(OutputExecute),
		.j(InputMemory),
		.clk(clk),
       .reset(reset),
	   .enable(1'b1),
	   .clear(1'b0)
	);

	assign PCSrcM = InputMemory[0];
	assign RegWriteM = InputMemory[1];
	assign MemToRegM = InputMemory[2];
	assign MemWriteM = InputMemory[3];

	assign OutputMemory[0] = PCSrcM;
	assign OutputMemory[1] = RegWriteM;
	assign OutputMemory[2] = MemToRegM;

	ff1to1 #(3) MemoryToWriteBackReg(
		.i(OutputMemory),
		.j(InputWriteBack),
		.clk(clk),
       .reset(reset),
	   .enable(1'b1),
	   .clear(1'b0)
	);

	assign PCSrcW = InputWriteBack[0];
	assign RegWriteW = InputWriteBack[1];
	assign MemtoRegW = InputWriteBack[2];

	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(CondE),
		.ALUFlags(ALUFlags),
		//.FlagW(FlagW),
		//.PCS(PCS),
		//.RegW(RegW),
		//.MemW(MemW),
		//.PCSrc(PCSrc),
		//.RegWrite(RegWrite),
		//.MemWrite(MemWrite)
		.CondEx(CondExE),
		.Flags(FlagsE)
	);
endmodule