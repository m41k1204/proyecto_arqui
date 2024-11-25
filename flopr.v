module flopr (
	clk,
	reset,
	d,
	q,
	enable
);

	parameter WIDTH = 8;
	input wire clk;
	input wire reset;
	input wire enable;
	input wire [WIDTH - 1:0] d;
	output reg [WIDTH - 1:0] q;
	always @(posedge clk or posedge reset)
		if (reset)
			q <= 0;
		else if (enable)
			q <= d;
		else 
			q <= q;
endmodule