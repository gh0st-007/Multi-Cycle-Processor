module MCP_tb();
    reg clk,reset;
    Multi_Cycle_Top dut(.clk(clk),.rst(reset));
    always #5 clk = ~clk;
    
 initial begin
        clk = 1'b0;
        reset = 1'b1;
        // Run for some cycles
        #800 
        $stop;
    end

endmodule
