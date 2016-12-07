//Module: Shape Detection Demo
//Author(s): Noah Petersen
//Description: Wrapper file for Splitter, opcdoe detector and CCU for DSSC Demonstration

module shapedetectiondemo(
	input wire clk,
	input wire n_reset,
	input wire [95:0]full_opcode,
	input wire new_shape,
	input wire line_done,
	input wire arc_done,
	input wire data_ready,
	output reg data_sent,
	output reg enable,
	output reg [15:0] color,
	output reg shape_done,
	output reg prim_sel,
	output reg write,
	output reg read,
	output reg [37:0] locations
);

//Internal Signal Declarations
//reg write;
//reg read;
//reg [37:0] locations;
reg [3:0] output_sel;
reg [3:0] shape_id;
reg [73:0] opcode_data;

//FIFO Wrapper
//SHAPEFIFO1 rx_fifo(.clk(clk), .n_rst(n_reset), .r_enable(read), .w_enable(write), [7:0] .w_data(), [7:0] .r_data(),.empty(),.full());

//Splitter Wrapper
splitter SPLT(.opdata(opcode_data), .output_sel(output_sel), .locations(locations), .color(color));

//Opcode Decoder Wrapper
opcodeDecoder DEC(.opcode(full_opcode), .shape(shape_id), .color(color),.opdata(opcode_data));

//CCU Wrapper
corecontrolunit CCU(.clk(clk), .nreset(n_reset), .new_shape(new_shape), .data_ready(data_ready), .data_sent, .line_done(line_done), .arc_done(arc_done), .shapeid(shape_id), .prim_sel(prim_sel), .shape_done(shape_done), .write(write), .read(read), .enable(enable), .output_sel(output_sel));


endmodule
