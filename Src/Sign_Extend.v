module Sign_Extend (
    input [31:0]In,
    input [1:0] ImmSrc,
    output [31:0]Imm_Ext
    );
    
    localparam IMM_I = 2'b00;
    localparam IMM_S = 2'b01;
    localparam IMM_B = 2'b10;
    localparam IMM_J = 2'b11;
    
    //The 32-bit immediate is generated from the instruction based on the instruction type.
    //The instruction type has already been decoded based on the opcode by the control unit.
    //The instruction type is sent by the control unit to this unit as a 2 bit signal.
    assign Imm_Ext = ( ImmSrc == IMM_I ) ? {{20{In[31]}},In[31:20]}                 :   //I-type
                     ( ImmSrc == IMM_S ) ? {{20{In[31]}}, In[31:25], In[11:7]}      :   //S-type
                     ( ImmSrc == IMM_B ) ? {{19{In[31]}}, In[31], In[7], In[30:25], In[11:8], 1'b0} :   //B-type
                     ( ImmSrc == IMM_J ) ? {{11{In[31]}}, In[31], In[19:12], In[20], In[30:21], 1'b0}: //J-type
                                            {32{1'b0}};
    endmodule
