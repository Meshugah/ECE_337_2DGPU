// $Id: $
// File name:   tb_computationalcore.sv
// Created:     12/6/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for computational core wrapper
`timescale 1ns/100ps
module tb_computationalcore();
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
	wire tb_data_ready;
	wire tb_shape_done;
	wire tb_frame_target;
	wire [18:0]tb_address;
	wire [15:0]tb_color;

	computationalcore DUT (
		.clk(tb_clk),
		.n_rst(tb_nrst),
		.data_sent(tb_data_sent),
		.new_shape(tb_new_shape),
		.full_opcode(tb_opcode),
		.data_ready(tb_data_ready),
		.shape_done(tb_shape_done),
		.frame_target(tb_frame_target),
		.address(tb_address),
		.color(tb_color)
	);

initial
begin
	tb_data_sent = 0;
	tb_new_shape = 0;
	tb_opcode = {4'd0, 16'b0000000001100000, 10'd300, 9'd200, 10'd0, 9'd200, 10'd0, 9'd0, 1'b0, 17'd0}; 
	reset_dut();
end
///////////////////////////DUT RESET///////////////////////////
	task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronize with clock)
		tb_nrst = 1'b0;
		
		// Wait for a couple clock cycles
		@(posedge tb_clk);
		@(posedge tb_clk);
		// Release the reset
		tb_nrst = 1;
		
		// Wait for a while before activating the design
		@(posedge tb_clk);
		@(posedge tb_clk);
		@(posedge tb_clk);
	end
	endtask
///////////////////////////////////////////////////////////////
endmodule
