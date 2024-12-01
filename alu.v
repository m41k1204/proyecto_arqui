module alu(
    a,
    b,
    c,
    d,
    ALUControl,
    Carry,
    curr_carry_flag,
    Saturated,
    Negate,
    Unsigned,
    Long,
    Memory,
    FinalResult,
    FinalResult2,
    ALUFlags
);
    input wire [31:0] a;
    input wire [31:0] b;
    input wire [31:0] c;
    input wire [31:0] d;
    input wire [3:0] ALUControl;
    input wire Carry;
    input wire curr_carry_flag;
    input wire Saturated;
    input wire Negate;
    input wire Unsigned;
    input wire Long;
    input wire Memory;

    wire carry_val;

    reg [31:0] Result;
    reg [31:0] Result2; 
    output wire [4:0] ALUFlags;
    output wire [31:0] FinalResult;
    output wire [31:0] FinalResult2;

    wire  neg, zero, carry_flag, overflow, saturated_flag;
    wire [31:0] condinva;
    wire [31:0] condinvb;
    wire [32:0] sum;
    wire [31:0] inv_a, inv_b, signed_division;
    wire [63:0] signed_product;
    wire [63:0] accumulate;

    assign condinva = ALUControl[3:0] == 4'b0101 ? ~a : a;
    assign condinvb = (ALUControl[3:0] == 4'b0001 | Negate) ? ~b : b;
    assign carry_val = ~((ALUControl[3:0] == 4'b0000) ^ (curr_carry_flag & Carry));
    assign sum = condinva + condinvb + carry_val;
    assign inv_a = a[31] ? ~a + 1 : a;
    assign inv_b = b[31] ? ~b + 1 : b;

    assign signed_division = a[31] ^ b[31] ? ~(inv_a / inv_b) + 1 : (inv_a / inv_b);
    assign signed_product = a[31] ^ b[31] ? ~(inv_a * inv_b) + 1 : (inv_a * inv_b);

    assign accumulate = Long ? {c, d} : {32'h00000000, c};
    
    always @(*)
    begin
        casex (ALUControl[3:0])
        4'b0000 , 4'b0001 , 4'b0101: 
        if(saturated_flag) begin
            if(sum[31]) begin
                Result =32'hefffffff;
            end
            else begin
                Result = 32'h80000000;
            end
        end
        else begin
            Result = sum;
        end
        4'b0010: Result = a & condinvb;
        4'b0011: Result = a | condinvb;
        4'b0100: Result = a ^ b;
        4'b0101: Result = b - a;
        4'b0110: 
        if(Unsigned) begin
            {Result2, Result} = a * b;
        end
        else begin
            {Result2, Result} = signed_product;
        end
        4'b0111:
        if(Unsigned) begin
            {Result2, Result} = accumulate + a * b;
        end
        else begin
            {Result2, Result} = accumulate + signed_product;
        end
        4'b1000: Result = c - a * b;
        4'b1001:
        if(Unsigned) begin
            Result = a / b;
        end
        else begin
            Result = signed_division;
        end
        endcase
    end
    assign FinalResult = Memory ? a : Result;
    assign FinalResult2 = Memory ? Result : Result2;

    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry_flag = (ALUControl[3:0] == 4'b0000 | ALUControl[3:0] == 4'b0001 | ALUControl[3:0] == 4'b0101) & sum[32];
    assign overflow = ((ALUControl[3:0] == 4'b0000 | ALUControl[3:0] == 4'b0001 | ALUControl[3:0] == 4'b0101) & ~(condinva[31] ^ condinvb[31]) & (condinva[31] ^ sum[31]));
    //assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    assign saturated_flag = overflow & Saturated;
    assign ALUFlags = {saturated_flag, neg, zero, carry_flag, overflow};
endmodule
