module branchPredictorFSM(
    input clk,
    input reset,
    input BranchTakenE,
    output PredictTaken
);
    reg [1:0] state, nextstate;

    parameter SNT = 2'b00; 
    parameter WNT = 2'b01; 
    parameter WT  = 2'b10; 
    parameter ST  = 2'b11; 

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= SNT; 
        else
            state <= nextstate;
    end

    always @(*) begin
        case (state)
            SNT: nextstate = BranchTakenE ? WNT : SNT; 
            WNT: nextstate = BranchTakenE ? WT : SNT;  
            WT:  nextstate = BranchTakenE ? ST : WNT; 
            ST:  nextstate = BranchTakenE ? ST : WT;  
            default: nextstate = SNT; 
        endcase
    end

    assign PredictTaken = (state == WT) || (state == ST);

endmodule
