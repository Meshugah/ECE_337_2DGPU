// $Id: $
// File name:   ImageSpecRegs.sv
// Created:     11/13/2014
// Author:      Cong Ku
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Image sepecificatin registers. Should push data in the right order to get right result

module ImageSpecRegs
(
  input wire clk,
  input wire n_rst,
  input wire read_enable,
  input wire[7:0] data,
  output wire[31:0] mid_readAddress,
  output wire[31:0] bot_readAddress,
  //output wire[31:0] Address,
  output wire[15:0] n_colum,
  output wire[15:0] n_row
);

reg[31:0] dataRegs;
wire[31:0] next_dataRegs;

always_ff @(posedge clk, negedge n_rst) begin
  if(n_rst == 0) begin
    dataRegs[31:0] <= 0;
  end else if (read_enable == 1'b1) begin
    dataRegs <= next_dataRegs;
  end else begin
    dataRegs <= dataRegs;
  end
end


assign next_dataRegs = {dataRegs[23:0],data[7:0]}; 

assign n_colum = dataRegs[31:16];
assign n_row = dataRegs[15:0];

assign mid_readAddress = 32'h08000000 + (n_colum*4);
assign bot_readAddress = 32'h08000000 + (n_colum*8);

endmodule
