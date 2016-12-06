// $Id: $
// File name:   bresencircle.sv
// Created:     12/5/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Bresenham's circle
module bresencircle
(
input wire clk,
input wire n_rst,
input wire [37:0]positions,
input wire stop,
input wire primSelect,
output wire [18:0]address,
output wire circleDone
);

typedef enum {IDLE, RUN, DRAW1, DRAW2, DRAW3, DRAW4, DRAW5, DRAW6, DRAW7, DRAW8, UPDATE, PAUSE} stateType;
stateType state;
stateType next_state;

logic [18:0]temp_address;
logic circleD;

logic [9:0] startX;
logic [8:0] startY;
logic [18:0] radius;

logic signed [9:0] currentX;
logic signed [8:0] currentY;

logic [9:0] tempX;
logic [8:0] tempY;

logic signed [10:0] err;

stateType prevState;

assign address = {tempX, tempY};
assign startX = positions[37:28];
assign startY = positions[27:19];
assign radius = positions[19:10];
assign circleDone = circleD;


always_ff @ (posedge clk)
begin
	if (!n_rst) begin
		state <= IDLE;
		currentX <= 0;
		currentY <= 0;
		tempX <= 0;
		tempY <= 0;
		err <= 0;
		circleD <= 0;
	end else begin case (state)
		IDLE:	begin
			if (primSelect == 0) begin
				currentX <= radius;
				currentY <= 0;
				err <= 0;
				state <= RUN;
				circleD <= 0;
				tempX <= 0;
				tempY <= 0;
			end
			end
		RUN:	begin
			if (stop) begin
				prevState <= RUN;
				state <= PAUSE;
			end else if (currentX >= currentY) begin
				state <= DRAW1;
			end else if (currentY > currentX) begin
				state <= IDLE;
				circleD <= 1;
			end end
		DRAW1:
			begin
			if (stop) begin
				prevState <= DRAW1;
				state <= PAUSE;
			end else begin
			tempX <= startX + currentX;
			tempY <= startY + currentY;
			state <= DRAW2;
			end end
		DRAW2:
			begin
			if (stop) begin
				prevState <= DRAW2;
				state <= PAUSE;
			end else begin
			tempX <= startX + currentY;
			tempY <= startY + currentX;
			state <= DRAW3;
			end end
		DRAW3:
			begin
			if (stop) begin
				prevState <= DRAW3;
				state <= PAUSE;
			end else begin
			tempX <= startX - currentY;
			tempY <= startY + currentX;
			state <= DRAW4;
			end end
		DRAW4:
			begin
			if (stop) begin
				prevState <= DRAW4;
				state <= PAUSE;
			end else begin
			tempX <= startX - currentX;
			tempY <= startY + currentY; 
			state <= DRAW5;
			end end
		DRAW5:
			begin
			if (stop) begin
				prevState <= DRAW5;
				state <= PAUSE;
			end else begin
			tempX <= startX - currentX;
			tempY <= startY - currentY; 		
			state <= DRAW6;
			end end
		DRAW6:
			begin
			if (stop) begin
				prevState <= DRAW6;
				state <= PAUSE;
			end else begin
			tempX <= startX - currentY;
			tempY <= startY - currentX; 
			state <= DRAW7;
			end end
		DRAW7:
			begin
			if (stop) begin
				prevState <= DRAW7;
				state <= PAUSE;
			end else begin
			tempX <= startX + currentY;
			tempY <= startY - currentX; 
			state <= DRAW8;
			end end
		DRAW8:
			begin
			if (stop) begin
				prevState <= DRAW8;
				state <= PAUSE;
			end else begin
			tempX <= startX + currentX;
			tempY <= startY - currentY; 
			state <= UPDATE;
			end end
		UPDATE:
			begin
			if (stop) begin
				prevState <= UPDATE;
				state <= PAUSE;
			end else begin
			currentY <= currentY + 10'd1;
			err <= err + 1 + (currentY << 1);
			if (((err - currentX) << 1) + 1 > 0) begin
				currentX <= currentX - 10'd1;
				err <= err + 1 - (currentX << 1);
			end
			state <= RUN;
			end end
		PAUSE:
			begin
			if (!stop)
				state <= prevState;
			end
		default:
			state <= IDLE;
	endcase
end end

endmodule
			
