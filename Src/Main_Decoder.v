module Main_Decoder(
    input [6:0]Op,
    input Zero,rst,clk,
    input [2:0] funct3,
    output reg RegWrite,MemWrite,IRWrite,AdrSrc,PCUpdate,Branch,
    output reg [1:0]ALUSrcA, ALUSrcB, ResultSrc,
    output reg [2:0] ALUOp
    );
    
    
    localparam [6:0] R_Type=7'b0110011,
                     I_Type=7'b0010011,
                     I_load_Type=7'b0000011,
                     S_Type=7'b0100011,
                     B_Type=7'b1100011,
                     J_Type=7'b1101111;
                    // U_Type=7'b0110111;
    parameter Fetch=0, Decode=1, MemAdr=2, MemRead=3, MemWB=4, MemoryWrite=5, ExecuteR=6, ALUWB=7, ExecuteI=8, JAL=9, BEQ=10;              
    reg [3:0] state,next;
    
	always @(posedge clk) begin
		if(~rst) state<=Fetch;
		else state<=next;
	end    

    always @(*) begin
        case(state)
            Fetch               : next = Decode;
            Decode              : next = (Op == I_load_Type || Op == S_Type) ? MemAdr :
                                         (Op == R_Type) ? ExecuteR :
                                         (Op == I_Type) ? ExecuteI :
                                         (Op == J_Type ) ? JAL :
                                         (Op == B_Type) ? BEQ : Fetch;
            MemAdr              : next = (Op == I_load_Type) ? MemRead : MemoryWrite;
            MemRead             : next = MemWB;
            MemWB               : next = Fetch;
            MemoryWrite         : next = Fetch;
            ExecuteR            : next = ALUWB;
            ALUWB               : next = Fetch;
            ExecuteI            : next = ALUWB;
            JAL                 : next = ALUWB;
            BEQ                 : next = Fetch;
            default             : next = Fetch;
        endcase
    end
    
    always @(*) begin
    RegWrite=1'b0;MemWrite=1'b0;IRWrite=1'b0;AdrSrc=1'b0;PCUpdate=1'b0;
    ALUSrcA=2'b00; ALUSrcB=2'b00;ResultSrc=2'b00;  Branch=1'b0;
    ALUOp = 3'b011;
        case(state)
            Fetch:      {AdrSrc, IRWrite, ALUSrcA, ALUSrcB, ALUOp, ResultSrc, PCUpdate} = {1'b0, 1'b1, 2'b00, 2'b10, 3'b011 , 2'b10, 1'b1};
            Decode:     {ALUSrcA,ALUSrcB,ALUOp} = {2'b01, 2'b01, 3'b011};
            MemAdr:     {ALUSrcA,ALUSrcB,ALUOp} = {2'b10, 2'b01, 3'b011};
            MemRead:    {ResultSrc, AdrSrc} = {2'b00,1'b1};
            MemWB:      {ResultSrc, RegWrite} = {2'b01, 1'b1};
            MemoryWrite:{ResultSrc, AdrSrc, MemWrite} = {2'b00, 1'b1, 1'b1};
            ExecuteR:   {ALUSrcA,ALUSrcB,ALUOp} = {2'b10, 2'b00, 3'b000};
            ALUWB:      {ResultSrc, RegWrite} = {2'b00, 1'b1};
            ExecuteI:   {ALUSrcA,ALUSrcB,ALUOp} = {2'b10, 2'b01, 3'b001};
            JAL:        {ALUSrcA,ALUSrcB,ALUOp, ResultSrc, PCUpdate} = {2'b01, 2'b10, 3'b011,2'b00, 1'b1};
            BEQ:        {ALUSrcA,ALUSrcB,ALUOp, ResultSrc, Branch} = {2'b10, 2'b00, 3'b010, 2'b00, 1'b1};
            default:    ;
        endcase
    end
    
    initial begin
         RegWrite=1'b0;MemWrite=1'b0;IRWrite=1'b1;AdrSrc=1'b0;PCUpdate=1'b1;
    ALUSrcA=2'b00; ALUSrcB=2'b10;ResultSrc=2'b10; Branch=1'b0;
    ALUOp = 3'b011; state=Fetch;next=Decode; 
    end                        
endmodule
