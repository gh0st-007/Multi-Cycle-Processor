module Multi_Cycle_Top(clk,rst);

    input clk,rst;

    wire [31:0] Result,PC_Top,Adr,Top_A, Top_B,ReadData, Instr, OldPC, RD1_Top,RD2_Top,SrcA,SrcB, ImmExt,ALUResult,ALUOut,Data;
    wire PCWrite,AdrSrc, MemWrite, IRWrite, RegWrite,Zero;
    wire [1:0]ALUSrcA,ALUSrcB, ImmSrc,ResultSrc;
    wire [2:0]ALUControl;

    PC_Module PC(
                .clk(clk),
                .rst(rst),
                .PC_Write(PCWrite),
                .PC(PC_Top),
                .PC_Next(Result)
    );
    
    Mux Instruction_Address(
                .in1(PC_Top),
                .in2(Result),
                .sel(AdrSrc),
                .out(Adr)    
    );
    
    Memory ID_Memory(
                .clk(clk),
                .rst(rst),
                .Write_Enable(MemWrite),
                .Address(Adr),
                .Write_Data(Top_B),
                .Read_Data(ReadData)
    );
    
    Instruction_Register IR(
                .rst(rst),
                .clk(clk),
                .IRWrite(IRWrite),
                .Instr_In(ReadData),
                .PC_In(PC_Top),
                .Instr_Out(Instr),
                .PC_Out(OldPC)
    );
    Control_Unit_Top Control_Unit(
                            .Op(Instr[6:0]),
                            .funct7(Instr[31:25]),
                            .funct3(Instr[14:12]),
                            .Zero(Zero),
                            .clk(clk),
                            .rst(rst),
                            .RegWrite(RegWrite),
                            .MemWrite(MemWrite),
                            .IRWrite(IRWrite),
                            .AdrSrc(AdrSrc),
                            .PCWrite(PCWrite),
                            .ImmSrc(ImmSrc),
                            .ALUSrcA(ALUSrcA),
                            .ALUSrcB(ALUSrcB),
                            .ResultSrc(ResultSrc),
                            .ALUControl(ALUControl)
    );

    Register_File Register_File(
                            .clk(clk),
                            .rst(rst),
                            .Write_Enable(RegWrite),
                            .WD3(Result),
                            .A1(Instr[19:15]),
                            .A2(Instr[24:20]),
                            .A3(Instr[11:7]),
                            .RD1(RD1_Top),
                            .RD2(RD2_Top)
    );
    
    
     Sign_Extend Immediate_Generator(
                        .In(Instr),
                        .ImmSrc(ImmSrc),
                        .Imm_Ext(ImmExt)
    );
    
    RF_Register RFregister(
                            .clk(clk), 
                            .data_a(RD1_Top),
                            .data_b(RD2_Top),
                            .A(Top_A),
                            .B(Top_B)
    );
    
   
    
    Mux4 ALU_Src_A(
                .in1(PC_Top),
                .in2(OldPC),
                .in3(Top_A),
                .in4(32'd0),
                .sel(ALUSrcA),
                .out(SrcA)
                );

   Mux4 ALU_Src_B(
                .in1(Top_B),
                .in2(ImmExt),
                .in3(32'd4),
                .in4(32'd0),
                .sel(ALUSrcB),
                .out(SrcB)
                );

    

    ALU ALU(
            .A(SrcA),
            .B(SrcB),
            .Result(ALUResult),
            .ALUControl(ALUControl),
            .Zero(Zero)
    );

    
    ALUResult ALU_Result_Reg(
                            .clk(clk),
                            .ALU_Result_In(ALUResult),
                            .ALU_Result_Out(ALUOut)    
    );

    Mux4 Write_Back_Mux(
                        .in1(ALUOut),
                        .in2(Data),
                        .in3(ALUResult),
                        .in4(32'd0),
                        .sel(ResultSrc),
                        .out(Result)

    );
    
    Memory_Data_Register MDR(
                        .clk(clk),
                        .MDR_In(ReadData),
                        .MDR_Out(Data)         
    );
    
endmodule
