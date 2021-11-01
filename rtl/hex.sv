/* file: hex.sv
Turns a number, from 0-F, into it's appropriate lighting scheme
on a seven-segment display. If a OOB number is given, the display
will show 3 bars.

Note: This seven-segment display is active low.

Written by: Austin Staton, with module inputs/outputs given in course frame.
Date: September 19th, 2020
*/
module hex(input [3:0] in,
           output logic [6:0] out);

    always_comb begin

        out = 7'b0110110;  // Display a non-number by default.

        if (in == 4'h0) out = 7'b1000000;      // 0
        else if (in == 4'h1) out = 7'b1111001; // 1
        else if (in == 4'h2) out = 7'b0100100; // 2
        else if (in == 4'h3) out = 7'b0110000; // 3
        else if (in == 4'h4) out = 7'b0011001; // 4
        else if (in == 4'h5) out = 7'b0010010; // 5
        else if (in == 4'h6) out = 7'b0000010; // 6
        else if (in == 4'h7) out = 7'b1111000; // 7
        else if (in == 4'h8) out = 7'b0000000; // 8 
        else if (in == 4'h9) out = 7'b0011000; // 9
        else if (in == 4'hA) out = 7'b0001000; // A (10)
        else if (in == 4'hB) out = 7'b0000011; // b (11)
        else if (in == 4'hC) out = 7'b1000110; // C (12)
        else if (in == 4'hD) out = 7'b0100001; // d (13)
        else if (in == 4'hE) out = 7'b0000110; // E (14)
        else if (in == 4'hF) out = 7'b0001110; // F (15)

    end

endmodule
