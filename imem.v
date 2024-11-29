module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	
	initial begin 
	   RAM[0] = 32'he04f000f;
	   RAM[1] = 32'he2801004;
	   RAM[2] = 32'he2802006;
	   RAM[3] = 32'he2803006;
	   RAM[4] = 32'he0814003;
	   RAM[5] = 32'he0425001;
	   end
	   
	assign rd = RAM[a[31:2]];
endmodule