`timescale 1ns / 1ps

module basysdecoder(
    output wire[6:0] out0,    // (AN0)
    // output [6:0] out1,    // (AN1)
    // output [6:0] out2,    // (AN2)
    // output [6:0] out3,    // (AN3)
    output wire [3:0] enable,  
    input wire [3:0] in       
);

    assign enable = 4'b1110; // los cuatro displays al mismo tiempo
    
    
    assign out0 = 7'b1001100;
//    decoder4bit decoderan0 (.in(in),   .out(out0)); //  AN0
    // decoder4bit decoderan1 (.in(in[7:4]),   .out(out1)); //  AN1
    // decoder4bit decoderan2 (.in(in[11:8]),  .out(out2)); //  AN2
    // decoder4bit decoderan3 (.in(in[15:12]), .out(out3)); //  AN3

endmodule

//module decoder4bit(
//    input [3:0] in,       
//    output reg [6:0] out  
//);
//    always @(*) begin
////        case (in)
////            4'b0000: out = 7'b0000001; // 0
////            4'b0001: out = 7'b1001111; // 1
////            4'b0010: out = 7'b0010010; // 2
////            4'b0011: out = 7'b0000110; // 3
////            4'b0100: out = 7'b1001100; // 4
////            4'b0101: out = 7'b0100100; // 5
////            4'b0110: out = 7'b0100000; // 6
////            4'b0111: out = 7'b0001111; // 7
////            4'b1000: out = 7'b0000000; // 8
////            4'b1001: out = 7'b0001100; // 9
////            4'b1010: out = 7'b0001000; // A
////            4'b1011: out = 7'b1100000; // b
////            4'b1100: out = 7'b0110001; // C
////            4'b1101: out = 7'b1000010; // d
////            4'b1110: out = 7'b0110000; // E
////            4'b1111: out = 7'b0111000; // F
////            default: out = 7'b1111111; 
////        endcase;
//        out = 7'b0000110;
    
//    end
//endmodule
