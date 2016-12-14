// $Id: $
// File name:   tb_bresenline.sv
// Created:     11/29/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for bresenham's line generator.


//TESTING INSTRUCTIONS:
//Step 1: Uncomment one and only one desired test case or preferably:
//Step 1a: Modify position values in given test case as such {startX,startY,endX,endY} where X is between 0 and 640 and y is between 0 and 480.
//Step 2: Simulate to completion.
//Note: If successful, a populated 'output.txt' file will be generated.
//Step 3: Run the python address script with the following command:
//          python3.4 addressparse.py
//Step4: Observe resulting image
`timescale 1ns/100ps
module tb_bresenline();
	localparam CLK_PERIOD = 50;
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
	reg tb_lineDone;
	reg tb_stop;
	reg [8:0][9:0]img_buff = 0;

	reg r, c, num_cols, num_rows;
	integer i,j,f;

	bresenline DUT (.clk(tb_clk),
		.n_rst(tb_nrst),
		.positions(tb_positions),
		.address(tb_address),
		.lineDone(tb_lineDone),
		.primSelect(tb_primSelect),
		.stop(tb_stop)
	);

	task print_buffer;
		input [8:0][9:0]img_buff;
	begin
		f = $fopen("output.txt", "w");
		for (r = 0; r < 480; r = r + 1)
		begin
			for (c = 0; c < 640; c = c + 1)
			begin
				$fwrite(f,"%c", img_buff[r][c]);
			end
			$fwrite(f,"\n");
		end
	end
	endtask

	task initialize_buffer;
		input [8:0][9:0]img_buff;
	begin
		for (r = 0; r < 480; r = r + 1)
		begin
			for (c = 0; c < 640; c = c + 1)
			begin
				img_buff[r][c] = 0;
			end
		end
	end
	endtask

	task writeToFile;
	begin
		f = $fopen("output.txt", "w");
		for (i = 0; i < 640; i++) begin
			for (j = 0; j < 480; j++) begin
			@(posedge tb_clk);
			if (tb_lineDone == 1) begin
				i = 640; j = 480;
			end
			$fdisplay(f, "%b", tb_address);
		end end
		$fclose(f);
	end
	endtask
	
initial
	begin
		//f = $fopen("output.txt","w"); //Get file pointer
/*
	//Test case 1: positive slope 
		tb_positions = 38'b00100100000001000110000100110001100001;
		tb_nrst = 0;
		@(posedge tb_clk);
		tb_nrst = 1;
		@(negedge tb_clk);
		tb_primSelect = 1;
		@(posedge tb_clk);
		tb_primSelect = 0;
		for (i = 0; i < 640; i++) begin
			for (j = 0; j < 480; j++) begin
			old_address = tb_address;
			@(posedge tb_clk);
			if (old_address == tb_address) begin
				i = 640; j = 480;
			end
			$fdisplay(f, "%b", tb_address);
		end end
		#15000;
		$fclose(f);
/*
	//Test case 2: negative slope
		tb_positions = 38'b00000000000000000000000011110000001111;
		@(negedge tb_clk);
		tb_primSelect = 1;
		@(posedge tb_clk);
		tb_primSelect = 0;

		#12000;
*/
	//Test case 3: worst case negative slope (0,0) -> (640,480)

		tb_positions = {10'd640, 9'd0, 10'd0, 9'd480}; //If desired, one can modify these values to test whichever line they wish. {10'd<0-640>, 9'd<0-480>}, and so on
		tb_nrst = 0;
		tb_primSelect = 1;
		tb_stop = 0;
		@(negedge tb_clk);
		tb_nrst = 1;
		@(posedge tb_clk);
		@(negedge tb_clk);
		tb_primSelect = 0;
		@(negedge tb_clk);
		tb_primSelect = 1;
		@(posedge tb_clk);
/*
	//Test case 4: negative slope with pause
		tb_positions = 38'b00000000000000000000000011110000001111;
		@(negedge tb_clk);
		tb_primSelect = 1;
		@(posedge tb_clk);
		tb_primSelect = 0;
		#1000;
		tb_stop = 1;
		#300;
		tb_stop = 0;
*/
/*
		for (i = 0; i < 640; i++) begin //Write into the file 640*480 times
			for (j = 0; j < 480; j++) begin
		//	old_address = tb_address;
			@(posedge tb_clk);
		//	if (old_address == tb_address) begin
		//		i = 640; j = 480;
		//	end
			$fdisplay(f, "%b", tb_address);
		end end
		#1000;
*/
		writeToFile;
		
	end
endmodule
