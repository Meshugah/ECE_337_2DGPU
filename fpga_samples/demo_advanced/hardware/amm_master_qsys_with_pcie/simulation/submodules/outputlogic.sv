// output logic block
// Coder: Aiman


module outputlogic (
        input wire n_rst, 
	input wire clk, 
	input wire data_select, 
	input wire underflow, 
	input wire overflow,
        input wire [7:0] arith_out,
        output wire [7:0] final_out
        );


reg [7:0] out;

//assign final_out = (data_select == 1'b0)? 8'h12:8'h54;

assign final_out = out;

always_ff @(posedge clk, negedge n_rst) begin
  if(n_rst == 1'b0) begin
    out <= 8'h00;
  end
  else begin
    if(data_select == 1'b0) begin
      out <= 8'h12; // STOPBYTE
    end else if(underflow == 1'b1) begin
        out <= 8'h00;
     end else if(overflow == 1'b1) begin
        out <= 8'hFF;
     end else begin
        out <= arith_out;
     end
    end
end

endmodule



