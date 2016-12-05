//Module: GPU Control Unit
//Author(s): Noah Petersen
//Version: 1.0 Initial

module gpucontrolunit
(
	input wire clk,
	input wire n_reset,
	input wire busy,
	input wire output_done,
	input wire wait_request,
	input wire shape_done,
	output reg read,
	output reg new_shape,
	output reg output_en,
	output reg byteenable,
	output reg busy_reset
);

//State Enumeration
typedef enum bit [3:0] {
		IDLE = 4'b0000,
		READOP1 = 4'b0001,
		READOP2 = 4'b0010,
		READOP3 = 4'b0011,
		SHIFTOP1 = 4'b0100,
		SHIFTOP2 = 4'b0101,
		SHIFTOP3 = 4'b0110,
		WAIT1 = 4'b0111,
		READOPCODE = 4'b1000,
		BUILDSKELETON = 4'b1001,
		SKELETONBUFFWAIT = 4'b1010,
		OUTPUTWAIT = 4'b1011,
		OUTPUTSHAPE = 4'b1100,
		WAIT2 = 4'b1101,
		DONE = 4'b1110,
		FIFOWRITE = 4'b1111
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


//Output Logic
/*
		IDLE = 4'b0000,
		READOP1 = 4'b0001,
		READOP2 = 4'b0010,
		READOP3 = 4'b0011,
		SHIFTOP1 = 4'b0100,
		SHIFTOP2 = 4'b0101,
		SHIFTOP3 = 4'b0110,
		WAIT1 = 4'b0111,
		READOPCODE = 4'b1000,
		BUILDSKELETON = 4'b1001,
		SKELETONBUFFWAIT = 4'b1010,
		OUTPUTWAIT = 4'b1011,
		OUTPUTSHAPE = 4'b1100,
		WAIT2 = 4'b1101,
		DONE = 4'b1110,
		FIFOWRITE = 4'b1111
*/

always_comb begin
	if(state == IDLE) begin
		read = 0;
		new_shape = 0;
		output_en = 0;
		byteenable = 0;
		busy_reset = 0;
	end else if (state == FIFOWRITE) begin
		read = 0;
		new_shape = 0;
		output_en = 0;
		byteenable = 0;
		busy_reset = 0;
	end else if (state == READOP1) begin
	end else if (state == READOP2) begin
	end else if (state == READOP3) begin
	end else if (state == SHIFTOP1) begin
	end else if (state == SHIFTOP2) begin
	end else if (state == SHIFTOP3) begin

	end else if (state == WAIT1) begin
	end else if (state == READOPCODE) begin
	end else if (state == BUILDSKELETON) begin

	end else if (state == SKELETONBUFFWAIT) begin
	end else if (state == OUTPUTWAIT) begin
	end else if (state == OUTPUTSHAPE) begin

	end else if (state == WAIT2) begin
	end else if (state == DONE) begin
	end else if (state == FIFOWRITE) begin
	end else begin
		read = 0;
		new_shape = 0;
		output_en = 0;
		byteenable = 0;
		busy_reset = 0;
	end
end

//Next State Logic
always_comb begin
	//IDLE
	if((state == IDLE) && (busy == 0)) begin
		next_state = 0;
	end else if((state == IDLE) && (busy == 1)) begin
		next_state = FIFOWRITE;

	//FIFOWRITE
	end else if(state == FIFOWRITE) begin
		next_state = READOP1;

	//READOP1
	end else if(state == READOP1) begin
		next_state = READOP2;

	//READOP2
	end else if(state == READOP2) begin
		next_state = READOP3;

	//READOP3
	end else if(state == READOP3) begin
		next_state = SHIFTOP1;

	//SHIFTOP1
	end else if(state == SHIFTOP1) begin
		next_state = SHIFTOP2;

	//SHIFTOP2
	end else if(state == SHIFTOP2) begin
		next_state = SHIFTOP3;

	//SHIFTOP3
	end else if(state == SHIFTOP3) begin
		next_state = WAIT1;

	//READOPCODE
	end else if(state == READOPCODE) begin
		next_state = WAIT1;

	//WAIT1
	end else if(state == WAIT1) begin
		next_state = BUILDSKELETON;

	//BUILDSKELETON
	end else if((state == BUILDSKELETON) && (wait_request == 1)) begin
		next_state = SKELETONBUFFWAIT;
	end else if((state == BUILDSKELETON) && (shape_done == 1)) begin 
		next_state = WAIT2;
	end else if((state == BUILDSKELETON) && (shape_done == 0)) begin 
		next_state = BUILDSKELETON;

	//SKELETONBUFFWAIT
	end else if((state == SKELETONBUFFWAIT) && (wait_request == 1)) begin
		next_state = SKELETONBUFFWAIT;
	end else if((state == SKELETONBUFFWAIT) && (wait_request == 0)) begin 
		next_state = BUILDSKELETON;
	
	//OUTPUTSHAPE
	end else if((state == OUTPUTSHAPE) && (wait_request == 1)) begin
		next_state = OUTPUTWAIT;
	end else if((state == OUTPUTSHAPE) && (output_done == 1)) begin 
		next_state = WAIT2;
	end else if((state == OUTPUTSHAPE) && (output_done == 0)) begin 
		next_state = OUTPUTSHAPE;

	//OUTPUTWAIT
	end else if((state == OUTPUTWAIT) && (wait_request == 1)) begin
		next_state = OUTPUTWAIT;
	end else if((state == OUTPUTWAIT) && (wait_request == 0)) begin 
		next_state = OUTPUTSHAPE;

	//Done (busy reset)
	end else if(state == DONE) begin
		next_state = IDLE;

	//DEFAULT
	end else begin
		next_state = IDLE;
	end
end



endmodule

