`include "ff1to1.v"
`include "mux2.v"
`include "flopr.v"
`include "adder.v"
`include "regfile.v"
`include "extend.v"
`include "alu.v"
`include "mux8.v"
`include "shift.v"

module datapath (
	clk,
	reset,
	RegSrc,
	RegWrite,
	RegWrite2W,
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
	ForwardCE,
	ForwardDE,
	Match_1E_M,
    Match_1E_W,
    Match_1E_M0,
	Match_1E_W0,
	Match_2E_M,
    Match_2E_W,
	Match_2E_M0,
	Match_2E_W0,
	Match_3E_M,
    Match_3E_W,
	Match_3E_M0,
	Match_3E_W0,
	Match_0E_M,
    Match_0E_W,
	Match_0E_M0,
	Match_0E_W0,
    Match_12D_E,
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
	NoShift,
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
	input wire RegWrite2W;
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
	
	wire [189:0] OutputDecode;
	wire [189:0] InputExecute;

	wire [31:0] PC_;
	input wire [2:0] ForwardAE;
	input wire [2:0] ForwardBE;
	input wire [2:0] ForwardCE;
	input wire [2:0] ForwardDE;

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
	input wire NoShift;

	input wire MImmediateD;
	input wire MPreindexD;
	input wire MUpD;
	input wire MByteD;
	input wire MWriteBackD;
	input wire MLoadD;
	
	output wire Match_1E_M;
    output wire Match_1E_W;
    output wire Match_1E_M0;
	output wire Match_1E_W0;

	output wire Match_2E_M;
    output wire Match_2E_W;
	output wire Match_2E_M0;
	output wire Match_2E_W0;

	output wire Match_3E_M;
    output wire Match_3E_W;
	output wire Match_3E_M0;
	output wire Match_3E_W0;

	output wire Match_0E_M;
    output wire Match_0E_W;
	output wire Match_0E_M0;
	output wire Match_0E_W0;

	output wire Match_12D_E;

	wire [3:0] RA3;
	wire [3:0] RA0;
	wire [3:0] WA0W;
	wire [31:0] RD3;
	wire [31:0] RD0;
	wire [31:0] Result2W;
	wire [31:0] ALUResult2E;
	wire [31:0] SrcCE;
	wire [31:0] SrcDE;

	wire [3:0] RA0E;
	wire [3:0] RA3E; 
	wire [3:0] RA1E;
	wire [3:0] RA2E;
	wire [31:0] SrcAE;
	wire [31:0] ExtImmE;
	wire [31:0] SrcBE;
	wire [31:0] WriteDataE;
	wire [3:0] WA3E;
	wire [31:0] ALUResultE;
	wire [31:0] ALURes;

	wire [1:0] ShiftTypeE;
	wire ShiftSourceE;
	wire [4:0] ShiftImmediateE;

	wire [31:0] ShiftInputE;
	wire [31:0] ShiftResultE;
	wire [4:0] ShiftAmountE;

	wire [3:0] WA3M;
	wire [3:0] WA0E;
	wire [3:0] WA0M;
	
	wire [31:0] ALUOut2M;

	wire [103:0] OutputExecute;
	wire [103:0] InputMemory;
	
	wire [103:0] OutputMemory;
	wire [103:0] InputWriteBack;
		
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
	assign OutputDecode[139:108] = RD0;
	assign OutputDecode[171:140] = RD3;
	assign OutputDecode[175:172] = InstrD[11:8];
	assign OutputDecode[177:176] = InstrD[6:5];
	assign OutputDecode[178] = InstrD[4];
	assign OutputDecode[183:179] = InstrD[11:7];

	ff1to1 #(190) DecodeToExecuteReg(
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
	assign RA3E = InputExecute[99:96];
	assign RA0E = InputExecute[175:172];
	assign ShiftTypeE = InputExecute[177:176];
	assign ShiftSourceE = InputExecute[178];
	assign ShiftImmediateE = InputExecute[183:179];

	// logica para los Match Signals del Forwarding
	assign Match_1E_M = (RA1E == WA3M);
	assign Match_1E_W = (RA1E == WA3W);
	assign Match_1E_M0 = (RA1E == WA0M);
	assign Match_1E_W0 = (RA1E == WA0W);

	assign Match_2E_M = (RA2E == WA3M);
	assign Match_2E_W = (RA2E == WA3W);
	assign Match_2E_M0 = (RA2E == WA0M);
	assign Match_2E_W0 = (RA2E == WA0W);

	assign Match_3E_M = (RA3E == WA3M);
	assign Match_3E_W = (RA3E == WA3W);
	assign Match_3E_M0 = (RA3E == WA0M);
	assign Match_3E_W0 = (RA3E == WA0W);

	assign Match_0E_M = (RA0E == WA3M);
	assign Match_0E_W = (RA0E == WA3W);
	assign Match_0E_M0 = (RA0E == WA0M);
	assign Match_0E_W0 = (RA0E == WA0W);

	// logica para el Match Signaling del Stalling
	assign Match_12D_E = (RA1 == WA3E) || (RA2 == WA3E);
	
	assign OutputExecute[31:0] = ALUResultE;
	assign OutputExecute[63:32] = WriteDataE;
	assign OutputExecute[67:64] = InputExecute[99:96];
	assign OutputExecute[99:68] = ALUResult2E;
	assign OutputExecute[103:100] = WA0E;
	
	ff1to1 #(104) ExecuteToMemoryReg(
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
	assign ALUOut2M = InputMemory[99:68];
	assign WA0M = InputMemory[103:100];
	
	assign OutputMemory[31:0] = ReadData;
	assign OutputMemory[63:32] = ALUOutM;
	assign OutputMemory[67:64] = WA3M;
	assign OutputMemory[99:68] = ALUOut2M;
	assign OutputMemory[103:100] = WA0M;
	
	ff1to1 #(104) MemoryToWriteBackReg (
	   .i(OutputMemory),
	   .j(InputWriteBack),
	   .clk(clk),
       .reset(reset),
	   .clear(1'b0),
	   .enable(1'b1)
	);

	wire [3:0] WA3W;
	assign WA3W = InputWriteBack[67:64];
	assign Result2W = InputWriteBack[99:68];
	assign WA0W = InputWriteBack[103:100];

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
	
	//assign WA3W = 4'b0010;
	
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.we0(RegWrite2W),
		.ra0(RA0),
		.ra1(RA1),
		.ra2(RA2),
		.ra3(RA3),
		.wa3(WA3W),
		.wd3(ResultW),
		.r15(PCPlus4),
		.wa0(WA0W),
		.wd0(Result2W),
		.rd0(RD0),
		.rd1(SrcA),
		.rd2(WriteData),
		.rd3(RD3)
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

	mux8 forwardsrcamux(
		.d0(InputExecute[31:0]),
		.d1(ResultW),
		.d2(ALUOutM),
		.d3(ALUOut2M),
		.d4(Result2W),
		.s(ForwardAE),
		.y(SrcAE)
	);

	mux8 forwardsrcbmux(
		.d0(InputExecute[63:32]),
		.d1(ResultW),
		.d2(ALUOutM),
		.d3(ALUOut2M),
		.d4(Result2W),
		.s(ForwardBE),
		.y(ShiftInputE)
	);

	mux8 forwardsrccmux(
		.d0(InputExecute[139:108]),
		.d1(ResultW),
		.d2(ALUOutM),
		.d3(ALUOut2M),
		.d4(Result2W),
		.s(ForwardCE),
		.y(SrcCE)
	);

	mux8 forwardsrcdmux(
		.d0(InputExecute[171:140]),
		.d1(ResultW),
		.d2(ALUOutM),
		.d3(ALUOut2M),
		.d4(Result2W),
		.s(ForwardDE),
		.y(SrcDE)
	);

	mux2 #(32) shiftmux(
		.d0(ALURes),
		.d1(SrcBE),
		.s(Shift),
		.y(ALUResultE)
	);

	mux2 #(5) shiftamountmux(
		.d0(ShiftImmediateE),
		.d1(SrcCE[4:0]),
		.s(ShiftSourceE),
		.y(ShiftAmountE)
	);

	mux2 #(32) noshiftmux(
		.d0(ShiftResultE),
		.d1(ShiftInputE),
		.s(NoShift),
		.y(WriteDataE)
	);

	shift shift(
		.ShiftInput(ShiftInputE),
    	.ShiftAmount(ShiftAmountE),
		.ShiftType(ShiftTypeE),
		.ShiftResult(ShiftResultE)
	);

	alu alu(
		.a(SrcAE),
		.b(SrcBE),
		.c(SrcCE),
		.d(SrcDE),
		.ALUControl(ALUControl),
		.Carry(Carry),
		.curr_carry_flag(CarryFlag),
		.Saturated(Saturated),
		.Negate(Negate),
		.Unsigned(Unsigned),
		.Result(ALURes),
		.Result2(ALUResult2E),
		.ALUFlags(ALUFlags)
	);
endmodule
