/* hex_testtop.sv
  
  A testbench for `hexdecoder.sv`, which maps a 0-15 binary value
  to a control signal for seven-segment displays.

  Reads from 'testbench/vectors_hex.txt', where data is in format:
  {10:7}  {6:0}
  {input} {expected output} 

  Written by: Austin Staton, with module frame given in course materials
  Date: Sept. 20th, 2020
*/
module hex_testtop;
    logic [3:0] number;
    logic [6:0] ss_display; // Seven segment display control.

    hex dut (.in(number),
                    .out(ss_display));
                    
    // Go get values for test vectors.
    logic [10:0] testvectors [15:0]; 
    initial $readmemb("testbench/hex_vectors.txt", testvectors);
    

    // Drive test vectors in DUT; vaildate the DUT's results.
    integer i;
    initial begin
        #10;
        for (i=0;i<16;i=i+1) begin
            number = testvectors[i][10:7];
            // Check if we've read past the last vector
            if (number===4'bX) begin
                $display("input in unknown state");
                $finish();
            end
            #10; // Wait for the output to propogate (This MUST be added)
            if (ss_display!==testvectors[i][6:0]) begin
                $display("vector %0d failed at time %0t. expected=%0b, actual=%0b",
                     i, $time, testvectors[i][6:0], ss_display);
            end else begin 
                $display("vector %0d passed at time %0t.", i, $time);
            end
        end
    end
endmodule
