module splitter (
	input wire [75:0] opdata,
	input wire [3:0] output_sel,
	output reg [37:0] locations
	//output wire [15:0] color
);
localparam LL1 = 4'b0000;
localparam TL1 = 4'b0001;
localparam TL2 = 4'b0010;
localparam TL3 = 4'b0011;
localparam CA1 = 4'b0100;

reg [18:0] lstart;
reg [18:0] lend;
reg [18:0] t1start;
reg [18:0] t1end;
reg [18:0] t2start;
reg [18:0] t2end;
reg [18:0] t3start;
reg [18:0] t3end;
reg [18:0] c1cent;
reg [18:0] c1rad;

//Bits that matter from opcode
//91:76 - Next 16 bits define the color ( 5r, 6g, 5b )
//75:57 - Determines part of the position for an object. E.g. Starting point for a line. 10 bits for x, 9 bits for y.
//56:38 - Next 19 bits define the second position/location for an object (e.g. end point for a line). 10 bits for x, 9 bits for y.
//37:19 - Next 19 bits define the third position. Used for  more advanced shapes such as triangles or rectangles that need more bits for definition.
//91:76 -> Color (not given here)
//75:57 -> 57:39 Pos1
//56:38 -> 38:20 Pos2
//37:19 -> 19:1 Pos3,unused for Line
//18    -> 0 Fill -> Effectively trash data now
//17:0  -> Trash Data

//Color
//assign color = opdata[73:58];

//Line Assignments
assign lstart = opdata[75:57];
assign lend = opdata[56:38];

//Triangle
assign t1start = opdata[75:57]; //A->B
assign t1end = opdata[56:38];
assign t2start = opdata[56:38]; //B->C
assign t2end = opdata[37:19];
assign t3start = opdata[75:57]; //A->C
assign t3end = opdata[37:19];

//Circle Assignements
assign c1cent = opdata[56:38];
assign c1rad = opdata[37:19];


always_comb begin
	//Output selection
	if(output_sel == LL1) begin
		locations = {lstart,lend};

	end else if(output_sel == TL1) begin
		locations = {t1start,t1end};

	end else if(output_sel == TL2) begin
		locations = {t2start,t2end};

	end else if(output_sel == TL3) begin
		locations = {t3start,t3end};

	end else if(output_sel == CA1) begin
		locations = {c1cent,c1rad};

	end else begin
		locations = 0;
	end
end

endmodule


