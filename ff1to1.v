module ff1to1(
    
    input wire [WIDTH - 1:0] i,
    output reg [WIDTH - 1:0] j,
    input wire clk,
    input wire reset,
    input wire enable,
    input wire clear
    );


    parameter WIDTH = 8;
    
    always @ (posedge clk)
        if(reset || clear) j <= 0;
        else if (enable) j <= i;
        else
            j <= j;

endmodule
