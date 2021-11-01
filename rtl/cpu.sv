/* cpu.sv
  This file will tie together all of the CPU components. This will be done in a
  three stage pipeline. A value named:
    *_F  is associated with the first stage, FETCH
    *_EX is associated with the middle stage, EXECUTE (& DECODE & MEMORY)
    *_WB is associated with WRITE BACK

  Written by: Austin Staton
  Date: October 20th, 2020
*/
module cpu (
    input  logic        clk,
    input  logic        rst,
    input  logic [17:0] io0, 

    output logic [31:0] result,
    output logic [31:0] hexes 
);

    logic  [31:0] instruction_mem [4095:0];

    /*       ---DATA BUS SIGNALS---       */ 
    /* Instruction Mem */
    logic  [31:0] instr_EX;
    logic  [11:0] PC_F;

    /* Instruction Decoder */
    logic   [6:0] funct7_EX;
    logic   [4:0] rs2_EX;
    logic   [4:0] rs1_EX;
    logic   [2:0] funct3_EX;
    logic   [4:0] rd_EX;
    logic   [6:0] opcode_EX;
    logic  [11:0] imm_i_EX;
    logic  [19:0] imm_u_EX, imm_u_WB;


    /* Control Unit */
    logic   [3:0] aluop_EX;
    logic   [1:0] regsel_EX, regsel_WB;
    logic         alusrc_EX, regwe_EX, hexwe_EX,
                  regwe_WB, hexwe_WB;
    // logic  [31:0] reg_to_mux_EX;
    

    /* Register File */
    logic [31:0] writedata_EX, writedata_WB;
    logic [4:0] regdest_WB;
    logic [31:0] readdata2_EX;

 
    /* ALU */
    logic  [31:0] A_EX, B_EX, R_EX;
    logic  [31:0] R_WB;

    logic [17:0] io0_WB;

    /* Component / Module Connections */
    decode instr_decode(.instr(instr_EX), .funct7(funct7_EX), .rs2(rs2_EX),
                        .rs1(rs1_EX), .funct3(funct3_EX), .rd(rd_EX), 
                        .opcode(opcode_EX), .imm_i(imm_i_EX), .imm_u(imm_u_EX));
    
    control control_unit(.funct7(funct7_EX), .funct3(funct3_EX),
                         .opcode(opcode_EX), .csr(imm_i_EX),
                         .aluop(aluop_EX), .regsel(regsel_EX),
                         .alusrc(alusrc_EX), .regwe(regwe_EX),
                         .hexwe(hexwe_EX));

    regfile32x32 ref_file(.we(regwe_WB), .clk(clk), .readaddr1(rs1_EX),
                          .readaddr2(rs2_EX), .writeaddr(regdest_WB),
                          .readdata1(A_EX), .readdata2(readdata2_EX), 
                          .writedata(writedata_WB));

    alu alu(.A(A_EX), .B(B_EX), .op(aluop_EX), .R(R_EX));


    initial begin
        $readmemh("program.rom", instruction_mem, 0, 1023);
    end
 
    /* INSTRUCTION FETCH */
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            instr_EX <= 32'b0; // ADDI 0x, 0x, 0
            PC_F <= 12'b0;
            // rd_EX <= 5'b0;
        end else begin
            // Fetch
            instr_EX <= instruction_mem[PC_F];
            PC_F <= PC_F + 12'b1;
        end
    end

    /* DECODE | MEMORY | EXECUTE */
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            regwe_WB <= 1'b0;
            regsel_WB <= 2'b0;
            R_WB <= 32'b0;
            imm_u_WB <= 20'b0;
            io0_WB <= 18'b0;
        end else begin
            regwe_WB <= regwe_EX;
            regsel_WB <= regsel_EX;
            R_WB <= R_EX;
            imm_u_WB <= imm_u_EX;
            io0_WB <= io0;
            regdest_WB <= rd_EX;
            hexwe_WB <= hexwe_EX;
        end
    end

    /*  MULTIPLEXERS */
    // Mux to the ALU input for immediates.
    /* verilator lint_off WIDTH */
    always_comb begin
        // The immediate needs to be sext-ed from 12 to 32 bits.
        if  (alusrc_EX) begin
            if (imm_i_EX[11]) B_EX = {20'hfffff, imm_i_EX};
            else B_EX = {20'h00000, imm_i_EX};
        end 
        else B_EX = readdata2_EX;
    end

    // WRITEBACK | Mux for the result of the CPU.
    // **Note: I adjusted the widths here.
    always_comb begin
        if (regsel_WB == 2'b00) begin
            writedata_WB = {14'b0, io0_WB}; // SWITCH IN 
        end 
        else if (regsel_WB == 2'b01) writedata_WB = {imm_u_WB, 12'b0}; // IMMEDIATE 
        else writedata_WB = R_WB; // ALU
    end

    // Handles `csrrw x0 io2 rs1`
    always_comb begin
        if (hexwe_EX) hexes = A_EX; // Grad the value fo rs1.
    end

    /* veriltor lint_on WIDTH */
endmodule
