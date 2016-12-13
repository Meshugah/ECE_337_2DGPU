//Module: Shift Register for GPU Project - 3 bits deep, 32 bits wide
//Author: Noah Petersen
//STP Shift Register for GPU. Needs to be 3 bits deep (for 3 sections of opcode) and 32 bits wide for opcode.

module opcode_stp

(
 input wire clk, n_rst, shift_enable, 
 input wire [31:0] serial_in,
 output wire [95:0]parallel_out
 ); 
  // reg [95:0]temp_out;

reg [31:0]line1;
reg [31:0]line2;
reg [31:0]line3;


assign parallel_out = {line1,line2,line3};



always_ff @(posedge clk, negedge n_rst) begin
	if(n_rst == 0) begin
		line1 <= '1;
		line2 <= '1;
		line3 <= '1;
	end else begin
		if(shift_enable) begin
			line3 <= line2;
			line2 <= line1;
			line1 <= serial_in;
		end
	end
end
			
endmodule
