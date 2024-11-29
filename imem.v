module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	
	initial begin 
	   RAM[0] = 32'he04f000f;
	   RAM[1] = 32'he080100f;
	   RAM[2] = 32'he080200f;
	   end
	   
	assign rd = RAM[a[31:2]];
endmodule