`include "flopenr.v"
`include "condcheck.v"

module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagWrite,
	Saturated,
	//PCS,
	//RegW,
	//MemW,
	//PCSrc,
	//RegWrite,
	//MemWrite
	CondEx,
	Flags
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [4:0] ALUFlags;
	//input wire [1:0] FlagW;
	//input wire PCS;
	//input wire RegW;
	//input wire MemW;
	//output wire PCSrc;
	//output wire RegWrite;
	//output wire MemWrite;
	input wire [1:0] FlagWrite;
	input wire Saturated;
	output wire [4:0] Flags;
	output wire CondEx;

	flopenr #(1) flagreg2(
		.clk(clk),
		.reset(reset),
		.en(Saturated),
		.d(ALUFlags[4]),
		.q(Flags[4])
	);

	flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[1]),
		.d(ALUFlags[3:2]),
		.q(Flags[3:2])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWrite[0]),
		.d(ALUFlags[1:0]),
		.q(Flags[1:0])
	);
	condcheck cc(
		.Cond(Cond),
		.Flags(Flags),
		.CondEx(CondEx)
	);


	//assign FlagWrite = FlagW & {2 {CondEx}};
	//assign RegWrite = RegW & CondEx;
	//assign MemWrite = MemW & CondEx;
	//assign PCSrc = PCS & CondEx;
endmodule
