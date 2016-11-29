// $Id: $
// File name:   flex_counter.sv
// Created:     9/13/2014
// Author:      Cong Ku
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: counter

module flex_counter
  #(
    parameter NUM_CNT_BITS = 4
  )
  (
    input wire clk,
    input wire n_rst,
    input wire clear,
    input wire count_enable,
    input wire [NUM_CNT_BITS - 1:0] rollover_val,
    output wire [NUM_CNT_BITS - 1:0] count_out,
    output wire rollover_flag
  );
  
  reg [NUM_CNT_BITS-1:0] curr_count;
  reg [NUM_CNT_BITS-1:0] next_count;
  reg flg,flg_n;
  
  assign count_out = curr_count;
  assign rollover_flag = flg;
  
  
  always_ff @ (posedge clk, negedge n_rst) begin
    if( n_rst == 0 ) begin
      curr_count <= 0;
      flg <= 0;
    end else begin
      curr_count <= next_count;
      flg <= flg_n;
    end
  end
  
  always_comb
  begin
    next_count = 0;
    flg_n = 0;   

      if (clear == 1) begin
        next_count = 0;
        flg_n = 0;
      end
      else if (count_enable == 1)
      begin
        if (rollover_val == curr_count) begin
          next_count = 1;
          flg_n = 0;
        end  
        else begin
          next_count = curr_count + 1;
        end
      end
      else begin
        next_count = curr_count;
        flg_n = flg;
      end
      
      if (count_enable == 1 && (curr_count == (rollover_val - 1)))
      begin
        flg_n = 1'b1;
      end
      else begin
	 flg_n = 1'b0;
      end
      
end
     
endmodule
