// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/main/ip/sopc/components/verification/altera_tristate_conduit_bfm/altera_tristate_conduit_bfm.sv.terp#7 $
// $Revision: #7 $
// $Date: 2010/08/05 $
// $Author: klong $
//-----------------------------------------------------------------------------
// =head1 NAME
// altera_conduit_bfm
// =head1 SYNOPSIS
// Bus Functional Model (BFM) for a Standard Conduit BFM
//-----------------------------------------------------------------------------
// =head1 DESCRIPTION
// This is a Bus Functional Model (BFM) for a Standard Conduit Master.
// This BFM sampled the input/bidirection port value or driving user's value to 
// output ports when user call the API.  
// This BFM's HDL is been generated through terp file in Qsys/SOPC Builder.
// Generation parameters:
// output_name:                                       altera_conduit_bfm
// role:width:direction:                              rdwr_cntl:1:output,add_data_sel:1:output,rdwr_address:26:output,n_action:1:output,display_data:26:input
// true
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ns

module altera_conduit_bfm
(
   clk,
   reset,
   reset_n,
   sig_rdwr_cntl,
   sig_add_data_sel,
   sig_rdwr_address,
   sig_n_action,
   sig_display_data
);

   //--------------------------------------------------------------------------
   // =head1 PINS 
   // =head2 User defined interface
   //--------------------------------------------------------------------------
   input clk;
   input reset;
   input reset_n;
   output sig_rdwr_cntl;
   output sig_add_data_sel;
   output [25 : 0] sig_rdwr_address;
   output sig_n_action;
   input [25 : 0] sig_display_data;

   // synthesis translate_off
   import verbosity_pkg::*;
   
   typedef logic ROLE_rdwr_cntl_t;
   typedef logic ROLE_add_data_sel_t;
   typedef logic [25 : 0] ROLE_rdwr_address_t;
   typedef logic ROLE_n_action_t;
   typedef logic [25 : 0] ROLE_display_data_t;

   reg rdwr_cntl_temp;
   reg rdwr_cntl_out;
   reg add_data_sel_temp;
   reg add_data_sel_out;
   reg [25 : 0] rdwr_address_temp;
   reg [25 : 0] rdwr_address_out;
   reg n_action_temp;
   reg n_action_out;
   logic [25 : 0] display_data_in;
   logic [25 : 0] display_data_local;

   //--------------------------------------------------------------------------
   // =head1 Public Methods API
   // =pod
   // This section describes the public methods in the application programming
   // interface (API). The application program interface provides methods for 
   // a testbench which instantiates, controls and queries state in this BFM 
   // component. Test programs must only use these public access methods and 
   // events to communicate with this BFM component. The API and module pins
   // are the only interfaces of this component that are guaranteed to be
   // stable. The API will be maintained for the life of the product. 
   // While we cannot prevent a test program from directly accessing internal
   // tasks, functions, or data private to the BFM, there is no guarantee that
   // these will be present in the future. In fact, it is best for the user
   // to assume that the underlying implementation of this component can 
   // and will change.
   // =cut
   //--------------------------------------------------------------------------
   
   event signal_reset_asserted;
   event signal_input_display_data_change;
   
   function automatic string get_version();  // public
      // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1" 
      string ret_version = "13.0";
      return ret_version;
   endfunction

   // -------------------------------------------------------
   // rdwr_cntl
   // -------------------------------------------------------

   function automatic void set_rdwr_cntl (
      ROLE_rdwr_cntl_t new_value
   );
      // Drive the new value to rdwr_cntl.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      rdwr_cntl_temp = new_value;
   endfunction

   // -------------------------------------------------------
   // add_data_sel
   // -------------------------------------------------------

   function automatic void set_add_data_sel (
      ROLE_add_data_sel_t new_value
   );
      // Drive the new value to add_data_sel.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      add_data_sel_temp = new_value;
   endfunction

   // -------------------------------------------------------
   // rdwr_address
   // -------------------------------------------------------

   function automatic void set_rdwr_address (
      ROLE_rdwr_address_t new_value
   );
      // Drive the new value to rdwr_address.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      rdwr_address_temp = new_value;
   endfunction

   // -------------------------------------------------------
   // n_action
   // -------------------------------------------------------

   function automatic void set_n_action (
      ROLE_n_action_t new_value
   );
      // Drive the new value to n_action.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      n_action_temp = new_value;
   endfunction

   // -------------------------------------------------------
   // display_data
   // -------------------------------------------------------
   function automatic ROLE_display_data_t get_display_data();
   
      // Gets the display_data input value.
      $sformat(message, "%m: called get_display_data");
      print(VERBOSITY_DEBUG, message);
      return display_data_in;
      
   endfunction

   always @(posedge clk) begin
      rdwr_cntl_out <= rdwr_cntl_temp;
      add_data_sel_out <= add_data_sel_temp;
      rdwr_address_out <= rdwr_address_temp;
      n_action_out <= n_action_temp;
      display_data_in <= sig_display_data;
   end
   
   assign sig_rdwr_cntl = rdwr_cntl_out;
   assign sig_add_data_sel = add_data_sel_out;
   assign sig_rdwr_address = rdwr_address_out;
   assign sig_n_action = n_action_out;

   always @(posedge reset or negedge reset_n) begin
      -> signal_reset_asserted;
   end

   always @(display_data_in) begin
      if (display_data_local != display_data_in)
         -> signal_input_display_data_change;
      display_data_local = display_data_in;
   end
   


// synthesis translate_on

endmodule


