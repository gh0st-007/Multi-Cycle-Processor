module Memory_Data_Register(
    input clk,
    input [31:0] MDR_In,
    output reg [31:0] MDR_Out
    );
    
    always @(posedge clk) begin
            MDR_Out<=MDR_In;
    end
endmodule
