module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [63:0];
	
	initial begin 
	    RAM[0] = 32'he3a00004;
        RAM[1] = 32'he3a02005;
        RAM[2] = 32'he3a04007;
        RAM[3] = 32'hec203402;

	   end
	   
	assign rd = RAM[a[31:2]];
endmodule
