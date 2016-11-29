// $Id: $
// File name:   startdecoder.sv
// Created:     11/23/2014
// Author:      Fangda Li
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: detects a start byte

module startdecoder
  (
    input wire [7:0] read_user_buffer_output_data,
    output wire start    
  );
  
  assign start = (read_user_buffer_output_data == 8'h53)? 1:0;  //A byte of 0x53 indicates a start signal; 0x53 for "S"
  

endmodule