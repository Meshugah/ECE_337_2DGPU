`timescale 1ns / 1ns

module tb ();

   logic clk    = 1'b0;
   logic reset_n  = 1'b0;

   logic rdwr_cntl = 1'b1;
   logic n_action = 1'b1;
   logic [25:0] address = 26'b0;
   
   localparam  CLOCK_PERIOD            = 10; // Clock period in ns
   localparam  INITIAL_RESET_CYCLES    = 3;  // Number of cycles to reset when simulation starts
   
   master_example_test dut(
	.clock(clk),
	.reset_n(reset_n),
   );
  
   test_program  tp();
   
   // Clock signal generator
   always begin
      #(CLOCK_PERIOD / 2);
      clk = ~clk;
   end


   
   // Initial reset
   initial begin
      repeat(INITIAL_RESET_CYCLES) @(posedge clk);
      reset_n = 1'b0;
      repeat(INITIAL_RESET_CYCLES) @(posedge clk);
        reset_n = 1'b1;
//	n_action = 1'b0;
//        #2000 ;
//	n_action = 1'b1;
//	rdwr_cntl = 1'b0;
//	#50   
//	n_action = 1'b0;
	
   end

endmodule 



