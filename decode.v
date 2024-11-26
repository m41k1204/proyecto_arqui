module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	ImmSrc,
	RegSrc,
	ALUControl,
	Branch
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [3:0] ALUControl;
	reg [9:0] controls;
	output wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 10'b0000101001;
				else
					controls = 10'b0000001001;
			2'b01:
				if (Funct[0])
					controls = 10'b0001111000;
				else
					controls = 10'b1001110100;
			2'b10: controls = 10'b0110100010;
			default: controls = 10'bxxxxxxxxxx;
		endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0100: ALUControl = 4'b0000;
				4'b0010: ALUControl = 4'b0001;
				4'b0000: ALUControl = 4'b0010;
				4'b1100: ALUControl = 4'b0011;
				4'b1000: ALUControl = 4'b0111;
				4'b1001: ALUControl = 4'b0110;
				4'b1010: ALUControl = 4'b0100;
				default: ALUControl = 4'bxxxx;
			endcase
			FlagW[1] = Funct[0] & ~ALUControl[2];
			FlagW[0] = Funct[0] & ((ALUControl == 4'b0000) | (ALUControl == 4'b0001));
		end
		else begin
			ALUControl = 4'b0000;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
