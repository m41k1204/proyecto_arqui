`timescale 1ns / 1ps

module basysdecoder (
    output reg [6:0] out0,        
    output reg [3:0] enable,      
    input wire internal_clk,               
    input wire real_clk,         
    input wire [15:0] ResultW,
    input wire [7:0] PC
);

    reg [1:0] state;             
    reg [3:0] digito;            

    parameter S0 = 2'b00;       
    parameter S1 = 2'b01;       
    parameter S2 = 2'b10;       
    parameter S3 = 2'b11;       

    // Reset the state to S0 on real_clk
    
    // State transitions on internal_clk (only if real_clk is not active)
    always @(posedge internal_clk) begin
        begin  // Ensure state only changes on internal_clk, not on real_clk
            case (state)
                S0: begin 
                    state <= S1;
                    enable <= 4'b1110;
                end
                S1: begin 
                    state <= S2;
                    enable <= 4'b1101;
                end
                S2: begin 
                    state <= S3;
                    enable <= 4'b1011;
                end
                S3: begin 
                    state <= S0;
                    enable <= 4'b0111;
                end 
            endcase
        end
    end

    // Determine the output digit based on the current state
    always @(*) begin
        case (state)
            S1: digito = ResultW[3:0];    
            S2: digito = ResultW[7:4];    
            S3: digito = PC[3:0];   
            S0: digito = PC[7:4];  
            default: digito = 4'b0000;
        endcase
    end

    // Display the 7-segment values based on the current digit
    always @(*) begin
        case (digito)
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
