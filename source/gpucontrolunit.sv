//Module: GPU Control Unit
//Author(s): Noah Petersen
//Version: 1.0 Initial

module gpucontrolunit
(
	input wire clk,
	input wire n_reset,
	input wire master_busy,
	input wire busy,
	input wire data_ready,
	input wire shape_done,
	output reg read,
	output reg new_shape,
	output reg shift_enable,
	output reg send_data,
	output reg busy_reset
);

//State Enumeration
typedef enum bit [3:0] {
		IDLE 		= 4'b0000,
		GETOP2 		= 4'b0001,
		GETOP3 		= 4'b0010,
		SHIFTOP1 	= 4'b0011,
		SHIFTOP2 	= 4'b0100,
		SHIFTOP3 	= 4'b0101,
		NEWSHAPE 	= 4'b0110,
		OUTPUTWAIT	= 4'b0111,
		DATAOUTPUT 	= 4'b1000,
		DATASENT 	= 4'b1001,
		OUTPUTEND	= 4'b1010
			}StateType;


//State Variables
StateType [3:0] state;
StateType [3:0] next_state;

//State Update
always_ff @(posedge clk, negedge n_reset) begin
	if(n_reset == 0) begin
		state = IDLE;
	end else begin
		state = next_state;
	end
end

//Next State Logic
always_comb begin
	//IDLE
	if((state == IDLE) && (busy == 1)) begin
		next_state = SHIFTOP1;
	end else if((state == IDLE) && (busy == 0)) begin
		next_state = IDLE;
	
	//SHIFTOP1
	end else if(state == SHIFTOP1) begin
		next_state = GETOP2;

	//SHIFTOP2
	end else if(state == SHIFTOP2) begin
		next_state = GETOP3;

	//SHIFTOP3
	end else if(state == SHIFTOP3) begin
		next_state = NEWSHAPE;

	//GETOP2
	end else if(state == GETOP2) begin
		next_state = SHIFTOP2;

	//GETOP3
	end else if(state == GETOP3) begin
		next_state = SHIFTOP3;

	//NEWSHAPE
	end else if(state == NEWSHAPE) begin
		next_state = OUTPUTWAIT;

	//OUTPUTWAIT
	end else if((state == OUTPUTWAIT) && (shape_done == 1)) begin
		next_state = OUTPUTEND;
	end else if((state == OUTPUTWAIT) && (data_ready == 1)) begin
		next_state = DATAOUTPUT;
	end else if(state == OUTPUTWAIT) begin
		next_state = OUTPUTWAIT;

	//DATASENT
	end else if(state == DATASENT) begin
		next_state = OUTPUTWAIT;

	//OUTPUTEND
	end else if(state == OUTPUTEND) begin
		next_state = IDLE;

	//Default
	end else begin
		next_state = IDLE;
	end
end //End of next_state logic



//Output Logic
always_comb begin
	//IDLE
	if(state == IDLE) begin
		read = 0;
		new_shape = 0;
		shift_enable = 0;
		send_data = 0;
		busy_reset = 0;
	//SHIFTOP1
	end else if(state == SHIFTOP1) begin
		read = 0;
		new_shape = 0;
		shift_enable = 1;
		send_data = 0;
		busy_reset = 0;

	//SHIFTOP2
	end else if(state == SHIFTOP2) begin
		read = 0;
		new_shape = 0;
		shift_enable = 1;
		send_data = 0;
		busy_reset = 0;
	//SHIFTOP3
	end else if(state == SHIFTOP3) begin
		read = 0;
		new_shape = 0;
		shift_enable = 1;
		send_data = 0;
		busy_reset = 0;
	//GETOP2
	end else if(state == GETOP2) begin
		read = 1;
		new_shape = 0;
		shift_enable = 0;
		send_data = 0;
		busy_reset = 0;
	//GETOP3
	end else if(state == GETOP3) begin
		read = 1;
		new_shape = 0;
		shift_enable = 0;
		send_data = 0;
		busy_reset = 0;
	//NEWSHAPE
	end else if(state == NEWSHAPE) begin
		read = 0;
		new_shape = 1;
		shift_enable = 0;
		send_data = 0;
		busy_reset = 0;
	//OUTPUTWAIT
	end else if(state == OUTPUTWAIT) begin
		read = 0;
		new_shape = 0;
		shift_enable = 0;
		send_data = 0;
		busy_reset = 0;
	//DATASENT
	end else if(state == DATASENT) begin
		read = 0;
		new_shape = 0;
		shift_enable = 0;
		send_data = 1;
		busy_reset = 0;
	//OUTPUTEND
	end else if(state == OUTPUTEND) begin
		read = 0;
		new_shape = 0;
		shift_enable = 0;
		send_data = 0;
		busy_reset = 1;
	//Default
	end else begin
		read = 0;
		new_shape = 0;
		shift_enable = 0;
		send_data = 0;
		busy_reset = 0;
	end
end

endmodule

