module Instr_Decoder(
            input [6:0] Op,
            output  [1:0] ImmSrc
    );
    
    localparam [6:0] R_Type=7'b0110011,
                     I_Type=7'b0010011,
                     I_load_Type=7'b0000011,
                     S_Type=7'b0100011,
                     B_Type=7'b1100011,
                     J_Type=7'b1101111;
    //The ImmSrc signal decides the kind of immediate that is generated
    //based on the type of the instruction
    assign ImmSrc = (Op == S_Type) ? 2'b01 : 
                    (Op == B_Type) ? 2'b10 :
                    (Op == J_Type) ? 2'b11 :    
                     2'b00 ; // for I-type mainly because for R-type, we wont be using the immediate value
             
endmodule
