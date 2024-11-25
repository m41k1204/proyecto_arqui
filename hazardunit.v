`timescale 1ps/1ps

module hazardunit(
    input wire clk,
    input wire RegWriteW, 
    input wire RegWriteM,
    input wire MemToRegE,  
    input wire Match_1E_M,
    input wire Match_1E_W,
    input wire Match_2E_M,
    input wire Match_2E_W,
    input wire Match_12D_E,
    input wire PCSrcD,
    input wire PCSrcE,
    input wire PCSrcM,
    input wire PCSrcW,
    input wire BranchTakenE,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output wire StallF,
    output wire StallD,
    output wire FlushE,
    output wire FlushD
);

wire LDRstall;
wire PCWrPendingF;

assign PCWrPendingF = PCSrcD + PCSrcE + PCSrcM;
assign LDRstall = Match_12D_E & MemToRegE;
assign StallF = LDRstall || PCWrPendingF;
assign StallD = LDRstall;
assign FlushE = LDRstall || BranchTakenE;
assign FlushD = PCWrPendingF || PCSrcW || BranchTakenE;

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
