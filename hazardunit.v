`timescale 1ps/1ps

module hazardunit(
    input wire clk,
    input wire RegWriteW, 
    input wire RegWriteM,  
    input wire Match_1E_M,
    input wire Match_1E_W,
    input wire Match_2E_M,
    input wire Match_2E_W,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE
);

always @(*) begin
    if (Match_1E_M & RegWriteM)         
        ForwardAE = 2'b10;
    else if (Match_1E_W & RegWriteW)    
        ForwardAE = 2'b01;
    else                                
        ForwardAE = 2'b00;

    if (Match_2E_M & RegWriteM)         
        ForwardBE = 2'b10;
    else if (Match_2E_W & RegWriteW)    
        ForwardBE = 2'b01;
    else                                
        ForwardBE = 2'b00;
end

endmodule
