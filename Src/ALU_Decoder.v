module ALU_Decoder(
    input [2:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [2:0] ALUControl
    );

    //3'b000 means R-type 
    //I-type->001
    //B-type->010 (means subtraction)
    //S-type or I-load type ->011
    //else 100( including for J-type)
    
    always @(*) begin
    case(ALUOp)
        3'b000: begin  // R-type 
            case({funct7, funct3})
                10'b0000000_000: ALUControl = 3'b000; // ADD
                10'b0100000_000: ALUControl = 3'b001; // SUB
                10'b0000000_010: ALUControl = 3'b010; // SLT
                10'b0000000_110: ALUControl = 3'b011; // OR
                10'b0000000_111: ALUControl = 3'b100; // AND
                default: ALUControl = 3'b000; // Add is default for now
            endcase
        end
        3'b001: begin // I-type arithmetic
            case(funct3)
                3'b000: ALUControl = 3'b000; // ADDI
                3'b010: ALUControl = 3'b010; // SLTI
                3'b110: ALUControl = 3'b011; // ORI
                3'b111: ALUControl = 3'b100; // ANDI
                default: ALUControl = 3'b000; //Add is defualt for now. NEEDS to be Updated.
            endcase
        end
        3'b010: ALUControl = 3'b001; // B-type : both involve subtraction SUB
        3'b011: ALUControl = 3'b000; // load word and save word - both involve ADD 
        default: ALUControl = 3'b000;  
    endcase
end
endmodule
