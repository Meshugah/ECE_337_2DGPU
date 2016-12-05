//2x1 MUX with 32 bit throughput


module MUX
(
	input wire [31:0]a,
	input wire [31:0]b,
	input wire sel,
	output reg [31:0]data
);

always_comb begin
	if(sel == 1'b1) begin
		data = a;
	end else if(sel == 1'b0) begin
		data = b;
	end else begin
		data = '0;
	end
end

endmodule
