// $Id: $
// File name:   bresenline.sv
// Created:     11/29/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Bresenham's line generator in Verilog
module bresenline
(
input wire clk,
input wire n_rst,
input wire [37:0]positions,
input wire stop,
input wire getData,
input wire primSelect,
output wire [18:0]address,
output wire lineDone
);

typedef enum {IDLE, PAUSE, RUN} stateType;
stateType state;
stateType next_state;
//Initialize requried variables
logic [18:0]temp_address;
logic  lineDone_temp;
logic lineD;

logic [9:0]startX;
logic [8:0]startY;
logic [9:0]endX;
logic [8:0]endY;

logic [9:0]x, tempX;
logic [8:0]y, tempY;
logic start;
logic in_loop;
logic done;

logic signed [10:0]dx, dy, err, e2;
logic right, down;

assign address = {x,y};
assign lineDone = lineD;
assign startX = positions[37:28];
assign startY = {0,positions[27:19]}; //Refer to below
assign endX = positions[18:9];
assign endY = {0,positions[8:0]}; //Need to add leading 0 to pad it to 10 bits for arithmetic logic

always_ff @ (posedge clk)
begin
	if (!n_rst) begin

		lineD <= 0;
		state <= IDLE;
		x <= 0;
		y <= 0;
	end else case (state)
		IDLE:
			if (primSelect == 1) begin
				dx = endX - startX;
				right = dx >= 0;

				if (~right)
					dx = -dx;

				dy = endY - startY;
				down = dy >= 0;

				if (down)
					dy = -dy;

				err = dx + dy;
				x <= startX;
				y <= startY;

				state <= RUN;
			end
		RUN:
			
			if (stop) begin
				state <= PAUSE;
			end else if (x == endX && y == endY) begin
				lineD <= 1;
				state <= IDLE;
			end else begin
				e2 = err << 1;
				if (e2 > dy) begin
					err += dy;
					if (right)
						x <= x + 10'd1;
					else
						x <= x - 10'd1;
				end
				if (e2 < dx) begin
					err += dx;
					if (down)
						y <= y + 10'd1;
					else
						y <= y - 10'd1;
				end
			end		

		PAUSE:
			if (!stop)
				state <= RUN;	
		default:
			state <= IDLE;
	endcase
end












endmodule







/*

always_ff @ (posedge clk)
begin : NEXT_LOGIC
	if (!n_rst) begin
		state <= IDLE;
		x <= 0;
		y <= 0;
		lineD <= 0;
	end else begin
		state <= next_state;
		x <= tempX;
		y <= tempY;
		lineD <= lineDone_temp;
	end	
end


always_comb
begin : STATE_LOGIC
	next_state = state;
	case(state)
		IDLE:

		begin
			if (primSelect == 1)
				next_state = RUN;
		end

		RUN:

		begin
			if (stop)
				next_state = PAUSE;
			else if (lineDone) 
				next_state = DONE;
		end


		PAUSE:

		begin
			if (!stop)
				next_state = RUN;
		end
	endcase
end

always_comb
begin : STATE_VALUES
	in_loop = 0;
	done = 0;
	case (state)

		IDLE:
		begin

			lineDone_temp = 0;

			dx = endX-startX;
			right = dx >= 0;
			if (~right) dx = -dx;
			dy = endY-startY;
			down = dy >= 0;
			if (down) dy = -dy;
			err = dx+dy;
			tempX = startX;
			tempY = startY;
		end

		RUN:
		begin
			if (x == endX && y == endY)
				lineDone_temp = 1;
			else
				e2 = err << 1;
				if (e2 > dy) begin
					err += dy;
					if (right) 
						tempX = x + 10'd1;
					else
						tempX = x - 10'd1;
				end
				if (e2 < dx) begin
					err += dx;
					if (down)
						tempY = y + 10'd1;
					else
						tempY = y - 10'd1;
				end
		end

		DONE:
		begin
			tempX = 0;
			tempY = 0;
			lineDone_temp = 0;
			dx = 0;
			dy = 0;
			down = 0;
			right = 0;
			err = 0;
			done = 0;
			e2 = 0;	
		end

		default:
		begin
			tempX = 0;
			tempY = 0;
			lineDone_temp = 0;
			dx = 0;
			dy = 0;
			down = 0;
			right = 0;
			err = 0;
			e2 = 0;
		end
		
	endcase
end


endmodule

*/
