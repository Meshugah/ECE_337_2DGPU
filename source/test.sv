// $Id: $
// File name:   test.sv
// Created:     11/16/2016
// Author:      Ahmad dit Ziad Dannawi
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Some test file
module test
(
input wire i,
output wire o
);

assign o = ~i;

endmodule
