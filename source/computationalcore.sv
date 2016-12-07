// $Id: $
// File name:   computationalcore.sv
// Created:     12/6/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Top level computational core wrapper
module ComputationalCore(
	input wire clk,
	input wire n_rst,
	input wire data_sent,
	input wire new_shape,
	input wire [95:0]full_opcode,
	output wire data_ready,
	output wire shape_done,
	output wire frame_target,
	output wire [18:0]address,
	output wire [15:0]color
);

reg [75:0]split_opcode;
reg [3:0]desired_output;
reg [3:0]desired_shape;
reg [37:0]locations;
reg [15:0]in_color;
reg read;
reg [18:0]line_address;
reg [18:0]arc_address;
reg empty;
reg full
reg primselect;
reg linedone;
reg arcdone;
reg en;
reg waitreq;
reg write;
reg data_r;

splitter SHAPESPLIT (
	.clk(clk),
	.n_rst(n_rst),
	.opdata(split_opcode),
	.output_sel(desired_output),
	.read(read),
	.locations(locations),
	.color(in_color)
);

opcodeDecoder OPDECODE (
	.opcode(full_opcode),
	.shape(desired_shape),
	.color(in_color),
	.opdata(split_opcode)
);

CoreControlUnit CCU (
	.clk(clk),
	.nreset(n_rst),
	.empty(empty),
	.newshape(new_shape),
	.waitrequest(waitreq),
	.ldone(linedone),
	.adone(arcdone),
	.shapeid(desired_shape),
	.primsel(primselect),
	.shapedone(shape_done),
	.write(write),
	.read(read),
	.enable(en),
	.outputsel(desired_output)
);

MUX MUX1 (
	.a(line_data_ready),
	.b(arc_data_ready),
	.sel(primselect),
	.data(data_r)
);

MUX MUX2 (
	.a(line_address),
	.b(arc_address),
	.sel(primselect),
	.data(address)
);

bresenline BRESENL (
	.clk(clk),
	.n_rst(n_rst),
	.positions(locations),
	.stop(en),
	.primSelect(primselect),
	.address(line_address),
	.lineDone(linedone)
);

bresencircle BRESNC (
	.clk(clk),
	.n_rst(n_rst),
	.positions(locations),
	.stop(en),
	.primSelect(primselect),
	.address(arc_address),
	.circleDone(arcdone)
);

corefifo COREFIFO (
	.clk(clk),
	.n_rst(n_rst),
	.r_enable(read_en),
	.w_enable(write_en),
	.w_data(write_data),
	.r_data(read_data),
	.empty(empty),
	.full(full)
);
endmodule
