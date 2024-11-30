module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	
	initial begin 
	   RAM[0] = 32'he3a00004;
RAM[1] = 32'he3a02006;
RAM[2] = 32'he5820000;
RAM[3] = 32'he5923000;
RAM[4] = 32'hea000000;
RAM[5] = 32'he3a04007;
RAM[6] = 32'he3a05005;


	   end
	   
	assign rd = RAM[a[31:2]];
endmodule
