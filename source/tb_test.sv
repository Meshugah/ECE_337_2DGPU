// $Id: $
// File name:   tb_test.sv
// Created:     11/16/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: test bench for test file
`timescale 1ns/100ps

module tb_test ();

	reg test_input;
	reg test_output;

	test DUT (.i(test_input), .o(test_output));

	initial
	begin
		test_input = 0;
		if (test_output == 1)
			$info("Test case passed.");
		else
			$error("Test case failed.");
		test_input = 1;
		if (test_output == 0)
			$info("Test case passed.");
		else
			$error("Test case failed.");
	end
endmodule

