/*  decode.sv
    This module will take in a 32-bit RISC-V instruction, then separate the
    word into its appropriate components. Not all outputs will be used,
    depending on the type of instruction.

    This will account for the 'R', 'I' , and 'U' RISC-V instructions.

    Written by: Austin J. Staton
    Date: Oct. 15th, 2020
*/
module decode(input [31:0]  instr, 
            
              output  [6:0] funct7,
              output  [4:0] rs2,
              output  [4:0] rs1,
              output  [2:0] funct3,
              output  [4:0] rd,
              output  [6:0] opcode,
              output [11:0] imm_i,
              output [19:0] imm_u);

    // General outputs.
    assign rd = {instr[11:7]};
    assign opcode = {instr[6:0]};

    // R-Type specific outputs. 
    assign funct7 = {instr[31:25]};
    assign rs2 = {instr[24:20]};
    assign rs1 = {instr[19:15]};
    assign funct3 = {instr[14:12]};
    
    // I-Type specific outputs.
    assign imm_i = {instr[31:20]};
    
    // U-Type specific outputs.
    assign imm_u = {instr[31:12]};

endmodule