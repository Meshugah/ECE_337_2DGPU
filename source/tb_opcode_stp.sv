//Test Bench for Opcode STP
//Author: Noah Petersen
//Description: Test bench for Opcode STP Just needs to verify that if bits are shifted in a,b,c, they end up
//		displayed at the output as c,b,a if the output pins are defined as 95:0

`timescale 1ns/100ps
module tb_opcode_stp();
	//Clock Variables
	localparam CLK_PERIOD = 50;
	localparam DELAY = 1;
	reg tb_clk;

	//Clock Generation	
	always
	begin: CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	
	//Variable Declarations
	//reg [95:0] tb_opcode;
	reg [31:0] tb_opcode_a; //First Part of Opcode
	reg [31:0] tb_opcode_b; //Second part of Opcode
	reg [31:0] tb_opcode_c; //Last Part of Opcode
	reg tb_nrst;
	reg tb_shift_enable;
	reg [31:0] tb_serial_in;
	int tb_test_case;
	wire [95:0] tb_parallel_out;
	int tb_i;

	//DUT
	opcode_stp DUT
		(
		.clk(tb_clk), 
		.n_rst(tb_nrst), 
		.shift_enable(tb_shift_enable), 
		.serial_in(tb_serial_in), 
		.parallel_out(tb_parallel_out)
	); 
	/*
		parallel_out should end with {C,B,A} if A, B, C are shifted in that order 


	*/



	//Tests
	initial begin


	tb_nrst = 1;
	tb_opcode_c = '0;
	tb_opcode_b = '0;
	tb_opcode_a = '0;
	tb_serial_in = '0;
	tb_shift_enable = 0;

	reset_dut();

	//Test Case 1:
	tb_test_case = 1;

	shift_opcode();

	//Test Case 2:
	tb_test_case = tb_test_case + 1;
	tb_opcode_b = 2;
	tb_opcode_a = 3;
	shift_opcode();

	//Test Case 3:

	for(tb_i = 0; tb_i < 498; tb_i = tb_i + 1) begin
		tb_test_case = tb_test_case + 1;
		tb_opcode_c = $random % 32;
		tb_opcode_b = $random % 32;
		tb_opcode_a = $random % 32;
		shift_opcode();
	end

	end

///////////////////////////DUT RESET///////////////////////////
	task shift_opcode;
	//input reg [31:0]opcode_a;
	//input reg [31:0]opcode_b;
	//input reg [31:0]opcode_c;
	begin
		
		@(posedge tb_clk)
		
		//Set values
		tb_serial_in = tb_opcode_a;

		
		//Perform Shift 1
		shift();
		if(tb_parallel_out[95:64] != tb_opcode_a) begin
			$error("Data incorrect for bits 95:64 after shifting in part 1 of opcode");
		end
		
		//Set values
		tb_serial_in = tb_opcode_b;

		//Perform Shift 2
		shift();
		if(tb_parallel_out[95:64] != tb_opcode_b) begin
			$error("Data incorrect for bits 95:64 after shifting in part 2 of opcode");
		end
		if(tb_parallel_out[63:32] != tb_opcode_a) begin
			$error("Data incorrect for bits 63:32 after shifting in part 2 of opcode");
		end

		//Set values
		tb_serial_in = tb_opcode_c;

		//Perform Shift 3
		shift();


		if(tb_parallel_out[95:64] != tb_opcode_c) begin
			$error("Data incorrect for bits 95:64 after shifting in part 3 of opcode");
		end
		if(tb_parallel_out[63:32] != tb_opcode_b) begin
			$error("Data incorrect for bits 63:32 after shifting in part 3 of opcode");
		end
		if(tb_parallel_out[31:0] != tb_opcode_a) begin
			$error("Data incorrect for bits 31:0 after shifting in part 3 of opcode");
		end
	
		@(posedge tb_clk);
	end
	endtask
///////////////////////////////////////////////////////////////
///////////////////////////DUT RESET///////////////////////////
	task shift;
	begin
		//Wait for negedge
		@(negedge tb_clk);
		
		//Set Shift enable
		tb_shift_enable = 1;

		//Wait for start of next cycle
		@(posedge tb_clk);

		//Wait for middle of cycle, reset shift enable
		@(negedge tb_clk);
		tb_shift_enable = 0;

	end
	endtask
///////////////////////////////////////////////////////////////
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
