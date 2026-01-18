module PC_Module(
    input clk,rst,PC_Write,
    input [31:0]PC_Next,
    output reg [31:0]PC
    );
    always @(posedge clk)
    begin
        if(~rst)
            PC <= {32{1'b0}};
        else if(PC_Write)
            PC <= PC_Next;
    end
    
    initial PC = 32'b0;
endmodule
