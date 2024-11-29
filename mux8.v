module mux8(
    d0, 
    d1, 
    d2, 
    d3, 
    d4,
    s,
    y
);

input wire [31:0] d0;
input wire [31:0] d1;
input wire [31:0] d2;
input wire [31:0] d3;
input wire [31:0] d4;

input wire [2:0] s;
output reg [31:0] y;

always @ (*) 
    begin
        if (s == 3'b000) y <= d0;
        else if (s == 3'b001) y <= d1;
        else if (s == 3'b010) y <= d2;
        else if (s == 3'b011) y <= d3;
        else if (s == 3'b100) y <= d4;
    end


endmodule