module shift(
    ShiftSource,
    ShiftAmount,
    ShiftSel,
    ShiftResult
);
    input wire [31:0] ShiftSource;
    input wire [4:0] ShiftAmount;
    input wire [1:0] ShiftSel;
    output reg [31:0] ShiftResult;

    always @ (*) 
        case (ShiftSel)
            2'b00: assign ShiftResult = ShiftSource << ShiftAmount;
            2'b01: assign ShiftResult = ShiftSource >> ShiftAmount;
            2'b10: assign ShiftResult = ShiftSource >>> ShiftAmount;
            2'b11: assign ShiftResult = (ShiftSource >> ShiftAmount) | (ShiftSource << (32 - ShiftAmount));
    endcase
endmodule
