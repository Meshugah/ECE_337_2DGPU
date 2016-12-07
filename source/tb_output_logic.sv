//Module: Test Bench for Output Logic
//Authors: Noah Petersen
//Description: Test bench for combinational output logic.
`timescale 1ns/100ps
module tb_output_logic ();


	//Test Bench Signals
	reg [15:0]tb_color;
	reg tb_address_lsb;
	wire [31:0]tb_pixel_data;
	wire [3:0]tb_byteenable;

	//DUT Declaration
	output_logic DUT(.color(tb_color), .address_lsb(tb_address_lsb), .pixel_data(tb_pixel_data), .byteenable(tb_byteenable));

	initial begin
		setinputs(16'b0101010101010101,0);
		checkoutput();

		setinputs(16'b0101010101010101,1);
		checkoutput();

		setinputs(16'b1010101010101010,0);
		checkoutput();

		setinputs(16'b1010101010101010,1);
		checkoutput();

		setinputs('1,0);
		checkoutput();

		setinputs('1,1);
		checkoutput();

		setinputs('0,0);
		checkoutput();

		setinputs('0,1);
		checkoutput();
	end
/////////////////////////////BLANK/////////////////////////////
	task setinputs(
	input [15:0]input_color,
	input input_lsb
	);
	begin
		#(1);
		tb_color = input_color;
		tb_address_lsb = input_lsb;
		#(1);
	end
	endtask
///////////////////////////////////////////////////////////////


/////////////////////////////BLANK/////////////////////////////
	task checkoutput();
	begin
		#(1);
		if(tb_pixel_data == {tb_color,tb_color}) begin
			$info("pixel_data Output correct");
		end else begin
			$error("pixel Data is incorrect");
		end

		if((tb_address_lsb == 0) && (tb_byteenable == 4'b0011)) begin
			$info("byttenable Output correct");
		end else if((tb_address_lsb == 1) && (tb_byteenable == 4'b1100)) begin
			$info("byttenable Output correct");
		end else begin
			$error("byttenable is incorrect");
		end
		#(1);
	end
	endtask
///////////////////////////////////////////////////////////////

endmodule
