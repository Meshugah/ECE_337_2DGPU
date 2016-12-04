
module CoreControlUnit (
	input wire clk,
	input wire nreset,
	input wire empty,
	input wire newshape,
	input wire waitrequest,
	input wire ldone,
	input wire adone,
	input wire [3:0] shapeid,
	output reg primsel,
	output reg shapedone,
	output reg write,
	output reg read,
	output reg enable,
	output reg outputsel
);
//Need to deal with wait request state? -> YES NEED TO DEAL WITH IT

typedef enum bit [4:0] {
		IDLE = 5'b00000,
		IDENTIFYSHAPE 	= 5'b00001,
		TRISENDL1 	= 5'b00010,
		TRISENDL2 	= 5'b00011,
		TRISENDL3 	= 5'b00100,
		TRIMAKEL1 	= 5'b00101,
		TRIMAKEL2 	= 5'b00110,
		TRIMAKEL3 	= 5'b00111,
		TRICLFIFOL1 	= 5'b01000,
		TRICLFIFOL2 	= 5'b01001,
		TRICLFIFOL3 	= 5'b01010,
		DISPWAIT 	= 5'b01011,
		LSENDL 		= 5'b01100,
		LMAKEL 		= 5'b01101,
		LCLFIFO 	= 5'b01111,
		SENDCIRC 	= 5'b10000,
		ARC1 		= 5'b10001,
		ARC2 		= 5'b10010,
		ARC3 		= 5'b10011,
		ARC4 		= 5'b10100,
		ARC5 		= 5'b10101,
		ARC6 		= 5'b10110,
		ARC7 		= 5'b10111,
		ARC8 		= 5'b11000,
		CCLFIFO 	= 5'b11001
			}StateType;
//Local Parameters
localparam LINE = 4'b0000;
localparam TRI = 4'b0001;
localparam ARC = 4'b0010;

//Local Variables
StateType [5:0] nextstate;
StateType [5:0] state;

always_ff @(posedge clk, negedge nreset) begin
	if(nreset == 0) begin
		state <= 0;
	end else begin
		state <= nextstate;
	end
end

always_comb begin
	//Next State Logic
		//IDlE
	if((state == IDLE) && (newshape == 1)) begin	
		nextstate = IDENTIFYSHAPE;
	end else if ((state == IDLE) && (newshape == 0)) begin
		nextstate = IDLE;

		//IDENTIFY SHAPE
	end else if ((state == IDENTIFYSHAPE) && (shapeid == LINE)) begin
		nextstate = LSENDL;
	end else if ((state == IDENTIFYSHAPE) && (shapeid == TRI)) begin
		nextstate = TRISENDL1;
	end else if ((state == IDENTIFYSHAPE) && (shapeid == ARC)) begin
		nextstate = SENDCIRC;

		//Line Sequence
	end else if(state == LSENDL) begin
		nextstate = LMAKEL;
	end else if ((state == LMAKEL) && (ldone == 1)) begin
		nextstate = LCLFIFO;
	end else if ((state == LMAKEL) && (ldone == 0)) begin
		nextstate = LMAKEL;

		//Triangle Sequence
	end else if (state == TRISENDL1) begin
		nextstate = TRISENDL2;
	end else if (state == TRISENDL2) begin
		nextstate = TRISENDL3;
	end else if (state == TRISENDL3) begin
		nextstate = TRIMAKEL1;
			//Triangle Line 1
	end else if ((state == TRIMAKEL1) && (ldone == 0)) begin
		nextstate = TRIMAKEL1;
	end else if ((state == TRIMAKEL1) && (ldone == 1)) begin
		nextstate = TRICLFIFOL1;
	end else if (state == TRICLFIFOL1) begin
		nextstate = TRIMAKEL2;
			//Triangle Line 2
	end else if ((state == TRIMAKEL2) && (ldone == 0)) begin
		nextstate = TRIMAKEL2;
	end else if ((state == TRIMAKEL2) && (ldone == 1)) begin
		nextstate = TRICLFIFOL2;
	end else if (state == TRICLFIFOL2) begin
		nextstate = TRIMAKEL3;
			//Triangle Line 3
	end else if ((state == TRIMAKEL3) && (ldone == 0)) begin
		nextstate = TRIMAKEL3;
	end else if ((state == TRIMAKEL3) && (ldone == 1)) begin
		nextstate = TRICLFIFOL3;
	end else if (state == TRICLFIFOL3) begin
		nextstate = DISPWAIT;

		//Arc Sequence
	end else if (state == SENDCIRC) begin
		nextstate = ARC1;
	end else if (state == ARC1) begin
		nextstate = ARC2;
	end else if (state == ARC2) begin
		nextstate = ARC3;
	end else if (state == ARC3) begin
		nextstate = ARC4;
	end else if (state == ARC4) begin
		nextstate = ARC5;
	end else if (state == ARC5) begin
		nextstate = ARC6;
	end else if (state == ARC6) begin
		nextstate = ARC7;
	end else if (state == ARC7) begin
		nextstate = ARC8;
	end else if ((state == ARC8) && (adone == 0)) begin
		nextstate = ARC1;
	end else if ((state == ARC8) && (adone == 1)) begin
		nextstate = CCLFIFO;
	end else if (state == CCLFIFO) begin
		nextstate = DISPWAIT;
	
		//DISPWAIT
	end else if (state == DISPWAIT) begin
		nextstate = IDLE;
	end else begin
		nextstate = state;
	end
end

always_comb begin
	//State determine output logic
	//Codings for different primitives
	//	Line: 0000
	//	Triangle L1: 0001
	//	Triangle L2: 0010
	//	Triangle L3: 0011
	//	Circle A1: 0100

	if(state == IDLE) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 0;
	end else if (state == IDENTIFYSHAPE) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 0;
	end else if (state == LSENDL) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		enable = 0;
		outputsel = 4'b0000;
	end else if (state == LMAKEL) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == LCLFIFO) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0001;
		enable = 0;
	end else if (state == TRISENDL1) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0010;
		enable = 0;
	end else if (state == TRISENDL2) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0011;
		enable = 0;
	end else if (state == TRISENDL3) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 0;
	end else if (state == TRIMAKEL1) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == TRIMAKEL2) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == TRIMAKEL3) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == TRICLFIFOL1) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 1;
		outputsel = 4'b0000;
		enable = 0;
	end else if (state == TRICLFIFOL2) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 1;
		outputsel = 4'b0000;
		enable = 0;
	end else if (state == TRICLFIFOL3) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 1;
		outputsel = 4'b0000;
		enable = 0;
	end else if (state == DISPWAIT) begin
		primsel = 0;
		shapedone = 1;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 0;
	end else if (state == SENDCIRC) begin
		primsel = 1;
		shapedone = 0;
		write = 1;
		read = 0;
		outputsel = 4'b0100;
		enable = 0;
	end else if (state == ARC1) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == ARC2) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == ARC3) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == ARC4) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == ARC5) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == ARC6) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == ARC7) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == ARC8) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
		enable = 1;
	end else if (state == CCLFIFO) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 1;
		outputsel = 4'b0000;
		enable = 0;
	end
end

endmodule
