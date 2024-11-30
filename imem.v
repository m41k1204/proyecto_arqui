module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	
	initial begin 

RAM[0] = 32'he3a02014;
RAM[1] = 32'he3a04009;
RAM[2] = 32'he3a05008;
RAM[3] = 32'hec049005;
RAM[4] = 32'he3a0a004;
RAM[5] = 32'hec24b20a;
RAM[6] = 32'he24ac00a;
RAM[7] = 32'hec450a0c;
RAM[8] = 32'hece9100a;
RAM[9] = 32'hed09200c;

	   end
	   
	assign rd = RAM[a[31:2]];
endmodule
