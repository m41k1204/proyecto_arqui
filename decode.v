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
	Branch,
	Carry,
	NoWrite,
	Shift,
	Saturated,
	Negate,
	Unsigned,
	Long
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
	output wire Carry;
	output wire NoWrite;
	output wire Shift;
	output wire Saturated;
	output wire Negate;
	output wire Unsigned;
	output wire Long;

	reg [9:0] controls;
	output wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00 || 2'b11:
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

	assign Carry = (Op == 2'b00) & (Funct[4:1] == 4'b0101 | Funct[4:1] == 4'b0110 | Funct[4:1] == 4'b0111);
	assign NoWrite = (Op == 2'b00) & (Funct[4:0] == 5'b10001 | Funct[4:0] == 5'b10011 | Funct[4:1] == 4'b1010 | Funct[4:1] == 4'b1011);
	assign Shift = (Op == 2'b00) & (Funct[4:0] == 4'b1101);
	assign Saturated = (Op == 2'b00) & (Funct[4:0] == 5'b10000 | Funct[4:0] == 5'b10010);
	assign Negate = (Op == 2'b00) & (Funct[4:0] == 4'b1110 | Funct[4:0] == 4'b1111);
	assign Unsigned = (Op == 2'b11) & ~(Funct[4:0] == 4'b0101 | Funct[4:0] == 4'b0110 | Funct[4:0] == 4'b1000);
	assign Long = (Op == 2'b11) & (Funct[4:0] == 4'b0011 | Funct[4:0] == 4'b0100 | Funct[4:0] == 4'b0101 | Funct[4:0] == 4'b0110);

	always @(*)
		if (ALUOp) begin
			if(Op == 2'b00) begin
				case (Funct[4:1])
					4'b0100: ALUControl = 4'b0000;

					4'b0010: ALUControl = 4'b0001;

					4'b0000: ALUControl = 4'b0010;

					4'b1100: ALUControl = 4'b0011;

					4'b0001: ALUControl = 4'b0100;

					4'b0011: ALUControl = 4'b0101;

					4'b0101: ALUControl = 4'b0000;

					4'b0110: ALUControl = 4'b0001;

					4'b0111: ALUControl = 4'b0101;

					4'b1000:
					if(Funct[0]) begin
						ALUControl = 4'b0010;
					end
					else begin
						ALUControl = 4'b0000;
					end

					4'b1001:
					if(Funct[0]) begin
						ALUControl = 4'b0100;
					end
					else begin
						ALUControl = 4'b0001;
					end

					4'b1010: ALUControl = 4'b0001;

					4'b1011: ALUControl = 4'b0000;

					4'b1101: ALUControl = 4'bxxxx;

					4'b1110: ALUControl = 4'b0010;

					4'b1111: ALUControl = 4'b0011;

					default: ALUControl = 4'bxxxx;
				endcase
			end
			else if(Op == 2'b11) begin
				case (Funct[4:1])
					4'b0000: ALUControl = 4'b0110;

					4'b0001: ALUControl = 4'b0111;

					4'b0010: ALUControl = 4'b1000;

					4'b0011: ALUControl = 4'b0110;

					4'b0100: ALUControl = 4'b0111;

					4'b0101: ALUControl = 4'b0110;

					4'b0110: ALUControl = 4'b0111;

					4'b0111: ALUControl = 4'b1001;

					4'b1000: ALUControl = 4'b1001;

					default: ALUControl = 4'bxxxx;
				endcase
			end


			FlagW[1] = Op == 2'b00 & Funct[0];
			FlagW[0] = Op == 2'b00 & Funct[0] & ALUControl != 4'b0010 & ALUControl != 4'b0011 & ALUControl != 4'b0100;
		end
		else begin
			ALUControl = 4'b0000;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
