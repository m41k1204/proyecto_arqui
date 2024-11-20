`timescale 1ns / 1ps

module ff1to1(
    input wire  i,
    output wire j,
    input wire clk
    );
    
    reg temp;
    always @ (posedge clk) 
        temp <= i;
        
    assign j = temp;

endmodule
