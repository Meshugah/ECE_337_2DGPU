// $Id: $
// File name:   tb_computationalcore.sv
// Created:     12/6/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for computational core wrapper
`timescale 1ns/100ps
module tb_bresenline();
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
	reg [95:0]tb_opcode;
	reg tb_data_sent;
	reg tb_new_shape;
	reg tb_data_ready;
	reg tb_shape_done;
	reg tb_frame_target;
	reg [18:0]tb_address;
	reg [15:0]tb_color;

	ComputationalCore DUT (
		.clk(tb_clk),
		.n_rst(tb_nrst),
		.data_sent(tb_data_sent),
		.new_shape(tb_new_shape),
		.full_opcode(tb_opcode),
		.data_ready(tb_data_ready),
		.shape_done(tb_shape_done),
		.frame_target(tb_frame_target),
		.address(tb_address),
		.color(tb_address)
	);

initial
begin
	@(posedge tb_clk);
	tb_nrst = 0;
	@(posedge tb_clk);
	tb_nrst = 1;
	
end
endmodule
