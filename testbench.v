`include "top.v"
`timescale 1ns/1ns

module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] DataAdr;
	wire MemWriteM;
	wire [31:0] ResultW;
	wire [31:0] Result2W;
	wire ForwardA;
	wire ForwardB;
	wire BranchTakenE;
	top dut(
		.clk(clk),
		.reset(reset),
		.WriteData(WriteData),
		.DataAdr(DataAdr),
		.MemWriteM(MemWriteM),
		.ResultW(ResultW),
		.Result2W(Result2W),
		.BranchTakenE(BranchTakenE),
		.ForwardA(ForwardA),
		.ForwardB(ForwardB)
	);
	initial begin
		reset <= 1;
		#(22)
			;
		reset <= 0;
	end
	always begin
		clk <= 1;
		#(5)
			;
		clk <= 0;
		#(5)
			;
	end
endmodule