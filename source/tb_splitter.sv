// $Id: $
// File name:   tb_splitter.sv
// Created:     11/28/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for splitter
`timescale 1ns/100ps
module tb_splitter();
	localparam CLK_PERIOD = 30;
	localparam DELAY = 1;

	reg tb_clk;

	always
	begin: CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	reg tb_nrst;
	reg tb_read;
	reg [75:0]tb_opcode;
	reg [3:0]tb_shape;
	reg [15:0]tb_test_color;
	reg [37:0]tb_locations;

	splitter DUT (.clk(tb_clk), 
		.n_rst(tb_nrst),
		.opdata(tb_opcode),
		.output_sel(tb_shape),
		.read(tb_read),
		.locations(tb_locations),
		.color(tb_test_color)
	);

initial
	begin
		tb_opcode = 0;
		tb_opcode[75:38] = 38'b0000000110000001001000010000001000101;
		tb_shape = 4'b0000;
		@(posedge tb_clk);
		@(posedge tb_clk);
		@(posedge tb_clk);
	end	
endmodule
		
