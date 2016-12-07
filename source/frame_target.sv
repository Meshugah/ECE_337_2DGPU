//Module: Frame Target
//Author(s): Noah Petersen
//Description: 	Indicates which frame in SDRAM to target with output (1 or 2). 
//		Alternates every time new_shape is asserted.

module frame_target
(
	input wire clk,
	input wire n_reset,
	input wire new_shape,
	output reg frame_target 
);

always_ff @(posedge clk, negedge n_reset) begin
	if(n_reset == 0) begin
		frame_target = 1;
	end else if (new_shape == 1) begin
		frame_target = !frame_target;
	end else begin
		frame_target = frame_target;
	end
end

endmodule
