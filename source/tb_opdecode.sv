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
	int i;
	opdecode DUT(.opcode(test_in), .shape(shape), .color(test_color), .opdata(outcode));


	
	initial
	begin
		////////////////////////////////////////////////////////
		//Line
		test_in[95:92] = 4'b0000;
		test_in[91:76] = '1;
		test_in[75:57] = '0;
		test_in[56:38] = '1;
		test_in[37:19] = '0;
		test_in[18:0] = '1;
		#1;

		if (shape == test_in[95:92]) begin
			//info("Shape matches!");
		end else begin
			$error("Shape mismatch!");
		end
		#1;

		if (test_color == test_in[91:76]) begin 
			//$info("Color matches!");
		end else begin
			$error("Color mismatch!");
		end

		#1;
		if (outcode[75:19] == test_in[75:19]) begin
			//$info("Opcode data matches!");
		end else begin
			$error("Opcode data mismatch!");
		end
		#1
		////////////////////////////////////////////////////////
		//Triangle
		test_in[95:92] = 4'b0001;
		test_in[91:76] = '0;
		test_in[75:57] = '1;
		test_in[56:38] = '0;
		test_in[37:19] = '1;
		test_in[18:0] = '0;
		#1;
		if (shape == test_in[95:92]) begin
			//info("Shape matches!");
		end else begin
			$error("Shape mismatch!");
		end
		#1;

		if (test_color == test_in[91:76]) begin 
			//$info("Color matches!");
		end else begin
			$error("Color mismatch!");
		end

		#1;
		if (outcode[75:19] == test_in[75:19]) begin
			//$info("Opcode data matches!");
		end else begin
			$error("Opcode data mismatch!");
		end

		#1

		////////////////////////////////////////////////////////
		//Circle
		test_in[95:92] = 4'b0010;
		test_in[91:76] = '1;
		test_in[75:57] = '0;
		test_in[56:38] = '1;
		test_in[37:19] = '0;
		test_in[18:0] = '1;
		#1;

		if (shape == test_in[95:92]) begin
			//info("Shape matches!");
		end else begin
			$error("Shape mismatch!");
		end
		#1;

		if (test_color == test_in[91:76]) begin 
			//$info("Color matches!");
		end else begin
			$error("Color mismatch!");
		end

		#1;
		if (outcode[75:19] == test_in[75:19]) begin
			//$info("Opcode data matches!");
		end else begin
			$error("Opcode data mismatch!");
		end

		#1

		//Pseudo-Random Test Cases
		for(i = 0; i < 450; i++) begin
			if( i < 150) begin
				test_in[95:92] = 4'b0000;
			end else if ( i < 300) begin
				test_in[95:92] = 4'b0001;
			end else begin
				test_in[95:92] = 4'b0010;
			end
		
			test_in[91:76] = $random % 16;
			test_in[75:57] = $random % 19;
			test_in[56:38] = $random % 19;
			test_in[37:19] = $random % 19;
			test_in[18:0] = $random % 19;
			#1;

			if (shape == test_in[95:92]) begin
				//$info("Shape matches!");
			end else begin
				$error("Shape mismatch!");
			end
			#1;

			if (test_color == test_in[91:76]) begin
				//$info("Color matches!");
			end else begin
				$error("Color mismatch!");
			end

			#1;
			
			if (outcode[75:19] == test_in[75:19]) begin
				//$info("Opcode data matches!");
			end else begin
				$error("Opcode data mismatch!");
			end

			//#1;
		end
	
	end
endmodule
