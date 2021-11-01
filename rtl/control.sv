/* control.sv
  The control unit for the RISC-V CPU. This module will take in the
  fields of each instruction (from the instruction decoder) and assert
  various control lines depending on their values.

  Written by: Austin Staton
  Date: Oct. 19th, 2020
*/
module control (input  logic [6:0] funct7,
                input  logic [2:0] funct3,
                input  logic [6:0] opcode,
                input  logic [11:0] csr,
                
                output logic [3:0] aluop,
                output logic [1:0] regsel,
                output logic alusrc, regwe, hexwe);

always_comb begin

    // Default databus values.
    aluop = 4'h0;
    regsel = 2'b01;
    regwe = 1'b0;
    alusrc = 1'b0;
    hexwe = 1'b0;

    // Cases by Instruction Type
    if (opcode == 7'h33) begin // R-Type instructions.
        // R-types should simply operate on the two register values and write back.
        regwe = 1'b1;
        alusrc = 1'b0; // 0 will indicate a register src by default.
        regsel = 2'b10;        

        if      (funct3 == 3'b000 && funct7 == 7'h00) aluop = 4'b0011; // add
        else if (funct3 == 3'b000 && funct7 == 7'h20) aluop = 4'b0100; // sub
        else if (funct3 == 3'b111 && funct7 == 7'h00) aluop = 4'b0000; // and
        else if (funct3 == 3'b110 && funct7 == 7'h00) aluop = 4'b0001; // or
        else if (funct3 == 3'b100 && funct7 == 7'h00) aluop = 4'b0010; // xor
        else if (funct3 == 3'b001 && funct7 == 7'h00) aluop = 4'b1000; // sll
        else if (funct3 == 3'b101 && funct7 == 7'h20) aluop = 4'b1010; // sra
        else if (funct3 == 3'b101 && funct7 == 7'h00) aluop = 4'b1001; // srl

        else if (funct3 == 3'b010 && funct7 == 7'h00) aluop = 4'b1100; // slt 
        else if (funct3 == 3'b011 && funct7 == 7'h00) aluop = 4'b1101; // sltu 
        else if (funct3 == 3'b000 && funct7 == 7'h01) aluop = 4'b0101; // mul
        else if (funct3 == 3'b001 && funct7 == 7'h01) aluop = 4'b0110; // mulh
        else if (funct3 == 3'b011 && funct7 == 7'h01) aluop = 4'b0111; // mulhu
        else                                          aluop = 4'b0111; // default will be mulhu

    end else if (opcode == 7'h13) begin // I-Type instructions.
        regwe = 1'b1;
        regsel = 2'b10;
        alusrc = 1'b1; // Use the immediate, not register.
        if      (funct3 == 3'b000)                    aluop = 4'b0011; // addi
        else if (funct3 == 3'b111)                    aluop = 4'b0000; // andi
        else if (funct3 == 3'b110)                    aluop = 4'b0001; // ori
        else if (funct3 == 3'b001 && funct7 == 7'h00) aluop = 4'b1000; // slli
        else if (funct3 == 3'b100)                    aluop = 4'b0010; // xori
        else if (funct3 == 3'b101 && funct7 == 7'h20) aluop = 4'b1010; // srai
        else if (funct3 == 3'b101 && funct7 == 7'h00) aluop = 4'b1001; // srli

        
    end else if (opcode == 7'h37) begin // U-Type instructions.
        alusrc = 1'b1;
        aluop = 4'b0000; 
        regwe = 1'b1;
        regsel = 2'b01; // Use the imm_u value.

    end else if (opcode == 7'h73 && funct3 == 3'b001) begin // CSRRW
        regsel = 2'b00;
        if (csr == 12'hf02) begin // HEX (io2)
            hexwe = 1'b1;
        end else begin // SW (io0)
            regwe = 1'b1;
            regsel = 2'b0;
        end
    end
end

endmodule
