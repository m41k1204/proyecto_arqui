`include "clk_div_pipelined.v"
`include "top.v"


module demo (
    input wire clk,
    input wire rst,
    output wire [6:0] out,
    output wire [3:0] enable,
    output wire real_clk,
    output wire RegWriteW

);

    wire [31:0] ResultW;   
    wire WriteData, DataAdr, MemWriteM;
    wire internal_clk;
    wire [31:0] PC;

    
    clk_divider_internal internal_clk_divider (
        .clk(clk),
        .rst(rst),
        .led(internal_clk)
    );

    
    top top (
        .clk(real_clk),
        .reset(rst),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWriteM(MemWriteM),
        .ResultW(ResultW),
        .PC(PC),
        .Result2W(Result2W),
        .BranchTakenE(BranchTakenE),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .RegWriteW(RegWriteW)
        
    );

    
    basysdecoder decoder (
        .out0(out),
        .enable(enable),
        .internal_clk(internal_clk),
        .real_clk(real_clk),
        .ResultW(ResultW[15:0]),
        .PC(PC[7:0])
    );

   
    clk_divider clk_divider (
        .clk(clk),
        .rst(rst),
        .led(real_clk)
    );

endmodule
