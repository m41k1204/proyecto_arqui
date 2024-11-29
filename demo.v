`include "top.v"
`include "clk_div_pipelined.v"
`include "basysdecoder.v"

module demo(
    clk,
    rst,
    out, 
    enable,
    real_clk
);

input wire clk;
output wire real_clk;
input wire rst;
wire [31:0] ResultW;
wire WriteData;
wire DataAdr;
wire MemWriteM;

output wire [6:0] out;
output wire [3:0] enable;


clk_divider clk_divider(
    .clk(clk),
    .rst(rst),
    .led(real_clk)
);

top top(
    .clk(real_clk),
    .reset(rst),
    .WriteData(WriteData),
    .DataAdr(DataAdr),
    .MemWriteM(MemWriteM),
    .ResultW(ResultW)
);

basysdecoder decoder(
    .out0(out),
    .enable(enable),
    .in(ResultW[3:0])
);

endmodule
