/* deocode_testtop.sv
  This module will provide a streamlined (not a comprehensive) validation
  for `decode.sv` this CPU's instruction decoder. It will read the test vectors
  provided in ./decode_vectors.txt, where each vector has 1 of 32 asserted.

  This approach will check that the single asserted bit shows up on outputs
  where it should.
  **Note: This testing approach is not own, original thought.

  For example,
    instr[31:0]  0b1000 0000 0000 0000 0000 0000 0000 0000
  should yield...
    funct7[6:0] 0b100 0000

  Written by: Austin J. Staton
  Date: Oct. 18th, 2020
*/
module decode_testtop;
    // Inputs
    logic  [31:0] instr;
    logic  [6:0]  funct7;
    logic  [4:0]  rs2;
    logic  [4:0]  rs1;
    logic  [2:0]  funct3;
    logic  [4:0]  rd;
    logic  [6:0]  opcode;
    logic  [11:0] imm_i;
    logic  [19:0] imm_u;

    decode dut (    .instr(instr),
                    .funct7(funct7),
                    .rs2(rs2),
                    .rs1(rs1),
                    .funct3(funct3),
                    .rd(rd),
                    .opcode(opcode),
                    .imm_i(imm_i),
                    .imm_u(imm_u));
                    
    // Go get values for test vectors.
    // Width[]   Depth[]
    logic [95:0] testvectors [31:0]; 
    initial $readmemb("testbench/decode_vectors.txt", testvectors);
    

    // Drive test vectors in DUT; vaildate the DUT's results.
    integer i;
    initial begin
        #10;
        for (i=0;i<32;i=i+1) begin
            instr = testvectors[i][95:64];
            // Check if we've read past the last vector
            if (instr===32'bX) begin
                $display("input in unknown state");
                $finish();
            end

            #10; // Wait for the output to propogate (This MUST be added)
            
            if (funct7!==testvectors[i][63:57]) begin
                $display("funct7 vector %0d failed at time %0t. expected=%0b, actual=%0b",
                     i, $time, testvectors[i][63:57], funct7);

            end else if (rs2!==testvectors[i][56:52]) begin
                $display("rs2 vector %0d failed at time %0t. expected=%0b, actual=%0b",
                     i, $time, testvectors[i][56:52], rs2);

            end else if (rs1!==testvectors[i][51:47]) begin
                $display("rs1 vector %0d failed at time %0t. expected=%0b, actual=%0b",
                     i, $time, testvectors[i][51:47], rs1);

            end else if (funct3!==testvectors[i][46:44]) begin
                $display("funct3 vector %0d failed at time %0t. expected=%0b, actual=%0b",
                     i, $time, testvectors[i][46:44], funct3);

            end else if (rd!==testvectors[i][43:39]) begin
                $display("rd vector %0d failed at time %0t. expected=%0b, actual=%0b",
                     i, $time, testvectors[i][43:39], rd);

            end else if (opcode!==testvectors[i][38:32]) begin
                $display("opcode vector %0d failed at time %0t. expected=%0b, actual=%0b",
                     i, $time, testvectors[i][38:32], opcode);
                     
            end else if (imm_i!==testvectors[i][31:20]) begin
                $display("imm_i vector %0d failed at time %0t. expected=%0b, actual=%0b",
                     i, $time, testvectors[i][31:20], imm_i);

            end else if (imm_u!==testvectors[i][19:0]) begin
                $display("imm_u vector %0d failed at time %0t. expected=%0b, actual=%0b",
                     i, $time, testvectors[i][19:0], imm_u);

            end  else begin 
                $display("vector %0d passed at time %0t.", i, $time);
            end
            
        end
    end
endmodule
