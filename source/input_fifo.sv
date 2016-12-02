// $Id: $
// File name:   input_fifo.sv
// Created:     12/2/2016
// Author:      Vignesh Karthikeyan
// Lab Section: 337-07
// Version:     1.0  Initial Design Entry
// Description: Fifo that stores 4 of our 96-bit opcodes
module input_fifo //FIFO
(
    input wire clk,
    input wire n_rst,
    input wire r_enable,
    input wire w_enable,
    input wire [95:0]w_data,
    output reg [95:0]r_data,
    output reg empty,
    output reg full

);
    reg [95:0]data1, next_data1, data2, next_data2, data3, next_data3, data4, next_data4;
    reg [2:0] w_pointer, next_w_pointer;
	reg [95:0] nextr_data;
	reg next_empty, next_full;
  always_ff @ (posedge clk, negedge n_rst)
  begin
    if(n_rst == 0)
    begin
      data1 = '0; //set all to 0 on reset
      data2 = '0;
      data3 = '0;
      data4 = '0;
      w_pointer = '0;
      r_data = '0;
      empty = 1;
      full = 0;
    end
    else
      begin
	 	 data1 = next_data1; 
         data2 = next_data2;
         data3 = next_data3; 
         data4 = next_data4;
         w_pointer = next_w_pointer;
         r_data = nextr_data;
         empty = next_empty;
         full =next_full;
         
      end
	 
  end


  
  always_comb begin //load_info
      next_data1 = data1;
      next_data2 = data2;
      next_data3 = data3; 
      next_data4 = data4;
      nextr_data = r_data;
      next_w_pointer = w_pointer;
      if(w_enable) begin
      	 if(~full) begin
      	       next_w_pointer = w_pointer + 1;    

		       if(w_pointer == 0) begin
			   		next_data1 = w_data;
			   		
		       end
		       if(w_pointer == 1) begin
	 	     			next_data2 = w_data;
		       end
		       if(w_pointer == 2) begin
		          next_data3 = w_data;
		       end
		       if(w_pointer == 3) begin
		          next_data4 = w_data; 
		       end
		 end
      end
      else if(r_enable) begin
      		if(~empty) begin
      		    next_w_pointer = w_pointer - 1; 
      			nextr_data = data1;
		  		next_data1 = data2;
		  		next_data2 = data3;
		  		next_data3 = data4;
		  		next_data4 = '0;
		  	end

      end
      	

  end
  	
  	//have to see if this is okay
	assign next_full = (next_w_pointer == 3'b100);
	assign next_empty = (next_w_pointer == 3'b000);

endmodule
