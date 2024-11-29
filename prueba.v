`timescale 1ns / 1ps

module prueba (
    output reg [6:0] out0,     // 7-segment display output
    output wire [3:0] enable,  // Enable for the display
    input wire clk,            
    input wire rst             
);

    reg [3:0] count;  

    assign enable = 4'b1110;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000; 
        end else begin
            if (count == 4'b1111) begin
                count <= 4'b0000; 
            end else begin
                count <= count + 4'b0001; 
            end
        end
    end

    // Decoder logic for 7-segment display
    always @(*) begin
        case (count)
            4'b0000: out0 = 7'b0000001; // 0
            4'b0001: out0 = 7'b1001111; // 1
            4'b0010: out0 = 7'b0010010; // 2
            4'b0011: out0 = 7'b0000110; // 3
            4'b0100: out0 = 7'b1001100; // 4
            4'b0101: out0 = 7'b0100100; // 5
            4'b0110: out0 = 7'b0100000; // 6
            4'b0111: out0 = 7'b0001111; // 7
            4'b1000: out0 = 7'b0000000; // 8
            4'b1001: out0 = 7'b0001100; // 9
            4'b1010: out0 = 7'b0001000; // A
            4'b1011: out0 = 7'b1100000; // b
            4'b1100: out0 = 7'b0110001; // C
            4'b1101: out0 = 7'b1000010; // d
            4'b1110: out0 = 7'b0110000; // E
            4'b1111: out0 = 7'b0111000; // F
            default: out0 = 7'b1111111; // Default (all segments off)
        endcase
    end

endmodule
