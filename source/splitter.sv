module splitter (
	input wire [73:0] opdata,
	input wire [3:0] output_sel,
	output reg [37:0] locations,
	output wire [15:0] color
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
//91:76 -> 73:58 Color
//75:57 -> 57:39 Pos1
//56:38 -> 38:20 Pos2
//37:19 -> 19:1 Pos3,unused for Line
//18    -> 0 Fill

//Color
assign color = opdata[73:58];

//Line Assignments
assign lstart = opdata[57:39];
assign lend = opdata[38:20];

//Triangle
assign t1start = opdata[57:39];
assign t1end = opdata[38:20];
assign t2start = opdata[57:39];
assign t2end = opdata[19:1];
assign t3start = opdata[38:20];
assign t3end = opdata[19:1];

//Circle Assignements
assign c1cent = opdata[57:39];
assign c1rad = opdata[38:20];


always_comb begin
	//Output selection
	case(output_sel)
		LL1: locations = {lstart,lend};
		TL1: locations = {t1start,t1end};
		TL2: locations = {t2start,t2end};
		TL3: locations = {t3start,t3end};
		CA1: locations = {c1cent,c1rad};
		default:  locations = '0;//Select LLine1
	endcase
end

endmodule


