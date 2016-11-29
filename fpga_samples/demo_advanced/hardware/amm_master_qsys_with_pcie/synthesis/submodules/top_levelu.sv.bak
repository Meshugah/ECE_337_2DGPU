// $Id: $
// File name:   top_levelu.sv
// Created:     11/23/2014
// Author:      Saulo Cesar Rodrigues Pereira Sobrinho
// Project
// Version:     1.0  Initial Design Entry
// Description: Top Level for FPGA portion of the design.
// 


/*ERRORS SEEN FROM THE TOP-LEVEL PERSPECTIVE:

-ADD STATE TO CONTROL TO ACCOUNT FOR OVERFLOW/UNDERFLOW AND CHANGE OUTPUT REGISTER MULTIPLEX SIGNAL.
  -IF OVERFLOW (CHANGE FOR CEILING VALUE), ELSE IF NEGATIVE (CHANGE FOR FLOOR VALUE), ELSE USE THE ACTUAL OUTPUT.

-OVERFLOW SIGNAL DOES NOT ACCOUNT FOR NEGATIVE VALUES YET.

-IMAGESPECREGS SHOULD MATCH THE CONTROL UNIT LOADING ORDER.

-INPUT DATA IN ALL BLOCKS ARE PENDING. THEY GO THROUGH THE BUS INTERFACE.

*/ 

module top_levelu
  (
    input wire clk,
    input wire n_rst,
    input wire user_data_available,
    input wire user_buffer_full,
    input wire [7:0]data_in,
	 input wire idle_out,
	 input wire read_state,
	 
	 input wire [2:0]w_address_select,
    input wire w_data_select,
	 input wire w_rw_load_ctrl,
	 input wire w_buffer_load,
//	 input wire w_buffer_clear,
	 input wire w_load_size,
	 input wire w_count_enable,
	 
	 input wire w_flag_clear,
	 
	 output wire w_image_done,
	 output wire [31:0] w_mid_addr,
	 output wire [31:0] w_bot_addr,
	 output wire [15:0] row_count_out,
	 output wire [15:0] col_count_out,
	 
    output wire user_read_buffer,
    output wire user_write_buffer,
    output wire rdwr_cntl,
    output wire n_action,
    output wire [7:0]data_out,
    output wire [31:0]address,
	 output wire LED1,
	 output wire LED2,
	 output wire LED3,
	 output wire LED4,
	 output wire LED5,
	 output wire LED6,
	 output wire start
  );
  
  
  
  
  
  //WIRES:
  wire [71:0] w_pixel_matrix;
  wire w_start;
  wire w_overflow;
  wire w_underflow;
  wire [7:0] w_arith_out;
  wire [15:0] w_n_columns;
  wire [15:0] w_n_rows;
  wire w_sweep_done;
  wire w_output_load;
  wire w_ini_shift;
  assign start = w_start;
  
  arit ARITH (
    // inputs
    .in_pixels(w_pixel_matrix),
    
    // outputs
    .out_pixel(w_arith_out),
    .overflow(w_overflow), 
    .underflow(w_underflow)
    
    );
  
  ImageSpecRegs IMGSPECREGS   (
    // input
    .clk(clk), 
    .n_rst(n_rst), 
    .read_enable(w_load_size), 
    .data(data_in),
    
    // output 
    .mid_readAddress(w_mid_addr),
	 .bot_readAddress(w_bot_addr), 
    .n_colum(w_n_columns), 
    .n_row(w_n_rows)
    
    );

  readCounter COUNTERS (
    // inputs
    .clk(clk), 
    .n_rst(n_rst), 
    .n_columns(w_n_columns), 
    .n_rows(w_n_rows), 
    .count_enable(w_count_enable),
	 
	 .flag_clear(w_flag_clear),
                        
    // outputs                    
	 .switch_rows(w_buffer_clear), 
    .image_done_flag(w_image_done),
    .col_count_out(col_count_out),
	 .row_count_out(row_count_out)
    );
                        
  shift_register SHIFT_REG( 
    // inputs
    .pix_in(data_in), 
    .shift_enable(w_buffer_load), 
    .n_rst(n_rst), 
    .clear(w_buffer_clear), 
    .clk(clk),
    
    //outputs
    .out0(w_pixel_matrix[7:0]), 
    .out1(w_pixel_matrix[15:8]), 
    .out2(w_pixel_matrix[23:16]), 
    .out3(w_pixel_matrix[31:24]), 
    .out4(w_pixel_matrix[39:32]), 
    .out5(w_pixel_matrix[47:40]), 
    .out6(w_pixel_matrix[55:48]), 
    .out7(w_pixel_matrix[63:56]), 
    .out8(w_pixel_matrix[71:64])
                            
    );
                             
  outputlogic OUTLOGIC (
    // input
    .n_rst(n_rst), 
    .clk(clk), 
    .data_select(w_data_select), 
    .underflow(w_underflow), 
    .overflow(w_overflow), 
    .arith_out(w_arith_out),
    
    // output
    .final_out(data_out)
    );
  

  
  
endmodule