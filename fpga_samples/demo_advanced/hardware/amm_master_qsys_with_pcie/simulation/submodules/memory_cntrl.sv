// $Id: $
// File name:   memory_cntrl.sv
// Created:     11/20/2014
// Author:      Cong Ku
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Memory controller

module memory_cntrl
(
  input wire clk,
  input wire n_rst,
  
  input wire Ini_sft_strobe,

  input wire [31:0] read_start_addr,
  input wire [31:0] write_start_addr,
  input wire [15:0] n_columes,
  input wire [2:0] sel,           //000 row1, 010 row2, 010 row3, 011 write, 100 idle address, 101 ini addr, 111 test addr
  input wire [1:0] rw_load_ctrl,  //00 do nothing  01 for read addrs reload, 10 for write addr reload, 11 for initial load
  
  output reg busy,
  output reg [31:0] addr
 
);



typedef enum bit [3:0] {IDLE,INITIAL, READ, WRITE} stateType;

stateType state;
stateType n_state;

reg pre_Ini_sft_strobe;
wire Ini_risingFound;

wire [1:0] rw_load_flag;//00 read, 01 write, 10 initial, 11 nothing
 
reg [31:0] row1_addr;
reg [31:0] row2_addr;
reg [31:0] row3_addr;
reg [31:0] ini_addr_offset;
reg [31:0] n_row1_addr;
reg [31:0] n_row2_addr;
reg [31:0] n_row3_addr;
wire [15:0] n_2x_columes;
wire [31:0] n_ini_addr_offset;


reg [31:0] write_addr;
reg [31:0] n_write_addr;

always_ff @(posedge clk, negedge n_rst) begin  //000 row1, 010 row2, 010 row3, 011 write, 100 idle address, 101 ini addr, 110,111 test addr
  if(!n_rst) begin
	 addr <= 32'h00000000;
  end else begin 
		if(sel == 3'b100) begin
			addr <= 32'h00000000;
		end else if(sel == 3'b110) begin
			addr <= 32'h00000008;
		end else if(sel == 3'b011) begin
		  addr <= write_addr;
		end else if(sel == 3'b111) begin
			addr <= 32'h0000000C;
		end
	end	
end

always_ff @(posedge clk, negedge n_rst) begin //00 do nothing  01 for read addrs reload, 10 for write addr reload, 11 for initial load
	if(!n_rst) begin
			write_addr <= 32'h00000010;
		end else begin 
		  if(rw_load_ctrl == 2'b10) begin
			write_addr <= n_write_addr;    //takes two clock cycles to get incremented adddress after asserting sel and load cntrl
		  end
		end
end
		
assign n_write_addr = write_addr + 4;

//assign addr = (sel == 3'b000) ? (row1_addr) : ((sel == 3'b001) ? (row2_addr) : ((sel == 3'b010) ? (row3_addr) : ((sel == 3'b011) ? (write_addr): ((sel == 3'b100) ? (32'h00000000) : (sel == 3'b111) ? 32'h000000018 : (sel == 3'b110) ? 32'h00000001C : (sel == 3'b101) ? 32'h000000010: (32'h00000000+ini_addr_offset)))));


endmodule
