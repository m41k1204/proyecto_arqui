module shift(
    ShiftInput,
    ShiftAmount,
    ShiftType,
    ShiftResult
);
    input wire [31:0] ShiftInput;
    input wire [4:0] ShiftAmount;
    input wire [1:0] ShiftType;
    output reg [31:0] ShiftResult;

    always @ (*) 
        case (ShiftType)
            2'b00: assign ShiftResult = ShiftInput << ShiftAmount;
            2'b01: assign ShiftResult = ShiftInput >> ShiftAmount;
            2'b10: assign ShiftResult = ShiftInput >>> ShiftAmount;
            2'b11: assign ShiftResult = (ShiftInput >> ShiftAmount) | (ShiftInput << (32 - ShiftAmount));
    endcase
endmodule
