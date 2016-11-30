
module CoreControlUnit (
	input wire clk,
	input wire nreset,
	input wire empty,
	input wire newshape,
	input wire waitrequest,
	input wire ldone,
	input wire adone,
	input wire [3:0] shapeid,
	output wire primsel,
	output wire shapedone,
	output wire write,
	output wire read,
	output wire outputsel
);

typedef enum bit [5:0] {
		IDLE = 4'b00000,
		IDENTIFYSHAPE = 4'b00001,
		TRISENDL1 = 4'b00010,
		TRISENDL2 = 4'b00011,
		TRISENDL3 = 4'b00100,
		TRIMAKEL1 = 4'b00101,
		TRIMAKEL2 = 4'b00110,
		TRIMAKEL3 = 4'b01000,
		TRICLFIFOL1 = 4'b00111,
		TRICLFIFOL2 = 4'b01001,
		TRICLFIFOL3 = 4'b01010,
		DISPWAIT = 4'b01011,
		LSENDL = 4'b01100,
		LMAKEL = 4'b01101,
		LCLFIFO = 4'b01111,
		SENDCIRC = 4'b01101,
		ARC1 = 4'b01111,
		ARC2 = 4'b10000,
		ARC3 = 4'b10001,
		ARC4 = 4'b10010,
		ARC5 = 4'b10011,
		ARC6 = 4'b10100,
		ARC7 = 4'b10101,
		ARC8 = 4'b10110,
		CCLFIFO = 4'b10111
			}StateType
//Local Parameters
localparam LINE 2'b0000;
localparam TRI 2'b0001;
localparam ARC 2'0010;

//Local Variables
StateType [5:0] nextstate;
StateType [5:0] state;

always_comb begin
	//Next State Logic
		//IDlE
	if((state == IDLE) && (NEWSHAPE == 1)) begin	
		nextstate = IDENTIFYSHAPE;
	end else if ((state == IDLE) && (NEWSHAPE == 0)) begin
		nextstate = IDLE;

		//IDENTIFY SHAPE
	end else if ((state == IDENTIFYSHAPE) && (shapeid == LINE)) begin
		nextstate == LSENDL;
	end else if ((state == IDENTIFYSHAPE) && (shapeid == TRI)) begin
		nextstate == TRISENDL1;
	end else if ((state == IDENTIFYSHAPE) && (shapeid == ARC)) begin
		nextstate == SENDCIRC;

		//Line Sequence
	end else if(state == LSENDL) begin
		nextstate = LMAKEL;
	end else if ((state == LMAKEL) && (ldone == 1)) begin
		nextstate = LCLFIFO;
	end else if ((state == LMAKEL) && (ldone == 0)) begin
		nextstate == LMAKELk

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

always_ff @(posedge clk, negedge nreset) begin
	if(nreset == 0) begin
		state <= 0;
	end else begin
		state <= nextstate;
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
	end else if (state == IDENTIFYSHAPE) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;

	end else if (state == LSENDL) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == LMAKEL) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == LCLFIFO) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0001;
	end else if (state == TRISENDL1) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0010;
	end else if (state == TRISENDL2) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0011;
	end else if (state == TRISENDL3) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == TRISENDL3) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == TRIMAKEL1) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == TRIMAKEL2) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == TRIMAKEL3) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == TRICLFIFOL1) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 1;
		outputsel = 4'b0000;
	end else if (state == TRICLFIFOL2) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 1;
		outputsel = 4'b0000;
	end else if (state == TRICLFIFOL3) begin
		primsel = 0;
		shapedone = 0;
		write = 0;
		read = 1;
		outputsel = 4'b0000;
	end else if (state == DISPWAIT) begin
		primsel = 0;
		shapedone = 1;
		write = 0;
		read = 0;
		outputsel = 4'b0000;

	end else if (state == SENDCIRC) begin
		primsel = 1;
		shapedone = 0;
		write = 1;
		read = 0;
		outputsel = 4'b0100;
	end else if (state == ARC1) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == ARC2) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == ARC3) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == ARC4) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == ARC5) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == ARC6) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == ARC7) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == ARC8) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 0;
		outputsel = 4'b0000;
	end else if (state == CCLFIFO) begin
		primsel = 1;
		shapedone = 0;
		write = 0;
		read = 1;
		outputsel = 4'b0000;
	end
end

endmodule
