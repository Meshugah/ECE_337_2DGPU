// $Id: $
// File name:   tb_splitter.sv
// Created:     11/28/2016
// Author:      Ahmad dit Ziad Dannawi, Noah Petersen
// Lab Section: 337-03
// Version:     1.1  Fairly complete Test Bench
// Description: Test bench for splitter. Uses iterated pseudo-random opcodes to test splitter.
//		Could also add more targeted test cases, but as it is every shape is tested,
//		and the actual locations data is relatively inconsequential as long as it 
//		matches the expected.

`timescale 1ns/100ps
module tb_splitter();
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

typedef enum bit [3:0] {
		LINE 		= 4'b0000,
		TRIANGLE 	= 4'b0001,
		CIRCLE	 	= 4'b0010
			}ShapeType;

	//Test Bench variables
	int i;


	//Opcode Input declarations
	ShapeType op_shape;
	reg [15:0] op_color;
	reg [18:0] op_location1;
	reg [18:0] op_location2;
	reg [18:0] op_location3;
	reg op_fill;

	//reg [18:0] exp_location;
	//reg [18:0] exp_color

	//TB Variables
	reg tb_nrst;
	reg [3:0]tb_shape;
	reg [73:0]tb_opcode; 
	wire [15:0]tb_test_color;
	wire [37:0]tb_locations;

	splitter DUT (
		.opdata(tb_opcode),
		.output_sel(tb_shape),
		.locations(tb_locations),
		.color(tb_test_color)
	);

/*/////////////////////////////////////////////////////////////
	Testing
*//////////////////////////////////////////////////////////////
	initial
		begin
		reset_dut;
	
		//Initial Variable Settings'
		op_color = 0;
		op_location1 = 0;
		op_location2 = 0;
		op_location3 = 0;
		op_fill = 0;

		//Pseudo Random Tests
		for(i = 0; i < 1000; i++) begin

			//Set Opcode & Expected Values
			op_color = $random % 16;
			op_location1 = $random % 19;
			op_location2 = $random % 19;
			op_location3 = $random % 19;
			op_fill = 0;

			//Shape Selection
			if((i % 3) == 0) begin
				//Line Test
				op_shape = LINE;
			end else if((i % 3) == 1) begin
				//Triangle Test -> Slightly different because there are 3 phases to check
				op_shape = TRIANGLE;
			end else if((i % 3) == 2) begin
				//Circle Test
				op_shape = CIRCLE;
			end

			//Apply Opcode
			tb_opcode = {op_color, op_location1, op_location2, op_location3, op_fill};
			@(posedge tb_clk)

			//$display("Checking outputs for pseudo-random test case #%0d", i);
			//Check Outputs
			if((i % 3) == 0) begin
				//Line Test
				tb_shape = 4'b0000;

				@(posedge tb_clk);

				if(tb_locations == {op_location1,op_location2}) begin
					//$display("Line is printed correctly");
				end else begin
					$error("Error, line locations output is incorrect on pseudo random test case #%0d",i);
				end
				@(posedge tb_clk);


			end else if((i % 3) == 1) begin
				//Triangle Test -> Slightly different because there are 3 phases to check
				//Check Line 1
				tb_shape = 4'b0001;
	
				@(posedge tb_clk);

				if(tb_locations == {op_location1,op_location2}) begin
					//$display("Line is printed correctly");
				end else begin
					$error("Error, triangle line 1 locations output is incorrect on pseudo random test case #%0d",i);
				end

				//Check Line 2
				tb_shape = 4'b0010;
		
				@(posedge tb_clk);
			
				if(tb_locations == {op_location1,op_location3}) begin
					//$display("Line is printed correctly");
				end else begin
					$error("Error, triangle line 2 locations output is incorrect on pseudo random test case #%0d",i);
				end
		
				//Check Line 3
				tb_shape = 4'b0011;

				@(posedge tb_clk);

				if(tb_locations == {op_location2,op_location3}) begin
					//$display("Line is printed correctly");
				end else begin
					$error("Error, triangle line 3 locations output is incorrect on pseudo random test case #%0d",i);
				end
				@(posedge tb_clk);


			end else if((i % 3) == 2) begin
				//Circle Test
				tb_shape = 4'b0100;
				@(posedge tb_clk);
				//Check Center/Radius
				if(tb_locations == {op_location1,op_location2}) begin
					//$display("Line is printed correctly");
				end else begin
					$error("Error, circle locations output is incorrect on pseudo random test case #%0d",i);
				end
				@(posedge tb_clk);
			end

			if(tb_test_color == op_color) begin
			end else begin
				$error("Color was wrong on test #%0d",i);
			end
		end
	end

/*/////////////////////////////////////////////////////////////
	Tasks
*//////////////////////////////////////////////////////////////

/////////////////////////////BLANK/////////////////////////////
	task template;
	begin
		//Insert Statements
	end
	endtask
///////////////////////////////////////////////////////////////
/*
localparam LL1 = 4'b0000;
localparam TL1 = 4'b0001;
localparam TL2 = 4'b0010;
localparam TL3 = 4'b0011;
localparam CA1 = 4'b0100;
*/

///////////////////////////DUT RESET///////////////////////////
	task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronize with clock)
		tb_nrst = 1'b0;
		
		// Wait for a couple clock cycles
		@(posedge tb_clk);
		@(posedge tb_clk);
		
		// Release the reset
		@(negedge tb_clk);
		tb_nrst = 1;
		
		// Wait for a while before activating the design
		@(posedge tb_clk);
		@(posedge tb_clk);
	end
	endtask
///////////////////////////////////////////////////////////////

endmodule
		
