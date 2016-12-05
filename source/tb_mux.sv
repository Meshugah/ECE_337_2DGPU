// $Id: $
// File name:   tb_splitter.sv
// Created:     11/28/2016
// Author:      Noah Petersen
// Lab Section: 337-03
// Version:     1.1  Mostly Test Bench
// Description: Test bench for [31:0] 2x1 Mux

`timescale 1ns/100ps
module tb_mux();

/////////////////////////////////////////////////////////////
//Clock
/////////////////////////////////////////////////////////////
	localparam CLK_PERIOD = 10;
	localparam DELAY = 1;

	reg tb_clk;

	always
	begin: CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

/////////////////////////////////////////////////////////////
//Test Bench Variables & Setup
/////////////////////////////////////////////////////////////
reg [31:0] tb_a;
reg [31:0] tb_b;
reg tb_sel;
wire [31:0] tb_data;

//DUT
mux DUT (
	.a(tb_a),
	.b(tb_b),
	.sel(tb_sel),
	.data(tb_data)
);


/*/////////////////////////////////////////////////////////////
	Testing
*//////////////////////////////////////////////////////////////
initial begin
	tb_a = '0;
	tb_b = '1;
	tb_sel = 1'b0;

	@(posedge tb_clk);
	checkoutput;
	@(posedge tb_clk);
	
	tb_sel = 1'b1;

	@(posedge tb_clk);
	checkoutput;
	@(posedge tb_clk);
	@(negedge tb_clk);
	

	tb_a = '1;
	tb_b = '0;
	tb_sel = 1'b0;

	@(posedge tb_clk);
	checkoutput;
	@(posedge tb_clk);
	
	tb_sel = 1'b1;

	@(posedge tb_clk);
	checkoutput;
	@(posedge tb_clk);

end

/////////////////////////////BLANK/////////////////////////////
	task checkoutput;
	begin
		@(negedge tb_clk);
		//Insert Statements
		if((tb_sel = 1'b0) && (tb_data == tb_b)) begin
			$display("Correct Output");
		end else if((tb_sel = 1'b0) && (tb_data == tb_b)) begin
			$display("Correct Output");
		end else begin
			$error("Incorrect output");
		end
	end
	endtask
///////////////////////////////////////////////////////////////

endmodule
