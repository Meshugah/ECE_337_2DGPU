// $Id: $
// File name:   readCounter.sv
// Created:     11/13/2014
// Author:      Cong Ku
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: a counter which counts the colums and rows of pixel currently processing

module readCounter
(
  input wire clk,
  input wire n_rst,
  input wire[15:0] n_columns,
  input wire[15:0] n_rows,
  input wire count_enable,
  
  input wire flag_clear,
  
  output wire switch_rows,

  output wire image_done_flag,
  output wire [15:0] col_count_out,
  output wire [15:0] row_count_out
);

reg flag;


flex_counter #(.NUM_CNT_BITS(16)) COLUMN_COUNTER
(
  .clk(clk),
  .n_rst(n_rst),
  .clear(done),
  .count_enable(count_enable),
  .rollover_val(n_columns),
  .rollover_flag(switch_rows),
  .count_out(col_count_out)
);

flex_counter #(.NUM_CNT_BITS(16)) ROW_COUNTER
(
  .clk(clk),
  .n_rst(n_rst),
  .clear(done),
  .count_enable(switch_rows),
  .rollover_val(n_rows-1), 
  .rollover_flag(done),
  .count_out(row_count_out)
);

always_ff @(posedge clk) begin
		if(!n_rst) begin
			flag <= 0; 
		end else begin
			if (done) begin
				flag <= 1;
			end
			else if(flag_clear) begin
				flag <= 0;
			end
		end
	end
	
assign image_done_flag = flag;

endmodule
