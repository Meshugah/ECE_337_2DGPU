// $Id: $
// File name:   outputlogic.sv
// Created:     11/23/2014
// Author:      Aiman
// Project
// Version:     1.0  Initial Design Entry
// Description: This block controls the flow of output, putting different types of data onto the output data bus on demand. Possible output data include STOPBYTE, edge pixel data, overflow and underflow.

module outputlogic (
        input wire n_rst, 
	input wire clk, 
	input wire data_select,   //data_select decides which data should be put onto output data bus.
	input wire underflow, 
	input wire overflow,
        input wire [7:0] arith_out,
        output wire [7:0] final_out
        );

reg [7:0] out;

assign final_out = out;

//Output Register
always_ff @(posedge clk, negedge n_rst) begin
  if(n_rst == 1'b0) begin
    out <= 8'h00;
  end
  else begin
    if(data_select == 1'b0) begin
      out <= 8'h12;  //Output STOPBYTE
    end else if(underflow == 1'b1) begin  
        out <= 8'h00;  //If underflow occurs, the pixel value is overwritten to 0
     end else if(overflow == 1'b1) begin
        out <= 8'hFF;  //If overflow occurs, the pixel value is overwritten to 255
     end else begin
        out <= arith_out;  //If no error is present, output the calculated pixel value
     end
    end
end

endmodule
