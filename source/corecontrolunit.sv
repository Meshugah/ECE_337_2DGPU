
module corecontrolunit(
	input wire clk,
	input wire nreset,
	input wire new_shape,
	input wire data_ready,
	input wire data_sent,
	input wire line_done,
	input wire arc_done,
	input wire [3:0] shapeid,
	output reg prim_sel,
	output reg shape_done,
	output reg write,
	output reg read,
	output reg enable,
	output reg [3:0]output_sel
);
//Need to deal with wait request state? -> YES NEED TO DEAL WITH IT

//Now 35 States

typedef enum bit [5:0] {
		IDLE = 6'b000000,
		IDENTIFYSHAPE 	= 6'b000001,

		TRISENDL1 	= 6'b000010,
		TRISENDL2 	= 6'b000011,
		TRISENDL3 	= 6'b000100,
		TRIMAKEL1 	= 6'b000101,
		TRIMAKEL2 	= 6'b000110,
		TRIMAKEL3 	= 6'b000111,
		TRIOUTPIXL1	= 6'b001000,
		TRIOUTPIXL2 	= 6'b001001,
		TRIOUTPIXL3 	= 6'b001010,

		CLEARFIFO1 	= 6'b001011,
		CLEARFIFO2 	= 6'b001100,
		CLEARFIFO3 	= 6'b001101,

		DISPWAIT 	= 6'b001111,

		LINESENDL	= 6'b010000,
		LINEMAKEL	= 6'b010001,
		LINEOUTPIX 	= 6'b010010,

		SENDCIRC 	= 6'b010011,
		MAKEARC1	= 6'b010100,
		MAKEARC2	= 6'b010101,
		MAKEARC3	= 6'b010110,
		MAKEARC4	= 6'b010111,
		MAKEARC5	= 6'b011000,
		MAKEARC6	= 6'b011001,
		MAKEARC7	= 6'b011010,
		MAKEARC8	= 6'b011011,

		OUTPIXARC1	= 6'b011100,
		OUTPIXARC2	= 6'b011101,
		OUTPIXARC3	= 6'b011110,
		OUTPIXARC4	= 6'b011111,
		OUTPIXARC5	= 6'b100000,
		OUTPIXARC6	= 6'b100001,
		OUTPIXARC7	= 6'b100010,
		OUTPIXARC8	= 6'b100011
			}StateType;

typedef enum bit [3:0] {
		LINE1 = 4'b0000,
		TRILINE1 = 4'b0001,
		TRILINE2 = 4'b0010,
		TRILINE3 = 4'b0011,
		ARC1 = 4'b0100
			}ShapePrimitive;

//Local Parameters
localparam LINE = 4'b0000;
localparam TRIANGLE = 4'b0001;
//localparam TRILINE2 = 4'b0011;
//localparam TRILINE3 = 4'b0010;
localparam CIRCLE = 4'b0011;

//Local Variables
StateType [5:0] next_state;
StateType [5:0] state;
ShapePrimitive shape_select;

//assign output_sel = shape_select;

always_ff @(posedge clk, negedge nreset) begin
	if(nreset == 0) begin
		state <= 0;
	end else begin
		state <= next_state;
	end
end

always_comb begin
	//Next State Logic
		//IDLE
	if((state == IDLE) && (new_shape == 0)) begin 
		next_state = IDLE;
	end else if((state == IDLE) && (new_shape == 1)) begin
		next_state = IDENTIFYSHAPE;

		//State Identification
	end else if((state == IDENTIFYSHAPE) &&  (shapeid == LINE)) begin
		next_state = LINESENDL;
	end else if((state == IDENTIFYSHAPE) &&  (shapeid == TRIANGLE)) begin	
		next_state = TRISENDL1;
	end else if((state == IDENTIFYSHAPE) &&  (shapeid == CIRCLE)) begin
		next_state = SENDCIRC;
	end else if(state == IDENTIFYSHAPE) begin
		next_state = IDLE;

	//Line Path
		//Send Line to FIFO staet
	end else if(state == LINESENDL) begin
		next_state = LINEMAKEL;
		
		//Calculating Line data
	end else if ((state == LINEMAKEL) && (line_done == 1)) begin
		next_state = CLEARFIFO3;
	end else if ((state == LINEMAKEL) && (data_ready == 1)) begin
		next_state = LINEOUTPIX;
	end else if ((state == LINEMAKEL) && (data_ready == 0) && (line_done == 0)) begin
		next_state = LINEMAKEL;

		//Outputting a pixel from the line
	end else if ((state == LINEOUTPIX) && (data_sent == 0)) begin
		next_state = LINEMAKEL;
	end else if ((state == LINEOUTPIX) && (data_sent == 1)) begin
		next_state = LINEOUTPIX;
 
	//Circle Path
		//Put Circle Into FIFO
	end else if(state == SENDCIRC) begin
		next_state = MAKEARC1;

		//Make Arc states - all very similar, 1 has extra branch

		//Make Arc 1
	end else if((state == MAKEARC1) && (arc_done == 1)) begin
		next_state = CLEARFIFO3;
	end else if((state == MAKEARC1) && (data_ready == 1)) begin
		next_state = OUTPIXARC1;
	end else if((state == MAKEARC1) && (data_ready == 0)) begin
		next_state = MAKEARC1;

		//Make Arc 2
	end else if((state == MAKEARC2) && (data_ready == 1)) begin
		next_state = OUTPIXARC2;
	end else if((state == MAKEARC2) && (data_ready == 0)) begin
		next_state = MAKEARC2;

		//Make Arc 3
	end else if((state == MAKEARC3) && (data_ready == 1)) begin
		next_state = OUTPIXARC3;
	end else if((state == MAKEARC3) && (data_ready == 0)) begin
		next_state = MAKEARC3;

		//Make Arc 4
	end else if((state == MAKEARC4) && (data_ready == 1)) begin
		next_state = OUTPIXARC4;
	end else if((state == MAKEARC4) && (data_ready == 0)) begin
		next_state = MAKEARC4;

		//Make Arc 5
	end else if((state == MAKEARC5) && (data_ready == 1)) begin
		next_state = OUTPIXARC5;
	end else if((state == MAKEARC5) && (data_ready == 0)) begin
		next_state = MAKEARC5;

		//Make Arc 6
	end else if((state == MAKEARC6) && (data_ready == 1)) begin
		next_state = OUTPIXARC6;
	end else if((state == MAKEARC6) && (data_ready == 0)) begin
		next_state = MAKEARC6;

		//Make Arc 7
	end else if((state == MAKEARC7) && (data_ready == 1)) begin
		next_state = OUTPIXARC7;
	end else if((state == MAKEARC7) && (data_ready == 0)) begin
		next_state = MAKEARC7;

		//Make Arc 8
	end else if((state == MAKEARC8) && (data_ready == 1)) begin
		next_state = OUTPIXARC8;
	end else if((state == MAKEARC8) && (data_ready == 0)) begin
		next_state = MAKEARC8;

		//Sending Pixels from each arc out

		//Send Arc Pix 1
	end else if((state == OUTPIXARC1) && (data_sent == 1)) begin
		next_state = MAKEARC2;
	end else if((state == OUTPIXARC1) && (data_sent == 0)) begin
		next_state = OUTPIXARC1;

		//Send Arc Pix 2
	end else if((state == OUTPIXARC2) && (data_sent == 1)) begin
		next_state = MAKEARC3;
	end else if((state == OUTPIXARC2) && (data_sent == 0)) begin
		next_state = OUTPIXARC2;

		//Send Arc Pix 3
	end else if((state == OUTPIXARC3) && (data_sent == 1)) begin
		next_state = MAKEARC4;
	end else if((state == OUTPIXARC3) && (data_sent == 0)) begin
		next_state = OUTPIXARC3;

		//Send Arc Pix 4
	end else if((state == OUTPIXARC4) && (data_sent == 1)) begin
		next_state = MAKEARC5;
	end else if((state == OUTPIXARC4) && (data_sent == 0)) begin
		next_state = OUTPIXARC4;

		//Send Arc Pix 5
	end else if((state == OUTPIXARC5) && (data_sent == 1)) begin
		next_state = MAKEARC6;
	end else if((state == OUTPIXARC5) && (data_sent == 0)) begin
		next_state = OUTPIXARC5;

		//Send Arc Pix 6
	end else if((state == OUTPIXARC6) && (data_sent == 1)) begin
		next_state = MAKEARC7;
	end else if((state == OUTPIXARC6) && (data_sent == 0)) begin
		next_state = OUTPIXARC6;

		//Send Arc Pix 7
	end else if((state == OUTPIXARC7) && (data_sent == 1)) begin
		next_state = MAKEARC8;
	end else if((state == OUTPIXARC7) && (data_sent == 0)) begin
		next_state = OUTPIXARC7;

		//Send Arc Pix 8
	end else if((state == OUTPIXARC8) && (data_sent == 1)) begin
		next_state = MAKEARC1;
	end else if((state == OUTPIXARC8) && (data_sent == 0)) begin
		next_state = OUTPIXARC8;

	//Triangle Path
	//	Putting Lines into FIFO
	end else if (state == TRISENDL1) begin
		next_state = TRISENDL2;
	end else if (state == TRISENDL2) begin
		next_state = TRISENDL3;
	end else if (state == TRISENDL3) begin
		next_state = TRIMAKEL1;

	//	Generate Line Data For Triangle Line 1
	end else if ((state == TRIMAKEL1) && (data_ready == 1)) begin
		next_state = TRIOUTPIXL1;
	end else if ((state == TRIMAKEL1) && (line_done == 1)) begin
		next_state = CLEARFIFO1;
	end else if ((state == TRIMAKEL1) && (data_ready == 0)) begin	
		next_state = TRIMAKEL1;

	//	Generate Line Data For Triangle Line 2
	end else if ((state == TRIMAKEL2) && (data_ready == 1)) begin
		next_state = TRIOUTPIXL2;
	end else if ((state == TRIMAKEL2) && (line_done == 1)) begin
		next_state = CLEARFIFO2;
	end else if ((state == TRIMAKEL2) && (data_ready == 0)) begin	
		next_state = TRIMAKEL2;

	//	Generate Line Data For Triangle Line 3
	end else if ((state == TRIMAKEL3) && (data_ready == 1)) begin
		next_state = TRIOUTPIXL3;
	end else if ((state == TRIMAKEL3) && (line_done == 1)) begin
		next_state = CLEARFIFO3;
	end else if ((state == TRIMAKEL3) && (data_ready == 0)) begin	
		next_state = TRIMAKEL3;


	//	Output Triangle Line 1 Pixels
	end else if ((state == TRIOUTPIXL1) && (data_sent == 1)) begin
		next_state = TRIMAKEL1;
	end else if ((state == TRIOUTPIXL1) && (data_sent == 0)) begin
		next_state = TRIOUTPIXL1;

	//	Output Triangle Line 2 Pixels
	end else if ((state == TRIOUTPIXL2) && (data_sent == 1)) begin
		next_state = TRIMAKEL2;
	end else if ((state == TRIOUTPIXL2) && (data_sent == 0)) begin
		next_state = TRIOUTPIXL2;

	//	Output Triangle Line 3 Pixels
	end else if ((state == TRIOUTPIXL3) && (data_sent == 1)) begin
		next_state = TRIMAKEL3;
	end else if ((state == TRIOUTPIXL3) && (data_sent == 0)) begin
		next_state = TRIOUTPIXL3;

	//	Clear line 1 out of FIFO
	end else if(state == CLEARFIFO1) begin
		next_state = TRIMAKEL2;

	//	Clear line 2 out of FIFO
	end else if(state == CLEARFIFO2) begin
		next_state = TRIMAKEL3;

	//	Final FIFO Clear State
	end else if(state == CLEARFIFO3) begin
		next_state = DISPWAIT;

	//	Wait State for Display -> mainly to set Shape Done Signal
	end else if (state == DISPWAIT) begin
		next_state = IDLE;

	//Default to resetting to IDLE encourages better programming 
	//by including states where the state will stay the same until 
	//something happens
	end else begin
		next_state = 0;
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

	//IDLE Output
	if(state == IDLE) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Shape Identification
	end else if (state == IDENTIFYSHAPE) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Send Line for Line
	end else if (state == LINESENDL) begin
		prim_sel = 0;
		shape_done = 0;
		write = 1;
		read = 0;
		enable = 0;
		output_sel = 4'b0000;
	//Calculating Line Output
	end else if (state == LINEMAKEL) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Outputting a pixel for line
	end else if (state == LINEOUTPIX) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Send Line 1 for Traingle
	end else if (state == TRISENDL1) begin
		prim_sel = 0;
		shape_done = 0;
		write = 1;
		read = 0;
		output_sel = 4'b0001;
		enable = 0;
	//Send Line 2 for Traingle
	end else if (state == TRISENDL2) begin
		prim_sel = 0;
		shape_done = 0;
		write = 1;
		read = 0;
		output_sel = 4'b0010;
		enable = 0;
	//Send Line 3 for Traingle
	end else if (state == TRISENDL3) begin
		prim_sel = 0;
		shape_done = 0;
		write = 1;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Calculating pixels for Triangle L1
	end else if (state == TRIMAKEL1) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Calculating pixels for Triangle L2
	end else if (state == TRIMAKEL2) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Calculating pixels for Triangle L3
	end else if (state == TRIMAKEL3) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Outputting pixel from trinagle line 1
	end else if (state == TRIOUTPIXL1) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Outputting pixel from trinagle line 1
	end else if (state == TRIOUTPIXL2) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Outputting pixel from triangle line 1
	end else if (state == TRIOUTPIXL3) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Send Circle Into FIFO
	end else if (state == SENDCIRC) begin
		prim_sel = 1;
		shape_done = 0;
		write = 1;
		read = 0;
		output_sel = 4'b0100;
		enable = 0;
	//Generate Pixel Data for ARC 1
	end else if (state == MAKEARC1) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Generate Pixel Data for ARC 2
	end else if (state == MAKEARC2) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Generate Pixel Data for ARC 3
	end else if (state == MAKEARC3) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Generate Pixel Data for ARC 4
	end else if (state == MAKEARC4) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Generate Pixel Data for ARC 5
	end else if (state == MAKEARC5) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Generate Pixel Data for ARC 6
	end else if (state == MAKEARC6) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Generate Pixel Data for ARC 7
	end else if (state == MAKEARC7) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Generate Pixel Data for ARC 8
	end else if (state == MAKEARC8) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 1;
	//Output Pixel Data form Arc 1
	end else if (state == OUTPIXARC1) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Output Pixel Data form Arc 2
	end else if (state == OUTPIXARC2) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Output Pixel Data form Arc 3
	end else if (state == OUTPIXARC3) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Output Pixel Data form Arc 4
	end else if (state == OUTPIXARC4) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Output Pixel Data form Arc 5
	end else if (state == OUTPIXARC5) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Output Pixel Data form Arc 6
	end else if (state == OUTPIXARC6) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Output Pixel Data form Arc 7
	end else if (state == OUTPIXARC7) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Output Pixel Data form Arc 8
	end else if (state == OUTPIXARC8) begin
		prim_sel = 1;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Clear First Item From FIFO
	end else if (state == CLEARFIFO1) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 1;
		output_sel = 4'b0000;
		enable = 0;
	//Clear Second Item From FIFO
	end else if (state == CLEARFIFO2) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 1;
		output_sel = 4'b0000;
		enable = 0;
	//Clear Last Item From FIFO
	end else if (state == CLEARFIFO3) begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 1;
		output_sel = 4'b0000;
		enable = 0;
	//Displaying shape trigger
	end else if (state == DISPWAIT) begin
		prim_sel = 0;
		shape_done = 1;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;
	//Default
	end else begin
		prim_sel = 0;
		shape_done = 0;
		write = 0;
		read = 0;
		output_sel = 4'b0000;
		enable = 0;	
	end	
end

endmodule
