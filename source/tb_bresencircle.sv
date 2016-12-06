// $Id: $
// File name:   tb_bresencircle.sv
// Created:     12/5/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for bresenham's circle
`timescale 1ns/100ps
module tb_bresencircle();
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
	reg [37:0]tb_positions;
	reg [18:0]tb_address;
	reg [18:0]old_address;
	reg tb_primSelect;
	reg tb_circDone;
	reg tb_stop;

	reg r,c,num_cols,num_rows;
	integer i,j,f;

	bresencircle DUT ( 
		.clk(tb_clk),
		.n_rst(tb_nrst),
		.positions(tb_positions),
		.address(tb_address),
		.primSelect(tb_primSelect),
		.circleDone(tb_circDone)
	);
	task writeToFile;
	begin
		f = $fopen("output.txt", "w");
		for (i = 0; i < 640; i++) begin
			for (j = 0; j < 480; j++) begin
			old_address = tb_address;
			@(posedge tb_clk);
			if (tb_circDone == 1) begin
				i = 640; j = 480;
			end
			$fdisplay(f, "%b", tb_address);
		end end
		$fclose(f);
	end
	endtask
initial
	begin
		@(posedge tb_clk);
		tb_nrst = 0;
		@(negedge tb_clk);
		tb_nrst = 1;
		@(posedge tb_clk);
		tb_positions = 38'b01010000000111100000001111110000000000;
		@(posedge tb_clk);
		@(posedge tb_clk);
		@(negedge tb_clk);
		tb_primSelect = 1;
		@(negedge tb_clk);
		tb_primSelect = 0;
		@(posedge tb_clk);
		tb_primSelect = 1;
		writeToFile;
		#1000;
	end
endmodule

		
