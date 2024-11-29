`include "ff1to1.v"
`include "mux2.v"
`include "flopr.v"
`include "adder.v"
`include "regfile.v"
`include "extend.v"
`include "alu.v"
`include "mux4.v"
`include "shift.v"

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
	CarryFlag,
	ALUFlags,
	PC,
	InstrF,
	ALUOutM,
	WriteDataM,
	ReadData,
	ForwardAE, 
	ForwardBE,
	Match_1E_M,
    Match_1E_W,
    Match_2E_M,
    Match_2E_W,
	StallF,
	StallD, 
	FlushE,
	FlushD,
	BranchTakenE,
	Match_12D_E,
	Carry,
	NoWrite,
	Shift,
	Saturated,
	Negate,
	Unsigned,
	Long,
	MImmediateD,
	MPreindexD,
	MUpD,
	MByteD,
	MWriteBackD,
	MLoadD,
	ResultW
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrc;
	input wire RegWrite;
	input wire [1:0] ImmSrc;
	input wire ALUSrc;
	input wire [3:0] ALUControl;
	input wire MemtoReg;
	input wire PCSrc;
	input wire CarryFlag;
	output wire [4:0] ALUFlags;
	output wire [31:0] PC;
	input wire [31:0] InstrF;
	wire [31:0] InstrD;
	output wire [31:0] ALUOutM;
	output wire [31:0] WriteDataM;
	wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	output wire [31:0] ResultW;
	wire [3:0] RA1;
	wire [3:0] RA2;
	wire [107:0] OutputDecode;
	wire [107:0] InputExecute;

	wire [31:0] PC_;
	input wire [1:0] ForwardAE;
	input wire [1:0] ForwardBE;
	input wire BranchTakenE;
	input wire StallF; 
	input wire StallD; 
    input wire FlushE;
	input wire FlushD;

	input wire Carry;
	input wire NoWrite;
	input wire Shift;
	input wire Saturated;
	input wire Negate;
	input wire Unsigned;
	input wire Long;

	input wire MImmediateD;
	input wire MPreindexD;
	input wire MUpD;
	input wire MByteD;
	input wire MWriteBackD;
	input wire MLoadD;
	
	output wire Match_1E_M;
    output wire Match_1E_W;
    output wire Match_2E_M;
    output wire Match_2E_W;

	output wire Match_12D_E;


	wire [3:0] RA1E;
	wire [3:0] RA2E;
	wire [31:0] SrcAE;
	wire [31:0] ExtImmE;
	wire [31:0] SrcBE;
	wire [31:0] WriteDataE;
	wire [3:0] WA3E;
	wire [31:0] ALUResultE;
	wire [31:0] ALURes;

	wire [3:0] WA3M;
	
	wire [67:0] OutputExecute;
	wire [67:0] InputMemory;
	
	wire [67:0] OutputMemory;
	wire [67:0] InputWriteBack;
		
	ff1to1 #(32) FetchToDecodeReg(
	      .i(InstrF),
	      .j(InstrD),
	      .clk(clk),
	      .reset(reset),
		  .enable(StallD),
		  .clear(FlushD)
	);
	
	assign OutputDecode[31:0] = SrcA;
	assign OutputDecode[63:32] = WriteData;
	assign OutputDecode[95:64] = ExtImm;
	assign OutputDecode[99:96] = InstrD[15:12];
	assign OutputDecode[103:100] = RA1;
	assign OutputDecode[107:104] = RA2;

	ff1to1 #(108) DecodeToExecuteReg(
	       .i(OutputDecode),
	       .j(InputExecute),
	       .clk(clk),
	       .reset(reset),
		   .clear(FlushE),
		   .enable(1'b1)
	);
	
	assign ExtImmE = InputExecute[95:64];
	assign WA3E = InputExecute[99:96];
	assign RA1E = InputExecute[103:100];
	assign RA2E = InputExecute[107:104];

	// logica para los Match Signals del Forwarding
	assign Match_1E_M = (RA1E == WA3M);
	assign Match_1E_W = (RA1E == WA3W);
	assign Match_2E_M = (RA2E == WA3M);
	assign Match_2E_W = (RA2E == WA3W);

	// logica para el Match Signaling del Stalling
	assign Match_12D_E = (RA1 == WA3E) || (RA2 == WA3E);
	
	assign OutputExecute[31:0] = ALUResultE;
	assign OutputExecute[63:32] = WriteDataE;
	assign OutputExecute[67:64] = InputExecute[99:96];
	
	ff1to1 #(68) ExecuteToMemoryReg(
	   .i(OutputExecute),
	   .j(InputMemory),
	   .clk(clk),
       .reset(reset),
	   .clear(1'b0),
	   .enable(1'b1)
	);
	
	assign ALUOutM = InputMemory[31:0];
	assign WriteDataM = InputMemory[63:32];
	assign WA3M = InputMemory[67:64];
	
	assign OutputMemory[31:0] = ReadData;
	assign OutputMemory[63:32] = ALUOutM;
	assign OutputMemory[67:64] = WA3M;
	
	ff1to1 #(68) MemoryToWriteBackReg (
	   .i(OutputMemory),
	   .j(InputWriteBack),
	   .clk(clk),
       .reset(reset),
	   .clear(1'b0),
	   .enable(1'b1)
	);
	
	mux2 #(32) pcmux(
		.d0(PCPlus4),
		.d1(ResultW),
		.s(PCSrc),
		.y(PCNext)
	);

	mux2 #(32) branchmux(
		.d0(PCNext),
		.d1(ALUResultE),
		.s(BranchTakenE),
		.y(PC_)
	);
	

	flopr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PC_),
		.q(PC),
		.enable(StallF)
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

	mux4 forwardsrcamux(
		.d0(InputExecute[31:0]),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardAE),
		.y(SrcAE)
	);

	mux4 forwardsrcbmux(
		.d0(InputExecute[63:32]),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardBE),
		.y(WriteDataE)
	);

	mux2 #(32) shiftmux(
		.d0(ALURes),
		.d1(SrcBE),
		.s(Shift),
		.y(ALUResultE)
	);

	shift shift(

	);

	alu alu(
		.a(SrcAE),
		.b(SrcBE),
		.c(SrcCE),
		.ALUControl(ALUControl),
		.Carry(Carry),
		.curr_carry_flag(CarryFlag),
		.Saturated(Saturated),
		.Negate(Negate),
		.Unsigned(Unsigned),
		.Result(ALURes),
		.HiResult(ALUHiResultE),
		.ALUFlags(ALUFlags)
	);
endmodule
