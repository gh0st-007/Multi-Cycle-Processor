module Control_Unit_Top(
        input [6:0] Op, funct7,
        input [2:0] funct3,
        input Zero,clk,rst,
        output RegWrite,MemWrite,IRWrite,AdrSrc,PCWrite,
        output [1:0]ALUSrcA, ALUSrcB, ResultSrc, ImmSrc,
        output [2:0]ALUControl
    );
    wire [2:0]ALUOp;
    wire PCUpdate,Branch;

    Main_Decoder Main_Decoder(
                .Op(Op),
                .clk(clk),
                .rst(rst),
                .funct3(funct3),
                .Zero(Zero),
                .RegWrite(RegWrite),
                .ALUSrcA(ALUSrcA),
                .ALUSrcB(ALUSrcB),
                .ALUOp(ALUOp),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .PCUpdate(PCUpdate),
                .AdrSrc(AdrSrc),
                .IRWrite(IRWrite),
                .Branch(Branch)
    );

    ALU_Decoder ALU_Decoder(
                            .ALUOp(ALUOp),
                            .funct3(funct3),
                            .funct7(funct7),
                            .ALUControl(ALUControl)
    );

    Instr_Decoder Instr_Decoder(
                    .Op(Op),
                    .ImmSrc(ImmSrc)
                    );
                  
    assign PCWrite = (PCUpdate ) || (Branch && Zero);
endmodule
