module RF_Register(
    input  clk,// ab_write,
    input   [31:0] data_a, data_b,
    output reg [31:0] A, B
);
    always @(posedge clk) begin
            A<=data_a;
            B<=data_b;
        end
endmodule
