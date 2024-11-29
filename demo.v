`include "clk_div_pipelined.v"
`include "top.v"


module demo (
    input wire clk,
    input wire rst,
    output wire [6:0] out,
    output wire [3:0] enable,
    output wire real_clk
);

    wire [31:0] ResultW;   // Result from processor
    wire WriteData, DataAdr, MemWriteM;
    wire internal_clk;
    wire [31:0] PC;

    // Clock divider for internal FSM clock
    clk_divider_internal internal_clk_divider (
        .clk(clk),
        .rst(rst),
        .led(internal_clk)
    );

    // Pipelined processor
    top top (
        .clk(real_clk),
        .reset(rst),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWriteM(MemWriteM),
        .ResultW(ResultW),
        .PC(PC)
    );

    // Basys decoder with FSM
    basysdecoder decoder (
        .out0(out),
        .enable(enable),
        .internal_clk(internal_clk),
        .real_clk(real_clk),
        .ResultW(ResultW[15:0]),
        .PC(PC[7:0])
    );

    // Real clock for processor
    clk_divider clk_divider (
        .clk(clk),
        .rst(rst),
        .led(real_clk)
    );

endmodule
