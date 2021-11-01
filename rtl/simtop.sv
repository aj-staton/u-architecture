/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

/* Edited by: Austin Staton, for use in CSCE 611. */

module simtop (
	//////////// CLOCK //////////
	input                                   CLOCK_50,
	input                                   CLOCK2_50,
    input                                   CLOCK3_50,

	//////////// LED //////////
	output               [8:0]              LEDG,
	output              [17:0]              LEDR,

	//////////// KEY //////////
	input                [3:0]              KEY,

	//////////// SW //////////
	input               [17:0]              SW,

	//////////// SEG7 //////////
	output               [6:0]              HEX0,
	output               [6:0]              HEX1,
	output               [6:0]              HEX2,
	output               [6:0]              HEX3,
	output               [6:0]              HEX4,
	output               [6:0]              HEX5,
	output               [6:0]              HEX6,
	output               [6:0]              HEX7

);

logic [31:0] result;
logic [31:0] hexes_loc;

cpu cpu(.clk(CLOCK_50), .rst(KEY[3]), .io0(SW), .result(result), .hexes(hexes_loc));

hex hex0(.in(hexes_loc[3:0]), .out(HEX0));
hex hex1(.in(hexes_loc[7:4]), .out(HEX1));
hex hex2(.in(hexes_loc[11:8]), .out(HEX2));
hex hex3(.in(hexes_loc[15:12]), .out(HEX3));
hex hex4(.in(hexes_loc[19:16]), .out(HEX4));
hex hex5(.in(hexes_loc[23:20]), .out(HEX5));
hex hex6(.in(hexes_loc[27:24]), .out(HEX6));
hex hex7(.in(hexes_loc[31:28]), .out(HEX7));

endmodule
