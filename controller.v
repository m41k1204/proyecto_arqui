module controller (
	clk,
	reset,
	Instr,
	ALUFlags,
	RegSrc,
	RegWriteW,
	ImmSrc,
	ALUSrcE,
	ALUControlE,
	MemWriteM,
	MemtoRegW,
	PCSrcW
);
	input wire clk;
	input wire reset;
	input wire [31:12] Instr;
	input wire [3:0] ALUFlags;
	output wire [1:0] RegSrc;
	wire RegWrite;
	output wire [1:0] ImmSrc;
	wire ALUSrc;
	wire [1:0] ALUControl;
	wire MemWrite;
	wire MemtoReg;
	wire [1:0] FlagWrite;
	wire PCSrc;
	wire RegW;
	wire MemW;

	wire CondExE;
	wire Branch;
	wire Flags;

	wire PCSrcE;
	wire RegWriteE;
	wire MemToRegE;
	wire MemWriteE;
	output wire [1:0] ALUControlE;
	wire BranchE;
	output wire ALUSrcE;
	wire [1:0] FlagWriteE;

	wire PCSrcM;
	wire RegWriteM;
	wire MemToRegM;
	output wire MemWriteM;

	output wire PCSrcW;
	output wire RegWriteW;
	output wire MemToRegW;

	wire [17:0] OutputDecode;
	wire [17:0] InputExecute;
	wire [3:0] OutputExecute;
	wire [3:0] InputMemory;
	wire [2:0] OutputMemory;
	wire [2:0] InputWriteBack;
	
	decode dec(
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.FlagW(FlagWrite),
		.PCS(PCSrc),
		.RegW(RegW),
		.MemW(MemW),
		.MemtoReg(MemtoReg),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl),
		.Branch(Branch)
	);

	assign OutputDecode [0] = PCSrc;
	assign OutputDecode [1] = RegWrite;
	assign OutputDecode [2] = MemtoReg;
	assign OutputDecode [3] = MemWrite;
	assign OutputDecode [5:4] = ALUControl;
	assign OutputDecode [6] = Branch;
	assign OutputDecode [7] = AluScr;
	assign OutputDecode [9:8] = FlagWrite;
	assign OutputDecode [13:10] = Instr[31:28];
	assign OutputDecode [17:14] = Flags;
	
	ff1to1 #(17) DecodeToExecuteReg(
		.i(OutputDecode),
		.j(InputExecute),
		.clk(clk)
	);

	assign PCSrcE = InputExecute[0];
	assign RegWriteE = InputExecute[1];
	assign MemToRegE = InputExecute[2];
	assign MemWriteE = InputExecute[3];
	assign AluControlE = InputExecute[5:4];
	assign BranchE = InputExecute[6];
	assign AluScrE = InputExecute[7];
	assign FlagWriteE = InputExecute[9:8];
	assign CondE = InputExecute[13:10];
	assign FlagsE = InputExecute[17:14];

	assign OutputExecute[0] = (PCSrcE & CondExE) | (BranchE & CondExE);
	assign OutputExecute[1] = RegWriteE & CondExE;
	assign OutputExecute[2] = MemToRegE;
	assign OutputExecute[3] = MemWriteE & CondExE;

	ff1to1 #(4) ExecuteToMemoryReg(
		.i(OutputExecute),
		.j(InputMemory),
		.clk(clk)
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
		.clk(clk)
	);

	assign PCSrcW = InputWriteBack[0];
	assign RegWriteW = InputWriteBack[1];
	assign MemToRegW = InputWriteBack[2];

	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(Instr[31:28]),
		.ALUFlags(ALUFlags),
		//.FlagW(FlagW),
		//.PCS(PCS),
		//.RegW(RegW),
		//.MemW(MemW),
		//.PCSrc(PCSrc),
		//.RegWrite(RegWrite),
		//.MemWrite(MemWrite)
		.CondEx(CondExE),
		.Flags(Flags)
	);
endmodule