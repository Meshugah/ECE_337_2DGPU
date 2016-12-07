// $Id: $
// File name:   OpDecoder.sv
// Created:     11/22/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Opcode decoder
module opdecode
(
input wire [95:0]opcode,
output wire [3:0]shape,
output wire [15:0]color,
output wire [73:0]opdata
);

assign shape = opcode[95:92];
assign color = opcode[91:76];
assign opdata = opcode[75:0];

endmodule
