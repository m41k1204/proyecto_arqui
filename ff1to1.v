`timescale 1ns / 1ps

module ff1to1(
    
    input wire [WIDTH - 1:0] i,
    output wire [WIDTH - 1:0] j,
    input wire clk,
    input wire reset
    );
    
    parameter WIDTH = 8;
    
    reg [WIDTH - 1:0] temp;
    always @ (posedge clk)
        if(reset) temp <= 0;
        else temp <= i;
        
    assign j = temp;

endmodule
