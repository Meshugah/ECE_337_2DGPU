// $Id: $
// File name:   arit.sv
// Created:     11/13/2014
// Modified:    11/23/2014
// Author:      Saulo Cesar Rodrigues Pereira Sobrinho
// Project 
// Version:     1.0  Initial Design Entry
// Description: Arithmetic block.

module arit
  (
  input [71:0]in_pixels,   //I decided to write with all registers as input. So we can change the masks later if we want to.
  
  output [7:0]out_pixel,
  output overflow,
  output underflow
  );
  
  /*
  7:0     - reg0
  15:8    - reg1
  23:16   - reg2
  31:24   - reg3
  39:32   - reg4
  47:40   - reg5
  55:48   - reg6
  63:56   - reg7
  71:64   - reg8
  */
  
  /*We work with 10 bit words to avoid overflows in the intermediate calculations.
    Since we multiply the number by 4, there's a potential overflow for any number >= 64,
    by working with 10 bit, we allow any multiplication to happen, and maybe the negative numbers
    can compensate.
  */
  wire [10:0]ext_reg_1 ;
  wire [10:0]ext_reg_3 ;
  wire [10:0]ext_reg_5 ;
  wire [10:0]ext_reg_7 ;
  wire [10:0]ext_reg_4 ;
  
  reg [10:0]neg_reg_1;
  reg [10:0]neg_reg_3;
  reg [10:0]neg_reg_5;
  reg [10:0]neg_reg_7;
  
  
  reg [10:0]w_out_p1;
  reg [10:0]w_out_p2;
  reg [10:0]w_out;
  
  //Multiplication by 4:
  assign ext_reg_4 = {1'b0,in_pixels[39:32],2'b00};
  //Complement 2
  assign ext_reg_1 = {3'b111, (~in_pixels[15:8])};
  assign ext_reg_3 = {3'b111,(~in_pixels[31:24])};
  assign ext_reg_5 = {3'b111,(~in_pixels[47:40])};
  assign ext_reg_7 = {3'b111,(~in_pixels[63:56])};
  
  always @(ext_reg_1, ext_reg_3, ext_reg_5, ext_reg_7)
  begin
    neg_reg_1 = ext_reg_1 + 11'd1;
    neg_reg_3 = ext_reg_3 + 11'd1;  
    neg_reg_5 = ext_reg_5 + 11'd1;
    neg_reg_7 = ext_reg_7 + 11'd1;
  end
  
  always @(neg_reg_1,neg_reg_3,ext_reg_4,neg_reg_5,neg_reg_7)
  begin
    w_out_p1 = neg_reg_1 + neg_reg_3;
    w_out_p2 = neg_reg_5 + neg_reg_7;  
    w_out = w_out_p1 + w_out_p2 + ext_reg_4;   
  end  
  
  //Modified 
  assign out_pixel = w_out[7:0];
  
  assign underflow = w_out[10];
  
  assign overflow = (underflow == 1'b0)? w_out[8] | w_out[9]:0; 
  
  
endmodule