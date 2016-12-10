// $Id: $
// File name:   computationalcore.sv
// Created:     12/6/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Top Level computational core wrapper
module computationalcore(
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
//reg [37:0]locations;
reg [15:0]in_color;
reg [18:0]line_address;
reg [18:0]arc_address;
//reg empty;
//reg full;
reg primselect;
reg linedone;
reg arcdone;
reg en;
reg waitreq;
reg read;
reg write;
reg [37:0] locations;
//reg [37:0]data_r;
reg [37:0] fifo_r_data;

splitter SHAPESPLIT (
	.opdata(split_opcode),
	.output_sel(desired_output),
	.locations(locations)
	//.color(in_color)
);

opdecode OPDECODE (
	.opcode(full_opcode),
	.shape(desired_shape),
	.color(in_color),
	.opdata(split_opcode)
);

corecontrolunit CCU (
	.clk(clk),
	.nreset(n_rst),
	.new_shape(new_shape),
	.line_done(linedone),
	.arc_done(arcdone),
	.shapeid(desired_shape),
	.prim_sel(primselect),
	.shape_done(shape_done),
	.write(write),
	.read(read),
	.enable(en),
	.output_sel(desired_output)
);

mux1 MUX1 (
	.a(line_data_ready),
	.b(arc_data_ready),
	.sel(primselect),
	.data(data_ready)
);

mux19 MUX2 (
	.a(line_address),
	.b(arc_address),
	.sel(primselect),
	.data(address)
);

bresenline BRESENL (
	.clk(clk),
	.n_rst(n_rst),
	.positions(fifo_r_data),
	.stop(~en),
	.primSelect(primselect),
	.address(line_address),
	.lineDone(linedone)
);

bresencircle BRESNC (
	.clk(clk),
	.n_rst(n_rst),
	.positions(fifo_r_data),
	.stop(~en),
	.primSelect(primselect),
	.address(arc_address),
	.circleDone(arcdone)
);

corefifo COREFIFO (
	.clk(clk),
	.n_rst(n_rst),
	.r_enable(read),
	.w_enable(write),
	.w_data(locations),
	.r_data(fifo_r_data),
	//.empty(empty),
	//.full(full)
	.empty(),
	.full()
);
endmodule
