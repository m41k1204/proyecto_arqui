`timescale 1ps/1ps

module hazardunit(
    input wire reset,
    input wire clk,
    input wire RegWriteW, 
    input wire RegWriteM,
    input wire RegWrite2W, 
    input wire RegWrite2M,
    input wire MemToRegE,  
    input wire Match_1E_M,
    input wire Match_1E_W,
    input wire Match_1E_M0,
	input wire Match_1E_W0,
	input wire Match_2E_M,
    input wire Match_2E_W,
	input wire Match_2E_M0,
	input wire Match_2E_W0,
	input wire Match_3E_M,
    input wire Match_3E_W,
	input wire Match_3E_M0,
	input wire Match_3E_W0,
	input wire Match_0E_M,
    input wire Match_0E_W,
	input wire Match_0E_M0,
	input wire Match_0E_W0,
    input wire Match_12D_E,
    input wire PCSrcD,
    input wire PCSrcE,
    input wire PCSrcM,
    input wire PCSrcW,
    input wire BranchTakenE,
    output reg [2:0] ForwardAE,
    output reg [2:0] ForwardBE,
    output reg [2:0] ForwardCE,
    output reg [2:0] ForwardDE,
    output wire StallF,
    output wire StallD,
    output wire FlushE,
    output wire FlushD
);

wire LDRstall;
wire PCWrPendingF;

assign PCWrPendingF = PCSrcD + PCSrcE + PCSrcM;
assign LDRstall = Match_12D_E & MemToRegE;
assign StallF = reset ? 1'b0 : ~(LDRstall || PCWrPendingF);
assign StallD = reset ? 1'b0 : ~LDRstall;
assign FlushE = reset ? 1'b0 : (LDRstall || BranchTakenE);
assign FlushD = reset ? 1'b0 : (PCWrPendingF || PCSrcW || BranchTakenE);

always @(*) begin
    if (Match_1E_M & RegWriteM)         
        ForwardAE = 3'b010;
    else if (Match_1E_W & RegWriteW)    
        ForwardAE = 3'b001;
    else if (Match_1E_M0 & RegWrite2M)    
        ForwardAE = 3'b011;
    else if (Match_1E_W0 & RegWrite2W)    
        ForwardAE = 3'b100;
    else                                
        ForwardAE = 3'b000;

    if (Match_2E_M & RegWriteM)         
        ForwardBE = 3'b010;
    else if (Match_2E_W & RegWriteW)    
        ForwardBE = 3'b001;
    else if (Match_2E_M0 & RegWrite2M)    
        ForwardBE = 3'b011;
    else if (Match_2E_W0 & RegWrite2W)    
        ForwardBE = 3'b100;
    else                                
        ForwardBE = 3'b000;

    if (Match_3E_M & RegWriteM)         
        ForwardCE = 3'b010;
    else if (Match_3E_W & RegWriteW)    
        ForwardCE = 3'b001;
    else if (Match_3E_M0 & RegWrite2M)    
        ForwardCE = 3'b011;
    else if (Match_3E_W0 & RegWrite2W)    
        ForwardCE = 3'b100;
    else                                
        ForwardCE = 3'b000;

    if (Match_0E_M & RegWriteM)         
        ForwardDE = 3'b010;
    else if (Match_0E_W & RegWriteW)    
        ForwardDE = 3'b001;
    else if (Match_0E_M0 & RegWrite2M)    
        ForwardDE = 3'b011;
    else if (Match_0E_W0 & RegWrite2W)    
        ForwardDE = 3'b100;
    else                                
        ForwardDE = 3'b000;

end

endmodule
