module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	assign RAM[0[31:2]] = 8'he04f000f;

	
	initial $readmemh("memfile_example.mem", RAM);
	assign rd = RAM[a[31:2]];
endmodule