module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	
	initial begin 
	   RAM[0] = 32'he3a00000;
	   RAM[1] = 32'he3a01004;
	   RAM[2] = 32'he3a06006;
	   RAM[3] = 32'he1510000;
	   RAM[4] = 32'h0a000001;
	   RAM[5] = 32'he2411001;
	   RAM[6] = 32'heafffffb;
	   RAM[7] = 32'he3a02002;
	   end
	   
	assign rd = RAM[a[31:2]];
endmodule
