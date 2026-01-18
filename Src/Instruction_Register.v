module Instruction_Register(
        input rst,clk,IRWrite,
        input [31:0] Instr_In,PC_In,
        output reg [31:0] Instr_Out,PC_Out
    );
    
    always @(posedge clk) begin
        if(~rst)
            Instr_Out<=32'b0;
        else if(IRWrite) begin
            Instr_Out<=Instr_In;        
            PC_Out <= PC_In;
            end
    end
endmodule
