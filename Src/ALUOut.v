module ALUResult(
    input clk,
    input [31:0] ALU_Result_In,
    output  reg [31:0] ALU_Result_Out    
    );
    
    always @(posedge clk) begin
         ALU_Result_Out <= ALU_Result_In;               
    end
endmodule
