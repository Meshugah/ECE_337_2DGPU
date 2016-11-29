// $Id: $
// File name:   tb_opdecode.sv
// Created:     11/22/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for opcode decoder
`timescale 1ns/100ps
module tb_opdecode();
	reg [95:0]test_in;
	reg [3:0]shape;
	reg [15:0]test_color;
	reg [75:0]outcode;

	opcodeDecoder DUT (.opcode(test_in), .shape(shape), .color(test_color), .opdata(outcode));

	initial
	begin
		test_in[95:92] = 4'b1010;
		test_in[91:76] = 16'b0000100000100001;
		test_in[75:57] = 19'b0000100001000100001;
		test_in[56:38] = 19'b0001000010001000010;
		test_in[37:19] = 0;
		test_in[18:0] = 0;
		#1;

		if (shape == 4'b1010)
			$info("Shape matches!");
		else
			$error("Shape mismatch!");
		#1;

		if (test_color == 16'b0000100000100001)
			$info("Color matches!");
		else
			$error("Color mismatch!");
		#1;
		if (outcode[75:19] == test_in[75:19])
			$info("Opcode data matches!");
		else
			$error("Opcode data mismatch!");

	end
endmodule
