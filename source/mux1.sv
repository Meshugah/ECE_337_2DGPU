//2x1 MUX with 1 bit throughput


module mux1
(
	input wire a,
	input wire b,
	input wire sel,
	output reg data
);

//2x1 MUX
//	a -> 1
//	0 -> b
always_comb begin
	if(sel == 1'b1) begin
		data = a;
	end else if(sel == 1'b0) begin
		data = b;
	end else begin
		data = 1'b0;
	end
end

endmodule
