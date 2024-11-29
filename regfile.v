module regfile (
	clk,
	we3,
	we0,
	ra0,
	ra1,
	ra2,
	ra3,
	wa3,
	wd3,
	r15,
	rd1,
	rd2,
	rd3, 
	rd0,
	wd0,
	wa0	
);
	input wire clk;
	input wire we3;
	input wire we0;
	input wire [3:0] ra0;
	input wire [3:0] ra1;
	input wire [3:0] ra2;
	input wire [3:0] ra3;
	input wire [3:0] wa3;
	input wire [31:0] wd3;
	input wire [31:0] r15;
	input wire [3:0] wa0;
	input wire [31:0] wd0;
	output wire [31:0] rd0;
	output wire [31:0] rd1;
	output wire [31:0] rd2;
	output wire [31:0] rd3;

	reg [31:0] rf [14:0];
	always @(posedge ~clk) begin
		if (we3)
			rf[wa3] <= wd3;
		if (we0)
			rf[wa0] <= wd0;
	end

	assign rd0 = (ra0 == 4'b1111 ? r15 : rf[ra0]);
	assign rd1 = (ra1 == 4'b1111 ? r15 : rf[ra1]);
	assign rd2 = (ra2 == 4'b1111 ? r15 : rf[ra2]);
	assign rd3 = (ra3 == 4'b1111 ? r15 : rf[ra3]);
endmodule
