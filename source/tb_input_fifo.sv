// $Id: $
// File name:   tb_input_fifo.sv
// Created:     12/2/2016
// Author:      Vignesh Karthikeyan
// Lab Section: 337-07
// Version:     1.0  Initial Design Entry
// Description: test bench for the mentioned
`timescale 1ns / 10ps

module tb_input_fifo();
	localparam CLK_PERIOD = 10; //this?
	reg tb_clk;
	reg tb_n_rst;
	reg tb_r_enable;
	reg tb_w_enable;
	reg [95:0] tb_w_data;
	reg [95:0] tb_r_data;
	reg tb_empty;
	reg tb_full;
	infif DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.r_enable(tb_r_enable),
		.w_enable(tb_w_enable),
		.w_data(tb_w_data),
		.r_data(tb_r_data),
		.empty(tb_empty),
		.full(tb_full)
	);
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	initial
	begin
		tb_n_rst = 1'b0;
		#CLK_PERIOD
		tb_n_rst = 1'b1;
		//Test 1
		tb_r_enable = 1'b0;
		tb_w_enable = 1'b1;
		tb_w_data = '1;
		#CLK_PERIOD
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#CLK_PERIOD
		tb_r_enable = 1'b0;
		#CLK_PERIOD


		//Test 2
		tb_w_enable = 1'b1;
		tb_w_data = '1;
		#CLK_PERIOD
		tb_w_enable = 1'b0;
		#CLK_PERIOD
		
		tb_w_enable = 1'b1;
		tb_w_data = '1;
		#CLK_PERIOD
		tb_w_enable = 1'b0;
		#CLK_PERIOD
		
		tb_w_enable = 1'b1;
		tb_w_data = '1;
		#CLK_PERIOD
		tb_w_enable = 1'b0;
		#CLK_PERIOD
		
		tb_w_enable = 1'b1;
		tb_w_data = '1;
		#CLK_PERIOD
		tb_w_enable = 1'b0;
		#CLK_PERIOD
		
		$info("fifo should be all 1, so this should be one %d",tb_full);
		
		tb_r_enable = 1'b1;
		#CLK_PERIOD
		tb_r_enable = 1'b0;
		#CLK_PERIOD
		tb_r_enable = 1'b1;
		#CLK_PERIOD
		tb_r_enable = 1'b0;
		#CLK_PERIOD
		tb_r_enable = 1'b1;
		#CLK_PERIOD
		tb_r_enable = 1'b0;
		#CLK_PERIOD
		tb_r_enable = 1'b1;
		#CLK_PERIOD
		tb_r_enable = 1'b0;
		#CLK_PERIOD
		tb_r_enable = 1'b1;
		#CLK_PERIOD
		tb_r_enable = 1'b0;
		#CLK_PERIOD
		$info("must be empty %d",tb_empty);
		
		tb_w_enable = 1;
		tb_w_data = 96'b1111111110111111111011111111101111111110111111111011111111101111111110111111111011111111101111111110111111;
		#CLK_PERIOD
		tb_w_enable = 1'b0;
		#CLK_PERIOD
		
		tb_r_enable = 1'b1;
		#CLK_PERIOD
		tb_r_enable = 1'b0;
		#CLK_PERIOD
		
		if(tb_r_data != 96'b1111111110111111111011111111101111111110111111111011111111101111111110111111111011111111101111111110111111)
			$display("lol, fail");
	end
endmodule
