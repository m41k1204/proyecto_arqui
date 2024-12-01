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
RAM[3] = 32'hEC049005;
RAM[4] = 32'he3a0a004;
RAM[5] = 32'hEC24B20A;
RAM[6] = 32'he24ac00a;
RAM[7] = 32'hEC450A0C;
RAM[8] = 32'hECE9100A;
RAM[9] = 32'hED09200C;
RAM[10] = 32'he3a030bf;
RAM[11] = 32'he1a04803;
RAM[12] = 32'he3a050d4;
RAM[13] = 32'he1a06405;
RAM[14] = 32'hEC647806;
RAM[15] = 32'he3a09001;
RAM[16] = 32'he3a0a003;
RAM[17] = 32'hEC849A06;
RAM[18] = 32'he3a0b000;
RAM[19] = 32'he04bc006;
RAM[20] = 32'hECA4010C;
RAM[21] = 32'he3a02001;
RAM[22] = 32'he3a03003;
RAM[23] = 32'hECC4230C;






	   end
	   
	assign rd = RAM[a[31:2]];
endmodule
