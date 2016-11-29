// $Id: $
// File name:   splitter.sv
// Created:     11/28/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Subshape splitter
module splitter
(
input wire clk,
input wire n_rst,
input wire [75:0]opdata,
input wire [3:0]output_sel,
input wire read,
output wire [37:0]locations,
output wire [15:0]color
);


typedef enum {IDLE, START_CIRCLE, START_LINE, START_SQ, SQ1, SQ2, SQ3, SQ4, START_TRI, TRI1, TRI2, TRI3} stateType;
stateType state;
stateType next_state;
reg [37:0]temp_locations;
reg [37:0]temp_location;

always_ff @ (posedge clk, negedge n_rst)
begin : NEXT_LOGIC
	if (!n_rst) begin
		state <= IDLE;
		temp_locations <= temp_location;	
	end else begin
		state <= next_state;
		temp_locations <= temp_location;
	end
end

always_comb
begin : STATE_LOGIC
	next_state = state;
	case(state)
		IDLE:
		begin
			if (output_sel == 4'b0000) begin // line
				next_state = START_LINE;
			end 
			else if (output_sel == 4'b0001) begin //circle
				next_state = START_CIRCLE;
			end 
			else if (output_sel == 4'b0010) begin //triangle
				next_state = START_TRI;
			end
			else if (output_sel == 4'b0011) begin //square
				next_state = START_SQ;
			end
		end

		START_LINE:
		begin
			if (read == 1)
				next_state = IDLE;
		end
	endcase
end

always_comb
begin : STATE_VALUES
	temp_location = 0;
	case(state)
		START_LINE:
		begin
			 temp_location = opdata[75:38];
		end
	endcase
end

assign locations = temp_locations;
endmodule
			

