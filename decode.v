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
	Long,
	NoShift,
	Reg2W,
	PreIndex
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
	output wire [2:0] RegSrc;
	output reg [3:0] ALUControl;
	output wire Carry;
	output wire NoWrite;
	output wire Shift;
	output wire Saturated;
	output wire Negate;
	output wire Unsigned;
	output wire Long;
	output wire NoShift;

	reg [12:0] controls;
	output wire Branch;
	output wire Reg2W;
	output wire PreIndex;

	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00, 2'b11:
				if (Funct[5])
					controls = 13'b0000010100100;
				else
					controls = 13'b0000000100100;
			2'b01:
			begin
				controls[12:10] = 3'b100;
				controls[9:8] = Funct[5] ? 2'bxx : 2'b01;
				controls[7] = ~Funct[5];
				controls[6] = Funct[0];
				controls[5] = Funct[0];
				controls[4] = ~Funct[0];
				controls[3] = 1'b0;
				controls[2] = 1'b0;
				controls[1] = Funct[1] | ~Funct[4];
				controls[0] = Funct[1];
			end

			2'b10: controls = 13'b0011010001000;
			default: controls = 13'bxxxxxxxxxxxxx;
		endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, Reg2W, PreIndex} = controls;

	assign Carry = (Op == 2'b00) & (Funct[4:1] == 4'b0101 | Funct[4:1] == 4'b0110 | Funct[4:1] == 4'b0111);
	assign NoWrite = (Op == 2'b00) & (Funct[4:0] == 5'b10001 | Funct[4:0] == 5'b10011 | Funct[4:1] == 4'b1010 | Funct[4:1] == 4'b1011);
	assign Shift = (Op == 2'b00) & (Funct[4:1] == 4'b1101);
	assign Saturated = (Op == 2'b00) & (Funct[4:0] == 5'b10000 | Funct[4:0] == 5'b10010);
	assign Negate = (Op == 2'b00) & (Funct[4:1] == 4'b1110 | Funct[4:1] == 4'b1111);
	assign Unsigned = (Op == 2'b11) & ~(Funct[4:1] == 4'b0101 | Funct[4:1] == 4'b0110 | Funct[4:1] == 4'b1000);
	assign Long = (Op == 2'b11) & (Funct[4:1] == 4'b0011 | Funct[4:1] == 4'b0100 | Funct[4:1] == 4'b0101 | Funct[4:1] == 4'b0110);
	assign NoShift = (Op == 2'b11) & ~(Funct[4:1] == 4'b0000 | Funct[4:1] == 4'b0111 | Funct[4:1] == 4'b1000);

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
			FlagW = 2'b00;
			if (Op == 2'b01) begin
				if(Funct[3])
					ALUControl = 4'b0000;
				else
					ALUControl = 4'b0001;
			end
			else
				ALUControl = 4'b0000;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
