module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	
	initial begin 
RAM[0] = 32'he3a00005;
RAM[1] = 32'he3a01008;
RAM[2] = 32'he0802001;
RAM[3] = 32'he0413000;
RAM[4] = 32'he0034002;
RAM[5] = 32'he1815000;
RAM[6] = 32'he0256004;
RAM[7] = 32'he0667001;
RAM[8] = 32'he3770004;
RAM[9] = 32'he0a78004;
RAM[10] = 32'he0c19000;
RAM[11] = 32'he0e3a002;
RAM[12] = 32'he3a0b010;
RAM[13] = 32'he1a0cd0b;
RAM[14] = 32'he10c000c;
RAM[15] = 32'he1a0100b;
RAM[16] = 32'he1a02d81;
RAM[17] = 32'he1223004;
RAM[18] = 32'he119000b;
RAM[19] = 32'he13a0001;
RAM[20] = 32'he159000a;
RAM[21] = 32'he0454121;
RAM[22] = 32'he08450c8;
RAM[23] = 32'he18c6177;
RAM[24] = 32'he1c17006;
RAM[25] = 32'he1e18006;





	   end
	   
	assign rd = RAM[a[31:2]];
endmodule
