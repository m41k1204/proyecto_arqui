

module mux4(
    d0, 
    d1, 
    d2, 
    s,
    y
);

input wire [31:0] d0;
input wire [31:0] d1;
input wire [31:0] d2;
input wire [1:0] s;
output reg [31:0] y;

always @ (*) 
    begin
        if (s == 2'b00) y <= d0;
        else if (s == 2'b01) y <= d1;
        else if (s == 2'b10) y <= d2;
    end


endmodule