`include "top.v"
`include "clk_div_pipelined.v"
`include "basysdecoder.v"

module demo;

wire clk;
wire real_clk;
wire rst;
wire ResultW;
wire WriteData;
wire DataAdr;
wire MemWriteM;

wire out;
wire enable;


clkdivider clk_divider(
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
    .in(ResultW)
);

endmodule
