module datapath (
	clk,
	reset,
	RegSrc,
	RegWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	MemtoReg,
	PCSrc,
	ALUFlags,
	PC,
	InstrF,
	ALUOutM,
	WriteDataM,
	ReadData
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrc;
	input wire RegWrite;
	input wire [1:0] ImmSrc;
	input wire ALUSrc;
	input wire [1:0] ALUControl;
	input wire MemtoReg;
	input wire PCSrc;
	output wire [3:0] ALUFlags;
	output wire [31:0] PC;
	input wire [31:0] InstrF;
	wire [31:0] InstrD;
	wire [31:0] ALUResultE;
	output wire [31:0] ALUOutM;
	output wire [31:0] WriteDataM;
	wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCPlus8;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] ResultW;
	wire [3:0] RA1;
	wire [3:0] RA2;
	wire [110:0] OutputDecode;
	wire [110:0] InputExecute;
	
	wire [31:0] SrcAE;
	wire [31:0] ExtImmE;
	wire [31:0] SrcBE;
	wire [31:0] WriteDataE;
	wire [3:0] WA3E;
	wire [31:0] ALUResultE;
	
	wire [110:0] OutputExecute ;
	wire [110:0] InputMemory ;
	
	wire [110:0] OutputMemory;
	wire [110:0] InputWriteBack;
	
	 
	ff1to1 #(32) FetchToDecodeReg(
	      .i(InstrF),
	      .j(InstrD),
	      .clk(clk),
	      .reset(reset)
	);
	
	assign OutputDecode[31:0] = SrcA;
	assign OutputDecode[63:32] = WriteData;
	assign OutputDecode[95:64] = ExtImm;
	assign OutputDecode[99:96] = InstrD[15:12];
	
	ff1to1 #(100) DecodeToExecuteReg(
	       .i(OutputDecode),
	       .j(InputExecute),
	       .clk(clk),
	       .reset(reset)
	);
	
	assign SrcAE = InputExecute[31:0];
	assign WriteDataE = InputExecute[63:32];
	assign ExtImmE = InputExecute[95:64];
	assign WA3E = InputExecute[99:96];
	
	assign OutputExecute[31:0] = ALUResultE;
	assign OutputExecute[63:32] = WriteDataE;
	assign OutputExecute[67:64] = InputExecute[99:96];
	
	ff1to1 # (110) ExecuteToMemoryReg(
	   .i(OutputExecute),
	   .j(InputMemory),
	   .clk(clk),
       .reset(reset)
	);
	
	assign ALUOutM = InputMemory[31:0];
	assign WriteDataM = InputMemory[63:32];
	
	assign OutputMemory[31:0] = ReadData;
	assign OutputMemory[63:32] = ALUOutM;
	assign OutputMemory[67:64] = InputMemory[67:64];
	
	ff1to1 # (110) MemoryToWriteBackReg (
	   .i(OutputMemory),
	   .j(InputWriteBack),
	   .clk(clk),
       .reset(reset)
	);
	
	mux2 #(32) pcmux(
		.d0(PCPlus4),
		.d1(ResultW),
		.s(PCSrc),
		.y(PCNext)
	);
	flopr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCNext),
		.q(PC)
	);
	adder #(32) pcadd1(
		.a(PC),
		.b(32'b100),
		.y(PCPlus4)
	);
	
	mux2 #(4) ra1mux(
		.d0(InstrD[19:16]),
		.d1(4'b1111),
		.s(RegSrc[0]),
		.y(RA1)
	);
	mux2 #(4) ra2mux(
		.d0(InstrD[3:0]),
		.d1(InstrD[15:12]),
		.s(RegSrc[1]),
		.y(RA2)
	);
	
	wire [3:0] WA3W;
	assign WA3W = InputWriteBack[67:64];
	//assign WA3W = 4'b0010;
	
	
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.ra1(RA1),
		.ra2(RA2),
		.wa3(WA3W),
		.wd3(ResultW),
		.r15(PCPlus4),
		.rd1(SrcA),
		.rd2(WriteData)
	);
	mux2 #(32) resmux(
		.d0(InputWriteBack[63:32]),
		.d1(InputWriteBack[31:0]),
		.s(MemtoReg),
		.y(ResultW)
	);
	extend ext(
		.Instr(InstrD[23:0]),
		.ImmSrc(ImmSrc),
		.ExtImm(ExtImm)
	);
	mux2 #(32) srcbmux(
		.d0(WriteDataE),
		.d1(ExtImmE),
		.s(ALUSrc),
		.y(SrcBE)
	);
	alu alu(
		SrcAE,
		SrcBE,
		ALUControl,
		ALUResultE,
		ALUFlags
	);
endmodule
