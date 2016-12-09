//2x1 MUX with 19 bit throughput


module mux19
(
	input wire [18:0]a,
	input wire [18:0]b,
	input wire sel,
	output reg [18:0]data
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
