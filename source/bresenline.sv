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

typedef enum {IDLE, RUN, DONE, PAUSE} stateType;
stateType state;
stateType next_state;
//Initialize requried variables
reg [18:0]temp_address;
reg lineDone_temp;
reg lineD;

reg [9:0]startX;
reg [8:0]startY;
reg [9:0]endX;
reg [8:0]endY;

reg [9:0]x, tempX;
reg [8:0]y, tempY;
reg start;
reg in_loop;
reg done;

logic signed [10:0]dx, dy, err, e2;
logic right, down;

assign address = {x,y};
assign lineDone = lineD;
assign startX = positions[37:28];
assign startY = positions[27:19]; //Refer to below
assign endX = positions[18:9];
assign endY = positions[8:0]; //Need to add leading 0 to pad it to 10 bits for arithmetic logic


always_ff @ (posedge clk)
begin
	lineD <= 0;
	if (!n_rst)
		state <= IDLE;
	else case (state)
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
//Initialize requried variables
reg [18:0]temp_address;
reg lineDone_temp;
reg lineD;

reg [9:0]startX;
reg [8:0]startY;
reg [9:0]endX;
reg [8:0]endY;

reg [9:0]x, tempX;
reg [8:0]y, tempY;
reg start;
reg in_loop;
reg done;

logic signed [10:0]dx, dy, err, e2;
logic right, down;

//Extract required information from position data (i.e: start X, start Y, so on)
// 19 bit positions, 10 for x, 9 for y
assign startX = positions[37:28];
assign startY = positions[27:19]; //Refer to below
assign endX = positions[18:9];
assign endY = positions[8:0]; //Need to add leading 0 to pad it to 10 bits for arithmetic logic
assign start = (primSelect==1)?1:0;

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
			if (start)
				next_state = RUN;
		end

		RUN:

		begin
			if (stop)
				next_state = PAUSE;
			else if (lineDone) 
				next_state = DONE;
		end

		DONE:

		begin
			if (start)
				next_state = RUN;
			else
				next_state = IDLE;
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
		end

		PAUSE:
		begin
			done = 0;
			in_loop = 0;
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
		end
		
	endcase
end

assign address = {x,y};//temp_address;
assign lineDone = lineDone_temp;

endmodule
*/
