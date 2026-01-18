module Memory(
            input clk, rst, Write_Enable,
            input [31:0]Address,Write_Data,
            output [31:0]Read_Data
        );
        
        reg [31:0] mem [1023:0];
        assign Read_Data = (~rst) ? 32'd0 : mem[Address[11:2]];
        always @(posedge clk) begin
            if(Write_Enable)
                mem[Address[11:2]]<= Write_Data;                
        end
        
        initial begin
            $readmemh("mem.hex",mem);
        end
        
endmodule

