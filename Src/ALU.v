module ALU(
    input [31:0] A,B,
    input [2:0] ALUControl,
    output [31:0] Result,
    output Zero
    );
    
    
    wire Cout;
    wire [31:0]Sum;
    
    //000-add,001-sub,010-slt,011-or,100-and   
    
    
    
    assign {Cout,Sum} = (ALUControl == 3'b000) ? (A + B) : (A + ((~B)+1)) ;
    
    
    assign  #2 Result = (ALUControl == 3'b000) ? Sum :
                        (ALUControl == 3'b001) ? Sum :
                        (ALUControl == 3'b010) ? {{31{1'b0}},(Sum[31])} :
                        (ALUControl == 3'b011) ? A | B :
                        (ALUControl == 3'b100) ? A & B : {32{1'b0}};
    assign Zero = (Result == 32'b0);

endmodule

